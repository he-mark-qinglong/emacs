(add-to-list 'load-path "~/site-lisp")
;;(server-start)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;设置有用的个人信息。这在很多地方有用。
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq my-name "赵纯华")
(setq user-full-name "Mark Zhao")
(setq user-mail-address "ynsjzch@163.com")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 邮件设置
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq send-mail-function 'smtpmail-send-it)
(setq smtpmail-smtp-server "smtp.163.com")
(setq smtpmail-auth-credentials
      '(("smtp.163.com" 25 "ynsjzch@163.com" "666666")))

;;(setenv "MAILHOST" "ynsjzch@163.com")
(setq rmail-primary-inbox-list "ynsjzch")
(setq rmail-pop-password-required t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; UI 定义
(scroll-bar-mode nil)
(menu-bar-mode nil)
(tool-bar-mode nil)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 使用mew收发电子邮件
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(if nil
    (progn 
(autoload 'mew "mew" nil t)
(autoload 'mew-send "mew" nil t)
(if (boundp 'read-mail-command)
    (setq read-mail-command 'mew))
(autoload 'mew-user-agent-compose "mew" nil t)
(if (boundp 'mail-user-agent)
    (setq mail-user-agent 'mew-user-agent))
(if (fboundp 'define-mail-user-agent)
    (define-mail-user-agent
       'mew-user-agent
       'mew-user-agent-compose
       'mew-draft-send-message
       'mew-draft-kill
       'mew-send-hook))
(setq mew-pop-size 0)
(setq mew-smtp-auth-list nil)
(setq toolbar-mail-reader 'Mew)
(set-default 'mew-decode-quoted 't)  


(setq mew-config-alist
'(("default"
("name"         .  "Mark Zhao")
("user"         .  "ynsjzch")
("mail-domain"  .  "163.com")
("pop-server"   .  "pop.163.com")
("pop-port"     .  "110")
("pop-user"     .  "ynsjzch")
("pop-auth"     .  pass)
("smtp-server"  .  "smtp.163.com")
("smtp-port"    .  "25")
("smtp-user"    .  "ynsjzch")
("smtp-auth-list"  .  ("PLAIN" "LOGIN" "CRAM-MD5")))

))
))


;;(setq mew-icon-directory (expand-file-name "mew/etc" dtsite-dir))
(when (boundp 'utf-translate-cjk)
      (setq utf-translate-cjk t)
      (custom-set-variables
         '(utf-translate-cjk t)))
(if (fboundp 'utf-translate-cjk-mode)
    (utf-translate-cjk-mode 1)) 
(require 'flyspell) 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C++ 设置
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defconst c++-keywords
  (cons
   (regexp-opt
	(list "struct" "class" "public" "private" "interface" "virtual" "if" "for" "while" "protected" "static" "inline" "int"
	 ) 'words)
   font-lock-keyword-face))

;;(font-lock-add-keywords 'c++-mode (list c++-keywords) 'set)

(defface c++-type-face
'((((class color) (min-colors 88) (background dark))
   :foreground "#bb88ff"))
  "dnc begin end"
  :group 'c++-mode)

;;(add-hook
;; 'c++-mode-hook
 ;;(setq font-lock-type-face 'c++-type-face)
 ;;(setq font-lock-variable-name-face 'c++-type-face)
 ;;(setq font-lock-keyword-face 'c++-type-face)
;;  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; lua
(require 'lua-mode)

;;(defun my-c-mode-common-hook()
;;  (c-toggle-auto-hungry-state 1);Backspace
;;  )
;;(add-hook 'lua-mode 'my-lua-mode-common-hook)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;header
(require 'header)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; dnc 
(load "dnc")
;;dnc扩展的C++关键字
(defconst c++-dnc-keywords
  (cons
   (regexp-opt
	(list
	 "foreach" "foreach_r" "forto" "interface" "null" "foreign"  "dthis" "dsuper" "dtypeof" "decltype" "dcnew" "dcdel" "dtypename"  "dcdel_array"   "thread_value" "dnc_property_begin" "dnc_property_end" "dnc_property" "dnc_property_set" "dnc_property_get" "dnc_event" "dnc_event2" "dref" "dnew" "dnc_property2" "dnc_property_set2" "dnc_property_get2"  "true" "false" "static_assert" 
	 ) 'words)
   font-lock-keyword-face
  ))

(font-lock-add-keywords 'c++-mode (list c++-dnc-keywords))

(defface dnc-begin-end-face
'((((class color) (min-colors 88) (background dark))
   :foreground "#bb88ff"))
  "dnc begin end"
  :group 'c++-mode)
(defface dnc-begin-end-entry-face
'((((class color) (min-colors 88) (background dark))
   :foreground "#7788bb"))
  "dnc begin end"
  :group 'c++-mode)

(defface c++-operator-face
'((((class color) (min-colors 88) (background dark))
   :foreground "DeepSkyBlue1" ))
   ;;:foreground "gold" ))
  "" :group 'c++-mode)
(defface c++-number-face
'((((class color) (min-colors 88) (background dark))
   :foreground "PaleVioletRed3"))
  "" :group 'c++-mode)
(defface c++-include-face
'((((class color) (min-colors 88) (background dark))
   :foreground "#a88b17"))
  "" :group 'c++-mode)
(defface c++-lisp-face
'((((class color) (min-colors 88) (background dark))
   :foreground "#ff5500"))
  "" :group 'c++-mode)
(defface c++-define-face
'((((class color) (min-colors 88) (background dark))
   :foreground "#9955ff"))
"" :group 'c++-mode)
(defface c++-$operator-face
'((((class color) (min-colors 88) (background dark))
   :foreground "#ff66ff" :weight bold))
"" :group 'c++-mode)
(defface c++-keyword-face
'((((class color) (min-colors 88) (background dark))
   :foreground "DodgerBlue1" :weight bold))
"" :group 'c++-mode)
(defface c++-dnc-class-face
'((((class color) (min-colors 88) (background dark))
   :foreground "#ffb43a" :weight bold))
"" :group 'c++-mode)
(defface c++-property-name
'((((class color) (min-colors 88) (background dark))
   :foreground "#00ff44" :weight bold))
"" :group 'c++-mode)
(defface c++-event-name
'((((class color) (min-colors 88) (background dark))
   :foreground "#ff8844" :weight bold))
"" :group 'c++-mode)

(add-hook 'c++-mode-hook
      (lambda ()
        (font-lock-add-keywords 
         nil '(("\\(dnc_[A-Za-z_]+_begin\\|dnc_[A-Za-z_]+_end\\)" 
                (1 'dnc-begin-end-face)) 
               ("\\(dnc_cxxon_item_.*\\)(" 
                (1 'dnc-begin-end-entry-face))               
               ("#include +\\(\<.*\>\\|\".*\"\\)" 
               ;;("#include +\\(\<[a-z_.]+\>\\)" 
                (0 'c++-include-face))
               ("\\(dnc_virtual_property_get\\|dnc_virtual_property_set\\|dnc_virtual_property\\|dnc_get_set\\|dnc_set\\|dnc_get\\|dnc_property_set_and_function\\|dnc_property_get_and_function\\|dnc_property_and_function\\|dnc_handle_and_class\\|dnc_class\\|dnc_impl_object_alias\\|dnc_impl_object2\\|dnc_impl_object\\|dnc_struct\\|dnc_handle\\|dnc_object\\|dnc_black_function\\|dnc_event_cast\\|donew\\|dmnew\\|dpnew\\|dpdel\\|dhnew\\|dhdel\\|dself\\|dklass\\|dctor\\|dnc_member_function\\|dnc_virtual_cast\\|dnc_event_function\\|dnc_virtual_function\\|self\\|dnc_impl_template\\|dnc_events\\|dnc_event\\|dtnew\\|dnc_declare_class\\|dimport\\|dnc_interface\\|dnc_call_once_only\\|$n\\)" 
                (1 'c++-define-face))
               ("[ (\[{*\<\>;=%|&?^:~!,.]\\($<<\\|$>>\\)"
                (1 'c++-$operator-face))
               ("[ (\[{*\<\>;=%|&?^:~!,.]\\($[a-z][-+*/%^&\<\>=]\\|$[-+*/%^&\<\>=]\\)"
                (1 'c++-$operator-face))
               ("^\\($[a-z][-+*/%^&\<\>=]\\|$[-+*/%^&\<\>=]\\)"
                (1 'c++-$operator-face))
               ("([ \n]*\\(\$[a-zA-Z_]+\\)," 
                (1 'c++-lisp-face))
               ("\\b\\([.]*[0-9]+[.a-zA-Z_]*\\)\\b"
                (1 'c++-number-face))
               ("dnc_property_and_function(\\([a-zA-Z_0-9]*\\))"
                (1 'c++-property-name))
               ("dnc_property_set_and_function(\\([a-zA-Z_0-9]*\\))"
                (1 'c++-property-name))
               ("dnc_property_get_and_function(\\([a-zA-Z_0-9]*\\))"
                (1 'c++-property-name))
               ("dnc_get_set(\\([a-zA-Z_0-9]*\\),"
                (1 'c++-property-name))
               ("dnc_get(\\([a-zA-Z_0-9]*\\),"
                (1 'c++-property-name))
               ("dnc_set(\\([a-zA-Z_0-9]*\\),"
                (1 'c++-property-name))
               ("dnc_event(\\([a-zA-Z_0-9]*\\),"
                (1 'c++-event-name))
               ("\\(\+\\|\-\\|\[\\|\]\\|\*\\|==\\|!=\\|[.,!~:\{\}\(\);=%|&?\+\-\*/\>\<^]\\)" 
                (1 'c++-operator-face))
)
)))

(defun dnc-cxxon-get-keyword(arg)
  (let ((ret))
  (message "--%s--" arg)
  (setq ret (+ arg 1))
  (setq ret nil)
  ))

;;(font-lock-add-keywords 'c++-mode (list 'dnc-cxxon-get-keyword))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; javascript
;;(autoload 'javascript-mode "javascript" nil t)
;;(add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode))

;;ecmascript-mode
;;(add-to-list 'auto-mode-alist '("\\.js\\'" . ecmascript-mode))
;;(autoload 'ecmascript-mode "ecmascript-mode" nil t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; doxymacs
(require 'doxymacs)
(add-hook 'php-mode-user-hook 'doxymacs-mode)
(add-hook 'c-mode-common-hook 'doxymacs-mode)
(add-hook 'c++-mode-common-hook 'doxymacs-mode)
(defun my-doxymacs-font-lock-hook ()
  (if (or (eq major-mode 'c-mode)
          (eq major-mode 'c++-mode)
          (eq major-mode 'php-mode)
          (eq major-mode 'idl-mode))
        (doxymacs-font-lock)))
(add-hook 'font-lock-mode-hook 'my-doxymacs-font-lock-hook)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; others

;(setq display-time-24hr-format t)
;(setq display-time-day-and-date t)
;(display-time)
(setq inhibit-startup-message t)

;;syntax Highlighting
(global-font-lock-mode t)	
;;auto indent

;;'(font-lock-comment-face
;;  ((((class color) (background light))
;;    (:foreground "Firebrick" :slant italic))))


(fset 'yes-or-no-p 'y-or-n-p)

(transient-mark-mode t)

(setq column-number-mode t)
(setq line-number-mode t)





(setq-default make-backup-files nil)

(setq w32-use-w32-font-dialog nil)



(setq-default indent-tabs-mode nil)

(setq scroll-margin 3 scroll-conservatively 10000)

(setq frame-title-format "%b %f")



(put 'set-goal-column 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'LaTeX-hide-environment 'disabled nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; dired
(require 'dired-x)

(setq dired-recursive-copies 'top)
(setq dired-recursive-deletes 'top)
;; 快捷键: !
(setq dired-guess-shell-alist-user
(list
(list "\\.chm$" "xchm")
(list "\\.rm$" "gmplayer")
(list "\\.rmvb$" "gmplayer")
(list "\\.mkv$" "gmplayer")
(list "\\.avi$" "gmplayer * &")
(list "\\.asf$" "gmplayer")
(list "\\.wmv$" "gmplayer")
(list "\\.mpg$" "gmplayer")
(list "\\.htm$" "firefox")
(list "\\.html$" "firefox")
(list "\\.pdf$" "evince")
(list "\\.doc$" "soffice")
))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; project
(load "project")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; can open zip file
(auto-compression-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; the mouse cursor will dodge
(mouse-avoidance-mode 'animate) ;;
(show-paren-mode 1)		     ;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Makefile 
(setq auto-mode-alist (append auto-mode-alist
'( ("\\.ma?k\\'" . makefile-mode)
("\\(M\\|m\\|GNUm\\)akefile\\(\\.in\\)?" . makefile-mode)
("\\.cfg\\'" . makefile-mode)
))) 



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Function keys

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Mouse keys

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; tab keys
(setq backup-by-copying-when-mismatch t)	
(setq-default indent-tabs-mode nil) 
(setq default-tab-width 4)



;;(require 'cedet)
;;(require 'ecb)

;;(require 'tabbar)
;;(load "idb")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; svn
;;use
;;M-x svn-status 启动psvn
;;psvn 比emacs的pcl-cvs提供更加完整的svn操作支持
;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(require 'psvn)


(defconst header-copyright-notice 
"Copyright (C) 2007 Mark Zhao (ynsjzch@163.com).")



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; flex
(autoload 'bison-mode "bison-mode.el")
(autoload 'flex-mode "flex-mode")
(add-to-list 'auto-mode-alist '("\\.y\\'" . bison-mode))
(add-to-list 'auto-mode-alist '("\\.l\\'" . bison-mode)) ;;flex-mode is bad


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;剪贴板
;;解决其他程序粘贴到emacs是乱码的问题
;;(set-clipboard-coding-system 'utf-8)
;;(set-clipboard-coding-system 'ctext)
;;允许emacs与外部程序粘贴，如果没有这个设置，默认情况下有时粘贴会有问题
(setq x-select-enable-clipboard t) 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; font
;;字 体 设 置
;;X 下的字体
(if (string= window-system "x")
    (set-default-font "-*-Liberation Mono-normal-r-normal--12-*-*-*-*-*-iso8859-1"))
(if (string= window-system "ns")
    (set-default-font "-*-Liberation Mono-normal-r-normal--14-*-*-*-*-*-iso8859-1"))

      ;;(set-fontset-font "fontset-default" 'gb18030'("Microsoft YaHei" . "unicode-bmp"))
;;      ))

;;Windows 下的字体
(if (string= window-system "w32")
    (progn
      (set-language-environment 'utf-8)
      ))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; frame font cursor
;;(set-language-environment 'chinese-gb2312)
;;(setq default-frame-alist
;;      '((width . 120) (height . 50)
;;        (cursor-color . "white")
;;        (cursor-type . box)
;;(font . "-*-Courier-bold-r-*-12-*-*-*-*-*-*-iso8859-2")))
;;设置字体为新宋体 ( Only for windows )
;;(set-face-font 'default "-outline-新宋体-normal-r-normal-normal-*-*-96-96-c-*-iso8859-1")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; c/c++

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 定位：窗口切换，翻页，文件切换...

;; 源代码文件跳转
(setq ff-other-file-alist
      '((".h" (".c" ".cpp" ".cc"))
        (".cpp" (".h"))
        (".cc"  (".h"))
        (".c"   (".h"))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; general
;;普 通 设 置

;;去掉工具条和菜单条,都可以使用快捷键进行操作，没有它们存在的必要
(tool-bar-mode)
(menu-bar-mode)


;;鼠标滚轮，默认的滚动太快，这里设为3行
(defun up-slightly () (interactive) (scroll-up 3))
(defun down-slightly () (interactive) (scroll-down 3))


;;当shell或者gdb退出时自动关闭其buffer
(add-hook 'shell-mode-hook 'mode-hook-func)
;;(add-hook 'gdb-mode-hook 'mode-hook-func)
(defun mode-hook-func  ()
  (set-process-sentinel (get-buffer-process (current-buffer))
                        #'kill-buffer-on-exit))
(defun kill-buffer-on-exit (process state)
  (message "%s" state)
  (if (or
       (string-match "exited abnormally with code.*" state)
       (string-match "finished" state))
      (kill-buffer (current-buffer))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(clang "clang++")
 '(clang-flags (quote ("-I../include")))
 '(column-number-mode t)
 '(ecb-expand-methods-switch-off-auto-expand t)
 '(ecb-options-version "2.40")
 '(gdb-max-frames 60)
 '(show-paren-mode t)
 '(transient-mark-mode t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

;;==============================================================================
;; c/c++
;;==============================================================================
;; c++

;;(defun my-c++-mode-hook()
;;  (setq tab-width 2 indent-tabs-mode nil)
;;)
;;(add-hook 'c++-mode-hook 'my-c++-mode-hook)

;;cscope查找设置
;(global-set-key [C-.] 'cscope-find-global-definition) ;;搜索定义
;(global-set-key "\C-d" 'cscope-find-global-definition)
;(global-set-key [C-,] 'cscope-pop-mark) ;; 跳出转向;;设置Alt+Enter为自动补全菜单

;(global-set-key [(f6)]  'cscope-set-initial-directory)
;(define-key global-map [(control f4)]  'cscope-unset-initial-directory)
;(global-set-key [(f3)]  'cscope-find-this-symbol)
;(global-set-key [(f4)]  'cscope-find-global-definition)
;(define-key global-map [(control f7)]  'cscope-find-global-definition-no-prompting)
;(define-key global-map [(control f8)]  'cscope-pop-mark)
	;(define-key global-map [(control f9)]  'cscope-next-symbol)
	;(define-key global-map [(control f10)] 'cscope-next-file)
	;(define-key global-map [(control f11)] 'cscope-prev-symbol)
	;(define-key global-map [(control f12)] 'cscope-prev-file)
    ;(define-key global-map [(meta f9)]  'cscope-display-buffer)
    ;(defin-ekey global-map [(meta f10)] 'cscope-display-buffer-toggle)

;;(global-set-key [(meta return)] 'semantic-ia-complete-symbol-menu)

;;头文件
(if (string= window-system "w32")
    (progn
      (setq cc-search-directories
            (list "."
                  "d:/dev/include"
                  "d:/gnu-win32/mingw/include"
                  "d:/gnu-win32/mingw/lib/gcc/mingw32/4.5.2/include/c++"
                  )))
  (progn
    (setq cc-search-directories
          (list
           "."
           "/home/dev/include"
           "/home/mark/work/linux-2.6.23.1/include"
           "/usr/include"
           "/usr/include/c++/4.7.0"
           "/mnt/data/soft/android/android-ndk/platforms/android-3/arch-arm/usr/include"
           "/usr/include/wine/windows"
           "/mnt/data/soft/cocos2d-x/cocos2dx"
           "/mnt/data/soft/cocos2d-x/cocos2dx/include"
           ))))


(if (eq window-system nil)
    ()
  (progn
    (require 'color-theme)
    (color-theme-gnome2)
    ;;下面的命令可以列出系统颜色
    ;;M-x list-colors-display
    ))

;;c
(defun my-c-mode-common-hook()
  (setq tab-width 4 indent-tabs-mode nil)
  (c-set-style "stroustrup")
  (c-toggle-auto-hungry-state 1);Backspace
  (c-toggle-auto-state 0)
  (c-set-offset 'member-init-intro '++)
  (c-set-offset 'innamespace 0)) ;;名字空间里无缩进
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;;auto indent 很奇怪，设置自动缩进需要用global-set-key
(global-set-key "\C-m" 'reindent-then-newline-and-indent)


;;隐藏显示程序块
(add-hook 'c++-mode-hook         
          (lambda () (hs-minor-mode 1)))

;;C/C++语法检查
;;(global-cwarn-mode 1)

(add-to-list 'auto-mode-alist '("\\.dnc\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.c\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.hi\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.dox\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\'" . php-mode))
(add-to-list 'auto-mode-alist '("\\.mm\\'" . objc-mode))
;;(add-to-list 'auto-mode-alist '("\\.php\\'" . c++-mode))
;;(add-to-list 'auto-mode-alist '("\\.js\\'" . c++-mode))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ajax
;;(load "ajax.el")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; svn
;;(load "psvn")




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cimpile
;; 编译定制
(setq zch-compile-test-file "")
(setq zch-compile-test-args "")
(setq compile-command "make -j 2 d=true")

(defun zch-file-name (name)
  "获得文件名，返回结果不包括路径和扩展名"
  (setq fields (split-string name "/"))
  (setq name (elt fields (- (length fields) 1)))
  (setq len (length name))
  (setq i len)
  (setq ch "")
  (while (and (> i 0) (not (string= ch ".")))
    (progn
      (setq ch (substring name (- i 1) i))
      (setq i (- i 1))))
  (setq name (substring name 0 i)))


(defun zch-file-extension (name)
  "获取文件扩展名，如果文件没有扩展名返回空字符串"
  (setq len (length name))
  (setq i len)
  (setq ch "")
  (while (and (> i 0) (not (string= ch ".")))
    (progn
      (setq ch (substring name (- i 1) i))
      (setq i (- i 1))))
  (if (> i 0)
      (setq name (substring name (+ i 1)))
    (setq name "")))



(defun zch-cpp-file-type (name)
  "获取cpp文件类型，返回值可以是cpp,t,p,e
例如:
foo.cpp      --  cpp
foo.t.cpp    --  t
foo.p.cpp    --  p
"
  (setq fields (split-string name "\\."))
  (setq name (elt fields (- (length fields) 1)))
  (if (and (>= (length fields) 3) (string= name "cpp"))
      (setq name (elt fields (- (length fields) 2)))
    (setq name "")))

(defun zch-update-ac-clang-flags()
  "从Makefile更新auto-complete所需要编译参数,这样可以使得智能感知系统和Makefile里的编译参数是同步的，达到完美的感知能力。"
  (setq auto-complete-args (shell-command-to-string
                            (concat compile-command " auto_complete_cflags")))
  (setq auto-complete-args (split-string auto-complete-args "[ \n]"))
  (setq gt-clang-flags auto-complete-args)
  (setq sj-clang-flags auto-complete-args)
  (setq clang-flags auto-complete-args)
  (setq ac-clang-flags auto-complete-args))

(defun zch-compile(command)
  "截获编译命令，在编译之前做一些事情"
  (setq temp compile-command)
  (zch-update-ac-clang-flags)
  (compile command)
  (setq compile-command temp)
  )

(defun zch-onekey-compile ()
	"先保存所有文件，然后编译程序，不包括测试程序"
	(interactive)
	(save-some-buffers t)
    (zch-compile compile-command))

(defun zch-onekey-compile-test()
	"先保存所有文件，然后编译程序，包括当前的测试程序"
	(interactive)
	(save-some-buffers t)
    (setq command compile-command)
    (setq extension (zch-cpp-file-type buffer-file-name))
    (setq test-name nil)
    (setq type nil)

    (if (or (string= extension "t") (string= extension "e"))
        (setq zch-compile-test-file buffer-file-name))
    (if (not (string= zch-compile-test-file ""))
        (setq extension (zch-cpp-file-type zch-compile-test-file)))

    (message "extension")

    ;;如果是.ct或者.ce文件，修改测试名字
    (cond
     ((string= extension "t")   (setq type " t="))
     ((string= extension "e")   (setq type " e=")))

    (if (string= zch-compile-test-file "")
        (setq command compile-command)
      (progn
        (setq test-name (zch-file-name zch-compile-test-file))
        (setq test-name (zch-file-name test-name))
        (setq command (concat compile-command type test-name))))
    (zch-compile command))

(defun zch-compile-clean ()
  "在编译命令之后加上clean,清除完了再恢复原来的编译命令"
	(interactive)
	(save-some-buffers t)
    (zch-compile (concat compile-command " clean")))

(defun zch-compile-get-param(name)
  "获得编译命令里的参数值"
  (let ((fields)(ret))
    (setq fields (split-string compile-command " "))
    (while fields
      (setq param (car fields))
      (setq pair (split-string param "="))
      (setq key (car pair))

      (if (and (eq (length pair) 2) (string= key name))
          (progn
            (setq val (cdr pair))
            (setq ret (car val))
            (setq fields nil))
        (setq fields (cdr fields)))
      )
    (if (and (string= window-system "w32") (string= name "p"))
        (setq ret "msw")
    (setq ret ret))))

(defun zch-compile-test-prefix()
  "获得工程的测试目录，这个目录根据编译参数产生"
  (let ((p)(ret))
    (setq p (zch-compile-get-param "p"))
    (if (not p)
        (if (string= window-system "ns")
            (setq p "mac")
        (setq p "linux")))
    (setq d (zch-compile-get-param "d"))
    (if (and d (string= d "true"))
        (setq ret (concat (dnc-project-name) "-d." p))
      (setq ret (concat  (dnc-project-name) "." p)))
    ))

(defun zch-compile-run-command()
  "获得测试程序的路径和名称，使用这个名称可以直接运行"
  (let ((p)(ret)(dir-spliter)(name))
    (setq p (zch-compile-get-param "p"))
    (setq name (zch-file-name (zch-file-name zch-compile-test-file)))
    (if (string= window-system "w32")
        (setq dir-spliter "\\")
      (setq dir-spliter "/"))

    (if (string= p "mac")
        (if (string= "t" (zch-cpp-file-type zch-compile-test-file))
            (setq ret (concat "../test/" name ".app/Contents/MacOS/main"))
          (setq ret (concat "../test/" name ".app/Contents/MacOS/main")))
      (if (string= "t" (zch-cpp-file-type zch-compile-test-file))
            (setq ret (concat ".."dir-spliter"test"dir-spliter
                              (zch-compile-test-prefix) "."
                              (zch-file-name zch-compile-test-file)))
          (setq ret (concat ".."dir-spliter"bin"dir-spliter name))))
      
    
    (if (string= "msw" p)
        (setq ret (concat ret ".exe")))
    (if (string= "ndk" p)
        (setq ret "~/android-sdk/platform-tools/adb shell am start com.example.hellojni/com.example.hellojni.HelloJni"))
    (setq ret ret)
    ))



(defun zch-compile-run ()
  "编译并运行编译好的程序"
  (interactive)
  (save-some-buffers t)
  (setq extension (zch-cpp-file-type buffer-file-name))
  (setq test-name nil)
  (setq type nil)

  (if (or (string= extension "t") (string= extension "e"))
      (setq zch-compile-test-file buffer-file-name))
  (if (not (string= zch-compile-test-file ""))
      (setq extension (zch-cpp-file-type zch-compile-test-file)))
  
  ;;如果是.ct或者.ce文件，修改测试名字
  (cond
   ((string= extension "t") (setq type " t="))
   ((string= extension "e") (setq type " e=")))
  
  (if (string= zch-compile-test-file "")
      (setq command compile-command)
    (progn
      (setq test-name (zch-file-name zch-compile-test-file))
      (setq test-name (zch-file-name test-name))
      (setq command (concat compile-command type test-name))
      ;;(setq command (concat command " && " (zch-compile-run-command)))
      (setq command (concat command " args=\"" zch-compile-test-args "\" run"))))
  (zch-compile command))

(setq zch-compile-run-any-command "gcc")
(defun zch-compile-run-any ()
  "编译任意的单个文件并运行编译好的程序"
  (interactive)
  (save-some-buffers t)
  (setq temp compile-command)
  (setq test-name nil)
  (setq type nil)
  (setq extension (file-name-extension buffer-file-name))
  (setq run-name (zch-file-name buffer-file-name))
  (setq run-file (concat run-name "." extension))
  
  (setq command (concat zch-compile-run-any-command " -o " run-name " " run-file))
  (setq command (concat command " && ./" run-name))
  (setq command (concat command " " zch-compile-test-args))
  
  (compile command)
  (setq compile-command temp))


(defun zch-modify-compile-run-any-command(command)
  "修改zch-compile-run-any命令所使用的编译命令"
  (interactive
       (list (read-from-minibuffer "Modify compile run any command: "
                                   (eval zch-compile-run-any-command) nil nil))
       (list (eval zch-compile-run-any-command)))
  (setq zch-compile-run-any-command command))

(defun zch-compile-test-all()
  "编译所有测试程序"
  (interactive)
  (save-some-buffers t)
  (setq temp compile-command)
  (compile (concat compile-command " args=\"" zch-compile-test-args "\" compile_test_all"))
  (setq compile-command temp))

(defun zch-test-all()
  "编译所有测试程序并且运行它们"
  (interactive)
  (save-some-buffers t)
  (zch-compile (concat compile-command " args=\"" zch-compile-test-args "\" test")))

(defun zch-compile-exe-all()
  "编译所有可执行程序"
  (interactive)
  (save-some-buffers t)
  (zch-compile (concat compile-command " compile_exe_all")))


(defun zch-compile-modify-test-args(args)
  "修改测试程序的参数"
  (interactive
       (list (read-from-minibuffer "Modify test arguments: "
                                   (eval zch-compile-test-args) nil nil))
       (list (eval zch-compile-test-args)))
  (setq zch-compile-test-args args))


(defun zch-modify-compile-command(command)
  "修改编译命令compile-command，并且执行编译"
  (interactive
       (list (read-from-minibuffer "Modify compile command: "
                                 (eval compile-command) nil nil
                                 '(compile-history . 1)))
       (list (eval compile-command)))
  (save-some-buffers t)
  (compile command))

(defun zch-compile-modify-test (command)
  "修改测试单元zch-compile-test-file，并且执行编译和程序"
  (interactive
       (list (read-from-minibuffer "Modify test unit: "
                                   (eval zch-compile-test-file) nil nil))
       (list (eval zch-compile-test-file)))
  (setq zch-compile-test-file command)
  (zch-compile-run))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; debug
;;调试定制

;; 对于osx，需要装载修改过的gud模块。
(if (string= window-system "ns")
    (load "gud"))

(defun zch-gdb-get-file ()
  "获得正在调试的可执行文件名"
  (setq file (buffer-name gud-comint-buffer))
  (setq len (length file))
  (setq file (substring file 5 (- len  1))))

(defun zch-gdb-onekey-debug (command)
  "一键调试"
  (let ((old-buffer)(window))
	(interactive)
    (setq old-buffer (window-buffer))
    (setq window (selected-window))
    (if (string= window-system "ns")        
        (lldb (concat "lldb " command))
      (gdb (concat "gdb --annotate=3 -i=mi " command)))
    
    (set-window-buffer (selected-window) old-buffer)
    (other-window 1)
    (set-window-buffer (selected-window) gud-comint-buffer)
    (select-window window)))

(defun zch-gdb-ptype()
  "打印光标所在处的标识符的类型"
  (interactive)
  (setq symbol (sbw-get-symbol-at-cursor))
  (if symbol
      (gud-call (concat "ptype " symbol))))

(defun zch-gdb-print-dynamic-class(obj-name)
  "使用lldb的python接口打印dnc动态对象的类型。也就是说可以通过父类的引用查看到最终子类的类型"
  (gud-call (concat 
   "script obj=lldb.frame.FindVariable('" obj-name "');\
    mh=obj.GetChildMemberWithName('mh');\
    klass=mh.GetChildMemberWithName('klass');\
    name=klass.GetChildMemberWithName('name');\
    name_class=name.GetSummary()[1:-1]+'_class';\
    name_class=name_class.replace('.','::');\
    type=lldb.target.FindTypes(name_class).GetTypeAtIndex(0);\
    type=type.GetPointerType();\
    klass=klass.Cast(type);\
    print klass.Dereference();")))

(defun zch-gdb-ptype-dcptr()
  "打印光标所在处的标识符的类型"
  (interactive)
  (setq symbol (sbw-get-symbol-at-cursor))
  (if symbol
      (if (string= window-system "ns")
          (zch-gdb-print-dynamic-class symbol)
        (gud-call (concat "print *" symbol ".mh->klass")))
    ))


(defun zch-gdb-print-dynamic-object(obj-name)
  "使用lldb的python接口打印dnc动态对象的数据。也就是说可以通过父类的引用查看到最终子类的数据"
  (gud-call (concat 
   "script obj=lldb.frame.FindVariable('" obj-name "');\
    mh=obj.GetChildMemberWithName('mh');\
    klass=mh.GetChildMemberWithName('klass');\
    name=klass.GetChildMemberWithName('name');\
    name_handle=name.GetSummary()[1:-1]+'_handle';\
    name_handle=name_handle.replace('.','::');\
    type=lldb.target.FindTypes(name_handle).GetTypeAtIndex(0);\
    type=type.GetPointerType();\
    mh=mh.Cast(type);\
    print mh.Dereference()")))

(defun zch-gdb-print-dcptr()
  "打印光标所在处的智能指针的对象"
  (interactive)
  (setq symbol (sbw-get-symbol-at-cursor))
  (if symbol
      (if (string= window-system "ns")
          (zch-gdb-print-dynamic-object symbol)
        (message "%s" (gud-call (concat "print *" symbol ".mh"))))
    ))

(defun zch-gdb-pstar-dcptr()
  "打印光标所在处的智能指针的对象"
  (interactive)
  (setq symbol (sbw-get-symbol-at-cursor))
  (if symbol
      (gud-call (concat "print *" symbol ".m_p"))))

(setq zch-gdb-source-window nil)

(defun zch-gdb-switch-window()
  "在源代码窗口和调试窗口之间进行切换"
  (interactive)
  (if (eq (window-buffer) gud-comint-buffer)
      (select-window zch-gdb-source-window)
    (progn 
      (setq zch-gdb-source-window (selected-window))
      (setq gdb-window (get-buffer-window gud-comint-buffer))
      (if gdb-window
          (select-window gdb-window)
        (progn
          (other-window 1)
          (set-window-buffer (selected-window) gud-comint-buffer))))))

(defun zch-gdb-frame-buffer(name)
  "打开指定调试frame窗口,name 可以是任何gdb-buffer-rules-assoc变量列出的名字"
  (setq window (selected-window))
  (other-window 1)
  (if (eq (window-buffer) gud-comint-buffer) 
      (other-window 1))
  (if (eq (gdb-get-buffer name) nil)
      (set-window-buffer (selected-window) (gdb-get-buffer-create name)))
  (if (eq (get-buffer-window (gdb-get-buffer name)) nil)
      (set-window-buffer (selected-window) (gdb-get-buffer name)))
  (select-window window))
(defun zch-gdb-down ()
  (interactive)
  (gud-call "down"))
(defun zch-gdb-up ()
  (interactive)
  (gud-call "up"))

(defun zch-gdb-assembler-buffer()
  "在另外一个窗口打开assembler frame"
  (interactive)
  (zch-gdb-frame-buffer 'gdb-assembler-buffer))
(defun zch-gdb-locals-buffer()
  "在另外一个窗口打开locals frame"
  (interactive)
  (zch-gdb-frame-buffer 'gdb-locals-buffer))
(defun zch-gdb-memory-buffer()
  "在另外一个窗口打开memory frame"
  (interactive)
  (zch-gdb-frame-buffer 'gdb-memory-buffer))
(defun zch-gdb-registers-buffer()
  "在另外一个窗口打开registers frame"
  (interactive)
  (zch-gdb-frame-buffer 'gdb-registers-buffer))
(defun zch-gdb-threads-buffer()
  "在另外一个窗口打开threads frame"
  (interactive)
  (zch-gdb-frame-buffer 'gdb-threads-buffer))
(defun zch-gdb-stack-buffer()
  "在另外一个窗口打开stack frame"
  (interactive)
  (zch-gdb-frame-buffer 'gdb-stack-buffer))
(defun zch-gdb-breakpoints-buffer()
  "在另外一个窗口打开breakpoints frame"
  (interactive)
  (zch-gdb-frame-buffer 'gdb-breakpoints-buffer))
(defun zch-gdb-inferior-io()
  "在另外一个窗口打开inferior frame"
  (interactive)
  (zch-gdb-frame-buffer 'gdb-inferior-io))
(defun zch-gdb-partial-output-buffer()
  "在另外一个窗口打开partial output frame"
  (interactive)
  (zch-gdb-frame-buffer 'gdb-partial-output-buffer))

(defun zch-gdb-print-object()
  "打开打印对象状态，打开后能通过C++的虚拟机制打印一个对象的最终类的信息"
  (interactive)
  (gud-call "set print object on"))
  

;;调试环境
;;(setq gud-tooltip-mode t)
;;(setq gdb-many-windows t)

;;(require 'gdb-ui)

;;gdb正在调试的文件
(setq zch-gdb-file "")

(defun zch-gdb-test-debug-or-go ()
  "调试测试文件。这个函数的行为是这样的:
   *. 如果当前buffer是一个.t.cpp或者.e.cpp文件，并且gdb没有启动，那么启动一个gdb，并且装载当前的测试文件
   *. 如果当前buffer不是一个.t.cpp或者.e.cpp文件，并且gdb没有启动，那么启动一个gdb，并且装载当前的测试文件
   *. 如果gdb已经启动，那么继续进测试或者开始运行测试
   *. 如果当前buffer是一个.t.cpp或者.e.cpp文件，那么这个函数会把zch-compile-test-file变量改成当前buffer里的测试名称
"
  (interactive)
 
  (if (string= (zch-file-extension buffer-file-name) "t")
      (setq zch-compile-test-file buffer-file-name))
  (if (string= zch-compile-test-file "")
      (setq command "")
    (setq command (zch-compile-run-command)))

  ;;判断是否有gdb在运行
  (setq has-gdb nil)
  (if (and gud-comint-buffer
           (buffer-name gud-comint-buffer)
           (get-buffer-process gud-comint-buffer)
           (with-current-buffer gud-comint-buffer (eq gud-minor-mode 'gdba)))
      (setq has-gdb "true"))

  (if has-gdb
      (progn 
        (if (eq (get-buffer-window gud-comint-buffer) nil)
            (progn
              (other-window 1)
              (set-window-buffer (selected-window) gud-comint-buffer)))
        
        (setq window (selected-window))
        (gud-call (if gdb-active-process "continue" "run") "")
        (select-window window))
    (progn 
      (setq zch-gdb-source-window (selected-window))
      (zch-gdb-onekey-debug command)
      (setq zch-gdb-file command))))
    

(defun zch-gdb-debug-or-go ()
  "If gdb isn't running; run gdb, else call gud-go."
  (interactive)
  (if (and gud-comint-buffer
           (buffer-name gud-comint-buffer)
           (get-buffer-process gud-comint-buffer)
           (with-current-buffer gud-comint-buffer (eq gud-minor-mode 'gdba)))
      (progn
        (setq window (selected-window))
        (gud-call (if gdb-active-process "continue" "run") "")
        (select-window window))
    (zch-gdb-onekey-debug "")))

(defun zch-gdb-break-remove ()
  "Set/clear breakpoin."
  (interactive)
  (save-excursion
    (if (eq (car (fringe-bitmaps-at-pos (point))) 'breakpoint)
        (gud-remove nil)
      (gud-break nil))))

(defun zch-gdb-break-watch()
  "对光标当前的变量设置内存断点"
  (interactive)
  (setq symbol (sbw-get-symbol-at-cursor))
  (if symbol
      (gud-call (concat "watch " symbol))))
(defun zch-gdb-break-rwatch()
  "对光标当前的变量设置内存断点"
  (interactive)
  (setq symbol (sbw-get-symbol-at-cursor))
  (if symbol
      (gud-call (concat "rwatch " symbol))))
(defun zch-gdb-break-awatch()
  "对光标当前的变量设置内存断点"
  (interactive)
  (setq symbol (sbw-get-symbol-at-cursor))
  (if symbol
      (gud-call (concat "awatch " symbol))))


(defun zch-gdb-kill ()
  "Kill gdb process."
  (interactive)
  (with-current-buffer gud-comint-buffer (comint-skip-input))
  (kill-process (get-buffer-process gud-comint-buffer)))
;;(setq gdb-many-windows t)



(defun xcode:buildandrun ()
  "通过向Xcode发送command-r完成自动建造和运行操作"
 (interactive)
 (do-applescript
  (format
   (concat
    "tell application \"Xcode\" to activate \r"
    "tell application \"System Events\" \r"
	"    tell process \"Xcode\" \r"
	"	    key down {command} \r"
	"	    keystroke \"r\" \r"
	"	    key up {command} \r"
    "    end tell \r"
    "end tell \r"
    ))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;符号查找
(load "sourcebrowser")
(load-library "symbol-jump-clang")
(load-library "get-type-clang")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;窗口,文件切换
(defun switch-buffer()
  (interactive)
  (set-window-buffer (selected-window) (other-buffer)))

(defun onekey-kill-buffer()
  (interactive)
  (kill-buffer (current-buffer)))

(setq g-switch-ecb-flag t)
(defun switch-ecb-activate()
  (interactive)
  (if g-switch-ecb-flag
      (progn
        (setq g-switch-ecb-flag nil)
        (ecb-activate))
    (progn
      (setq g-switch-ecb-flag t)
      (ecb-deactivate))))

(setq g-previous-buffer-name nil)
(defun switch-ecb-edit-window()
  "在ECB窗口和编辑窗口之间进行切换"
  (interactive)
  (let ((current-buffer-name (buffer-name)))
    (if (or (string= current-buffer-name " *ECB Directories*")
            (string= current-buffer-name " *ECB Sources*")
            (string= current-buffer-name " *ECB Methods*")
            (string= current-buffer-name " *ECB History*"))
        (ecb-goto-window-edit-last)
      (progn
        (if (string= g-previous-buffer-name " *ECB Directories*")
            (ecb-goto-window-directories)()
            (if (string= g-previous-buffer-name " *ECB Sources*")
                (ecb-goto-window-sources)()
                (if (string= g-previous-buffer-name " *ECB Methods*")
                    (ecb-goto-window-methods)()
                    (if (string= g-previous-buffer-name " *ECB History*")
                        (ecb-goto-window-history)()
                        (ecb-goto-window-methods)))))))
      (setq g-previous-buffer-name current-buffer-name)
      ))

(defun insert-my-copyright()
  (interactive)
  (insert my-name (format-time-string " %Y-%m-%d")  " ynsjzch@163.com"))
(defun insert-date()
  (interactive)
  (insert (format-time-string "%Y-%m-%d")))
(defun replace-word()
  "替换一个单词，并且查找时区分大小写"
  (interactive)
  )

;;全屏
(defun my-fullscreen ()
  (interactive)
  (if (string= window-system "w32")
      (shell-command "msw-fullscreen.exe")
    (if (string= window-system "ns")
        ;;Mac OS X 上emacs24.3之后可以官方支持全屏幕，可以在
        ;;http://emacsformacosx.com下载最新版本，不过现在只有24.2，
        ;;现在暂时用一个补丁版本
        (ns-toggle-fullscreen)
      (progn
        (x-send-client-message
         nil 0 nil "_NET_WM_STATE" 32
         '(2 "_NET_WM_STATE_FULLSCREEN" 0))
        ))))

;;最大化
(defun my-maximized-horz ()
  (interactive)
  (x-send-client-message
   nil 0 nil "_NET_WM_STATE" 32
   '(1 "_NET_WM_STATE_MAXIMIZED_HORZ" 0)))
(defun my-maximized-vert ()
  (interactive)
  (x-send-client-message
   nil 0 nil "_NET_WM_STATE" 32
   '(1 "_NET_WM_STATE_MAXIMIZED_VERT" 0)))
(defun my-maximized ()
  (interactive)
  (x-send-client-message
   nil 0 nil "_NET_WM_STATE" 32
   '(1 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
  (interactive)
  (x-send-client-message
   nil 0 nil "_NET_WM_STATE" 32
   '(1 "_NET_WM_STATE_MAXIMIZED_VERT" 0)))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; buffer 操作
(defun zch-revert-buffer()
  "刷新buffer，当文件在外部被修改时有用"
  (interactive)
  (revert-buffer nil t))

(defun zch-revert-buffer-all()
  "重新装载所有buffer中的文件"
  (interactive)
  (let ((buffers (buffer-list))
        (old-buffer (current-buffer)
        ))
  (while buffers
    (setq buffer (car buffers))
    (set-buffer buffer)
    (if (buffer-file-name)
        (revert-buffer nil t))
    (pop buffers))
  (set-buffer old-buffer)
))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 查找替换
(setq zch-replace-files-regexp-command "perl -p -i -e 's///g' *")
(defun zch-replace-files-regexp(command)
"使用正则表达式替换多个文件中的字符串"
(interactive
   (list (read-from-minibuffer "replace files: "
                               (eval zch-replace-files-regexp-command) nil nil))
   (list (eval zch-replace-files-regexp-command)))
(save-some-buffers)
(shell-command command)
(zch-revert-buffer-all)
(setq zch-replace-files-regexp-command command))

(setq zch-replace-files-regexp-command-r "perl -p -i -e 's///g' `find . -name \"*\"`")
(defun zch-replace-files-regexp-r(command)
"使用正则表达式递归的替换多个文件中的字符串"
(interactive
   (list (read-from-minibuffer "replace files: "
                               (eval zch-replace-files-regexp-command-r) nil nil))
   (list (eval zch-replace-files-regexp-command-r)))
(save-some-buffers)
(shell-command command)
(zch-revert-buffer-all)
(setq zch-replace-files-regexp-command-r command))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 特殊编辑
(defun zch-insert-pointer-access()
  (interactive)
  (insert-string "->"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; window
;;为支持高清显示器
;;水平拆分成3个窗口
(defun split-window-horizontally3()
  "把窗口拆分成水平的3个，适合高清显示器"
  (interactive)
  (setq width (+ (/ (window-width) 3) 1))
  (split-window nil (* width 2) t)
  (split-window nil width t)
  )

;;水平拆分成4个窗口
(defun split-window-horizontally4()
  "把窗口拆分成水平的4个，适合2560pix显示器
总共317个字符，一个编辑区域90个字符，共三个编辑区域，编辑区域占用270个字符，剩下47个字符宽度作为一个单独得窗口，可以作为调试窗口用"
  (interactive)
  (split-window nil 261 t)
  (other-window 1)
  (clang-complete-items-mode)
  (other-window 1)
  (split-window nil 174 t)
  (split-window nil 87 t)
  )

(defun split-window6-and-fullscreen()
  "把窗口拆分成水平的5个，并且全屏显示emacs"
  (interactive)
  (my-fullscreen)
  (split-window6))

;;拆分成6个窗口
(defun split-window6()
  "把窗口拆分成6个,下面三个不高，上面三个很高，适合高清显示器写程序"
  (interactive)
  (setq width (+ (/ (window-width) 3) 1))
  (setq height (- (window-height) (/ (window-height) 5)))
  
  (setq w (split-window nil (* width 2) t))
  (split-window w height)
  
  (setq w (split-window nil width t))
  (split-window w height)

  (split-window nil height)
  )

;;窗口,文件切换
(defun zch-previous-window()
  (interactive)
  (select-window (previous-window)))
(defun zch-next-window()
  (interactive)
  (select-window (next-window)))

(defun onekey-kill-buffer()
  (interactive)
  (kill-buffer (current-buffer)))


;;最大化
(defun my-maximized-horz ()
  (interactive)
  (x-send-client-message
   nil 0 nil "_NET_WM_STATE" 32
   '(1 "_NET_WM_STATE_MAXIMIZED_HORZ" 0)))
(defun my-maximized-vert ()
  (interactive)
  (x-send-client-message
   nil 0 nil "_NET_WM_STATE" 32
   '(1 "_NET_WM_STATE_MAXIMIZED_VERT" 0)))
(defun my-maximized ()
  (interactive)
  (x-send-client-message
   nil 0 nil "_NET_WM_STATE" 32
   '(1 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
  (interactive)
  (x-send-client-message
   nil 0 nil "_NET_WM_STATE" 32
   '(1 "_NET_WM_STATE_MAXIMIZED_VERT" 0)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ecb
(setq g-switch-ecb-flag t)
(defun switch-ecb-activate()
  (interactive)
  (if g-switch-ecb-flag
      (progn
        (setq g-switch-ecb-flag nil)
        (ecb-activate))
    (progn
      (setq g-switch-ecb-flag t)
      (ecb-deactivate))))

(setq g-previous-buffer-name nil)
(defun switch-ecb-edit-window()
  "在ECB窗口和编辑窗口之间进行切换"
  (interactive)
  (let ((current-buffer-name (buffer-name)))
    (if (or (string= current-buffer-name " *ECB Directories*")
            (string= current-buffer-name " *ECB Sources*")
            (string= current-buffer-name " *ECB Methods*")
            (string= current-buffer-name " *ECB History*"))
        (ecb-goto-window-edit-last)
      (progn
        (if (string= g-previous-buffer-name " *ECB Directories*")
            (ecb-goto-window-directories)()
            (if (string= g-previous-buffer-name " *ECB Sources*")
                (ecb-goto-window-sources)()
                (if (string= g-previous-buffer-name " *ECB Methods*")
                    (ecb-goto-window-methods)()
                    (if (string= g-previous-buffer-name " *ECB History*")
                        (ecb-goto-window-history)()
                        (ecb-goto-window-methods)))))))
      (setq g-previous-buffer-name current-buffer-name)
      ))

(defun insert-my-copyright()
  (interactive)
  (insert my-name (format-time-string " %Y-%m-%d")  " ynsjzch@163.com"))
(defun insert-date()
  (interactive)
  (insert (format-time-string "%Y-%m-%d")))
(defun replace-word()
  "替换一个单词，并且查找时区分大小写"
  (interactive)
  )





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 自定义选择功能
;;矩形区域选择使用ctrl+enter键
(setq cua-enable-cua-keys nil)
(cua-mode t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; auto-complete
;; 自动补全

;;http://cx4a.org
;;(add-to-list 'load-path "/home/site-lisp/auto-complete")
;;(add-to-list 'ac-dictionary-directories "/home/site-lisp/auto-complete/ac-dict")
(add-to-list 'load-path "~/site-lisp/auto-complete")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/site-lisp/auto-complete/ac-dict")
(ac-config-default)

;;http://cx4a.org
(set-face-background 'ac-candidate-face  "#66bb00")
(set-face-underline  'ac-candidate-face  "#448800")
(set-face-background 'ac-selection-face  "#eeee00")
(set-face-foreground 'ac-selection-face  "#ff0000")

;;clang
;;在执行了基于dnc的编译命令后，zch-compile函数会更新 ac-clang-flags 变量，使得基于clang的自动
;;补全和编译环境完全融合
;;(require 'auto-complete-clang)
;;(setq ac-auto-start t)
;;(setq ac-quick-help-delay 0.5)
;; (ac-set-trigger-key "TAB")
;;(defun my-ac-config ()
;;  (setq-default ac-sources '(ac-source-abbrev ac-source-dictionary ac-source-words-in-same-mode-buffers))
;;  (add-hook 'emacs-lisp-mode-hook 'ac-emacs-lisp-mode-setup)
;;  ;; (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
;;  (add-hook 'ruby-mode-hook 'ac-ruby-mode-setup)
;;  (add-hook 'css-mode-hook 'ac-css-mode-setup)
;;  (add-hook 'auto-complete-mode-hook 'ac-common-setup)
;;  (global-auto-complete-mode t))
;;(defun my-ac-cc-mode-setup ()
;;  (setq ac-sources (append '(ac-source-clang ac-source-yasnippet) ac-sources)))
;;(add-hook 'c-mode-common-hook 'my-ac-cc-mode-setup)
;;;; ac-source-gtags
;;(my-ac-config)

;;clang-completion-mode
(load-library "clang-completion-mode")
(add-hook 'c++-mode-hook 'clang-completion-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;在退出后保存会话，启动时自动回复，包括输入命令等的历史
(require 'session)
(add-hook 'after-init-hook
          'session-initialize)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; word operation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun zch-copy-word()
  "复制光标所在处的单词"
  (interactive)
  (setq old-pos (point))
  
  (forward-word)
  (backward-word)
  (setq pos1 (point))
  (forward-word)
  (setq pos2 (point))
  
  (kill-ring-save pos1 pos2)
  (goto-char old-pos)
  (message "copy word %i %i" pos1 pos2))

(defun zch-copy-identifier()
  "复制光标所在处的标识符"
  (interactive)
  (setq old-pos (point))

  (c-beginning-of-current-token)
  (setq pos1 (point))
  (goto-char (+ (point) 1))
  (c-end-of-current-token)
  (setq pos2 (point))
  
  (kill-ring-save pos1 pos2)
  (goto-char old-pos)
  (message "copy identifier %i %i" pos1 pos2))

(defun zch-swith-=-()
  "交换选中区域等号两边的表达式,例如:
a = b ==> b = a"
  (interactive)  
  (replace-regexp
   "\\([a-zA-Z_][-a-zA-Z_0-9$:<>. ]*\\) = \\([a-zA-Z_][-a-zA-Z_0-9$:<>. ]*\\);"
   "\\2 = \\1;"
   nil (region-beginning) (region-end)))

(defun zch-to-dnc-identifier()
  "把选中区域的所有驼峰标识符转换成基于下划线的标识符规则,
例如: myAgeOf ==> my_age_of"
  (interactive)
  (setq begin  (region-beginning))
  (setq end (region-end))

  ;;把驼峰命名换成下划线命名
  (setq buffer-size-old   (buffer-size))
  (replace-regexp "\\([A-Z]\\)" "_\\1" nil begin end)

  ;;把所有大写字母转换成小写
  (setq buffer-size-new   (buffer-size))
  (downcase-region begin (+ end (- buffer-size-new buffer-size-old))))

(defun zch-to-dnc-function()
  "把选中区域的函数定义转换成符合dnc规范类函数定义,
例如: int setAge(int myAge); ==> int (*set_age)(int my_age);"
  (interactive)
  (setq begin  (region-beginning))
  (setq end (region-end))

  ;;把驼峰命名换成下划线命名
  (setq buffer-size-old   (buffer-size))
  (replace-regexp "\\([A-Z]\\)" "_\\1" nil begin end)

  ;;把C++函数变成dnc函数指针
  (setq buffer-size-new   (buffer-size))
  (replace-regexp " \\([a-z0-9_]*\\)(" " (*\\1)(" nil
                  begin (+ end (- buffer-size-new buffer-size-old)))

  ;;把所有大写字母转换成小写
  (setq buffer-size-new   (buffer-size))
  (downcase-region begin (+ end (- buffer-size-new buffer-size-old))))

(defun zch-to-dnc-function-impl()
  "把选中区域的dnc函数定义转换成静态函数实现方式，
例如: void (*func)(int arg); ==> static void func(int arg){}"
  (interactive)
  (setq begin  (region-beginning))
  (setq end (region-end))

  (setq buffer-size-old   (buffer-size))
  (zch-get-set-to-dnc-function-impl)
  

  (replace-regexp "^\\(.*\\)(\\*\\([a-zA-Z_0-9]*\\))\\(.*\\);"
                  "static \\1
\\2\\3{

}" nil begin (+ end (- buffer-size-new buffer-size-old))))

(defun zch-get-set-to-dnc-function-impl()
  "把选中区域的get set函数定义转换成静态函数实现方式，
例如: dnc_get_set(age,int,int) ==>
static int get_age(H*){
}
static void set_age(H*,int v){
}
"
  (interactive)
  (setq begin  (region-beginning))
  (setq end (region-end))

  (setq buffer-size-old   (buffer-size))
  (replace-regexp "dnc_get_set(\\([a-zA-Z_0-9]*\\),\\([a-zA-Z_0-9$:<>*& ]*\\),\\([a-zA-Z_0-9$:<>*& ]*\\));"
                  "static \\2
get_\\1(H* self){

}
static void
set_\\1(H* self,\\3 v){

}"  nil begin end)
  
  (setq buffer-size-new   (buffer-size))
  (replace-regexp "dnc_get(\\([a-zA-Z_0-9]*\\),\\([a-zA-Z_0-9$:<>*& ]*\\));"
                  "static \\2
get_\\1(H* self){

}" nil begin (+ end (- buffer-size-new buffer-size-old)))

  (setq buffer-size-new   (buffer-size))
  (replace-regexp "dnc_set(\\([a-zA-Z_0-9]*\\),\\([a-zA-Z_0-9$:<>*& ]*\\));"
                  "static void
set_\\1(H* self,\\2 v){

}" nil begin (+ end (- buffer-size-new buffer-size-old))))



(defun zch-to-dnc-function-call()
  "在对象定义中把函数指针定义转换成成员函数调用形式
例如: void (*func)(int arg); ==> void func(int arg){dklass->func(dself);}"
  (interactive)
  (setq begin  (region-beginning))
  (setq end (region-end))

  (setq buffer-size-old   (buffer-size))
  (zch-to-dnc-property-and-function)

  (setq buffer-size-new   (buffer-size))
  (replace-regexp "(\\*\\([a-zA-Z_0-9]*\\))\\(.*\\);"
                  "\\1\\2{
        return dklass->\\1(dself);
    }
"   nil
begin (+ end (- buffer-size-new buffer-size-old))))

(defun zch-to-dnc-property-and-function()
  "把类中的get set函数定义宏转换成用在对象定义中的 dnc_property_and_function 宏
例如: dnc_get_set(age); ==> dnc_property_and_function(age);"
  (interactive)
  (setq begin  (region-beginning))
  (setq end (region-end))

  (setq buffer-size-old   (buffer-size))
  (replace-regexp "dnc_get_set(\\([a-zA-Z_0-9]*\\),.*);"
                  "dnc_property_and_function(\\1);"
                  nil
                  begin end)
  
  (setq buffer-size-new   (buffer-size))
  (replace-regexp "dnc_get(\\([a-zA-Z_0-9]*\\),.*);"
                  "dnc_property_get_and_function(\\1);"
                  nil
                  begin (+ end (- buffer-size-new buffer-size-old)))

  (setq buffer-size-new   (buffer-size))
  (replace-regexp "dnc_set(\\([a-zA-Z_0-9]*\\),.*);"
                  "dnc_property_set_and_function(\\1);"
                  nil
                  begin (+ end (- buffer-size-new buffer-size-old))))

(defun zch-to-dnc-property-virtual()
  (interactive)
  (setq begin  (region-beginning))
  (setq end (region-end))

  (setq buffer-size-old   (buffer-size))
  (replace-regexp "dnc_get_set(\\([a-zA-Z_0-9]*\\),.*);"
                  "dnc_virtual_property(\\1);"
                  nil
                  begin end)
  
  (setq buffer-size-new   (buffer-size))
  (replace-regexp "dnc_get(\\([a-zA-Z_0-9]*\\),.*);"
                  "dnc_virtual_property_get(\\1);"
                  nil
                  begin (+ end (- buffer-size-new buffer-size-old)))

  (setq buffer-size-new   (buffer-size))
  (replace-regexp "dnc_set(\\([a-zA-Z_0-9]*\\),.*);"
                  "dnc_virtual_property_set(\\1);"
                  nil
                  begin (+ end (- buffer-size-new buffer-size-old))))

(defun zch-to-dnc-function-virtual()
  "把选中区域的dnc虚函数定义转换成虚函数指针初始化形式,
例如 void (*func)(H*,int arg); ==> dnc_virtual_function(func);"
  (interactive)
  (setq begin  (region-beginning))
  (setq end (region-end))

  (setq buffer-size-old   (buffer-size))
  (zch-to-dnc-property-virtual)

  (setq buffer-size-new   (buffer-size))
  (replace-regexp "^.*(\\*\\([a-zA-Z_0-9]*\\))\\(.*\\);"
                  "    dnc_virtual_function(\\1);"
                  nil
                  begin (+ end (- buffer-size-new buffer-size-old))))

(defun zch-android-clean-log()
  "清除android日志"
  (interactive)
  (shell-command "~/android-sdk/platform-tools/adb logcat -c"))

(defun zch-android-print-stack()
  "显示android应用程序由于崩溃产生的调用堆栈"
  (interactive)
  (setq temp compile-command)
  (compile "~/android-sdk/platform-tools/adb logcat -d | ~/script/android.print.stack")
  (setq compile-command temp))

(defun zch-android-stdout()
  "显示android应用程序的dnc输出部分"
  (interactive)
  (setq temp compile-command)
  (compile "~/android-sdk/platform-tools/adb logcat -d | ~/script/android.stdout")
  (setq compile-command temp))

(defun zch-android-logcat()
  "显示android日志"
  (interactive)
  (setq temp compile-command)
  (compile "~/android-sdk/platform-tools/adb logcat -d")
  (setq compile-command temp))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 自 定 义 快 捷 键
(global-set-key [(control *)]   'zch-copy-word)
(global-set-key [(meta *)]      'zch-copy-identifier)
;;(global-set-key [(control meta *)]      'zch-copy)

;;f1-f12的功能
(global-set-key [f1]      'switch-ecb-edit-window)
(global-set-key [f4]      'kill-this-buffer)

(global-set-key "\C-cs"     'shell)

;;emacs选项
(global-set-key "\C-cot"    'tool-bar-mode)
(global-set-key "\C-com"    'menu-bar-mode)

;;插入文本
(global-set-key "\C-cic"    'insert-my-copyright)
(global-set-key "\C-cid"    'insert-date)

(global-set-key [C-tab]     'buffer-menu)



(global-set-key "\M- "      'set-mark-command)
(global-set-key "\M-3"      'replace-string)
(global-set-key "\M-#"      'replace-regexp)

(global-set-key [(control \')]      'dnc-insert-quote1)
(global-set-key [(control \")]      'dnc-insert-quote2)
(global-set-key [(control \()]      'dnc-insert-bracket1)
;;(global-set-key [(control \[)]      'dnc-insert-bracket2)
(global-set-key [(control \{)]      'dnc-insert-bracket3)
(global-set-key [(control  <)]     'dnc-insert-bracket4)

(global-set-key "\C-xct"      'zch-onekey-compile-test)
(global-set-key "\C-xco"      'zch-compile-run)
(global-set-key "\C-xcu"      'zch-compile-run-any)
(global-set-key "\C-xcc"      'zch-onekey-compile)
(global-set-key "\C-xca"      'zch-test-all)
(global-set-key "\C-xcy"      'zch-compile-test-all)
(global-set-key "\C-xcl"      'zch-compile-clean)
(global-set-key "\C-xcm"      'zch-modify-compile-command)
(global-set-key "\C-xcw"      'zch-modify-compile-run-any-command)
(global-set-key "\C-xcj"      'zch-compile-modify-test)
(global-set-key "\C-xci"      'zch-compile-modify-test-args)
(global-set-key "\C-xce"      'zch-compile-exe-all)
(global-set-key "\C-xcg"      'zch-compile-gccsense)
(global-set-key "\C-xch"      'sbw-switch-to-h)
(global-set-key "\C-xcp"      'sbw-switch-to-cpp)
(global-set-key "\C-xcn"      'sbw-switch-to-ct)
(global-set-key "\C-xcr"      'xcode:buildandrun)



;;(global-set-key "\M-g" 'goto-line)
;;(global-set-key "\M-h" 'help-command)

(global-set-key [mouse-4] 'down-slightly)
(global-set-key [mouse-5] 'up-slightly)

(global-set-key "\C-cw3"  'split-window-horizontally3)
(global-set-key "\C-cw4"  'split-window-horizontally4)
(global-set-key "\C-cw6"  'split-window6)
(global-set-key "\C-cwf"  'my-fullscreen)
(global-set-key "\C-cwu"  'split-window6-and-fullscreen)

;;窗口切换
(global-set-key [(control \;)]      'zch-next-window)
(global-set-key [(control \:)]      'zch-previous-window)

;;自动补全
(define-key ac-mode-map  [(meta \.)] 'auto-complete)

;;调试快捷键
(global-set-key [f5] 'zch-gdb-test-debug-or-go)
(global-set-key [S-f5] 'zch-gdb-kill)
(global-set-key [f6] 'gud-next)
(global-set-key [C-f6] 'gud-until)
(global-set-key [S-f6] 'gud-jump)
(global-set-key [f7] 'gud-step)
(global-set-key [f8] 'gud-finish)
(global-set-key [f9] 'zch-gdb-break-remove)
(global-set-key "\C-cmw" 'zch-gdb-break-watch)
(global-set-key "\C-cmr" 'zch-gdb-break-rwatch)
(global-set-key "\C-cma" 'zch-gdb-break-awatch)

(global-set-key [(control =)] 'gud-print)
(global-set-key [(control +)] 'gud-pstar)
(global-set-key [(meta =)] 'zch-gdb-print-dcptr)
(global-set-key [(meta +)] 'zch-gdb-pstar-dcptr)
(global-set-key [(control meta +)] 'zch-gdb-ptype)

(global-set-key [(meta \,)] 'zch-gdb-switch-window)

(global-set-key "\C-xga"  'zch-gdb-assembler-buffer)
(global-set-key "\C-xgl"  'zch-gdb-locals-buffer)
(global-set-key "\C-xgm"  'zch-gdb-memory-buffer)
(global-set-key "\C-xgr"  'zch-gdb-registers-buffer)
(global-set-key "\C-xgt"  'zch-gdb-threads-buffer)
(global-set-key "\C-xgs"  'zch-gdb-stack-buffer)
(global-set-key "\C-xgb"  'zch-gdb-breakpoints-buffer)
(global-set-key "\C-xgi"  'zch-gdb-inferior-io)
(global-set-key "\C-xgp"  'zch-gdb-partial-output-buffer)
(global-set-key "\C-xgo"  'zch-gdb-print-object)
(global-set-key "\C-xgy"  'zch-gdb-ptype)
(global-set-key "\C-xg."  'zch-gdb-down)
(global-set-key "\C-xg,"  'zch-gdb-up)
(global-set-key [(control meta shift mouse-1)]  'zch-gdb-ptype)
(global-set-key "\C-xgk"  'zch-gdb-ptype-dcptr)
(global-set-key [(meta shift mouse-3)]  'zch-gdb-ptype-dcptr)
(global-set-key "\C-xgw"  'gud-print)
(global-set-key [(control shift mouse-1)]  'gud-print)
(global-set-key "\C-xge"  'gud-pstar)
(global-set-key [(control shift mouse-3)]  'gud-pstar)
(global-set-key "\C-xgd"  'zch-gdb-print-dcptr)
(global-set-key [(control meta mouse-1)]  'zch-gdb-print-dcptr)
(global-set-key "\C-xgh"  'zch-gdb-pstar-dcptr)
(global-set-key [(control meta mouse-3)]  'zch-gdb-ptype-dcptr)

(global-set-key "\C-cpg"    'sj-clang-goto-on-cursor)
(global-set-key "\C-cpt"    'sj-clang-type-goto-on-cursor)
(global-set-key "\C-cpc"    'sj-clang-class-goto-on-cursor)
(global-set-key "\C-cpc"    'sj-clang-class-goto-on-cursor)
(global-set-key [(control meta >)]    'cuc-completion-code-completion)

(global-set-key "\C-cbd"    'sbw-find-function-define-or-declare)
(global-set-key "\C-cbp"    'sbw-print-point)
(global-set-key "\C-cbi"    'sbw-insert-function-define)
(global-set-key "\C-cbs"    'sbw-get-syntactic-list)
(global-set-key "\C-cbq"    'sbw-get-dir-of-file)


(global-set-key "\C-cmf" 'c-mark-function)                 ;;选中整个函数体
(global-set-key "\C-caf" 'c-beginning-of-defun)            ;;跳转到函数开头
(global-set-key "\C-cef" 'c-end-of-defun)                  ;;跳转到函数末尾


(global-set-key [(control \.)]     'zch-insert-pointer-access)
(global-set-key [(control \7)]     'dnc-insert-dsref)
(global-set-key [(control \&)]     'dnc-insert-dwref)
(global-set-key [(control \')]     'dnc-insert-quote1)
(global-set-key [(control \")]     'dnc-insert-quote2)
(global-set-key [(control \()]     'dnc-insert-bracket1)
;;(global-set-key [(control \[)]   'dnc-insert-bracket2)
(global-set-key [(control \{)]     'dnc-insert-bracket3)
(global-set-key [(control  <)]     'dnc-insert-bracket4)
(global-set-key [(control  >)]     'dnc-insert-dnew)

(global-set-key "\C-cna" 'dnc-add-component)
(global-set-key "\C-cnp" 'dnc-add-widget)
(global-set-key "\C-cnh" 'dnc-init-header)
(global-set-key "\C-cnl" 'make-header)
(global-set-key "\C-cns" 'dnc-insert-sample)
(global-set-key "\C-cni" 'dnc-insert-interface)
(global-set-key "\C-cnc" 'dnc-insert-class)
(global-set-key "\C-cnt" 'dnc-insert-struct)
(global-set-key "\C-cnw" 'dnc-insert-widget)
(global-set-key "\C-cnu" 'dnc-insert-test-function)
(global-set-key "\C-cnf" 'zch-to-dnc-function)
(global-set-key "\C-cno" 'zch-to-dnc-identifier)
(global-set-key "\C-cnd" 'zch-to-dnc-function-impl)
(global-set-key "\C-cnx" 'zch-to-dnc-function-call)
(global-set-key "\C-cnv" 'zch-to-dnc-function-virtual)
(global-set-key "\C-cnr" 'zch-to-dnc-property-and-function)
(global-set-key "\C-cny" 'zch-get-set-to-dnc-function-impl)
(global-set-key "\C-cn=" 'zch-swith-=-)

;;android 相关操作
(global-set-key "\C-cac" 'zch-android-clean-log)
(global-set-key "\C-cas" 'zch-android-print-stack)
(global-set-key "\C-cap" 'zch-android-stdout)
(global-set-key "\C-cal" 'zch-android-logcat)

(global-set-key "\C-cos" 'scroll-bar-mode)


(global-set-key "\C-cr"             'zch-revert-buffer)
(global-set-key "\C-c\C-r"          'zch-revert-buffer-all)

(global-set-key [(control \#)]      'zch-replace-files-regexp)
(global-set-key [(control meta \#)] 'zch-replace-files-regexp-r)

(add-hook 'c++-mode-hook
          (lambda ()
            (define-key c-mode-base-map (kbd "C-c o") 'ff-find-other-file)
            (define-key c-mode-base-map [(control h)]   'next-error)
            ))





;;字母大小写转换
;;    从光标位置开始，处理单词后半部分
;;
;;    capitalize-word (M-c) ;; 单词首字母转为大写
;;    upcase-word (M-u)     ;; 整个单词转为大写
;;    downcase-word (M-l)   ;; 整个单词转为小写（注意，这里是 META － l(* 小写字母 L)）
;;
;;    从光标位置开始，处理单词前半部分
;;
;;    negtive-argument; capitalize-word (M-- M-c) ;; 单词首字母转为大写
;;    negtive-argument; upcase-word (M-- M-u)     ;; 整个单词转为大写
;;    negtive-argument; downcase-word (M-- M-l)   ;; 整个单词转为小写
;;
;;    改变选定区域的大小写
;;
;;
;;    downcase-region (C-x C-l) ;; 选定区域全部改为小写
;;    upcase-region (C-x C-u)   ;; 选定区域全部改为大写
