(load "gudx-base")


(defun gudx-break-get-breaks()
  "获取lldb的所有断点，返回一个列表，列表的每个项目是一个描述断点的字符串"
  (let ((breaks (gudx-run-command-fetch-lines "breakpoint list")))
    (setq breaks
          (delq nil
                (mapcar (lambda (item)
                          (and (string-match "^[0-9]+: " item) item))
                          breaks)))
    ))

(defun gudx-break-get-position(item)
  "获取一个断点的位置信息,返回一个映射表，字段有:
file: 文件名
line: 行号"
  (let ((ret))
    (string-match "^[0-9]+: file ='\\(.+\\)', line = \\([0-9]+\\)," item)
    (list (cons "file" (match-string 1 item))
          (cons "line" (string-to-number (match-string 2 item))))
    ))



(defun gudx-break-has-break-on-cursor()
  "判断在光标所在处是否有断点,由于断点的设置是相对于无路径的文件的，如果在两个目录有
相同的文件，可能导致不准确，这需要对lldb进一步探索，可能可以从 settings set 命令下手，
把断点的设置改成绝对路径的。"
  (let ((has-break nil)
        (pos)
        (file-name (file-name-nondirectory (buffer-file-name)))
        (line-number (line-number-at-pos))
        (breaks (gudx-break-get-breaks)))
    (message "%s  %s" file-name line-number)
    (mapcar (lambda (item)
              (setq pos (gudx-break-get-position item))
              (message "%s" pos)
              (if (and (string= file-name (cdr (assoc "file" pos)))
                       (eq line-number (cdr (assoc "line" pos))))
                  (setq has-break t)))
              breaks)
    has-break
    ))

(defun elisp-test()
  (interactive)
  (message "%s"(gudx-break-has-break-on-cursor))
  )
  