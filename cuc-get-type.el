(provide 'symbol-jump-clang)
(require 'cuc-base)

(defun cuc-show-message (msg)
  "在cuc-message里显示消息"
  (let ((buf (get-buffer-create cuc-message-buffer-name)))
    (with-current-buffer buf
      (erase-buffer)
      (insert msg))
    (display-buffer buf)
    ))

(defun cuc-show-result-buffer (buf)
  "把cuc-output里的内容显示到cuc-message里面"
    (if buf
      (with-current-buffer buf
        (cuc-show-message (cuc-get-result-string)))))

(defun cuc-print-type-on-cursor()
  "输出光标所在处的符号的类型名"
  (interactive)
  (setq buf (apply 'cuc-call-process
                   cuc-executable-get-type
                   (cuc-args)))
  (cuc-show-result-buffer buf))


(defun cuc-print-inclusions-get-buffer-name(arg)  
  (concat "cuc-inclusions: '"
          (file-name-nondirectory (buffer-file-name))
          "'"))

(defun cuc-print-inclusions()
  "输出当前文件的所有包含文件"
  (interactive)  
  (let ((old-cmd compile-command)(cmd))
    (save-some-buffers t)
    (setq compilation-buffer-name-function 'cuc-print-inclusions-get-buffer-name)
    (compile (concat cuc-executable-get-inclusions " " (cuc-args-string)))
    (setq compilation-buffer-name-function nil)
    (setq compile-command old-cmd)
  ))


(defun cuc-print-class-on-cursor()
  "输出光标所在处的符号的最终类名"
  (interactive)
  (setq buf (apply 'cuc-call-process
                   cuc-executable-get-class
                   (cuc-args)))
  (cuc-show-result-buffer buf))


(defun cuc-print-comment-on-cursor()
  "输出光标所在处的符号在定义处的注释"
  (interactive)
  (setq buf (apply 'cuc-call-process
                   cuc-executable-get-info
                   (cuc-args "--comment")))
  (cuc-show-result-buffer buf))

(defun cuc-print-comment-type-on-cursor()
  "输出光标所在处的符号的类型的注释"
  (interactive)
  (setq buf (apply 'cuc-call-process
                   cuc-executable-get-type
                   (cuc-args "--comment")))
  (cuc-show-result-buffer buf))

(defun cuc-print-comment-class-on-cursor()
  "输出光标所在处的符号的最终类的注释"
  (interactive)
  (setq buf (apply 'cuc-call-process
                   cuc-executable-get-class
                   (cuc-args "--comment")))
  (cuc-show-result-buffer buf))
