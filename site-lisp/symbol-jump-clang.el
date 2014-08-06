;; 用clang实现符号跳转功能
;; Copyright (C) 2013 赵纯华

;; Author: 赵纯华 <ynsjzch@163.com>
;; Keywords: jump
;; Version: 0.1

(provide 'symbol-jump-clang)

(require 'cuc-base)


(defun sj-clang-parse-output (buf)
  (let ((results)(file)(line)(column)(ret))
    "解释clang命令的执行结果，把sym的类型定义或者变量定义找出来"
    (with-current-buffer buf
      (goto-char (point-min))
      (setq results (cuc-get-result-string))
      (if (string= results "none")
          (progn 
            (message "found out!")
            (setq ret nil))
        (progn 
          (setq results (split-string results ","))
          (setq file (car results))
          (setq results (cdr results))
          (setq line (string-to-int (car results)))
          (setq results (cdr results))
          (setq column (- (string-to-int (car results)) 1))
          (setq ret (list file line column)))))
    (if ret (apply 'cuc-jump-to-file ret))
    ))

(defun sj-clang-goto-on-cursor()
  "跳到光标所在处的符号的定义"
  (interactive)
  (setq buf (apply 'cuc-call-process
                   cuc-executable-goto-define
                   (cuc-args)))
  (if buf (sj-clang-parse-output buf)))

(defun sj-clang-type-goto-on-cursor()
  "跳到光标所在处的符号的类型"
  (interactive)  
  (setq buf (apply 'cuc-call-process
                   cuc-executable-goto-type-define
                   (cuc-args)))
  (if buf (sj-clang-parse-output buf)))

(defun sj-clang-class-goto-on-cursor()
  "跳到光标所在处的符号的类型的类定义"
  (interactive)
  (setq buf (apply 'cuc-call-process
                   cuc-executable-goto-class-define
                   (cuc-args)))
  (if buf (sj-clang-parse-output buf)))

(defun sj-clang-type-goto-result-on-cursor()
  "跳到光标所在处的函数的返回类型"
  (interactive)  
  (setq buf (apply 'cuc-call-process
                   cuc-executable-goto-result-type-define
                   (cuc-args)))
  (if buf (sj-clang-parse-output buf)))

(defun sj-clang-class-goto-result-on-cursor()
  "跳到光标所在处的符号的返回类型的类定义"
  (interactive)
  (setq buf (apply 'cuc-call-process
                   cuc-executable-goto-result-class-define
                   (cuc-args)))
  (if buf (sj-clang-parse-output buf)))