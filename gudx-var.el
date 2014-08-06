 (defun elisp-test()
  (interactive)
  (save-some-buffers t)
  (gud-call (concat "script reload(gudx);gudx.print_variant('objs');"))
  )

(defun gudx-print-variant(var)
  "打印变量的值，这个函数利用python程序在lldb对变量进行分析，然后打印出它的值"
  (gud-call (concat "script gudx.print_variant('" var "');"))
  )