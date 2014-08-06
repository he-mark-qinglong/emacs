
;;(load "project.el")

;;初始化头文件的包含保护和注释
(defun dnc-init-header()
  (interactive)
  (dnc-init-header-include)
  (dnc-init-header-common)
  )


(defun dnc-insert-class(name base)
  "在当前光标位置插入dnc一个类定义"
  (interactive
   (list (read-from-minibuffer "class name:"
                               nil nil nil nil)
         (read-from-minibuffer "base name:"
                               nil nil nil nil)))
    
  (if (string= base "")
      (setq base "dnc::object"))

  (insert "dnc_declare_class(" name ");\n")  
  (insert "class " name "_w : public "base"_w{\n")
  (insert "    dnc_object("name","base"){\n")
  (insert "        handle();\n")
  (insert "    };\n")
  (insert "};\n")
  )


(defun dnc-insert-widget(name base)
  "在当前光标位置插入一个widget"
  (interactive
   (list (read-from-minibuffer "widget name:"
                               nil nil nil nil)
         (read-from-minibuffer "base name:"
                               nil nil nil nil)))
    
  (if (string= base "")
      (setq base "gui::widget"))
  
  (insert "class " name" : public "base"{\n")
  (insert "    GTKPP_WIDGET_DECLARE("name","base","");\n")
  (insert "public:\n")
  (insert "    " name "();\n")
  (insert "private:\n")
  (insert "\n")
  (insert "};\n")
  (goto-line (- (line-number-at-pos) 2))
  (insert "    ")
  )

;;在当前光标处插入一个接口
(defun dnc-insert-interface(name base)
  (interactive
   (list (read-from-minibuffer "interface name:"
                               nil nil nil nil)
         (read-from-minibuffer "base name:"
                               nil nil nil nil)))
  (if (string= base "")
      (setq base "dnc::Itf"))
  (insert "interface "name" : public " base "{\n")
  (insert "    dnc_interface("name");\n")
  (insert "\n")
  (insert "};\n")
  (goto-line (- (line-number-at-pos) 2))
  (insert "    ")
  )

(defun dnc-insert-struct(name)
  (interactive
   (list (read-from-minibuffer "struct name:"
                               nil nil nil nil)))
  (insert "struct "name"{\n")
  (insert "    dnc_struct("name");\n")
  (insert "\n")
  (insert "};\n")
  (goto-line (- (line-number-at-pos) 2))
  (insert "    ")
  )



(defun dnc-add-component(name base)
  "增加一个dnc组件"
  (interactive
   (list (read-from-minibuffer "class name: "
                               nil nil nil nil)
         (read-from-minibuffer "base name: "
                               nil nil nil nil)))
  (dnc-add-file name ".cpp")
  (dnc-init-source-for-class name base)
  (dnc-add-file name ".h")
  (dnc-init-header-for-class name base)
  (dnc-add-file name ".t.cpp")
  (dnc-init-test-for-class name base)
  )
   
(defun dnc-add-widget(name base)
  "增加一个部件(widget)"
  (interactive
   (list (read-from-minibuffer "widget name: "
                               nil nil nil nil)
         (read-from-minibuffer "base name: "
                               nil nil nil nil)))
  (dnc-add-file name ".cpp")
  (dnc-init-source-for-widget name base)
  (dnc-add-file name ".h")
  (dnc-init-header-for-widget name base)
  (dnc-add-file name ".ct")
  (dnc-init-test-for-widget name base)
  )
   

;;获得当前 buffer 的文件名，不包括路径
(defun dnc-file-name()
  (let ((fields) (name))
  (setq fields (split-string buffer-file-name "/"))
  (setq name (elt fields (- (length fields) 1)))
  ))

(defun dnc-project-name()
  (let ((fields)(name))
    (setq fields (split-string buffer-file-name "/"))
  (setq name (elt fields (- (length fields) 2)))
  (setq fields (split-string name "-"))
  (elt fields 0)
  ))

;;替换字符串中的某一个字符，把字符串中与 src 相等的字符全部替换成 dst
;;string 字符串
;;src 字符的 ASCII 码 在lisp中可以用 ?a(97) ?b(98) 表示
;;dst 字符的 ASCII 码
;;例子:
;;(dnc-replace-char "a.b.c" ?. ?-)
;;  => a-b-c
(defun dnc-replace-char(string src dst)
  (let ((i 0) (len (length string)) (ret string)(ch))
    (while (< i len)
      (setq ch (aref string i))
      (if (eq ch src)
          (aset ret i dst))
      (setq i (+ i 1))
      )
    (setq ret ret)
  ))

(defun dnc-test()
  (interactive)
  (dnc-init-header-for-class "MyClass" ""))

(defun dnc-init-header-for-class(name base)
  (let ((namespace (project-name))
        (base-file-name (replace-in-string base "::" "/")))
    (goto-line (- (line-number-at-pos (point-max)) 3))
    (if (string= base-file-name base)
        (insert "#include \"" base-file-name ".h\"\n\n")
      (insert "#include <" base-file-name ".h>\n\n"))
    (insert "namespace "namespace"{\n")
    (dnc-insert-class name base)
    (goto-line (+ (line-number-at-pos) 3))
    (insert "}\n")
    (goto-line (- (line-number-at-pos) 4))
    (line-move-to-column 4)
    (dnc-init-header)
    ))

