;; 用clang实现获得符号的类型信息
;; Copyright (C) 2013 赵纯华

;; Author: 赵纯华 <ynsjzch@163.com>
;; Keywords: type clang
;; Version: 0.1

(provide 'get-type-clang)

(defcustom gt-clang-executable
  (executable-find "clang")
  "*Location of clang executable"
  :type 'file)

(defconst gt-clang-error-buffer-name "*clang error*")

(defun gt-clang-handle-error (res args)
  (let ((cmd (concat gt-clang-executable " " (mapconcat 'identity args " "))))    
    (message "clang failed with error %s:\n" cmd)))

(defcustom gt-clang-flags nil
  "Extra flags to pass to the Clang executable.
This variable will typically contain include paths, e.g., ( \"-I~/MyProject\", \"-I.\" )."
  :type '(repeat (string :tag "Argument" "")))


(defun gt-clang-is-same-line (line)
  "向后查找第一个出现的行号，如果和指定的行号相等，返回t;否则返回nil"
    (let ((ret) (reg) (old-pos (point)))
      (setq reg (format "\\(<\\| \\)\\(<stdin>\\|line\\):\\([0-9]+\\):[0-9]+"))
      (setq ret (search-backward-regexp reg nil t))
      ;;(message "line:%s" (line-number-at-pos))
      (if ret
          (if (not (equal (string-to-number (match-string 3)) line))
              (setq ret nil)))
      (goto-char old-pos)
      (setq ret ret)
  ))

(defun gt-clang-find-symbol-type-by-regex(reg &rest args)
  "尝试用一个正则表达式直接找出符号的类型"
  (let ((ret))
    (goto-char (point-min))
    (setq reg (apply 'format reg args))
    (setq ret (search-forward-regexp reg nil t))
    ;;(message "%s %s" reg ret)
    (if ret (setq ret (match-string 1)))
    ))

(defun gt-clang-find-symbol-type-by-column (reg &rest args)
  "尝试用一个带有列号匹配的正则表达式找出符号，通过向后匹配行号来精确定位符号"
  (let ((ret)(type))
    (goto-char (point-min))
    (setq reg (apply 'format reg args))
    (setq ret (search-forward-regexp reg nil t))
    ;;(message "%s ret:%s" reg ret)

    ;;匹配行
    (while ret
      (setq type (match-string 1))
      ;;(message "%s line:%s" reg (line-number-at-pos))
      (if (gt-clang-is-same-line line)
          (setq ret nil)
        (progn 
          (setq ret (search-forward-regexp reg nil t))
          (setq type nil))))
    (setq type type)
  ))

(defun gt-clang-parse-output (sym line col is_member)
  ""
  (let ((ret) (type) (reg))
    (setq col (+ col 1)) ;;clang的列是以1为基索引的
    (goto-char (point-min))
    (if (string= is_member ".") (setq is_member "\\."))
    
    (if is_member
        (setq type (gt-clang-find-symbol-type-by-column
                    "(MemberExpr 0x.* <.*col:%i> '\\(.*\\)'.* %s%s"
                    col is_member sym))
      (setq type (gt-clang-find-symbol-type-by-column
                  "(DeclRefExpr 0x.* <.*col:%i> .* '%s' .*'\\(.*\\)')"
                  col sym)))
    
    ;;(message "%s type:%s" reg type)

    ;;没有找到，尝试另外一种找member的方法,这种方法直接匹配了行和列
    (if (not type)
        (setq type (gt-clang-find-symbol-type-by-regex
                    "(MemberExpr 0x.* <.*<stdin>:%i:%i> '\\(.*\\)'.* \\.%s 0x"
                    line col sym)))
    (if (not type)
        (setq type (gt-clang-find-symbol-type-by-regex
                    "(MemberExpr 0x.* <.*<stdin>:%i:%i> '\\(.*\\)'.* ->%s 0x"
                    line col sym)))
    (if (not type)
        (setq type (gt-clang-find-symbol-type-by-column
                    "(MemberExpr 0x.* <.*col:%i> '\\(.*\\)'.* ->%s 0x"
                    col sym)))
    (if (not type)
        (setq type (gt-clang-find-symbol-type-by-column
                    "(MemberExpr 0x.* <.*col:%i> '\\(.*\\)'.* \\.%s 0x"
                    col sym)))
    (setq type type)
    ))


(defsubst gt-clang-lang-option ()
  (cond ((eq major-mode 'c++-mode)
         "c++")
        ((eq major-mode 'c-mode)
         "c")
        ((eq major-mode 'objc-mode)
         (cond ((string= "m" (file-name-extension (buffer-file-name)))
                "objective-c")
               (t
                "objective-c++")))
        (t
         "c++")))

(defsubst gt-clang-build-symbol-args()
  (append '("-cc1" "-fsyntax-only")
          (list "-x" (gt-clang-lang-option))
          gt-clang-flags
          '("-ast-dump")         
          (list "-")))


(defun gt-clang-call-process (symbol &rest args)
  (let ((buf (get-buffer-create "*cuc-output*"))
        (ret)
        res)
    (setq gt-clang-current-file (buffer-file-name))
    (with-current-buffer buf (erase-buffer))
    (setq res (apply 'call-process-region (point-min) (point-max)
                     gt-clang-executable nil buf nil args))
    (with-current-buffer buf
      (unless (eq 0 res)
        (gt-clang-handle-error res args)
        (setq ret nil))
      ;; Still try to get any useful input.
      (apply 'gt-clang-parse-output symbol))))


(defun gt-clang-is-member()
  "判断当前符号是不是一个成员访问表达式"
  (let ((old-pos (point))
        (ret) (begin) (end))
    (c-beginning-of-current-token)
    (c-backward-token-2)
    (setq begin (point))
    (setq end (+ begin 1))
    (setq ret (buffer-substring-no-properties begin end))
    ;;(message "%s %s %s" ret begin end)
    (if (string= ret "-")
        (progn
          (setq end (+ begin 2))
          (setq ret (buffer-substring-no-properties begin end))))
    (if (or (string= ret ".") (string= ret "->"))
        (setq ret ret)
      (setq ret nil))
    (goto-char old-pos)
    (setq ret ret)
  ))

(defun gt-clang-get-token-at-cursor(&optional forward)
  "获得光标所在处的一个token,不断的调用可以起到词法分析的效果
param forward
如果是1，那么在获取token的同时还要调用c-forward-token-2移动到下一个token;
如果是-1,那么在获取token的同时还要调用c-backward-token-2移动到上一个token;
否则不移动光标.
这个函数是sbw的底层核心函数之一，它是进行代码分析的利器.
"
  (let ((old-pos (point)) (is_member)
        (ret) (begin) (end) (col) (line))
    (c-beginning-of-current-token)
    (setq begin (point))
    (goto-char (+ (point) 1))
    (c-end-of-current-token)
    (setq end (point))

    (goto-char old-pos)
    (setq is_member (gt-clang-is-member))
    (goto-char old-pos)
    
    (if forward
        (if (= forward 1)
            (c-forward-token-2)
          (if (= forward -1)
              (c-backward-token-2))))
    (setq line (line-number-at-pos begin))
    (setq col (- begin (line-beginning-position)))
    (setq ret (list (buffer-substring-no-properties begin end) line col is_member))
))

(defun gt-clang-get-type()
  "获得光标所在处的符号的类型"
  (apply 'gt-clang-call-process
         (gt-clang-get-token-at-cursor)
         (gt-clang-build-symbol-args)))

(defun gt-clang-print-type-on-cursor()
  "打印光标所在处的符号的类型"
  (interactive)
  (let ((pos (point))
        (ret))
    (setq ret (gt-clang-get-type))
    (if ret (message ret))
    ))