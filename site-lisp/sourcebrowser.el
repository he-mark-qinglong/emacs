; -*-Emacs-Lisp-*-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; File:         sourcebrowser.el
; Description:  sourcebrowser interface for (X)Emacs
; Author:       赵纯华
; Created:      2007-9-9
; Language:     Emacs-Lisp
;
; (C) Copyright 2007, 赵纯华 <ynsjzch@163.com>,
;     all rights reserved.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(require 'find-file)

(defcustom sbw-symbol-chars "A-Za-z0-9_"
  "*A string containing legal characters in a symbol.
The current syntax table should really be used for this."
  :type 'string
  :group 'sbw)

(defcustom sbw-filename-chars "-.,/A-Za-z0-9_~!@#$%&+=\\\\"
  "*A string containing legal characters in a symbol.
The current syntax table should really be used for this."
  :type 'string
  :group 'sbw)


;;c-beginning-of-decl-1
;;c-end-of-decl-1
;;c-search-decl-header-end
;;(goto-char (c-point 'boi)) 到缩近的开始
;;(goto-char (c-point 'ionl)) 到下一行缩近的开始
;;(goto-char (c-point 'iopl)) 到前一行缩近的开始
;;c-forward-comments
;;c-backward-comments 跨过C/C++的注释
;;c-backward-sws
;;c-forward-sws 跨过所有空白
;;c-on-identifier 判断光标是否在标示符上
;;c-beginning-of-current-token 转到一个单词的开始位置
;;c-end-of-current-token 转到一个单词的末尾
;;c-forward-token-2 到下一个符号或单词
;;c-backward-token-2 到上一个单词或符号
;;c-end-of-decl-1 到一个定义的最后

;;包含文件搜索路径
(setq sbw-dir-list (cdr cc-search-directories))




(defun sbw-test()
  (interactive)
  ;;(c-syntactic-re-search-forward ";" nil t)
  (sbw-end-of-syntactic)
  ;;(message "'%s'" (c-syntactic-re-search-forward "[{}]" nil t))
  ;;(c-beginning-of-decl-1)
)

(defun sbw-end-of-syntactic()
  "移动光标到语句定义的尾部，如果是函数申明或者变量定义，光标移动到';'位置，如果是函数定义或者空间定义，光标移动到'{'位置；"
  (let ((old-pos (point))
        (semicolon-pos)
        (big-bracket-pos) )
    (setq semicolon-pos (c-syntactic-re-search-forward ";" nil t))
    (goto-char old-pos)
    (setq big-bracket-pos (c-syntactic-re-search-forward "[{]" nil t))
    (if (and (not big-bracket-pos) semicolon-pos)
        (goto-char semicolon-pos))

    (if (and semicolon-pos big-bracket-pos)
        (if (< semicolon-pos big-bracket-pos)
            (progn
              (goto-char old-pos)
              (setq semicolon-pos (c-syntactic-re-search-forward ";" nil t)))))
    
    (if (or semicolon-pos big-bracket-pos)
        (goto-char (- (point) 1))
      (goto-char old-pos))
    ))

(defun sbw-test()
  (interactive)
  (sbw-beginning-of-syntactic)
)
(defun sbw-beginning-of-syntactic()
  "移动光标到语句的开始,这个函数具有以下特点:
如果光标在函数参数表里，那么光标会移动到函数定义的开始;
如果光标已经在语句的开始，那么不会移动光标。
bugs: 如果光标在字符串常量内部，移动不会成功"
  (sbw-end-of-syntactic)
  (c-beginning-of-statement-1 1 t))

(defun sbw-test()
  (interactive)
  (setq debug-on-error t)
  (message "'%s'" (sbw-get-token-at-cursor -1)))

(defun sbw-get-token-at-cursor(&optional forward)
  "获得光标所在处的一个token,不断的调用可以起到词法分析的效果
param forward
如果是1，那么在获取token的同时还要调用c-forward-token-2移动到下一个token;
如果是-1,那么在获取token的同时还要调用c-backward-token-2移动到上一个token;
否则不移动光标.
这个函数是sbw的底层核心函数之一，它是进行代码分析的利器.
"
  (let ((old-pos (point))
        (ret) (begin) (end))
    (c-beginning-of-current-token)
    (setq begin (point))
    (goto-char (+ (point) 1))
    (c-end-of-current-token)
    (setq end (point))
    (goto-char old-pos)
    ;;(message "%s,%s" begin end)
    (if forward
        (if (= forward 1)
            (c-forward-token-2)
          (if (= forward -1)
              (c-backward-token-2))))
      
    (setq ret (buffer-substring-no-properties begin end))
))


(defun sbw-test()
  (interactive)
  (setq debug-on-error t)
  (message "'%s'" (sbw-get-syntactic-category))
  ;;(sbw-beginning-of-syntactic)
)

(defun sbw-get-syntactic-category()
  "获得光标所在位置的定义的种类,种类有:function,variant,scope.通过这个函数确认语句类型后，
可以使用以下函数进行语句分析:
sbw-get-function-info() sbw-get-variant-info() sbw-get-scope-info() sbw-get-enum-info()"

  (let ((old-pos (point))(token)(pos (point))(ret)(type))
    (sbw-beginning-of-syntactic)
    (setq type (sbw-get-token-at-cursor))
    
    (setq pos (point))
    (setq token (sbw-get-token-at-cursor 1))
    (while (and (not ret) (not (= pos (point))))
      (cond 
       ((string= token "{") (setq ret "scope"))
       ((string= token "(") (setq ret "function"))
       ((string= token "=") (setq ret "variant"))
       ((string= token ";") (setq ret "variant")))
      (setq pos (point))
      (setq token (sbw-get-token-at-cursor 1)))

    (if (and (string= "enum" type) (string= "scope" ret))
        (setq ret "enum"))

    (goto-char old-pos)
    (setq ret ret)
))

(defun sbw-test()
  (interactive)
  (setq debug-on-error t)
  ;;(c-syntactic-re-search-forward "[=;]")
  ;;(c-backward-token-2)
  ;;(c-backward-token-2)
  (message "'%s'" (sbw-get-variant-info))
)

(defun sbw-get-variant-info()
  "获得光标所在处的变量定义的信息,调用此函数必须确保光标是在一个变量定义语句上,可以使用
sbw-get-syntactic-category()函数帮助确认光标是否在一个变量上"
(let ((old-pos (point))(info)(ret)(type))

  ;;移动光标到定义名的第一个字符
  (sbw-beginning-of-syntactic)
  (c-syntactic-re-search-forward "[=;{]")
  (c-backward-token-2)
  (c-backward-token-2)
  (setq info (sbw-get-declare-info))
  
  (goto-char old-pos)
  (setq type (cdr (assoc "type" info)))
  (if (string= "friend class" type)
      (setq ret nil)
    (setq ret (list (cons "type" (cdr (assoc "type" info)))
                    (cons "scopes" (cdr (assoc "scopes" info)))
                    (cons "name" (cdr (assoc "name" info)))
                    (cons "is-static" (cdr (assoc "is-static" info)))   
                    (cons "is-typedef" (cdr (assoc "is-typedef" info)))
                    (cons "category" "variant")
                    (cons "buffer" (current-buffer))
                    (cons "position" (point))
                    )))
  ))

(defun sbw-test()
  (interactive)
  (setq debug-on-error t)
  (message "'%s'" (sbw-get-enum-info))
)
(defun sbw-get-enum-info()
  "获得光标所在处的enum定义的信息,调用此函数必须确保光标是在一个enum定义上,可以使用
sbw-get-syntactic-category()函数帮助确认光标是否在一个enum上.
notes: 这个函数还没有实现对enum内部字段的解析"
(let ((old-pos (point))(info)(ret))
  ;;移动光标到定义名的第一个字符
  (sbw-beginning-of-syntactic)
  (c-syntactic-re-search-forward "[{]")
  (c-backward-token-2)
  (c-backward-token-2)
  (setq info (sbw-get-declare-info))
  
  (goto-char old-pos)
  (setq ret (list (cons "type" (cdr (assoc "type" info)))
                  (cons "scopes" (cdr (assoc "scopes" info)))
                  (cons "name" (cdr (assoc "name" info)))
                  (cons "category" "enum")
                  (cons "buffer" (current-buffer))
                  (cons "position" (point))
                  ))
  ))

(defun sbw-test()
  (interactive)
  (setq debug-on-error t)
  ;;(c-syntactic-re-search-forward "[=;]")
  ;;(c-backward-token-2)
  ;;(c-backward-token-2)
  (message "'%s'" (sbw-get-scope-info))
)

(defun sbw-get-scope-info()
  "获得光标所在处的scope定义的信息(scope包括类,名字空间),调用此函数必须确保光标是在一个scope定义上,可以使用
sbw-get-syntactic-category()函数帮助确认光标是否在一个scope上.
notes: 这个函数还没有实现获取基类列表的功能"
(let ((old-pos (point))(info)(ret)(is-define t)(token))
  ;;移动光标到定义名的第一个字符
  (sbw-beginning-of-syntactic)
  (c-syntactic-re-search-forward "[:{;]")
  (c-backward-token-2)
  (setq token (sbw-get-token-at-cursor))
  (if (string= ";" token) (setq is-define nil))       
  
  (c-backward-token-2)
  (setq info (sbw-get-declare-info))

  
  (goto-char old-pos)
  (setq ret (list (cons "type" (cdr (assoc "type" info)))
                  (cons "scopes" (cdr (assoc "scopes" info)))
                  (cons "name" (cdr (assoc "name" info)))
                  (cons "is-define" is-define)
                  (cons "category" "scope")
                  (cons "buffer" (current-buffer))
                  (cons "position" (point))
                  ))
  ))

(defun sbw-test()
  (interactive)
  (message "'%s'" (string-match "DECLARE " "WOS_DECLARE")))

(defun sbw-test()
  (interactive)
  (message "'%s'" (sbw-get-declare-info)))

(defun sbw-get-declare-info()
  "从光标当前位置向后获取申明信息，光标必须在一个申明符号的开头的第一个字母或者下划线，比如说类名，函数名或者变量名"
(let ((old-pos (point)) (is-loop t) (ret)  (token)(end)(begin)(temp)(is-typedef)
        (function-begin-pos)(is-inline)  (tokens)(pos (point))(has-declare)
        (is-explicit)(is-static)(is-virtual)
        (is-operator)(name)(ret-type nil)(scopes))
    ;;获取申明的名字
    (setq name (sbw-get-token-at-cursor -1))
    (setq token (sbw-get-token-at-cursor))
    ;;(message "%s %s" name token)
    (if (string= token "~")
        (progn
        (setq name (concat "~" name))
        (c-backward-token-2)))

    ;;获取申明的名字空间
    (setq token (sbw-get-token-at-cursor))
    (while (string= "::" token)
      (c-backward-token-2)
      (setq token (sbw-get-token-at-cursor))
      (push token scopes)
      (c-backward-token-2)
      (setq token (sbw-get-token-at-cursor)))

    ;;获取申明的类型
    (setq declare-position (point))
    (setq token (sbw-get-token-at-cursor))
    (while (and (not (= pos (point)))
                (not (or (string= token "}")
                         (string= token "{")
                         (string= token ":")
                         (string= token ";"))))
      ;;(message "'%s'" token)
      (cond 
       ((string= "explicit" token) (setq is-explicit t ))
       ((string= "virtual" token) (setq is-virtual t))
       ((string= "static" token) (setq is-static t))
       ((string= "operator" token) (setq is-operator t))
       ((string= "typedef" token) (setq is-typedef t))
       ((string= "inline" token) (setq is-inline t))
       ((string-match "_DECLARE$" token) (setq has-declare t))
       (t (push token tokens)))
      (setq pos (point))
      (c-backward-token-2)
      (setq token (sbw-get-token-at-cursor)))

    (setq ret-type (sbw-tokens2type tokens))

    (goto-char old-pos)

    (setq ret (list (cons "type" ret-type)
                    (cons "scopes" scopes)
                    (cons "name" name)
                    (cons "is-explicit" is-explicit)
                    (cons "is-virtual" is-virtual)
                    (cons "is-static" is-static)
                    (cons "is-operator" is-operator)
                    (cons "is-typedef" is-typedef)
                    (cons "is-inline" is-inline)
                    (cons "has-declare" has-declare)
                    (cons "declare-position" declare-position)
                    ))
))

(defun sbw-test()
  (interactive)
  (message "'%s'" (sbw-get-function-info))
)
  
(defun sbw-get-function-info()
  "获得光标所在处的函数的信息,调用此函数必须确保光标是在一个函数定义上(可以是参数列表中),可以使用
sbw-get-syntactic-category()函数帮助确认光标是否在一个函数上"
  (let ((old-pos (point)) 
        (is-loop t) 
        (ret)  (token)(end)(begin)(temp)
        (function-begin-pos)(info)
        (tokens)(pos (point))(is-define)
        (args)(is-const)(is-explicit)(is-static)(is-virtual)
        (name)(ret-type nil)(scopes))

    (sbw-end-of-syntactic)
    (setq token (sbw-get-token-at-cursor))
    (if (string= "{" token) (setq is-define t))       

    (c-backward-token-2)
    (while (and (not (= pos (point)))
                is-loop)
      (setq token (sbw-get-token-at-cursor))
      ;;(message "'%s'" token)
      (cond 
       ;;case 获取参数信息
       ( (string= token ")") 
         (sbw-move-to-bracket)
         (setq args (sbw-get-args-list))
         (setq is-loop nil))
       ;;case 获取函数后面的修饰信息
       ( (string= token "const")
         (setq is-const t)))
      (setq pos (point))
      (c-backward-token-2))
    
    (setq info (sbw-get-declare-info))

    (goto-char old-pos)
    (setq ret (list (cons "type" (cdr (assoc "type" info)))
                    (cons "scopes" (cdr (assoc "scopes" info)))
                    (cons "name" (cdr (assoc "name" info)))
                    (cons "is-explicit" (cdr (assoc "is-explicit" info)))
                    (cons "is-virtual" (cdr (assoc "is-virtual" info)))
                    (cons "is-static" (cdr (assoc "is-static" info)))
                    (cons "is-inline" (cdr (assoc "is-inline" info)))
                    (cons "is-operator" (cdr (assoc "is-operator" info)))
                    (cons "has-declare" (cdr (assoc "has-declare" info)))
                    (cons "declare-position" (cdr (assoc "declare-position" info)))
                    (cons "is-define" is-define) ;;标记是否是函数定义，而不是申明
                    (cons "is-const" is-const)
                    (cons "category" "function")
                    (cons "args" args)
                    (cons "buffer" (current-buffer))
                    (cons "position" (point))
                    ))
))

(defun sbw-test()
  (interactive)
  (setq debug-on-error t)
  (message "'%s'" (sbw-get-syntactic-info)))

(defun sbw-get-syntactic-info()
  "获得光标所在处的语句信息。这个函数是一个较上层的函数，它利用其他底层函数获取任何类型的语法的信息，从它的返回值可以知道一个语句的所有信息"
  (let ((category (sbw-get-syntactic-category))(ret)
        (old-modiffied-flag (buffer-modified-p)))
    (cond
     ((string= category "scope") (setq ret (sbw-get-scope-info)))
     ((string= category "enum") (setq ret (sbw-get-enum-info)))
     ((string= category "variant") (setq ret (sbw-get-variant-info)))
     ((string= category "function") (setq ret (sbw-get-function-info))))
    (set-buffer-modified-p old-modiffied-flag)
    (setq ret ret)
))

(defun sbw-test()
  (interactive)
  (setq debug-on-error t)
  (message "'%s'" (sbw-get-syntactic-info-full)))

(defun sbw-get-syntactic-info-full()
  "获得光标所在处的语句的全部信息，包括语句所在的名字空间"
  (let ((info (sbw-get-syntactic-info))
        (scopes)(n)
        (ns (sbw-get-namespace)))
    ;;把函数所在的空间追加到函数的定义空间中
    (if info
        (progn 
          (setq scopes (cdr (assoc "scopes" info)))
          (setq ns (reverse ns))
          (while ns
            (setq n (car ns))
            (push n scopes)
            (pop ns))
          (if scopes
              (setcdr (assoc "scopes" info) scopes))
          (setq info info))
      (setq info nil))
))

(defun sbw-is-operator(token)
  "判断一个token是否是一个操作符"
  (let ((ret))
    (if (or (string= token "::") 
            (string= token "*")
            (string= token "<")
            (string= token ">")
            (string= token "&"))
        (setq ret t))
    (setq ret ret)
))

(defun sbw-test()
  (interactive)
  (message "%s" (sbw-tokens2type (list "wos" "::" "Window" "*"))))

(defun sbw-tokens2type(tokens)
  "把一系列token转换成合适的类型字符串
param tokens 一个包含token的list"
(let ((token)(token2)(ret))
  (while tokens
    (setq token (car tokens))
    (if (and ret (not (sbw-is-operator token)) (not (sbw-is-operator token2)))
        (setq ret (concat ret " ")))
    (setq ret (concat ret token))
    (setq token2 token)
    (pop tokens))
  (setq ret ret)
))




(defun sbw-info2define-scope(info &optional namespace-spliter)
  "从syntactic-info中获取名字空间字符串"
  (let ((scopes-string)(scopes)(scope))
    (if (not namespace-spliter) (setq namespace-spliter "::"))
    ;;函数所在空间
    (setq scopes (cdr (assoc "scopes" info)))
    (while scopes
      (setq scope (car scopes))
      ;;(message scope)
      (if scopes-string (setq scopes-string (concat scopes-string namespace-spliter)))
      (setq scopes-string (concat scopes-string scope))
      (pop scopes))
    (setq scopes-string scopes-string)
))


(defun sbw-info2define-arg(info &optional has-name)
  "从syntactic-info中获取参数列表字符串.
param info 定义信息
param has-name 是否在字符串中包含参数名"
  (let ((args-string)(args)(arg))
  (setq args (cdr (assoc "args" info)))
  (while args
    (setq arg (car args))
    (if args-string (setq args-string (concat args-string ",")))
      (setq args-string (concat args-string (cdr (assoc "type" arg))))
      (if has-name
          (setq args-string (concat args-string " " (cdr (assoc "name" arg)))))
      (pop args))
  (setq args-string args-string)
))

(defun sbw-test()
  (interactive)
  (setq debug-on-error t)
  (setq info (sbw-get-syntactic-info-full))
  (message "'%s'" info)
  ;;(message "'%s'" (sbw-make-syntactic-entry info))
)

(defun sbw-make-syntactic-entry(info &optional namespace-spliter)
  "根据syntactic信息创建一个语句条目字符串，这个字符串方便阅读.
param info 由sbw-get-syntatic-info()函数获得的语句信息"
  (let ((type)(ret)(args-string)(is-const)(scopes-string))
    
    (if (not namespace-spliter) (setq namespace-spliter "::"))
    (setq scopes-string (sbw-info2define-scope info namespace-spliter))
    (if scopes-string (setq ret (concat ret scopes-string namespace-spliter)))

    (setq ret (concat ret (cdr (assoc "name" info))))
    
    (setq args-string (sbw-info2define-arg info t))
    (if (string= (cdr (assoc "category" info)) "function")
        (setq ret (concat ret "(" args-string ")")))

    (setq is-const (cdr (assoc "is-const" info)))
    (if is-const (setq ret (concat ret "const")))

    (setq type (cdr (assoc "type" info)))
    (if type (setq ret (concat ret "->" type)))

    (setq ret ret)
    ))


(defun sbw-test()
  (interactive)
  (setq debug-on-error t)
  (setq info (sbw-get-syntactic-info-full))
  (message "'%s'" info)
  (message "'%s'" (sbw-get-function-info2define info)))
(defun sbw-get-function-info2define(info)
  "把函数信息转换成函数定义的字符串
param info 由sbw-get-function-info()函数获得的函数信息"

  (let ((type)(ret)(args-string)(is-const)(scopes-string))    
    ;;函数类型
    (setq type (cdr (assoc "type" info))) 
    (if type (setq ret (concat type " ")))
    
    ;;函数所在空间
    (setq scopes-string (sbw-info2define-scope info))
    (if scopes-string (setq ret (concat ret scopes-string "::")))
    (setq ret (concat ret "\n"))
        
    ;;函数名
    (setq ret (concat ret (cdr (assoc "name" info))))

    ;;函数参数
    (setq args-string (sbw-info2define-arg info t))
    (setq ret (concat ret "(" args-string ")"))

    ;;函数修饰
    (setq is-const (cdr (assoc "is-const" info)))
    (if is-const
        (setq ret (concat ret " const")))
    (setq ret ret)
    ))

(defun sbw-test()
  (interactive)
  (setq debug-on-error t)
  (sbw-insert-function-define))

(defun sbw-insert-function-define()
  "在.cpp或者.cpt文件中插入当前光标下的函数申明的定义,这个函数用于在.h文件中写好函数申明，然后自动的在.cpp文件中产生函数定义.此函数不会检测已经存在的函数定义"
  (interactive)
  (setq file-name (buffer-file-name))
  (setq old-pos (point))
  (setq name (file-name-sans-extension file-name))
  (setq extension (file-name-extension file-name))
  (if (string= extension "h")
      (progn 
        (setq file-name (concat name ".cpp"))
        (if (not (file-exists-p file-name))
            (setq file-name (concat name ".cpt")))))

  ;;到行首，这样更准确
  (beginning-of-line)

  (setq info (sbw-get-syntactic-info-full))
  (if (not (file-exists-p file-name))
      (message "file:%s is not find." file-name))
            
  (setq buffer nil)
  (if (and (file-exists-p file-name) (string= "function" (cdr (assoc "category" info))))
      (with-current-buffer (find-file-noselect file-name)
        (setq buffer (current-buffer))
        (goto-char (point-max))
        (insert (sbw-get-function-info2define info) "{\n    \n}\n")
        (goto-char (- (point) 3))))
  (goto-char old-pos)
  (if buffer 
      (switch-to-buffer buffer)))

(defun sbw-test()
  (interactive)
  (setq debug-on-error t)
  (message "'%s'" (sbw-get-default-value t)))


(defun sbw-get-default-value(&optional forward)
  "获得光标所在处的默认参数值,光标必须是在'='号上
param forward 如果是t，表示移动光标到参数值的尾部;否则不移动光标"
  (let ((token (sbw-get-token-at-cursor))
        (begin) (end)
        (old-pos (point))
        (ret))
    (if (string= "=" token)
        (progn
          (c-forward-token-2)          
          (setq token (sbw-get-token-at-cursor))          
          (while (not (or (string= token ",")
                          (string= token ")")
                          (string= token "}")
                          (string= token "]")))
            (if ret (setq ret (concat ret " ")))
            (setq ret (concat ret token))
            (if (or (string= token "(") (string= token "{") (string= token "["))
                (progn
                  (setq begin (+ (point) 1))
                  (sbw-move-to-bracket)
                  (setq end (+ (point) 1))
                  (setq ret (concat ret (buffer-substring begin end)))))
            (c-forward-token-2)
            (setq token (sbw-get-token-at-cursor))
          )))

    (if (not forward) (goto-char old-pos))
    (setq ret ret)
    ))
  
(defun sbw-test()
  (interactive)
  (message "'%s'" (sbw-get-args-list)))


(defun sbw-get-args-list()
  "获得当前括号处所包围的参数列表,括号是'('或者'<'，此函数对于函数参数和模板参数都适用"
  (let* ((is-loop)(token)(token2)(ret)(arg)(tokens)
        (bracket (sbw-get-token-at-cursor))
        (default)
        (back-bracket)
        (old-pos (point)))

    (setq back-bracket (sbw-get-other-bracket bracket))
    ;;(message "'%s'" back-bracket)
    
    (if (or (string= bracket "(") (string= bracket "<"))
        (progn
          (c-forward-token-2)
          (setq token (sbw-get-token-at-cursor 1))
          (while (not (string= token back-bracket))
            ;;(message "'%s'" token)
            (setq token2 (sbw-get-token-at-cursor))
            (cond 
             ;;case 
             ( (or (string= "," token2)
                   (string= back-bracket token2)
                   (string= "=" token2))
               (if (string= "=" token2)
                   (progn 
                     (setq default (sbw-get-default-value t))
                     (setq token2 (sbw-get-token-at-cursor))))
               (setq tokens (reverse tokens))
               (setq arg (list (cons "type" (sbw-tokens2type tokens))
                               (cons "name" token)
                               (cons "default" default)))
               (push arg ret)
               (setq tokens nil))
             ;;case 
             (t (push token tokens)))
            
            (if (string= "," token2) (c-forward-token-2))
             
            (setq token (sbw-get-token-at-cursor 1)))
          
          ))
    (goto-char old-pos)
    (setq ret (reverse ret))
))
            
(defun sbw-print-point()
  "打印光标当前位置信息"
  (interactive)
  (message "point=%s" (point)))

(defun sbw-test()
  (interactive)
  (message "%s" (sbw-has-syntactic))
)

(defun sbw-has-syntactic()
  "判断当前光标之后是否还有语句"
  (let ((old-pos (point))(ret)(pos))
    (c-syntactic-re-search-forward "[;{]" nil t)
    (setq pos (point))
    (goto-char old-pos)
    (setq ret (not (= pos old-pos)))
))

(defun sbw-test()
  (interactive)
  ;;(c-end-of-decl-1)
  (sbw-into-scope)
)

(defun sbw-into-scope()
  "进入一个scope的内部"
  (let ((old-pos (point))(pos))
    (sbw-end-of-syntactic)
    (if (string= (sbw-get-token-at-cursor) "{")
        (progn           
          (c-forward-token-2)
          (if (string= "}" (sbw-get-token-at-cursor))
              (progn 
                (setq pos (point))
                (c-forward-token-2)
                (if (string= ";" (sbw-get-token-at-cursor))
                    (progn 
                      (setq pos (point))
                      (c-forward-token-2))
                  (c-backward-token-2))
                (if (not (= pos (point)))
                    (progn 
                      (c-end-of-decl-1)
                      (c-beginning-of-statement-1 1 t))
                  (goto-char old-pos)
                ))))
      (goto-char old-pos))
    ;;进入绝对是向前进的移动
    (if (< (point) old-pos)
        (goto-char old-pos))
    ))

(defun sbw-test()
  (interactive)
  ;;(c-end-of-decl-1)
  ;;(c-beginning-of-decl-1)
  (sbw-out-scope)
)

(defun sbw-out-scope()
  "从一个scope内部出去"
  (let ((old-pos (point))(pos (point)))
    ;;(message "out-scope")
    (c-end-of-decl-1)
    (setq pos (point))
    (c-syntactic-re-search-forward "}" nil t)    
    (if (= pos (point))
        (goto-char old-pos)
      (progn 
        (c-backward-token-2)
        (while (and (not (= pos (point)))
                    (string-match "[};]" (sbw-get-token-at-cursor)))
          (setq pos (point))
          (c-forward-token-2))))
    (if (string= ";" (sbw-get-token-at-cursor))
        (goto-char old-pos))
    ))
  
  
      
(defun sbw-test()
  (interactive)
  (setq debug-on-error t)
  (sbw-next-syntactic)
)

(defun sbw-next-syntactic()
  "移动光标到下一个定义语句的开始位置,这个函数的策略是这样的：如果当前的语句种类是 scope ，那么就进入这个scope，否则移动到下一个语句，不断的调用这个函数，可以遍历整个语法树."
  (let ((pos)(old-pos (point))
        (old-modiffied-flag (buffer-modified-p)))
  (if (string= (sbw-get-syntactic-category) "scope")
      (sbw-into-scope)
    (progn
      (setq pos (point))
      (c-end-of-decl-1)
      (c-end-of-decl-1)
      (c-beginning-of-statement-1 1 t)
      ;;如果光标不能移动，那么从scope出去，如果出去不能成功，那么就说明是在最后一个语句
      (if (= pos (point)) (sbw-out-scope))
      (if (> pos (point)) (goto-char old-pos))
      ))
  (set-buffer-modified-p old-modiffied-flag)
  ))


(defun sbw-test()
  (interactive)
  (setq debug-on-error t)
  (sbw-list-syntactic-all-files)
)

(defun sbw-list-syntactic-all-files()
  "显示当前目录下所有文件里的所有语句,这个函数便于测试sbw程序的正确性"
  (let ((files)(file)(find-result))

    ;;枚举所有.cpp .cpt .h 文件，并且排除了以'.'开头的隐藏文件
    (setq files (directory-files "." t "^[^.].*\.\\(cpp\\|cpt\\|h\\)$"))
    (while files
      (setq file (car files))
      (message "-----%s-------" file)
      (sbw-list-syntactic file)
      (pop files))
))


(defun sbw-test()
  (interactive)
  (setq debug-on-error t)
  (sbw-list-syntactic (buffer-file-name))
)

(defun sbw-list-syntactic(&optional file)
  "显示一个所有定义语句的列表"
  (let ((pos (point))(info)(ret)(buffer)
        (old-modiffied-flag (buffer-modified-p))
        (old-pos (point)))
    (setq buffer (sbw-find-buffer-by-file file))
    (with-current-buffer (find-file-noselect file)
      (setq old-modiffied-flag (buffer-modified-p)) 
      (setq old-pos (point))
      (setq pos 0)
      (goto-char (point-min))
      ;;遍历所有定义
      (while (and (not (= pos (point))) (not ret))
        (setq info (sbw-get-syntactic-info-full))        
        (message "%s: %s" file (sbw-make-syntactic-entry info))
        (setq pos (point))
        (sbw-next-syntactic))
      (goto-char old-pos)
      (set-buffer-modified-p old-modiffied-flag)
      (if (not buffer) (kill-buffer (current-buffer))))
))

(defun sbw-function-match(func1 func2)
  "判断两个函数定义是否匹配,这个函数用于函数的申明和定义的匹配，如果两个函数都是申明或者定义，那么匹配会失败"
  (let ((args-string1 (sbw-info2define-arg func1))
        (args-string2 (sbw-info2define-arg func2))
        (is-define1 (cdr (assoc "is-define" func1)))
        (is-define2 (cdr (assoc "is-define" func2)))
        (is-const1 (cdr (assoc "is-const" func1)))
        (is-const2 (cdr (assoc "is-const" func2)))
        (scopes-string1 (sbw-info2define-scope func1))
        (scopes-string2 (sbw-info2define-scope func2))
        (ret))
    (setq ret
          (and 
           (string= (cdr (assoc "name" func1)) (cdr (assoc "name" func2)))
           (or (and is-define1 (not is-define2)) (and is-define2 (not is-define1)))
           (or (and is-const1 is-const2) (and (not is-const1) (not is-const2)))
           (string= scopes-string1 scopes-string2)
           (string= args-string1 args-string2)))
))

(defun sbw-test()
  (interactive)
  (setq debug-on-error t)
  (sbw-find-function-define-or-declare)
)

(defun sbw-find-function-define-or-declare()
  "查找光标所在处的函数的定义或者申明，如果光标所在处是定义，就找申明；如果是申明，就找定义"
  (interactive)
  (setq old-modiffied-flag-function-define-or-declare (buffer-modified-p))
  (sbw-beginning-of-function)
  (setq decl (sbw-get-syntactic-info-full))
  (if (cdr (assoc "is-define" decl))
      (setq find-result (sbw-find-function-declare decl))
    (setq find-result (sbw-find-function-define decl)))
  (set-buffer-modified-p old-modiffied-flag-function-define-or-declare)

  (if find-result
      (progn
        (switch-to-buffer (cdr (assoc "buffer" find-result)))
        (goto-char (cdr (assoc "position" find-result)))))
)
  
(defun sbw-test()
  (interactive)
  (setq debug-on-error t)
  (sbw-find-function-define)
  ;;(file-name-sans-extension "pixmap.cpp")
  ;;(file-exists-p 
  ;;(with-current-buffer (find-file-noselect "pixmap2.cpp")
  ;;  (goto-char (point-min)))
  ;;(message "%s" (regexp-quote "."))

)

;;(string-match (concat ".*" "pixmap" ".*") "x.pixmap.cpt")
;;(switch-to-buffer (find-file-noselect file-path))
(defun sbw-find-function-define(&optional decl)
  "根据申明查找函数的定义"
  (let ((find-result nil)(temp-files)(reg)(exts)(ext)
        (file-name (buffer-file-name))(file)(files))
    (if (not decl)
        (setq decl (sbw-get-syntactic-info-full)))
        

    (setq file-extension (file-name-extension file-name))
    (setq file-name (file-name-sans-extension file-name))

    ;;在实际当中，申明可以在任何文件,因此把可能的 .cpp .cpt .h 全部找一遍，这里的顺序很重要,
    ;;一般情况下，函数定义都是在 .cpp 中，其次是 .cpt 很少会在 .h
    (setq exts (list "cpp" "cpt" "cc" "h"))
    (while exts
      (setq file (concat file-name "." (car exts)))
      (if (and (file-exists-p file) (not find-result))
          (setq find-result (sbw-find-function-define-or-declare-in-file decl file)))
      (if find-result (setq exts nil))
      (pop exts))

    ;;如果在单独的文件中没有找到,就遍历目录里的所有C++源文件，进行地毯式所搜
    (if (not find-result)
        (progn
          (setq files (directory-files "." t "^[^.].*\.\\(cpp\\|cpt\\|cc\\)$"))
          (setq find-result (sbw-find-function-define-or-declare-in-files 
                             decl files file-name))))
    (setq find-result find-result)
    ))

(defun sbw-test()
  (interactive)
  (setq debug-on-error t)
  (sbw-find-function-declare)
)
(defun sbw-find-function-declare(&optional decl)
  "根据定义查找函数的申明"
  (let ((decl)(find-result)(temp-files)
        (file-name buffer-file-name)(file))
    (if (not decl)
        (setq decl (sbw-get-syntactic-info-full)))

    (setq file-extension (file-name-extension file-name))
    (setq file-name (file-name-sans-extension file-name))

    ;;在实际当中，定义总是在.h文件，因此首先找.h文件，如果不在.h文件，那么一般是一个局部定义，
    ;;就在本文件中。
    (setq file (concat file-name ".h"))
    (if (and (file-exists-p file) (not find-result))
        (setq find-result (sbw-find-function-define-or-declare-in-file decl file)))
    (setq file (buffer-file-name))
    (if (and (not (string= file-extension "h")) (not find-result))
        (setq find-result (sbw-find-function-define-or-declare-in-file decl file)))   
    
    (if (not find-result)
        (progn
          (setq files (directory-files "." t "^[^.].*\.h$"))
          (setq find-result (sbw-find-function-define-or-declare-in-files 
                             decl files file-name))))
    (setq find-result find-result)
    ))

(defun sbw-find-function-define-or-declare-in-files(decl files file-name)
  "在指定的文件列表中找函数定义或者申明"
  (let ((find-result)(reg)(temp-files)(name))
    ;;第一层优化，先在与file-name匹配的文件中找

    (setq name (file-name-nondirectory file-name))
    (setq temp-files files)
    (setq files nil)
    (while (and temp-files (not find-result))
            (setq file (car temp-files))          
            (if (sbw-file-match-file name file)
                (setq find-result 
                      (sbw-find-function-define-or-declare-in-file decl file))
              (push file files))
            (pop temp-files))

    ;;如果在优化中没有找到，那么在其他文件中找
    (while (and files (not find-result))
            (setq file (car files))
            (setq find-result (sbw-find-function-define-or-declare-in-file decl file))
            (pop files))          
    (setq find-result find-result)
))

(defun sbw-test()
  (interactive)
  (message "'%s'" (directory-files "." nil "\.cpp$\\|\.cpt$")))

(defun sbw-find-function-define-or-declare-in-file(decl file)
  "在一个特定的文件中找函数定义或者申明,如果找到了就返回函数定义信息;否则返回nil.
param decl 如果decl是定义，那么就找申明；如果是申明，那么就找定义
param file 文件名"
  (let ((ret)(old-modiffied-flag)(pos)(info)(old-pos)(buffer))
    (setq buffer (sbw-find-buffer-by-file file))
    (if (file-exists-p file)
        (with-current-buffer (find-file-noselect file) 
          (setq old-modiffied-flag (buffer-modified-p)) 
          (setq old-pos (point))
          (setq pos 0)
          (goto-char (point-min))
          ;;遍历所有定义
          (while (and (not (= pos (point))) (not ret))
            (setq info (sbw-get-syntactic-info-full))
            ;;(message "%s" (sbw-make-syntactic-entry info))
            (if (string= "function" (cdr (assoc "category" info)))
                (if (sbw-function-match decl info)
                    (progn                     
                      ;;(message "%s" (sbw-get-function-info2define info))
                      (setq ret info))))
            (if (not ret)
                (progn 
                  (setq pos (point))
                  (sbw-next-syntactic))))
          (goto-char old-pos)         
          (set-buffer-modified-p old-modiffied-flag)
          (if (and (not buffer) (not ret))
              (kill-buffer (current-buffer)))))
  (setq ret ret)
))

(defun sbw-file-match-file(src-file dst-file)
  "对两个文件名进行模糊匹配"
  (let ((file-extension)(reg)(ret)(fields))
    (setq file-extension (file-name-extension src-file))
    (setq src-file (file-name-nondirectory src-file))

    ;;file.h 能匹配 a.file.h a.file.cpp file.cpp等
    (setq reg (concat ".*"(regexp-quote src-file)".*"))    
    (setq ret (string-match reg dst-file))

    (if (not ret)
        (progn 
          ;;以'.'分割，取文件名的最后一个单词进行匹配
          (setq fields (split-string src-file "[.]"))          
          (setq fields (reverse fields))          
          ;;a.file.h 能匹配 file.h a.file.cpp file.cpp等
          (setq reg (concat ".*"(regexp-quote (car fields))".*"))
          (setq ret (string-match reg dst-file))
          ))
    (if ret (message dst-file))
    (setq ret ret)
))


(defconst sbw-list-view-buffer-name "*sbwlist*")

(defun sbw-list-view-get-buffer()
  "获得sbwlist模式的缓冲区"
  (let ((buffer)(old-buffer))
  (setq buffer (get-buffer sbw-list-view-buffer-name))
  (when (not buffer)
      (setq buffer (get-buffer-create sbw-list-view-buffer-name))
      (setq old-buffer (current-buffer))
      (set-buffer buffer)
      (sbw-list-mode)
      (set-buffer old-buffer))
  (setq buffer buffer)
))
    

(defun sbw-list-view-add-line(line)
  "向sbwlist增加一行"
  (let ((buffer (sbw-list-view-get-buffer)))
    (with-current-buffer buffer
      (insert " " line "\n"))
    ))


(defun sbw-list-view-add-info(info)
  "向sbwlist增加一个语句信息"
  (let ((line (sbw-make-syntactic-entry info ".")))
    (sbw-list-view-add-line line)
))
(defun sbw-list-view-begin()
  "开始一次list显示"
  (let ((buffer))
    (setq buffer (sbw-list-view-get-buffer))    
    (set-buffer buffer)    
    (setq buffer-read-only nil)
    (erase-buffer)
    ;;(display-buffer buffer)
    (switch-to-buffer buffer)
    (setq buffer buffer)
))

(defun sbw-list-view-end()
  "结速一次list显示"
  (let ((buffer))
    (setq buffer (sbw-list-view-get-buffer))    
    (set-buffer buffer)
    (goto-char (point-min))    
    (setq buffer-read-only t)
    (set-buffer-modified-p nil)
))



(defun sbw-list-view-apply()
  (interactive)
  (setq info (elt sbw-current-syntactics (- (line-number-at-pos) 1)))
  (switch-to-buffer (cdr (assoc "buffer" info)))
  (goto-char (cdr (assoc "position" info))))

(defun sbw-test()
  (interactive)
  (setq debug-on-error t)
  (sbw-get-syntactic-list-1))

(defun sbw-get-syntactic-list()
  (interactive)
  (setq debug-on-error t)
  (sbw-get-syntactic-list-1)
)

(defvar sbw-current-syntactics nil)
(defun sbw-get-syntactic-list-1(&optional file)
  "显示一个所有定义语句的列表"
  (let ((pos (point))(info)(ret)(buffer)(view-buffer)
        (old-modiffied-flag (buffer-modified-p))
        (old-pos (point)))
    (if (not file)
        (setq file (buffer-file-name)))
    (setq buffer (sbw-find-buffer-by-file file))

    (sbw-list-view-begin)
    (setq sbw-current-syntactics nil)
    (with-current-buffer (find-file-noselect file)
      (setq old-modiffied-flag (buffer-modified-p)) 
      (setq old-pos (point))
      (setq pos 0)
      (goto-char (point-min))
      ;;遍历所有定义
      (while (and (not (= pos (point))) (not ret))
        (setq info (sbw-get-syntactic-info-full))
        (if info 
            (progn
              (sbw-list-view-add-info info)
              (push info sbw-current-syntactics)))
        (setq pos (point))
        (sbw-next-syntactic))
      (goto-char old-pos)
      (set-buffer-modified-p old-modiffied-flag)
      (if (not buffer) (kill-buffer (current-buffer))))
    (sbw-list-view-end)
    (setq sbw-current-syntactics (reverse sbw-current-syntactics))
))



(defvar sbw-list-mode-map nil)
(if sbw-list-mode-map 
    ()
  (setq sbw-list-mode-map (make-keymap))
  (suppress-keymap sbw-list-mode-map)
  (define-key sbw-list-mode-map [(return)] 'sbw-list-view-apply))

(defun sbw-list-mode()
  (setq major-mode 'sbw-list-mode)
  (setq mode-name "sbw list view")  
  (sbw-list-font-lock)
  (setq truncate-lines t)
  (use-local-map sbw-list-mode-map))


(defface sbw-face-variant
  '((((class color) (min-colors 88) (background dark))
     :foreground "OrangeRed1" :weight bold))    
  ""
  :group 'sbw-list-mode)

(defun sbw-test()
  (interactive)
  (re-search-forward "\\([a-zA-Z_]+\\)" nil t))
(defun sbw-list-view-get-keyword-function(arg)
  (let ((ret)(info))
    (setq info (elt sbw-current-syntactics (- (line-number-at-pos) 1)))    
    
    (if (string= (cdr (assoc "category" info)) "function")
        (progn 
          (setq ret (re-search-forward "\\([a-zA-Z_0-9]+\\)(" arg t))
          ;;(message "function--%s--%s--" arg ret)
          (setq ret ret)
          )
      (setq ret nil))
  ))

(defface sbw-face-scope
  '((((class color) (min-colors 88) (background dark))
     :foreground "DarkOrchid1" :weight bold))    
  ""
  :group 'sbw-list-mode)
(defun sbw-list-view-get-keyword-struct(arg)
  (let ((ret)(type))
    (setq info (elt sbw-current-syntactics (- (line-number-at-pos) 1)))
    (if (string= (cdr (assoc "category" info)) "scope")
        (progn 
          (setq ret (re-search-forward "\\([a-zA-Z_0-9]+\\)\-" arg t))
          ;;(message "struct--%s--%s--" arg ret)
          (setq ret ret)
          )
      (setq ret nil))
  ))

(defface sbw-face-scope-declare
  '((((class color) (min-colors 88) (background dark))
     :foreground "DarkOrchid4" :italic t))    
  ""
  :group 'sbw-list-mode)
(defun sbw-list-view-get-keyword-scope-declare(arg)
  (let ((ret)(type))
    (setq info (elt sbw-current-syntactics (- (line-number-at-pos) 1)))
    (setq type (cdr (assoc "type" info)))
    (if (and (string= (cdr (assoc "category" info)) "variant")
             (or (string= type "class")
                 (string= type "struct")
                 (string= type "union")
                 (string= type "interface")))
        (progn 
          (setq ret (re-search-forward "\\(.*\\)" arg t))
          ;;(message "struct--%s--%s--" arg ret)
          (setq ret ret)
          )
      (setq ret nil))
  ))


(defun sbw-list-view-get-keyword-typedef(arg)
  (let ((ret)(type))
    (setq info (elt sbw-current-syntactics (- (line-number-at-pos) 1)))
    (if (and (string= (cdr (assoc "category" info)) "variant")
             (cdr (assoc "is-typedef" info)))
          (re-search-forward "\\([a-zA-Z_0-9]+\\)->" arg t)
      (setq ret nil))
  ))

(defun sbw-list-view-get-keyword-argument(arg)
  (let ((ret)(param)(args))
    (setq info (elt sbw-current-syntactics (- (line-number-at-pos) 1)))
    (if (string= (cdr (assoc "category" info)) "function")
        (re-search-forward "\\([a-zA-Z_0-9]+\\)[,)]" arg t)
      (setq ret nil))
    ))

(defun sbw-list-view-get-keyword-variant(arg)
  (let ((ret))
    (setq info (elt sbw-current-syntactics (- (line-number-at-pos) 1)))
    (if (string= (cdr (assoc "category" info)) "variant")
        (progn 
          (setq ret (re-search-forward "\\([a-zA-Z_0-9]+\\)->" arg t))
          (setq ret ret)
          )
      (setq ret nil))
  ))

(defface sbw-face-namespace
  '((((class color) (min-colors 88) (background dark))
     :foreground "gray40" :italic t))    
  ""
  :group 'sbw-list-mode)
(defun sbw-list-view-get-keyword-namespace(arg)
  (let ((ret)(scopes-string))
    (setq info (elt sbw-current-syntactics (- (line-number-at-pos) 1)))
    (setq scopes-string (sbw-info2define-scope info "."))
    (if scopes-string
        (re-search-forward (concat "\\(" (regexp-quote scopes-string) "\.\\)") arg t)
      (setq ret nil))
  ))

(defface sbw-face-operator
'((((class color) (min-colors 88) (background dark))
   :foreground "DeepSkyBlue1"))
  "" :group 'sbw-list-mode)


(defun sbw-list-font-lock()
  (font-lock-mode)
  ;;(make-local-variable 'font-lock-keyword-face)
  ;;(setq font-lock-keyword-face 'sbw-face-function)
  (font-lock-add-keywords 
   nil
   (list  '("\\(^\\)" (1 font-lock-keyword-face  prepend)
            (sbw-list-view-get-keyword-namespace          
             nil nil (1 'sbw-face-namespace  prepend))
            (sbw-list-view-get-keyword-struct
             nil nil (1 'sbw-face-scope  prepend))
            (sbw-list-view-get-keyword-function             
             nil nil (1 font-lock-function-name-face  prepend))
            (sbw-list-view-get-keyword-scope-declare
             nil nil (1 'sbw-face-scope-declare  prepend))
            (sbw-list-view-get-keyword-typedef
             nil nil (1 font-lock-type-face  prepend))
            (sbw-list-view-get-keyword-argument
             nil nil (1 font-lock-variable-name-face  prepend))
            (sbw-list-view-get-keyword-variant          
             nil nil (1 'sbw-face-variant  prepend)))

          '("\\(\+\\|\-\\|\*\\|==\\|!=\\|[.,!~:\{\}\(\);=%|&?\+\-\*/\>\<]\\)"
            1 'sbw-face-operator)

          '("\\(class\\|struct\\|union\\|interface\\|namespace\\|const\\)" 
            1 font-lock-keyword-face)

          '("->\\([a-zA-Z_0-9]+\\)" 
            1 font-lock-type-face)
    )))

(defun sbw-find-symbol-in-buffer(symbol symbol-scope)
  "查找symbol的符号定义，并把光标定位到符号定义的位置。
   如果找到了，返回符号定义的位置，否则返回nil"
  (let ((old-pos (point))
        (found nil)
        (declare-pos)
        (old-modiffied-flag (buffer-modified-p))
        (i 0)
        (declare-scope))

    (goto-char (point-min))
    ;;向后找出所有与symbol匹配的定义，并且判断范围，找到后退出
    (setq declare-pos (sbw-find-cpp-declare symbol))
    (while (and (not (eq declare-pos nil)) (eq found nil))
      ;;查找定义
      (setq declare-scope (sbw-get-scope))
      (if (> declare-pos 0)
          (if (sbw-is-in-scope symbol-scope declare-scope)
              (setq found t)))
      ;;        (if (eq (sbw-is-in-range symbol-pos declare-pos) t)
      ;;            (setq found t)))

      ;;如果没有找到就继续找
      (if (eq found nil)
          (setq declare-pos (sbw-find-cpp-declare symbol))))

    ;;如果找到了就把光标定位到符号定义位置，否则复位光标位置
    (if (eq found t)
        (progn
          (goto-char declare-pos)
          (setq ret declare-pos))
      (progn
        (goto-char old-pos)
        (setq ret nil)))
    
    ;;(set-buffer-modified-p old-modiffied-flag)
    (setq ret ret)
    ))

(defun sbw-get-filename-at-cursor()
  "获得光标所在处的文件名，包括包含符号，例如
   \"object.h\"
    <object.h>"
  
  (interactive)
  (let ((symbol-chars sbw-filename-chars)
        (symbol-char-regexp)
        (start)
        (end))
    (setq symbol-char-regexp (concat "[" symbol-chars "]"))
    (setq start (progn
       (if (not (looking-at symbol-char-regexp))
           (re-search-backward "\\w" nil t))
       (skip-chars-backward symbol-chars)
       (point)))
    (setq end (progn
       (skip-chars-forward symbol-chars)
       (point)))
    (setq start (- start 1))
    (setq end (+ end 1))
    (buffer-substring-no-properties start end)
    ))

(defun sbw-test()
  (interactive)
  (message "%s" (sbw-get-symbol-at-cursor)))
(defun sbw-get-symbol-at-cursor()
  "获得光标所在处的标示符,如果光标没有在标示符上，返回nil.
note:这个函数应该使用  sbw-get-token-at-cursor()实现"
  (let ((symbol-chars)
        (symbol)
        (begin) (end)
        (old-pos (point)))
    (setq symbol-chars sbw-symbol-chars)
    (setq symbol-char-regexp (concat "[" symbol-chars "]"))
    
    (setq begin
          (progn
            (if (not (looking-at symbol-char-regexp))
                (re-search-backward "\\w" nil t))
            (skip-chars-backward symbol-chars)
            (point)))
    (setq end
          (progn
            (skip-chars-forward symbol-chars)
            (point)))
    (setq symbol (buffer-substring-no-properties begin end))
                  
    (goto-char old-pos)
    (if (eq begin end)
        (setq symbol nil)
      (setq symbol symbol))
    ))
(defun sbw-test()
  (interactive)
  (message "%s" (sbw-get-operator-at-cursor)))
(defun sbw-get-operator-at-cursor()
  "获得光标所在处的符号,包括 == && 这样的符号,如果光标没有在标示符上,返回nil.
note:这个函数应该使用  sbw-get-token-at-cursor()实现
"
  (let ((symbol-chars)
        (symbol)
        (begin) (end)
        (old-pos (point)))
    (setq symbol-chars "!&=|()->.*")
    (setq symbol-char-regexp "[!&=|()->.*]")
    (setq begin
          (progn
            (skip-chars-backward symbol-chars)
            (point)))
    (setq end
          (progn
            (skip-chars-forward symbol-chars)
            (point)))
    (setq symbol (buffer-substring-no-properties begin end))
    (goto-char old-pos)
    (if (eq begin end)
        (setq symbol nil)
      (setq symbol symbol))
    ))
;;(defun sbw-get-token-at-cursor-test()
;;  (interactive)
;;  (message "%s" (sbw-get-token-at-cursor)))
;;(defun sbw-get-token-at-cursor()
;;  "获得光标所在处的符号,包括 == && 这样的符号"
;;  (let ((symbol))
;;    (setq symbol (sbw-get-operator-at-cursor))
;;    (if (eq symbol nil)
;;        (setq symbol (sbw-get-symbol-at-cursor)))
;;    (setq symbol symbol)
;;    ))

(defun sbw-find-pair-file()
  (ff-find-other-file))

(defun sbw-find-file()
  "查找光标所在处的文件，如果找到就打开它"
  (interactive)
  (setq filename (sbw-get-filename-at-cursor))
  (setq dir "")

  (setq is-fund 0)
  (mapcar
   (lambda (dir)
     (if (eq is-fund 0)
         (progn
           (setq file-path (concat dir "/" filename))
           (if (file-readable-p file-path)
               (progn
                 (setq is-fund 1)
                 (switch-to-buffer (find-file-noselect file-path)))
             ))))
   sbw-dir-list))

(setq block-begin 1)
(setq block-end 1)

(defun sbw-get-block-begin(pos)
  "获得pos所在的语句块的起始位置"
  (setq get-block-old-pos (point))
  (setq count 1)
  (setq block-begin 1)
  (setq block-end (point-min))
  (goto-char pos)
  (while (< block-end pos)
    (setq block-begin (search-backward "{" nil t count))
    (if (eq block-begin nil)
        (setq block-end pos)
      (progn
        (setq block-end (search-forward "}" nil t count))
        (if (eq block-end nil)
            (progn
              (setq block-begin nil)
              (setq block-end pos)))))
    (setq count (+ count 1)))
  (goto-char get-block-old-pos)
  (setq block-begin block-begin))

(defun sbw-get-block-end(pos)
  "获得pos所在的语句块的末尾位置"
  (setq get-block-old-pos (point))
  (setq count 1)
  (setq block-begin (point-max))
  (setq block-end 1)
  (goto-char pos)
  (while (> block-begin pos)
    (setq block-end (search-forward "}" nil t count))
    (if (eq block-end nil)
        (setq block-begin pos)
      (progn
        (setq block-begin (search-backward "{" nil t count))
        (if (eq block-begin nil)
            (progn
              (setq block-end nil)
              (setq block-begin pos)))))
    (setq count (+ count 1)))
  (goto-char get-block-old-pos)
  (setq block-end block-end))



(defun sbw-test()
  (interactive)
  (message "%s" (c-syntactic-re-search-forward "}" nil t 1)))

(defun sbw-is-in-range(pos1 pos2)
  "判断pos1是否在pos2所在的语句块范围之内"
  (if (or (eq pos2 0) (eq pos2 nil))
      (setq ret nil)
    (progn 
      (setq begin-pos (sbw-get-block-begin pos2))
      (setq end-pos   (sbw-get-block-end   pos2))
  
      ;;判断pos1是否在
      (setq ret nil)
      (if (or (eq begin-pos nil) (eq end-pos nil))
          (setq ret t)
        (if (and (> pos1 begin-pos) (< pos1 end-pos))
            (setq ret t)))
      (setq ret2 ret))))


(defun sbw-test()
  (interactive)
  (message "%s" (sbw-find-buffer-by-file "/home/dev-lisp/wos/pixmap.h"))
)

(defun sbw-find-buffer-by-file(file-name)
  "根据file-name找到buffer"
  (let ((it-buffer (buffer-list))
        (ret-buffer nil)
        (temp-buffer))
    
    (while (and (eq ret-buffer nil) (not (eq it-buffer nil)))
      (setq temp-buffer (car it-buffer))
      (if (not (eq (buffer-file-name temp-buffer) nil))
          (progn
            (if (string= file-name (buffer-file-name temp-buffer))
                (setq ret-buffer temp-buffer))))
      (setq it-buffer (cdr it-buffer)))
    (setq ret-buffer ret-buffer)
    ))



;;(sbw-find-buffer-by-file "e:/trys/dnc-0/binary.cpp")


;;test
;;(sbw-unique-list (list "aa" "oo" "aa"))
(defun sbw-unique-list(list)
  "使list中的元素唯一化"
  (let ((ret)
        (sorted-list)
        (item))
    (setq sorted-list (sort list 'string<))
    (setq item (pop sorted-list))
    (while item
      (if (not (string= item (car sorted-list)))
          (push item ret))
      (setq item (pop sorted-list)))
    (setq ret ret)
    ))

;;test
;;(sbw-obviate-list '(("a" . 1)) (list "b"))
(defun sbw-obviate-list(found-files includes)
  "排除已经找到的文件，found-files是一个以文件名为key的alist，
  inclues是一个list"
  (let ((ret)
        (file-path))
    (setq file-path (pop includes))
    (while file-path
      (if (eq (assoc file-path found-files) nil)
          (push file-path ret))
      (setq file-path (pop includes)))
    (setq ret ret)
    ))

;;(sbw-find-symbol-in-include "binary.h" "Binary"
;;                          (list "dnc" "Binary"))

(defun sbw-find-symbol-in-include(file-path symbol symbol-scope)
  "在一个包含文件中查找符号定义，如果找到了返回
   (list 符号所在的buffer buffer是否是新打开的文件 old-pos) ，
   并把光标定位到符号申明的位置,把当前buffer设为符号所在的buffer,
   否则返回nil"
  (let ((declare-pos nil)
        (temp-buffer)
        (declare-buffer)
        (old-buffer (current-buffer))
        (ret nil) (is-new-file nil)
        (old-pos))
    
    (setq declare-buffer (sbw-find-buffer-by-file file-path))
    (setq temp-buffer nil)
    (if (eq declare-buffer nil)
        (progn
          (setq is-new-file t)
          (setq temp-buffer (find-file-noselect file-path))
          (setq declare-buffer temp-buffer)))
          
    (set-buffer declare-buffer)
    (setq old-pos (point))
    (goto-char (point-max))
    (setq declare-pos
          (sbw-find-symbol-in-buffer symbol symbol-scope))

    (if (and temp-buffer (eq declare-pos nil))
        (kill-buffer temp-buffer))
    (goto-char old-pos)

    (if declare-pos
        (progn
          (setq ret (list declare-buffer is-new-file old-pos))
          (goto-char declare-pos))
      (set-buffer old-buffer))
    (setq ret ret)
    ))

(defun sbw-find-symbol(symbol symbol-scope)
  "在当前文件和当前文件包含的文件中查找光标所在处的符号申明，如果找到就，
   返回(list 符号所在的buffer buffer是否是新打开的文件 old-pos),
   并把光标定位到 符号申明的位置,把当前buffer设为符号所在的buffer,
   否则返回nil"
  (interactive)
  (let ((filename (buffer-file-name))
        (it-include)
        (includes)
        (i)
        (old-pos (point))
        (found-files nil)
        (declare-result nil))

    (message "find (%s) in: %s" symbol (buffer-file-name))

    (setq includes (sbw-get-include))
    (if (sbw-find-symbol-in-buffer symbol symbol-scope)
        (setq declare-result (list (current-buffer) nil old-pos)))

    ;;最多递归的查找32层包含文件
    (setq i 0)
    (while (and (eq declare-result nil) includes (< i 32))
      (setq i (+ i 1))
      ;;在每一个头文件中找
      (setq it-include includes)
      (while (and (eq declare-result nil) (not (eq it-include nil)))
        (setq filename (car it-include))
        (message "find (%s) in: %s" symbol filename)
        (setq declare-result
              (sbw-find-symbol-in-include filename symbol symbol-scope))
        (push (cons filename 1) found-files)
        (setq it-include (cdr it-include)))

      ;;没有找到，构造新的includes，再找
      (if (eq declare-result nil)
          (progn
            (setq it-include includes)
            (setq includes nil)
            (while it-include
              (setq filename (car it-include))
              (setq includes (append includes (sbw-get-include-in-file filename)))
              (setq it-include (cdr it-include))
              ;;排除已经找过的文件
              (setq includes (sbw-unique-list includes))
              (setq includes (sbw-obviate-list found-files includes))))))
    (if declare-result
        (progn
          (message "(%s) is in %s" symbol filename)
          ;;移动到符号的开始处
          (c-backward-token-2))
      (message "found out (%s)" symbol))
    (setq declare-result declare-result)
    ))

(defun sbw-find-symbol-at-cursor()
  "查找光标所在处的符号的定义，包括包含头文件"
  (interactive)
  (setq debug-on-error t)
  (let ((ret1 nil)(ret2 nil)
        (type-ret nil)
        (symbol-list (sbw-symbol-access-list))
        (symbol)(is-namespace)
        (buffer1)(buffer2)
        (org-pos (point))
        (old-buffer (current-buffer))
        (declare-buffer)(is-new-buffer)(old-pos)
        (symbol-scope (sbw-get-scope)))
    
    (setq symbol (pop symbol-list))
    
    (while symbol-list
      (message "scope: %s" symbol-scope)
      (setq ret2 (sbw-search-symbol-type symbol symbol-scope))

      ;;恢复过渡的buffer和位置
      (if ret1
          (progn 
            (setq declare-buffer (pop ret1))
            (setq is-new-buffer (pop ret1))
            (setq old-pos (pop ret1))
            (if is-new-buffer
                (kill-buffer declare-buffer)             
              (progn
                (set-buffer declare-buffer)
                (goto-char old-pos)
                (if ret2 (set-buffer (car ret2)))))))
      (setq ret1 ret2)
      (if ret2
          (progn 
            (setq declare-buffer (pop ret1))
            (setq is-new-buffer (pop ret1))
            (setq old-pos (pop ret1))
            (setq symbol (pop symbol-list))
            (setq symbol-scope (sbw-get-scope)))
        (setq symbol-list nil))
      (setq ret1 ret2))

    ;;最后一个命名空间
    (setq is-namespace (sbw-is-namespace))
    (setq type-ret ret2)
    (if ret2
        (if (eq symbol-scope nil)
            (setq symbol-scope (list (sbw-get-token-at-cursor)))
          (nconc symbol-scope (list (sbw-get-token-at-cursor)))))
    ;;(if (sbw-is-class)
    ;;    (setq symbol-scope (sbw-get-scope)))
    (message "%s" (current-buffer))
    (message "symbol: %s, symbol scope: %s" symbol symbol-scope)

    (if is-namespace
        (set-buffer old-buffer))

    ;;恢复old-buffer的状态
    (setq ret1 ret2)

    ;;查找最终的符号
    (if symbol
        (setq ret2 (sbw-find-symbol symbol symbol-scope)))

    ;;恢复过渡的buffer和位置
    (setq buffer1 nil)
    (setq buffer2 nil)
    (if ret1 (setq buffer1 (car ret1)))
    (if ret2 (setq buffer2 (car ret2)))
    (if (and buffer1 (not (eq buffer1 buffer2)))
        (progn
          (pop ret1)
          (setq is-new-buffer (pop ret1))
          (setq old-pos (pop ret1))
          (if is-new-buffer
              (kill-buffer buffer1)
            (progn
              (set-buffer buffer1)
              (goto-char old-pos)
              (if ret2 (set-buffer (car ret2)))))))

    ;;跳转到最终找到的符号
    (if ret2
        (progn
          (setq declare-buffer (car ret2))
          (switch-to-buffer declare-buffer))
      (set-buffer old-buffer))


    ;;恢复符号所在的buffer的状态
    (if (not (eq declare-buffer old-buffer))
        (progn
          (set-buffer old-buffer)
          (goto-char org-pos)
          (if declare-buffer (set-buffer declare-buffer))))
 
    (setq ret2 ret2)
    ))



(defun sbw-get-current-dir()
  (let ((it (split-string buffer-file-name "/"))
        (ret nil))
    (while it
      (if (cdr it)
          (progn
            (if ret
                (setq ret (concat ret "/")))
            (setq ret (concat ret (car it)))))
      (setq it (cdr it)))
    (setq ret ret)
    ))

(defun sbw-get-include-in-file(file-path)
  "获得一个文件中的包含文件列表，如果没有任何包含文件，返回nil"
  (let ((temp-buffer)
        (buffer)
        (old-buffer (current-buffer))
        (includes nil)
        (current-dir)
        (old-pos))

    (setq buffer (sbw-find-buffer-by-file file-path))
    (setq temp-buffer nil)
    (if (eq buffer nil)
        (progn
          (setq temp-buffer (find-file-noselect file-path))
          (setq buffer temp-buffer)))

    (set-buffer buffer)
    (setq includes (sbw-get-include))
    (setq it-dir nil)
    (if temp-buffer
        (kill-buffer temp-buffer))
    
    (set-buffer old-buffer)
    (setq includes includes)
    ))

(defun sbw-get-full-filename(include-filename)
  "获得包含文件的全路径。依赖于sbw-dir-list和包含的方式。
  #include \"foo.h\" 先在当前目录找，如果没有找到就在sbw-dir-list指定的目录找
  #include <foo.h>   不在当前目录找，直接在sbw-dir-list中找
  return 如果找到了就返回文件的全路径名，否则返回nil"
  (let ((it-dir sbw-dir-list)
        (file-path nil)
        (old-buffer (current-buffer))
        (includes nil)
        (filename)
        (temp-filename)
        (current-dir (sbw-get-current-dir)))

    ;;获得包含文件类型 "" 或者 <>
    (setq include-type (substring include-filename 0 1))

    ;;获得真实的文件名
    (setq filename include-filename)
    (if (or (string= include-type "<") (string= include-type "\""))
        (setq filename (substring include-filename 1 -1)))
    (if (string= include-type "<")
        ;;从sbw-dir-list中查找文件
        (while it-dir
          (setq dir (car it-dir))
          (setq temp-filename (concat dir "/" filename))
          (if (file-readable-p temp-filename)
              (progn
                (setq file-path temp-filename)
                (setq it-dir nil)))
          (setq it-dir (cdr it-dir)))
      ;;从当前文件夹查找文件
      (progn
        (setq temp-filename (concat (sbw-get-current-dir) "/" filename))
        (if (file-readable-p temp-filename)
            (setq file-path temp-filename))))
    
    (setq file-path file-path)
    ))

(defun sbw-get-include-test()
  (interactive)
  (message "%s" (sbw-get-include)))
(defun sbw-get-include()
  "获得当前buffer的包含头文件"
  (let ((debug-on-error t)
        (old-pos (point))
        (filename)
        (postfix)
        (include-list nil))
    
  (goto-char (point-min))
  (while (not (eq (search-forward "#include" nil t) nil))
    (skip-chars-forward "#include \"<")
    (setq filename (sbw-get-filename-at-cursor))
    (setq filename (sbw-get-full-filename filename))
    (if filename
        (progn
          (setq postfix (file-name-extension filename))
          ;;过滤掉.dnc文件
          (if (not (string= postfix "dnc"))
              (if (eq include-list nil)
                  (setq include-list (list filename))
                (nconc include-list (list filename)))))
      ))

  (goto-char old-pos)
  (setq include-list include-list)
  ))





;;把光标停在一个符号上，运行这个命令
(defun sbw-is-cpp-declare-test()
  (interactive)
  (message "%s" (sbw-is-cpp-declare)))

(defun sbw-is-cpp-declare()
  "判断光标所在的位置是否是一个C++定义，如果是返回t，否则返回nil"
  (let ((old-pos (point))(type-name)(temp)(ret t)
        (old-modiffied-flag (buffer-modified-p)))
    ;;进一步做精确的判断
    (setq old-pos (point))
    (skip-chars-backward sbw-symbol-chars)
    (c-backward-token-2)
    (setq type-name (sbw-get-token-at-cursor))
    ;;(message "  %s " type-name)
    ;;如果在symbol前面是以下符号，则不是一个C++定义
    (if (string= type-name "const")   (setq ret nil))
    (if (string= type-name "typedef") (setq ret nil))
    (if (string= type-name "virtual") (setq ret nil))
    (if (string= type-name "static")  (setq ret nil))
    (if (string= type-name "public")  (setq ret nil))
    (if (string= type-name "private")  (setq ret nil))
    (if (string= type-name "protected")  (setq ret nil))
    (if (string= type-name "return")  (setq ret nil))
    (if (string= type-name "&&")  (setq ret nil))
    (if (string= type-name "||")  (setq ret nil))

    (if ret
        (progn
          ;;排除类成员实现定义
          (goto-char (- old-pos 1))
          (c-forward-token-2)
          (setq temp (buffer-substring-no-properties (point) (+ (point) 2 )))
          (if (string= temp "::") (setq ret nil))
          ;;排除类或者结构申明
          (if (or (string= type-name "class") (string= type-name "struct"))
              (progn
                (setq temp (buffer-substring-no-properties (point) (+ (point) 1 )))
                (if (string= temp ";") (setq ret nil))
                ))
          ))
    (goto-char old-pos)
    ;;(set-buffer-modified-p old-modiffied-flag)
    (setq ret ret)
    ))

(defun sbw-search-macro-forward-test()
  (interactive)
  ;(c-beginning-of-statement-1)
  (message "%s" (sbw-search-macro-forward))
  )
(defun sbw-search-macro-forward(symbol)
  "查找一个c/c++宏定义，不区分大小写
   return nil，没有找到，
          0，找到了，但是不能精确匹配，把光标被移动到找到的位置
          >0，找到了指定的宏"
  (let ((here (point)) (symbol-reg)
        (old-case case-fold-search)
        (case-fold-search nil)
        (old-modiffied-flag (buffer-modified-p))
        (temp) (ret nil)(char) (pos))
    (setq symbol-reg (concat "#define\\s-+" symbol "\\s-+"))
    ;;(setq pos (c-syntactic-re-search-forward symbol-reg nil t))
    (setq pos (re-search-forward symbol-reg nil t))
    (if pos
        (progn
          (setq ret 0)
          (if (c-beginning-of-macro)
              (progn
                (goto-char pos)
                (c-beginning-of-statement-1)
                (setq temp (buffer-substring-no-properties (point) (+ (point) 1)))
                (if (string= temp "#")
                    (progn
                      (skip-chars-forward "# \t")
                      (setq temp (sbw-get-symbol-at-cursor))
                      (if (string= temp "define")
                          (progn
                            (skip-chars-forward sbw-symbol-chars)
                            (skip-chars-forward " \t")
                            (setq temp (sbw-get-symbol-at-cursor))
                            (if (string= temp symbol)
                                (setq ret pos))))))))
          (goto-char pos)))
    (setq case-fold-search old-case)
    (set-buffer-modified-p old-modiffied-flag)
    (setq ret ret)
    ))


(defun sbw-test()
  (interactive)
  (message "%s" (sbw-syntactic-re-search-forward-token "class")))

(defun sbw-syntactic-re-search-forward-token(token)
  "根据语法向前搜索token"
  (let ((pos)(reg)(old-pos (point))(ret nil))
    (setq reg (concat "\\b" token "\\b"))
    (setq pos (c-syntactic-re-search-forward reg nil t))
    ;;c-syntactic-re-search-forward不能越过'_'分隔的单词
    (if pos
        (progn 
          (goto-char (- (point) 1))
          (setq token2 (sbw-get-token-at-cursor))
          (goto-char (+ (point) 1))
          (if (string= token2 token)
              (setq ret (point))
            (setq ret nil))
          ))
    (if (not ret) (goto-char old-pos))
    (setq ret ret)
    ))

;;  (message "%s" (c-forward-comments)))
;;test
;;binary.cpp
;;(sbw-find-symbol-in-buffer "Binary" (list "dnc" "Binary"))
(defun sbw-find-cpp-declare(symbol)
  "查找一个c/c++符号定义，不区分大小写
   return nil，没有找到，
          0，找到了，但是不能精确匹配，把光标被移动到找到的位置
          >0，找到了指定的符号"

  ;;一个C++符号定义的前边必然是一个 word 或者是 * 或 &
  (let ((word-reg) (symbol-reg)
        (old-case case-fold-search)
        (case-fold-search nil)
        (temp)
        (pos)  (old-pos (point)) (macro-pos)
        (type-name))

    ;;c-syntactic-re-search-forward会越过宏定义，所以要单独找宏定义
    (setq pos (sbw-search-macro-forward symbol))
    (setq macro-pos (point))
    
    ;;查找宏定义除外的一般符号
    (if (or (eq pos nil) (eq pos 0))
        (progn
          (goto-char old-pos)
          (setq word-reg (concat "\\s-*\\b" symbol "\\b"))
          (setq symbol-reg (concat "\\(\\w\\s-\\|*\\|&\\|>\\)" word-reg))
          (setq temp (c-syntactic-re-search-forward symbol-reg nil t))
          (if temp
              (progn
                (setq pos temp)
                (if (sbw-is-cpp-declare)
                    (progn
                      ;;精确的对比symbol和光标所在的符号
                      (setq temp (sbw-get-symbol-at-cursor))
                      (message temp)
                      (if (not (string= temp symbol))
                            (setq pos 0)))
                  (setq pos 0)))
            (goto-char macro-pos))))
    
    ;;恢复原来的查找属性
    (setq case-fold-search old-case)
    (setq pos pos)
    ))

(defun sbw-test()
  (interactive)
  (message "%s" (sbw-get-next-namespace-type)))
(defun sbw-get-next-namespace-type()
  "获得下一个命名空间类型，如果找到了返回类型，并把光标定位到找到的位置;否则返回nil"
  (let ((namespace-type nil)(pos (point-max))
        (namespace-pos)(class-pos)(struct-pos)
        (old-pos (point)))

    (setq namespace-pos (sbw-syntactic-re-search-forward-token "namespace"))
    (if (and (not (eq namespace-pos nil)) (< namespace-pos pos))
        (progn
          (setq namespace-type "namespace")
          (setq pos namespace-pos)))
    (goto-char old-pos)

    (setq class-pos (sbw-syntactic-re-search-forward-token "class"))
    (if (and (not (eq class-pos nil)) (< class-pos pos))
        (progn
          (setq namespace-type "class")
          (setq pos class-pos)))
    (goto-char old-pos)
        
    (setq struct-pos (sbw-syntactic-re-search-forward-token "struct"))
    (if (and (not (eq struct-pos nil)) (< struct-pos pos))
        (progn
          (setq namespace-type "struct")
          (setq pos struct-pos)))
    (goto-char old-pos)

    (if namespace-type (goto-char pos))
    (setq namespace-type namespace-type)
    ))



(defun sbw-test()
  (interactive)
  (message "%s" (c-end-of-defun)))

  
(defun sbw-end-of-block()
  (interactive)
  (let ((pos) (ret)
        (old-pos (point)))
    (setq pos (c-syntactic-re-search-forward "}" nil t 1))
    (if (eq pos nil)
        (c-syntactic-re-search-forward "}" nil t))
    (setq ret pos)
    ))

(defun sbw-test()
  (interactive)
  (message "%s" (sbw-argument-list-to-body)))

(defun sbw-argument-list-to-body()
  "把光标从参数列表移动到函数定义体，如果光标在参数列表中，返回函数体的位置；否则返回nil
bugs: 当光标在字符串内部时，(c-end-of-decl-1)会出错
"
(let ((char)(old-pos (point)) (pos)(ret nil)(is-loop t))
  (c-end-of-decl-1)
  (setq char (buffer-substring (point) (+ (point) 1)))

  (if (string= char ")")
      (while is-loop
        (setq pos (point))
        (c-forward-token-2)
        (if (eq pos (point))
            (setq is-loop nil))
        (setq char (buffer-substring (point) (+ (point) 1)))
        (if (string= char ";")
            (setq is-loop nil))
        (if (string= char "{")
            (progn
              (setq is-loop nil)
              (setq ret (point))))))
  (if (not ret)
      (goto-char old-pos))
  (setq ret ret)
  ))


(defun sbw-test()
  (interactive)
  (message "islambda = %s" (sbw-is-lambda "<lambda>@3")))

(defun sbw-is-lambda(functionName)
  (let ((ret)(fields))
    (if functionName
        (progn 
          (setq fields (split-string functionName "@"))
          (setq ret (string= (car fields) "<lambda>")))
      (setq ret nil))
))


(defun sbw-test()
  (interactive)
  (message "function-begin = %s" (sbw-beginning-of-function)))

(defun sbw-test()
  (interactive)
(c-beginning-of-decl-1))

(defun sbw-beginning-of-function()
  (interactive)
  (c-beginning-of-defun)
  (sbw-beginning-of-function-1))


;;(defun sbw-beginning-of-function-1()
;;  "转到函数开始处，当光标在函数体中或者在函数参数定义中，跳转就会成功。
;;  对C++函数同样有效,如果找到函数开始位置，总是返回函数开始位置，否则返回nil。
;;bugs: 如果光标刚好在函数定义的开始位置，此函数会跳到上一个定义。
;;"
;;  (let ((ret nil)
;;        (function-name nil)
;;        (old-pos (point))
;;        (old-modiffied-flag (buffer-modified-p))
;;        (begin) (end) (pre-pos 0)
;;        (pos nil))
;; 
;;    (while (and (not function-name) (= (c-backward-token-2) 0))
;;      (setq char (buffer-substring (point) (+ (point) 1)))
;;      ;;(message "%s:%s" char temp)
;;      (if (string= char "}")
;;          (progn 
;;            (forward-char)
;;            (c-beginning-of-decl-1))
;;        (progn 
;;          (setq function-name (sbw-get-function-name)))))      
;;
;;    (if (sbw-is-lambda function-name)
;;        (progn
;;          (c-syntactic-re-search-forward "]" nil t)
;;          (c-backward-token-1)
;;          (sbw-move-to-bracket)
;;          (setq ret (point)))
;;      (setq ret (c-beginning-of-decl-1)))
;;
;;    
;;    (if (not function-name)
;;        (goto-char old-pos))
;;
;;    (if function-name
;;        (setq ret (point))
;;      (setq ret nil))
;;    (set-buffer-modified-p old-modiffied-flag)
;;    ))

(defun sbw-beginning-of-function-1()
  ;; 可以由 c-beginning-of-defun 函数直接实现
  "转到函数开始处，当光标在函数体中或者在函数参数定义中，跳转就会成功。
  对C++函数同样有效,如果找到函数开始位置，总是返回函数开始位置，否则返回nil。
bugs: 如果光标刚好在函数定义的开始位置，此函数会跳到上一个定义。
"
  (let ((ret nil)
        (function-name nil)
        (old-pos (point))
        (old-modiffied-flag (buffer-modified-p))
        (begin) (end) (pre-pos 0)
        (pos nil))
 
    (while (and (not function-name) (= (c-backward-token-2) 0))
      (setq char (buffer-substring (point) (+ (point) 1)))
      ;;(message "%s:%s" char temp)
      (if (string= char "}")
          (progn 
            (forward-char)
            (c-beginning-of-decl-1))
        (progn 
          (setq function-name (sbw-get-function-name)))))      

    (if (sbw-is-lambda function-name)
        (progn
          (c-syntactic-re-search-forward "]" nil t)
          (c-backward-token-1)
          (sbw-move-to-bracket)
          (setq ret (point)))
      (setq ret (c-beginning-of-decl-1)))

    
    (if (not function-name)
        (goto-char old-pos))

    (if function-name
        (setq ret (point))
      (setq ret nil))
    (set-buffer-modified-p old-modiffied-flag)
    ))

(defun sbw-test()
  (interactive)
  (message "%s" (sbw-get-function-name-2)))

(defun sbw-get-function-name-2()
  "获得光标所在处的函数名字,光标必须停留在函数定义的最后,也就是在';'或者'{'上.
如果光标所在处是一个像下面的定义:
name(){}
或者:
name();
那么获取名字就会成功,并且返回真,否则返回nil.
这也意味着像下面的语句也会被认为是函数:
if(){}
并且得到函数名'if'。这在此函数的定义范围之内。
bugs:对于带有初始化表的构造函数还有问题
"
  (let ((ret nil)(old-pos (point)))
    (c-backward-token-1)
    (setq token (sbw-get-token-at-cursor))
    ;;(message "--------")
    ;;(message "%s,%i" token (point))
    (if (string= token "const") (c-backward-token-1))
    (setq token (sbw-get-token-at-cursor))
    ;;(message "%s,%i" token (point))
    (if (string= token ")")
        (progn
          (sbw-move-to-bracket)
          (c-backward-token-1)
          (setq ret (sbw-get-token-at-cursor))
          ))      
    (goto-char old-pos)
    (setq ret ret)
    ))

(defun sbw-is-control-keyword(name)
  "判断一个名字是否是控制结构关键字"
  (let ((ret))
    (setq ret
          (or (string= name "if")
              (string= name "for")
              (string= name "foreach")
              (string= name "while")
              (string= name "switch")
              (string= name "do")
              ))
    ))

(defun sbw-test()
  (interactive)
  ;;(message "%s" (sbw-get-function-name-2)))
  (message "%s" (sbw-move-to-function-declare-end)))

(defun sbw-move-to-function-declare-end()
  "如果光标在一个函数定义中，此函数把光标移动到函数定义的末尾，也就是'{'上,此函数可以用于判断光标
是否在一个函数定义的内部.这是sbw的一个底层函数。
返回: 如果光标是在函数定义中，返回函数定义的末尾位置，否则返回nil。"
  (interactive)
  (let ((is-loop t)(token)(pos)(ret)(count 0)
        (function-name nil)
        (old-pos (point)))
    
    ;;(message "==========")
    (while is-loop
      (setq pos (point))
      (c-backward-token-1)
      (if (eq pos (point)) (setq is-loop nil))
      
      (setq token (sbw-get-token-at-cursor))
      ;;(message "%s,%i" token (point))
      (if (string= token "{")
          (progn
            (setq count (- count 1))
            (setq function-name (sbw-get-function-name-2))
            (if function-name
                (progn
                  (if (not (sbw-is-control-keyword function-name))
                      (progn
                        (setq is-loop nil)
                        (setq ret (point))))
                  ))
            ))
      (if (string= token "}") (setq count (+ count 1)))
      )
    ;;(message "count=%s,name=%s" count function-name)
    (if (>= count 0) (setq ret nil))
    (if (not ret) (goto-char old-pos))
    (setq ret ret)
    ))

(defun sbw-test()
  (interactive)
  (message "%s" (sbw-get-function-name)))

(defun sbw-test()
  (interactive)
  (c-syntactic-re-search-forward "}" nil t))

(defun sbw-test()
  (interactive)
  (c-syntactic-re-search-forward "(" nil t))
(defun sbw-get-function-name()
  "获得光标所在处的函数定义的函数名字，如果不是一个函数定义，则返回nil.
note: 这个函数应该使用   sbw-get-function-info() 实现"
  (let ((ret)(pos)
        (old-pos (point))
        (function-name nil)
        (is-lambda nil)
        (line)
        (big-bracket-pos)
        (big-bracket-close-pos)
        (semicolon-pos)
        (char nil)
        (small-bracket-pos))
    ;;(c-beginning-of-decl-1)
    (setq pos (point))
    (setq small-bracket-pos (c-syntactic-re-search-forward "(" nil t))
    (c-backward-token-1)
    (setq char (buffer-substring (- (point) 1) (point)))
    (if (string= char "]") (setq is-lambda t))    
    (setq line (line-number-at-pos))
    (goto-char pos)
    (setq big-bracket-pos (c-syntactic-re-search-forward "{" nil t))
    (goto-char pos)
    (setq big-bracket-close-pos (c-syntactic-re-search-forward "}" nil t))
    (if (and big-bracket-pos (> big-bracket-pos big-bracket-close-pos))
        (setq big-bracket-pos nil))
    (goto-char pos)
    (setq semicolon-pos (c-syntactic-re-search-forward ";" nil t))
    ;;(message "%s %s %s" small-bracket-pos big-bracket-pos semicolon-pos)
    (if (and small-bracket-pos
             big-bracket-pos         
             (< small-bracket-pos big-bracket-pos))
        (progn
          (if is-lambda
              (setq function-name "<lambda>")
            (progn 
              (goto-char small-bracket-pos)
              (c-syntactic-skip-backward "(")
              (setq function-name (sbw-get-symbol-at-cursor))
              (if (sbw-is-control-keyword function-name)
                  (setq function-name nil))))
          (if (and semicolon-pos (< semicolon-pos big-bracket-pos))
              (setq function-name nil))
          ))

    ;;(message "%s" function-name)

    ;;如果是lambda函数，限制只有光标在[]之内才有函数名
    (if (and is-lambda function-name)
        (progn 
          (goto-char small-bracket-pos)
          (c-backward-token-1)
          (c-backward-token-1)
          (setq end (point))
          (sbw-move-to-bracket)          
          (setq begin (point))
          ;;(message "%s %s %s" begin old-pos end)
          (if (or (< old-pos begin) (> old-pos end))
              (setq function-name nil))))

    (if function-name
        ;;确定函数定义的行号，如果是全局函数，行号就是函数名所在的位置；如果函数有名字空间限定，
        ;;行号就是第一个名字空间所在的位置。注意行号不一定是返回类型的位置；也不一定是函数名的位置。
        (progn 
          (if (not is-lambda)
              (progn 
                (c-backward-token-2)
                (setq is-loop t)
                ;;从函数名反过来查找::符号，直到没有::符号
                (while is-loop
                  (setq line (line-number-at-pos))
                  (c-backward-token-2)
                  (setq char (buffer-substring (point) (+ (point) 1)))
                  ;;(message char)
                  (if (string= char ":")
                      (c-backward-token-2)
                    (setq is-loop nil)))))
          (setq function-name (concat function-name "@" (number-to-string line)))))

    (goto-char old-pos)
    (setq function-name function-name)
    ))

(defun sbw-get-namespace-name()
  "获得当前光标所在处的名字空间的名字"
  (let ((old-pos (point)) (pos) (ret))
    (c-syntactic-re-search-forward "[{:]")
    (c-syntactic-skip-backward " {:")
    (goto-char (- (point) 1))
    (setq ret (sbw-get-symbol-at-cursor))
    (goto-char old-pos)
    (setq ret ret)
    ))

(defun sbw-test()
  "获得当前光标所在处的namespace空间"
  (interactive)
  (setq debug-on-error t)
  (message "%s" (sbw-get-namespace)))
(defun sbw-get-namespace()
  "获得光标所在的命名空间，以查找 namespace/class/struct/union 关键字为准"
  (let ((old-pos (point))
        (old-modiffied-flag (buffer-modified-p))
        (namespace-list nil)
        (namespace-type nil)
        (namespace-pos nil)
        (namespace-name nil))
    
    (goto-char (point-min))

    ;;获得第一层空间
    (setq namespace-type (sbw-get-next-namespace-type))
    (setq namespace-pos (point))

    ;;循环所有空间
    (while (not (eq namespace-type nil))
      (c-search-decl-header-end)
      (setq namespace-begin-pos (point))
      (if namespace-begin-pos
          (progn
            (goto-char (- (point) 1))
            (if (c-end-of-decl-1)
                (setq namespace-end-pos (point))
              (setq namespace-end-pos nil))
            (if namespace-end-pos
                (if (and (>= old-pos namespace-begin-pos) (< old-pos namespace-end-pos))
                    (progn
                      (goto-char namespace-pos)
                      (setq namespace-name (sbw-get-namespace-name))
                      (push (sbw-get-namespace-name) namespace-list)
                      )))))
      (goto-char namespace-pos)
    
      ;;获得上一层空间
      (setq namespace-type (sbw-get-next-namespace-type))
      (setq namespace-pos (point)))
  
    ;;恢复原来的光标位置
    (goto-char old-pos)
    (set-buffer-modified-p old-modiffied-flag)

    (setq namespace-list (reverse namespace-list))
  ))

(defun sbw-test()
  (interactive)
   (c-beginning-of-decl-1))

(defun sbw-test()
  "获得当前光标所在处的class空间"
  (interactive)
  (setq debug-on-error t)
  (message "%s" (sbw-get-function)))
(defun sbw-get-function()
  "获得光标所在的函数空间，以查找 :: 符号为准"
  (let ((old-pos (point))
        (info)
        (scopes nil))

    (if (sbw-move-to-function-declare-end)        
        (progn
          ;;现在光标已经在函数末尾的'{'上
          (setq info (sbw-get-function-info))
          (setq scopes (cdr (assoc "scopes" info)))
          (setq scopes (reverse scopes))
          (setq name (cdr (assoc "name" info)))
          (setq pos (cdr (assoc "declare-position" info)))
          (setq name (concat name "@" (number-to-string (line-number-at-pos pos))))
          (push  name scopes)
          (setq scopes (reverse scopes))))
    (goto-char old-pos)
    (setq scopes scopes)
    ))


(defun sbw-test()
  "获得当前光标所在处的名字空间"
  (interactive)
  (setq debug-on-error t)
  (message "%s" (sbw-get-scope)))

(defun sbw-get-scope()
  "获得当前光标所在的命名空间位置，包括类空间"
  (let ((scope-list) (old-pos (point)))
    (setq scope-list
          (append
           (sbw-get-namespace)
           (sbw-get-function)))
  
    (goto-char old-pos)
    (setq scope-list scope-list)))


;;(message "%s" (sbw-is-in-scope (list "dnc") nil))
(defun sbw-is-in-scope(scope1 scope2)
  "判断scope1是否在scope2的空间范围之内，或者在同一个空间,
   如果scope是nil，表示全局命名空间"
  (let ((ret t)
        (it-scope1 scope1)
        (it-scope2 scope2)
        (scope-name1)
        (scope-name2)
        (is-loop t))
    
  (while (eq is-loop t)
    (setq scope-name1 (car it-scope1))
    (setq scope-name2 (car it-scope2))
    (if (not (string= scope-name2 scope-name1))
        (progn
          (setq ret nil)
          (setq is-loop nil)))
    (setq it-scope1 (cdr it-scope1))
    (setq it-scope2 (cdr it-scope2))
    (if (eq it-scope2 nil)
        (setq is-loop nil)
      (if (eq it-scope1 nil)
          (progn
            (setq is-loop nil)
            (setq ret nil)))))
  (if scope2
      (setq ret ret)
    (setq ret t))
  ))

;;对于符号是一个对象的成员的查找方法，例如:
;; MyClass a;
;; a.b.c;
;; 现在我们查找 c 。c被 . 限制，可以根据 . 找到 a 的类型，然后
;;找到b的类型，再在b中找到c的定义。

(defun sbw-test()
  (interactive)
  (message "%s" (sbw-symbol-access-list)))
;;  (message "%s" (sbw-get-operator-at-cursor)))
 ;; (message "%s" (c-backward-token-2)))
(defun sbw-symbol-access-list()
  "获得光标所在处的符号列表，此列表由类成员访问符号 . 和 -> 定义。
  例如:
  MyClass a;
  a.b->c;
  c的符号列表就是(list a b c)
  b的符号列表就是(list a b)
  a的符号列表就是(list a)"
  (let ((ret nil)
        (symbol (sbw-get-symbol-at-cursor))
        (old-pos (point))
        (symbol-pos (c-on-identifier))
        (operator nil)
        (is-loop nil))
    (if (and symbol-pos symbol)
        (progn
          (push symbol ret)
          (setq is-loop t)))
    (while is-loop
      (goto-char symbol-pos)      
      (setq operator (sbw-get-operator-at-cursor))      
      (if (and operator
               (or (string= operator ".")
                   (string= operator "->")
                   (string= operator "::")))
          (progn
            (c-backward-token-2)
            (setq symbol (sbw-get-symbol-at-cursor))
            (setq symbol-pos (c-on-identifier))
            (if (and symbol-pos symbol)
                (push symbol ret)
              (setq is-loop nil)))
        (setq is-loop nil))
      (c-backward-token-2))
    (goto-char old-pos)
    (setq ret ret)
    ))

(defun sbw-test()
  (interactive)
  (message "%s" (sbw-get-call-argument-count)))

(defun sbw-test()
  (interactive)
  (sbw-get-call-argument-count)
)

(defun sbw-test()
  (interactive)
  (c-syntactic-re-search-forward "(" nil t))

(defun sbw-get-call-argument-count()
  "获得光标所在处的函数调用的参数数目
bug: 如果函数没有参数并且在括号中有注释时会返回一个参数
"
(let ((ret nil)
      (old-pos (point))
      (i  0)
      (text "")
      (count 0))

  (setq char (buffer-substring (point) (+ (point) 1)))
  (if (not (string= char "("))      
      (c-forward-token-2))

  (while (< i 4000)    
    (c-forward-token-2)
    (setq char (buffer-substring (point) (+ (point) 1)))
    
    (if (string= char "(")
        (sbw-move-to-bracket))
    (if (string= char "<")
        (sbw-move-to-bracket))
    (if (string= char "{")
        (sbw-move-to-bracket))
    
    (if (string= char ",")
        (progn 
          (setq count (+ count 1))))
    (if (string= char ")")
        (progn
          (if (not (string= text ""))
              (setq count (+ count 1)))
          (setq i 100000)))

    (setq char (buffer-substring (point) (+ (point) 1)))
    (if (not (string= char " "))
        (setq text (concat text char)))
    (setq i (+ i 1)))

  (goto-char old-pos)  
  ;;(message "count=%i,text=%s" count text)
  (setq count count)
))



(defun sbw-get-other-bracket(bracket)
"获得括号的另外一端的匹配括号"
(let ((ret))
  (if (string= bracket "(")
      (setq ret ")")
    (if (string= bracket "[")
        (setq ret "]")
      (if (string= bracket "{")
          (setq ret "}")
        (if (string= bracket "<")
            (setq ret ">")))))
))
(defun sbw-is-open-bracket(bracket)
  "判断一个括号是否是开括号"
  (let ((ret nil))
    (if (string= bracket "(")
      (setq ret t)
      (if (string= bracket "[")
          (setq ret t)
        (if (string= bracket "{")
            (setq ret t)
          (if (string= bracket "<")
              (setq ret t)))))
))
(defun sbw-is-close-bracket(bracket)
  "判断一个括号是否是闭括号"
  (let ((ret nil))
    (if (string= bracket ")")
        (setq ret t)
      (if (string= bracket "]")
          (setq ret t)
        (if (string= bracket "}")
            (setq ret t)
          (if (string= bracket ">")
              (setq ret t)))))
))

(defun sbw-test()
  (interactive)
  (sbw-move-to-bracket)
)

(defun sbw-move-to-bracket()
"移动到光标所在位置的括号的匹配括号，括号包括(),[],<>,{}
bugs: 统一的处理开闭括号，不能处理异常情况，例如:
{} ) 
当光标在 ')' 上时，应该不能匹配，可是现在会匹配到'{'
"
  (let ((begin-bracket (buffer-substring (point) (+ (point) 1)))
        (old-pos)
        (char)(count)(is_loop t))
    
    (setq count 1)

    (if (and (not (sbw-is-open-bracket begin-bracket)) 
             (not (sbw-is-close-bracket begin-bracket)))
        (return))

    (if (sbw-is-open-bracket begin-bracket)
        (while is_loop
          (setq old-pos (point))
          (c-forward-token-2)
          (setq char (buffer-substring (point) (+ (point) 1)))      
          (if (sbw-is-open-bracket char)
              (setq count (+ count 1)))
          (if (sbw-is-close-bracket char)
              (setq count (- count 1)))

          (if (eq count 0)
              (setq is_loop nil))
          (if (eq (point) old-pos)
              (setq is_loop nil)))
      (while is_loop       
        (setq old-pos (point))
        (c-backward-token-2)
        (setq char (buffer-substring (point) (+ (point) 1)))      
        (if (sbw-is-open-bracket char)
            (setq count (- count 1)))
        (if (sbw-is-close-bracket char)
            (setq count (+ count 1)))

        (if (eq count 0)
            (setq is_loop nil))
        (if (eq old-pos (point))
            (setq is_loop nil))
        ))
))
  
(defun sbw-test()
  (interactive)
  (open-bracket "("))
 
  

(defun sbw-test()
  (interactive)
  (message "%s" (sbw-symbol-list2path (sbw-symbol-access-list))))


(defun sbw-symbol-list2path(list)
  "把list中的所有元素转换成C++路径，以::分隔"
  (let ((name))
    (setq name (pop list))
    (setq ret "")
    (while name
      (setq ret (concat ret name))
      (setq name (pop list))
      (if name
          (setq ret (concat ret "::")))))
  (setq ret ret))

(defun sbw-test()
  (interactive)
  (message "%s" (sbw-is-function-call-on-cursor))
  )
(defun sbw-is-function-call-on-cursor()
  "判断光标所在位置是否是一个函数调用"
  (let ((char)(ret)(old-pos (point)))
    (c-forward-token-2)
    (setq char (buffer-substring (point) (+ (point) 1)))
    (goto-char old-pos)
    (if (string= char "(")
        (setq ret t)
      (setq ret nil))    
))

(defun sbw-symbol-find-on-cursor(symbol)
  "找到指定符号的定义，符号可以是下面的形式:
 a 一个单独的符号，会在全局空间找这个符号
 a::b::c 一个符号路径， 在名字空间a::b中找符号c
 a::b::c-d::e  意思是d::e在a::b::c包围的大括号中，分别尝试在a::b::c、a::b、a、全局空间 中找d::e
"
  (let ((old-pos (point)))
    (setq fields (split-string buffer-file-name "/"))
    (setq name (elt fields (- (length fields) 1)))
    (shell-command (concat "make symbol d=true f=" name))
    (setq command (concat "findsymbol " name " " symbol))
    (setq position (shell-command-to-string  command))
    (goto-char old-pos)
    (message position)))

(defun sbw-symbol-type-goto-on-cursor()
  "跳到光标下的符号的类型的定义"
  (interactive)
  (sbw-symbol-goto "-type"))
(defun sbw-symbol-class-goto-on-cursor()
  "跳到光标下的符号的类型的定义"
  (interactive)
  (sbw-symbol-goto "-class"))
(defun sbw-symbol-goto-on-cursor()
  "跳到光标下的符号的定义"
  (interactive)
  (sbw-symbol-goto ""))

(defun sbw-symbol-goto(command)
  "跳到光标下的符号的定义"
  (let ((scopes)
        (symbols)
        (old-modiffied-flag (buffer-modified-p))
        (symbol))
    (save-some-buffers t)   
    (setq scopes (sbw-get-scope))
    (setq symbols (sbw-symbol-access-list))
    (setq symbol (sbw-symbol-list2path symbols))
    (if (sbw-is-function-call-on-cursor)
        (setq symbol (concat symbol "+" 
                             (number-to-string
                              (sbw-get-call-argument-count)))))
    (if scopes
        (setq symbol (concat (sbw-symbol-list2path scopes) "-" symbol)))
    (setq symbol (concat "\"" symbol "\""))
    (setq symbol (concat symbol " " command))
    
    (message "find symbol: %s" symbol)
    (setq position (sbw-symbol-find-on-cursor symbol))
    (if (not (string= position ""))   
        (progn 
          (setq fields (split-string position ":"))        
          (if (not (string= (car fields) "<error>"))
              (sbw-symbol-goto-file position)
            (message (concat "fund out: " symbol))))
      (message (concat "fund out: " symbol)))
    (set-buffer-modified-p nil)
    ))

(defun sbw-symbol-goto-file(position)
  (let ((fields (split-string position ":"))
        (file (elt fields 0))
        (line (elt fields 1))
        (new-buffer nil)
        (buffer-of-next-window nil)
        (buffer-of-current-window nil)
        (old-pos (point))
        (old-buffer (window-buffer))
        (old-window (selected-window)))

    (set-buffer-modified-p nil )

    (if t
        (progn 
          (find-file-existing file)
          (goto-line (string-to-number line)))
      (progn                      
        (setq buffer-of-current-window (window-buffer))
        (find-file-existing file)
        (setq buffer-of-next-window (window-buffer (next-window)))    
        (if (eq buffer-of-current-window buffer-of-next-window)
            (progn 
              (other-window 1)
              (goto-line (string-to-number line))
              (select-window old-window))
          (progn         
            (goto-line (string-to-number line))    
            (setq new-buffer (window-buffer))    
            (other-window 1)
            (set-window-buffer (selected-window) new-buffer)     
            (set-buffer-modified-p nil )             
            (select-window old-window)
            (set-window-buffer old-window old-buffer)
            (goto-char old-pos)))))

    (set-buffer-modified-p nil )
))

(defun sbw-test()
  (interactive)
  (sbw-search-symbol-type "pBin" (list "dnc" "Binary" "compare")))

(defun sbw-is-class()
  "判断光标所在处是否是一个类或者结构"
  (let ((ret)(temp)
        (old-pos (point)))
    (setq temp (sbw-get-token-at-cursor))
    (if (or (string= temp "class") (string= temp "struct"))
        (setq ret t))
    (if (not ret)
        (c-backward-token-2))
    (setq temp (sbw-get-token-at-cursor))
    (if (or (string= temp "class") (string= temp "struct"))
        (setq ret t))
    (if (not ret)
        (c-backward-token-2))
    (setq temp (sbw-get-token-at-cursor))
    (if (or (string= temp "class") (string= temp "struct"))
        (setq ret t))
    (goto-char old-pos)
    (setq ret ret)
    ))

(defun sbw-test()
  (interactive)
  (message "%s" (sbw-is-namespace)))
(defun sbw-is-namespace()
  "判断光标所在处是否是一个命名空间"
  (let ((ret)(temp)
        (old-pos (point)))
    (setq temp (sbw-get-token-at-cursor))
    (if (string= temp "namespace")
        (setq ret t))
    (if (not ret)
        (c-backward-token-2))
    (setq temp (sbw-get-token-at-cursor))
    (if (string= temp "namespace")
        (setq ret t))
    (goto-char old-pos)
    (setq ret ret)
    ))


;;有名字空间前缀的符号还没有实现
(defun sbw-search-symbol-type(symbol symbol-scope)
  "查找symbol的类型符号,返回sbw-find-symbol函数的结果"
  (let ((ret nil)
        (declare-buffer)(is-new-buffer)
        (old-pos (point))
        (old-buffer (current-buffer))
        (symbol-is-type nil)
        (old-modiffied-flag (buffer-modified-p))
        (temp))

    ;;找符号，并且把光标停在定义符号的类型的位置
    (setq ret (sbw-find-symbol symbol symbol-scope))
    (if ret
        (progn
          (setq temp ret)
          (setq declare-buffer (pop ret))
          (setq ret temp)
          (if (or (sbw-is-class) (sbw-is-namespace))
              (progn
                (setq symbol-is-type t))
            (progn
              (c-backward-token-2)
              (setq temp (sbw-get-token-at-cursor))
              (if (or (string= temp "*") (string= temp "&"))
                  (c-backward-token-2))))))
    
;;    (message "%s" ret)

    ;;如果符号不是一个类型,找符号的类型定义
    (if (and ret (not symbol-is-type))
        (progn
          ;;从符号所在的buffer获得信息
          (setq declare-buffer (pop ret))
          (setq is-new-buffer (pop ret))
;;          (setq old-pos (pop ret))
          (setq symbol (sbw-get-symbol-at-cursor))
          (setq symbol-scope (sbw-get-scope))
          ;;查找符号的类型定义
          ;;(setq ret (sbw-find-symbol symbol symbol-scope))
          (setq ret (sbw-find-symbol-at-cursor))
          ))
    ;;(set-buffer-modified-p old-modiffied-flag)
    
;;    (if declare-buffer  (switch-to-buffer declare-buffer))
    (setq ret ret)
    ))

(defun sbw-get-file-name(full-name)
  (let ((name)(ext1)(ext2))
    (setq name full-name)
    (message "%s" name)
    (setq ext1 (file-name-extension name))
    (message "%s" ext1)
    (setq name (file-name-sans-extension name))
    (setq ext2 (file-name-extension name))
    
    (if (and (or (string= ext1 "cpp") (string= ext1 "mm"))
             (or (string= ext2 "p") (string= ext2 "t") (string= ext2 "e")))
        (setq name (file-name-sans-extension name)))
    (setq name name)
    ))

(defun sbw-switch-to-relation-file(extension)
  "切换到当前文件的关联文件"
  (let ((name)(current-file))
    (setq current-file (buffer-file-name))
    (setq name (sbw-get-file-name current-file))
    
    (setq name (concat name "." extension))
    (if (not (file-exists-p name))
        (message "file '%s' found out." name)
      (switch-to-buffer (find-file-noselect name)))
    ))

(defun sbw-switch-to-relation-files(extensions)
  "切换到当前文件的关联文件,extensions是扩展名的列表，此函数按照顺序打开一个存在的文件"
  (let ((name)(ext)(file nil)(file-name)(current-file))
  (setq current-file (buffer-file-name))
  (setq file-name (sbw-get-file-name current-file))
  (setq exts extensions)
  (while exts
    (setq ext (car exts))
    (setq name (concat file-name "." ext))
    (message name)
    (if (and (file-exists-p name) (not (string= name current-file)))
        (progn
          (setq file name)
          (setq exts nil)))
    (pop exts))

  (if file
      (switch-to-buffer (find-file-noselect file))
    (message "relation of file '%s' found out." (buffer-file-name)))
  ))

(defun sbw-switch-to-h()
  "切换到当前文件关联的头文件"
  (interactive)
  (sbw-switch-to-relation-file "h"))

(defun sbw-switch-to-cpp()
  "切换到当前文件关联的源文件"
  (interactive)
  (sbw-switch-to-relation-files (list "cpp" "c" "cc" "p.cpp" "p.mm")))

(defun sbw-switch-to-ct()
  "切换到当前文件关联的测试文件"
  (interactive)
  (sbw-switch-to-relation-files (list "t.cpp" "e.cpp")))

(defun sbw-get-dir-of-file()
  "显示当前文件所在的目录"
  (interactive)
  (message (file-name-directory buffer-file-name)))
