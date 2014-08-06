(provide 'cuc-base)

;;(set-window-dedicated-p (get-buffer-window)  t)

(defcustom cuc-executable-goto-define
  (executable-find "~/bin/goto_define")
  "*Location of clang executable"
  :type 'file)

(defcustom cuc-executable-goto-type-define
  (executable-find "~/bin/goto_type_define")
  "*Location of clang executable"
  :type 'file)

(defcustom cuc-executable-goto-class-define
  (executable-find "~/bin/goto_class_define")
  "*Location of clang executable"
  :type 'file)

(defcustom cuc-executable-get-info
  (executable-find "~/bin/get_info")
  "*Location of clang executable"
  :type 'file)

(defcustom cuc-executable-goto-result-type-define
  (executable-find "~/bin/goto_result_type_define")
  "*Location of clang executable"
  :type 'file)

(defcustom cuc-executable-goto-result-class-define
  (executable-find "~/bin/goto_result_class_define")
  "*Location of clang executable"
  :type 'file)

(defcustom cuc-executable-get-type
  (executable-find "~/bin/get_type")
  "*Location of clang executable"
  :type 'file)

(defcustom cuc-executable-get-class
  (executable-find "~/bin/get_class")
  "*Location of clang executable"
  :type 'file)

(defcustom cuc-executable-code-completion
  (executable-find "~/bin/code_completion")
  "*Location of clang executable"
  :type 'file)
(defcustom cuc-executable-get-inclusions
  (executable-find "~/bin/get_inclusions")
  ""
  :type 'file)

(defconst cuc-message-buffer-name "*cuc-message*")

(defconst cuc-error-buffer-name "*clang error*")

(defvar cuc-source-files nil
  "保存所有源文件的信息，每个文件里有:
name 文件名，
global-decls 全局定义列表")

(defvar cuc-cflags-catch (list "-ObjC++" "-fsyntax-only" "-fno-color-diagnostic")
  "捕获 Makefile 里的编译参数" )

(defun cuc-get-current-file-object()
  (let ((file)(name))
    (setq name (buffer-file-name))
    (setq file (cdr (assoc name cuc-source-files)))
    (if (not file)
        (progn
          (setq file (list (cons "name" name)
                           (cons "old-size" (buffer-size))
                           (cons "global-list" nil)))
          (setq cuc-source-files
                (append cuc-source-files (list (cons name file))))))
    (setq file file)
    ))

(defun elisp-test()
  (interactive)
  (setq file (cuc-get-current-file-object))
  (setq global-list (assoc "global-list" file))
  (setcdr global-list "oooo")
  ;;(append file (cons "global-list" "oo"))
  (message "%s" file)
  )

(defun cuc-handle-error (executable res args)
  (let ((cmd (concat executable " " (mapconcat 'identity args " "))))
    (message "clang failed with error: %s:" cmd)))


(defun cuc-get-clang-flags()
  "从Makefile里获取编译选项"
  (let ((flags))
    (setq flags (shell-command-to-string
                 (concat compile-command " cuc_cflags"
                         " f=" (buffer-file-name))))
    
    (if (string-match "fsyntax-only" flags) ;;用fsyntax-only判断cflags是否获取成功
        (progn 
          (setq flags (replace-in-string flags "\n" ""))
          (setq flags (split-string flags " "))
          (setq cuc-cflags-catch flags))
      (setq cuc-cflags-catch cuc-cflags-catch))
    ))

(defun cuc-get-result-string ()
  (buffer-substring-no-properties (point-min) (point-max)))

(defsubst cuc-args-raw(&rest my-args)
  "获取cuc需要的原始参数，可以通过my-args增加任意多个其他参数"
  (interactive)
  (append (cuc-get-clang-flags) my-args))

(defsubst cuc-args(&rest my-args)
  "获取cuc需要的参数，可以通过my-args增加任意多个其他参数"
  (append (list  (buffer-file-name)
          (number-to-string (line-number-at-pos))
          (number-to-string (+ (- (point) (line-beginning-position)) 1)))
          (cuc-get-clang-flags)
          my-args
          ))

(defun cuc-args-string(&rest my-args)
  "和cuc-args差不多，只是返回的是一个参数列表字符串,有的调用需要字符串形式的参数"
  (let ((args (cuc-args my-args))
        (ret))
    (mapcar (lambda (item) (setq ret (concat ret " " item))) args)
    (setq ret ret)
  ))


(defun cuc-jump-to-file (file line col)
  "跳转到目标,并且切换到文件"
  (let ((buffer))
    ;;(message "result:%s,%i,%i" file line col)
    (setq buffer (find-file file))
    (if (> line 0)
        (progn 
          (goto-line line buffer)
          (line-move-to-column col)))
    ))


(defun cuc-call-process (executable &rest args)
  (let ((buf (get-buffer-create "*cuc-output*"))(ret)(res))
    ;;(message "%s" args)
    (with-current-buffer buf (erase-buffer))

    (setq res (apply 'call-process-region (point-min) (point-max) executable nil buf nil args))
    (if (eq 0 res)
        (setq ret buf)
      (progn
        (cuc-handle-error executable res args)
        (setq ret nil)))
    ))



(defun cuc-start-process (process-name executable &rest args)
  (let ((buf (get-buffer-create "*cuc-output*"))(ret)(res)(cuc-proc))
    (with-current-buffer buf (erase-buffer))
    (setq cuc-proc (apply 'start-process process-name buf executable args))
  ))


(defun cuc-init-message-buffer()
  (let ((buf (get-buffer-create cuc-message-buffer-name)))
    (switch-to-buffer buf)
    (c++-mode)
    (toggle-truncate-lines) ;;取消自动换行
    (set-window-dedicated-p (get-buffer-window)  t)
    ))


;;(cuc-start-process)
