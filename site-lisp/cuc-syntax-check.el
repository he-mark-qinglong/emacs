(provide 'cuc-syntax-check)
(require 'cuc-base)


(defun cuc-get-syntax-check-buffer-name(arg)  
  (concat "cuc-syntax-check: '"
          (file-name-nondirectory (buffer-file-name))
          "'"))

(defun cuc-syntax-check()
  "对当前文件进行语法检查，检查的结果输出到compile窗口"
  (interactive)  
  (let ((old-cmd compile-command)(cmd))
    (save-some-buffers t)
    (setq compilation-buffer-name-function 'cuc-get-syntax-check-buffer-name)
    (compile (concat compile-command " -s SYNTAX_CHECK_MODE=1 check-syntax CHK_SOURCES="
                     (buffer-file-name)))
    (setq compilation-buffer-name-function nil)
    (setq compile-command old-cmd)
  ))
