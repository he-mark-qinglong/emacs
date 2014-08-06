(defun elisp-test()
  (interactive)
  (setq compilation-finish-function '(lambda (proc msg)
                                       (message  "%s %s" arg arg2)))
  (zch-onekey-compile-test)
  )
;;

(global-set-key "\C-xc;"      'zch-swith-to-test-file)