(defun dnc-test()
  (interactive)
  (dnc-init-header-for-widget "ToolBar" "test::Widget"))

(defun dnc-init-header-for-widget(name base)
  (let ((namespace (project-name))
        (fields)
        (base-namespace "")
        (base-class))
    
    (if (string= base "")
        (setq base "gui::Widget"))
    (setq base-class base)
    (setq fields (split-string base "::"))
    (if (= 2 (length fields))
        (progn
          (setq base-namespace (elt fields 0))
          (setq base-class (elt fields 1))))

    (dnc-init-header)
    (goto-line (- (line-number-at-pos (point-max)) 3))
    (if (or (string= base-namespace "") (string= base-namespace namespace))
        (insert "#include \"" (downcase base-class) ".h\"\n\n")
      (insert "#include <" (downcase base-namespace) "/" (downcase base-class) ".h>\n\n"))
    (insert "namespace "namespace"{\n")
    (dnc-insert-widget name base)
    (goto-line (+ (line-number-at-pos) 3))
    (insert "}\n")
    (goto-line (- (line-number-at-pos) 4))
    (line-move-to-column 4)
    ))


(defun dnc-test()
  (interactive)
  (dnc-add-header "ToolBar" "Widget"))

(defun dnc-add-file(name suffix)
  "增加一个文件"
  (let ((file-name (concat (downcase name) suffix)))
    (pop-to-buffer (get-buffer-create file-name))
    (write-file file-name)
    ))

(defun dnc-test()
  (interactive)
  (dnc-init-test-for-class "MyClass" ""))
(defun dnc-init-test-for-class(name base)
  "为一个类初始化测试文件"
  (insert "#include \""(downcase name)".h\"\n")
  (insert "#include <dnc/test.h>\n\n")
  (insert "PRJ_TUNIT_BEGIN(){\n")
  (insert "    auto obj = dnew<"(project-name)"::"name">();\n")
  (insert "    tprintl(obj.to_string());\n")
  (insert "}\n")
  (insert "PRJ_TUNIT_END(){\n\n")
  (insert "}\n")
  (goto-line (- (line-number-at-pos) 5))
  )

(defun dnc-test()
  (interactive)
  (dnc-init-test-for-widget "ToolBar" ""))

;;(defun dnc-init-test-for-widget(name base)
;;  "为一个类初始化测试文件"
;;  (insert "#include \""(downcase name)".h\"\n")
;;  (insert "#include <dnc/test.h>\n")
;;  (insert "#include <wte/module.h>\n")
;;  (insert "#include <gui/module.h>\n\n")
;;  (insert "PRJ_TUNIT_BEGIN(){\n")
;;  (insert "    gui::init(argc,argv);\n")
;;  (insert "    auto widget = dnew<"(dnc-project-name)"::"name">();\n")
;;  (insert "    widget->on_destroy += gtk::exit;\n\n")
;;  (insert "    widget->map();\n") 
;;  (insert "}\n")
;;  (insert "PRJ_TUNIT_END(){\n")
;;  (insert "    wte::main();\n")
;;  (insert "}\n")
;;  (insert "WTE_AUTOTEST(){\n")
;;  (insert "    wte::wait(500);\n")
;;  (insert "}\n")
;;  (goto-line (- (line-number-at-pos) 9))
;;  (insert "    ")
;;  )

(defun dnc-init-test-for-widget(name base)
  "为一个类初始化测试文件"
  (insert "#include \""(downcase name)".h\"\n")
  (insert "#include <dnc/test.h>\n")
  (insert "#include \"main.h\"\n")
  (insert "#include \"window.h\"\n\n")
  (insert "PRJ_TUNIT_BEGIN(){\n")
  (insert "    gtk::init(argc,argv);\n")
  (insert "    auto window = dnew<gtk::window>();\n")
  (insert "    window->on_destroy += gtk::exit;\n\n")
  (insert "    window->show();\n")
  (insert "    auto widget = dnew<gtk::"name">();\n")
  (insert "    window->add(widget);\n")
  (insert "    widget->show();\n")
  (insert "}\n")
  (insert "PRJ_TUNIT_END(){\n")
  (insert "    gtk::main();\n")
  (insert "}\n"))

;;产生文件头部注释，注释包括两部分，一部分是 header 工具产生的，令一部分是用于
;;doxygen工具的，对于头文件的说明应写在 doxygen的注释中
(defun dnc-init-header-common()
  (let ((file-name)(namespace)(year))
    (setq file-name (dnc-file-name))
    (setq namespace (dnc-project-name))
   
    (setq year (format-time-string "2006-%Y"))
    (goto-char (point-min))
    
    (insert "\n/*! \\file " file-name "\n")
    ;;(insert "   \author " user-full-name )
    ;;(insert "  \\date " (format-time-string "%Y-%m-%d") "\n")
    (insert "  The " namespace " Module\n")
    (insert " */\n\n")

    (make-header)
    ))

