;;需要lldb版本的gud支持

(load-library "gudx-base")

(defvar gudx-stack-lines nil)
(defvar gudx-stack-line 1
  "记录当前选中项目的行号")
(defvar gudx-stack-overlay nil)


(defun gudx-stack-filter-lines (lines)
  (setq lines (cdr lines))
  (mapcar (lambda (line)
            (string-match "`\\(.+\\)" line)
            (match-string 1 line))
          lines))

(defun gudx-stack-update()
  (gudx-stack-display-buffer)
  )

(defun gudx-stack-display-buffer()
  (interactive)
  (let ((lines)(stack-window))
    (setq gudx-stack-line 1)
    (setq lines (gudx-run-command-fetch-lines "bt"))
    (setq gudx-stack-lines (gudx-stack-filter-lines lines))
    (with-current-buffer (gudx-stack-get-buffer)
      (erase-buffer)
      (mapcar (lambda (line)
                (insert line "\n")) gudx-stack-lines))
    (gudx-stack-show-window)
    (gudx-stack-make-overlay)
    ;;(gudx-stack-select-line)
    ))

(defun gudx-stack-get-lines()
  (let ((buffer (get-buffer gudx-stack-buffer)))
    (if (not buffer) (gudx-stack-display-buffer))
    gudx-stack-lines
  ))

(defconst gudx-stack-buffer "*gudx-stack*"
  "显示gud调用堆栈")

(defun gudx-stack-get-buffer()
  (let ((buffer (get-buffer gudx-stack-buffer)))
    (if (not buffer)
        (gudx-stack-mode))
    (setq buffer (get-buffer gudx-stack-buffer))
  ))

(defun gudx-stack-mode()
  (let ((buffer (get-buffer gudx-stack-buffer))
        (old-buffer (window-buffer)))
    (if (not buffer)
        (progn
          ;;(other-window 1)
          (setq buffer (get-buffer-create gudx-stack-buffer))
          (switch-to-buffer buffer)
          (set-buffer buffer)
          ;;(set-window-dedicated-p (get-buffer-window)  t)
          (setq major-mode 'gudx-stack-mode)
          (setq mode-name "gudx-stack")
          (gudx-stack-init-mode)
          (setq truncate-lines t)
          ;;(other-window -1)
          (switch-to-buffer old-buffer)
          ))
    (setq buffer buffer)
    ))

(defface gudx-func-name-face
'((((class color) (min-colors 88) (background dark))
   :foreground "#99ff55" :weight bold))
"" :group 'gudx-stack-mode)

(defun gudx-stack-init-mode ()
  (font-lock-mode)
  (font-lock-add-keywords 
   nil
   (list
    '(" \\([a-zA-Z0-9_]+\\)<.+>(" 1 'gudx-func-name-face)
    '("::\\([a-zA-Z0-9_]+\\)(" 1 'gudx-func-name-face)
    '("::\\(operator.+\\)(" 1 'gudx-func-name-face)
    '("^\\([a-zA-Z0-9_]+\\) \\+ " 1 'gudx-func-name-face)
    ))
  (setq truncate-lines t))



(defun gudx-stack-make-overlay ()
  "创建在 *gudx-stack* 里面的光标"
  (let ((line-begin)(face)(width)(line)
        (ov))
    (with-current-buffer (gudx-stack-get-buffer)
      (setq face 'gudx-overlay-face)
      (goto-char (point-min))
      (setq line-begin (line-beginning-position gudx-stack-line))
      (setq line (nth (- gudx-stack-line 1) gudx-stack-lines))
      (setq width (length line))
      (setq ov (make-overlay line-begin (+ line-begin width )))
      (overlay-put ov 'face face)
      (if gudx-stack-overlay
          (delete-overlay gudx-stack-overlay))
      (setq gudx-stack-overlay ov))
    ))

(defun gudx-jump-to-file (file line)
  "跳转到目标,并且切换到文件"
  (let ((buffer))
    ;;(message "result:%s,%i,%i" file line col)
    (setq buffer (find-file file))
    (goto-line (string-to-number line) buffer)
    ))


(defun gudx-stack-show-window()
  (let ((stack-window (get-buffer-window gudx-stack-buffer))
        (old-window (selected-window)))
    (if (not stack-window)
        (progn
          (if (get-buffer-window gud-comint-buffer)
              (select-window (get-buffer-window gud-comint-buffer)))          
          (other-window 1)
          (switch-to-buffer gudx-stack-buffer)
          (select-window old-window)
          ))
    ))

(defun gudx-stack-select-line()
  (let ((line (nth (- gudx-stack-line 1) gudx-stack-lines))
        (file)(line-number))
    (gudx-stack-make-overlay)
    (gud-call (concat "frame select " (number-to-string (- gudx-stack-line 1))))
    (string-match "at \\(/.+\\):\\([0-9]+\\)$" line)
    (setq file (match-string 1 line))
    (setq line-number (match-string 2 line))
    (message "%s" file)
    (if file  (gudx-jump-to-file file line-number))
    (gudx-stack-show-window)
    ))

(defun gudx-stack-up()
  (interactive)
  (if gud-comint-buffer
      (let ((count (list-length (gudx-stack-get-lines))))
        (if (or (eq gudx-stack-line count) (< gudx-stack-line 1))
            (setq gudx-stack-line 1)
          (setq gudx-stack-line (+ gudx-stack-line 1)))
        (gudx-stack-select-line)
        )))

(defun gudx-stack-down()
  (interactive)
  (if gud-comint-buffer
      (let ((count (list-length (gudx-stack-get-lines))))
        (if (eq gudx-stack-line 1)
            (setq gudx-stack-line count)
          (setq gudx-stack-line (- gudx-stack-line 1)))
        (gudx-stack-select-line)
        )))

