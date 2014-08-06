;;赵纯华 2013-03-30
;;用于gud lldb 的扩展基础

(if (string= gudx-debuger "lldb")
    (load "gud")
  (progn
    (defvar gud-comint-buffer nil)))

(defvar gudx-next-command-delay 0.1
  "用于在执行上一个命令后，立即执行下一个命令时的延迟时间，因为上一个命令可能正在执行或者刚好执行完时，不能马上执行下一个命令，要让lldb进程把上一个命令完全执行完毕。
这个延迟时间如果短了，可能导致递归调用")

(defface gudx-overlay-face
  '((((class color) (min-colors 88) (background dark))
    :weight bold :background "#223388"))
  "用于 buffer 中的光标条."
  :group 'gudx-stack-mode)

(if (string= gudx-debuger "lldb")
    (defvar gudx-prompt-regexp "^(lldb) ")
  (defvar gudx-prompt-regexp "^(gdb) "))

(defvar gudx-delay-task-timer nil)

;;(defvar gudx-gud-marker-filter nil)

(defun gudx-delay-task(task)
  "延迟执行指定的调试命令任务，如果上一次准备的任务还没有执行，又要执行下一个任务，就取消上一次的任务，准备执行最新的任务，确保只有一个任务在执行，这样可以避免陷入混乱。"
  (if gudx-delay-task-timer
      (progn
        (cancel-timer gudx-delay-task-timer)
        (setq gudx-delay-task-timer nil))
    (setq gudx-delay-task-timer
          (run-with-idle-timer gudx-next-command-delay nil
                               '(lambda (task)
                                  (funcall task)
                                  (setq gudx-delay-task-timer nil))
                               task))))

(defun gudx-command-hook(string)
  (if (or (string-match "thread step-in" string)
          (string-match "thread step-over" string)
          (string-match "continu" string)
          (string-match "thread step-out" string))
      (gudx-delay-task 'gudx-stack-update))
  (gud-lldb-marker-filter string))



(defun gudx-run-command-fetch-lines (command)
  "执行命令，然后获取命令返回的所有行列表"
  (let ((gudx-fetch-string nil)
        (gudx-fetch-lines nil)
        (gudx-fetch-lines-in-progress t)
        (last-line))
    (with-current-buffer gud-comint-buffer
      ;;(if (not gudx-gud-marker-filter) (setq gudx-gud-marker-filter gud-marker-filter))
      (setq gud-marker-filter
            `(lambda (string)
               (setq gudx-fetch-string (concat gudx-fetch-string string))
               (setq gudx-fetch-lines (split-string gudx-fetch-string "\n"))
               (setq last-line (car (last gudx-fetch-lines)))
               ;;不断的从lldb进程获取字符串，然后以lldb命令提示符结束
               (if (string-match gudx-prompt-regexp last-line)
                   (setq gudx-fetch-lines-in-progress nil))
               ""))
      ;;在lldb进程执行命令，然后等待命令的返回结果
      (gud-basic-call command)
      (while gudx-fetch-lines-in-progress
        (accept-process-output (get-buffer-process gud-comint-buffer))))
    
    (with-current-buffer gud-comint-buffer
      (setq gud-marker-filter `gudx-command-hook))

    ;;去掉头和尾的行，中间才是我们所需要的行
    (setq gudx-fetch-lines (cdr gudx-fetch-lines))
    (setq gudx-fetch-lines (reverse(cdr(reverse gudx-fetch-lines))))
    ))

(defun gdux-run-sync(command)
  "同步执行命令。发送一个命令到调试进程，然后等待它结束。这个函数适合于批量的执行
调试命令的场合，使命令一个接着一个的执行"
  (let ((gudx-fetch-string nil)
        (gudx-fetch-lines nil)
        (gudx-fetch-run-sync-in-progress t))
    (with-current-buffer gud-comint-buffer
      (setq gud-marker-filter
            `(lambda (string)
               (setq gudx-fetch-string (concat gudx-fetch-string string))
               (setq gudx-fetch-lines (split-string gudx-fetch-string "\n"))
               (setq last-line (car (last gudx-fetch-lines)))
               ;;不断的从lldb进程获取字符串，然后以lldb命令提示符结束
               (if (string-match gudx-prompt-regexp last-line)
                   (setq gudx-fetch-run-sync-in-progress nil))
               string))
      ;;在lldb进程执行命令，然后等待命令结束
      (gud-basic-call command)
      (while gudx-fetch-run-sync-in-progress
        (accept-process-output (get-buffer-process gud-comint-buffer))))
    
    (with-current-buffer gud-comint-buffer
      (setq gud-marker-filter `gudx-command-hook))
  ))