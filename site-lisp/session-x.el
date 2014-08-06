;; 赵纯华 2013-03-31
;; 扩展 session 模块
;; 基本使用方法:
;; 在 .eamcs 文件中加入
;;  (require 'session-x)
;;  (snx-initialize)
;;
;; 有这样的功能:
;; - 保存全局变量
;;   如果有全局变量 g-value 需要保存，可以这样:
;;   (defvar g-value nil)
;;   (snx-reg-var 'g-value)
;;   以后g-value改变后就会自动存入.session，并且下次启动emacs时这个变量会恢复到上一次的值

(require 'session)
(provide 'session-x)

(defvar snx-vars nil "保存全局变量符号列表")

(defvar snx-value-map nil "用于存储全局变量张开后的映射表，这个映射表会存入session")

;;内部的初始化过程
(defun snx-initialize-internel()
  ;;注意这里的次序相当重要，必须确保 snx-kill-emacs-hook 在 session-save-session
  ;;之后被调用
  (session-initialize)
  (snx-initialize-vars)
  (add-hook 'kill-emacs-hook 'snx-kill-emacs-hook)
  )


(defun snx-initialize()
  "必须调用这个函数进行初始化之后，session-x才能使用"
  (if (not snx-value-map)
      (setq snx-value-map (list (cons "head" "head"))))
  ;;真正的初始化在所有初始化完成后才进行
  (add-hook 'after-init-hook 'snx-initialize-internel)
  
  (add-to-list 'session-globals-include 'snx-value-map))

(defun snx-reg-var(var)
  "这个函数用于注册全局变量，必须通过这个函数注册后，全局变量才会被保存,例如:
(snx-reg-var 'g-value)"

  (let ((value)(name (format "%S" var)))
    (setq value (cdr (assoc name snx-value-map)))
    (if (not value)
        (setq snx-vars   (append snx-vars (list var)))             
      (set-default var value))
    ))

;;这个函数在关闭emacs时被执行，并且它应该总是在 session-save-session 之前执行，
;;它会把 snx-vars 里面的符号全部张开成名字/值对，然后复制给snx-value-map，这样就会被
;;session-save-session存入.session
(defun snx-kill-emacs-hook()
  (setq snx-value-map
        (mapcar (lambda (var)
                  (cons (format "%S" var) (default-value var)))
                snx-vars))
  )

;;这个函数在初始化时执行，并且它应该总是在 session-initialize 之后被执行，这样它可以利用
;;从.session里面恢复过来的snx-value-map初始化全局变量.
(defun snx-initialize-vars()
  (let ((name)(value))
  (mapcar (lambda (var)
            (setq name (format "%S" var))
            (setq value (cdr (assoc name snx-value-map)))
            (if value 
                (set-default var value)))
          snx-vars)
  ))