;;初始化头文件的包含保护宏
(defun dnc-init-header-include()
  (let ((file-name)(namespace)(mc))

    (setq file-name (dnc-file-name))
    (setq namespace (dnc-project-name))
    (goto-char (point-min))
    
    ;;产生文件头部宏定义
    (setq mc (concat"__"  (upcase namespace) "_"
                    (upcase (dnc-replace-char file-name ?. ?_))
                    "__"))
  
    (insert "#ifndef " mc "\n")
    (insert "#define " mc "\n")
    (insert "\n")

    (goto-char (point-max))
    ;;产生文件尾部宏定义
    (insert "\n#endif //"  mc "\n")
    ))

            
(defun dnc-test()
  (interactive)
  (dnc-init-source-for-class "MyClass" ""))
(defun dnc-init-source-for-class(class-name base)
  (let ((file-name (concat (downcase class-name) ".h"))
        (namespace (project-name))
        )
              
    (insert "#include \"" file-name "\"\n")
    (insert "\n")

    ;;产生基础函数
    (insert namespace "::" class-name "::handle::\n")
    (insert "handle(){\n")
    (insert "\n")
    (insert "}\n")
    (goto-line (- (line-number-at-pos) 2))
    (insert "    ")
   ))

(defun dnc-test()
  (interactive)
  (dnc-init-source-for-widget "ToolBar" ""))

(defun dnc-init-source-for-widget(class-name base)
  (let ((file-name (concat (downcase class-name) ".h"))
        (namespace (project-name))
        )
              
    (insert "#include \"" file-name "\"\n")
    (insert "#include \"widget_p.h\"\n")
    (insert "\n")
    (insert "GTKPP_WIDGET_IMPLEMENT("class-name");\n\n")

    ;;产生基础函数
    (insert namespace "::" class-name "::\n")
    (insert class-name "():dsuper(dnc::empty_construct()){\n")
    (insert "\n")
    (insert "}\n")
    (goto-line (- (line-number-at-pos) 2))
    (insert "    ")
   ))

(defun dnc-insert-sample(name)
  "增加一个dnc例子程序"
  (interactive
   (list (read-from-minibuffer "sample name: "
                               nil nil nil nil)))
  
  (insert "PRJ_SAMPLE_BEGIN("name")\n")
  (insert "+++===\n")
  (insert "PRJ_SAMPLE_END("name")")
  (goto-char (point-min))
  (replace-string "+++===" ""))

(defun dnc-insert-test-function(name)
  "插入一个测试函数"
  (interactive
   (list (read-from-minibuffer "test function name: "
                               nil nil nil nil)))
  
  (insert "PRJ_TFUNC("name"){\n    \n}")
  (goto-char (- (point) 2)))

(defun dnc-insert-dsref()
  "在当前光标位置插入强引用类型"
  (interactive)
  (insert "dsref<> ")
  (goto-char (- (point) 2)))

(defun dnc-insert-dwref()
  "在当前光标位置插入弱引用类型"
  (interactive)
  (insert "dwref<> ")
  (goto-char (- (point) 2)))

(defun dnc-insert-quote1()
  "在当前光标位置插入单引号"
  (interactive)
  (insert "''")
  (goto-char (- (point) 1)))
(defun dnc-insert-quote2()
  "在当前光标位置插入双引号"
  (interactive)
  (insert "\"\"")
  (goto-char (- (point) 1)))

(defun dnc-insert-bracket1()
  "在当前光标位置插入小括号"
  (interactive)
  (insert "()")
  (goto-char (- (point) 1)))
(defun dnc-insert-bracket2()
  "在当前光标位置插入中括号"
  (interactive)
  (insert "[]")
  (goto-char (- (point) 1)))
(defun dnc-insert-bracket3()
  "在当前光标位置插入大括号"
  (interactive)
  (insert "{}")
  (goto-char (- (point) 1)))
(defun dnc-insert-bracket4()
  "在当前光标位置插入尖括号"
  (interactive)
  (insert "<>")
  (goto-char (- (point) 1)))
(defun dnc-insert-dnew()
  "在当前光标位置插入dnew操作符"
  (interactive)
  (insert "dnew<>()")
  (goto-char (- (point) 3)))

(defun dnc-insert-declare-macro()
  "在当前光标位置插入共享库导出符号定义宏"
  (interactive)
  (let ((file (buffer-file-name)))
    ;;以工程的目录名作为导出符号宏的名字基础
    (setq file (file-name-directory file))
    (setq file (replace-in-string file "^.*/\\(.+\\)/$" "\\1"))
    (insert (upcase file) "_DECLARE")
  ))

(defun dnc-insert-comment()
  "在当前光标位置插入doxygen格式的注释"
  (interactive)
  (insert "/** @brief \n"
          " */")
  (goto-char (- (point) 4)))

(defun dnc-insert-empty-constructor-super()
  "在当前光标位置插入父类的空构造函数调用"
  (interactive)
  (insert "dsuper::handle(dempty())"))
