(defun gudx-run-command()
  "结束原来的调试进程，然后重新run"
  (interactive)
  (gud-call "process kill")
  (gud-call "run"))

(defun gudx-run-kill()
  "结束当前调试，关闭调试buffer"
  (interactive)
  (let ()
    (if (buffer-name gud-comint-buffer)
        (progn
          (with-current-buffer gud-comint-buffer (comint-skip-input))
          (if (get-buffer-process gud-comint-buffer)
              (delete-process gud-comint-buffer))
          (kill-buffer gud-comint-buffer)))
    ))

(defun gudx-switch-and-run(file args)
  (let ()
    (gdux-run-sync (concat "file " file))
    (gud-call (concat "run " args))
    (run-with-idle-timer 1.2 nil 'gudx-stack-update)))

(defun gudx-run-start-debug(command)
  (if (string= gudx-debuger "lldb")
      (progn 
        (lldb (concat "lldb " command))
        (gud-call "command script import ~/site-lisp/gudx.py")
        (sit-for 0.5))
    (progn 
      ;;(gdb (concat "gdb --annotate=3 -i=mi " command))
      (gdb (concat "gdb --annotate=3 " command))
      (sit-for 0.5))))

(defun gudx-run-has-debuger()
  "判断有没有一个debuger正在运行"
  (interactive)
  (and gud-comint-buffer
       (buffer-name gud-comint-buffer)
       (get-buffer-process gud-comint-buffer)))

;;(message "%s" (gudx-run-has-debuger))


(defun elisp-test()
  (interactive)
  (gudx-rerun-to-cursor (zch-compile-run-command) "")
  )

(defun gudx-run-start-debug-on-other-window (target)
  "在另外的窗口开始运行debuger，而不是当前窗口"
  (let ((old-buffer)(window))
    ;;记录下原来的窗口信息
    (setq old-buffer (window-buffer))
    (setq window (selected-window))
    
    (gudx-run-start-debug target)

    ;;把当前窗口恢复成原来的buffer
    (set-window-buffer (selected-window) old-buffer)

    ;;跳到哟用于显示debug的窗口，把gud的buffer设置到这个窗口
    (if (and (get-buffer cuc-message-buffer-name)
             (get-buffer-window cuc-message-buffer-name))
        ;;首选 *cuc-message* 下面的窗口为gud窗口
        (select-window (get-buffer-window cuc-message-buffer-name)))
    (other-window 1)
    (set-window-buffer (selected-window) gud-comint-buffer)

    ;;跳回原来的chuangkou
    (select-window window)))

(defun gudx-rerun-to-cursor(target args)
  "重新运行到光标所在处。如果debuger已经启动，并且在光标的前面有断点，这个函数可能会运行到前一个断点，也就是说，这个函数不会清除原来的断点。"
  (if (gudx-run-has-debuger)
      (gdux-run-sync "process kill")
    (gudx-run-start-debug-on-other-window target))
  (gud-break nil)
  (sit-for 0.2)
  (gud-call (concat "run " args))
  (sit-for 1)
  (if (string= gudx-debuger "lldb") (gudx-stack-update)))

(defun gudx-switch-to-cursor(target args)
  "重新装载目标程序，运行到光标所在处。由于重新载入了程序，因此原来的断点会全部消失，因此相对于 gudx-rerun-to-cursor 这个函数肯定会运行到光标所在处，当然前提是程序的逻辑本身就要运行到光标所在处"
  (if (gudx-run-has-debuger)
      (gdux-run-sync (concat "file " target))
    (gudx-run-start-debug-on-other-window target))
  (gud-break nil)
  (sit-for 1)
  (gud-call (concat "run " args))
  (if (string= gudx-debuger "lldb")
      (progn
          (sit-for 1)
          (gudx-stack-update))))