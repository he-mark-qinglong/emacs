;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 提供获得目录工程信息的函数
;; 假如文件object.cpp在下面的目录
;; e:\dev\dnc-0.6.1
;; 那么当object.cpp在当前buffer时
;; (project-name)    => dnc
;; (project-version) => 0.6.1
;; (project-exports) => DNC_EXPORTS
;; 这些信息可以传递给makefile文件作为参数,以便makefile可以自动的进行编译
;;
;; 工程文件夹的命名规定:
;; 工程名和版本号用'-'分隔,例如:
;; dnc-0
;; gui-2.0.9
;; dmo-3
;; 都是合法的工程文件夹名


;;获得工程名称
;;根据当前文件所在的目录,以文件的上一层目录名为工程名
(defun project-name()
  (let ((fields)(name))
  (setq fields (split-string buffer-file-name "/"))
  (setq name (elt fields (- (length fields) 2)))
  (setq fields (split-string name "-"))
  (elt fields 0)
  ))

;;获得工程版本
(defun project-version()
  (setq fields (split-string buffer-file-name "/"))
  (setq name (elt fields (- (length fields) 2)))
  (setq fields (split-string name "-"))
  (if (> (length fields) 1)
      (setq ver (elt fields 1)))
  (if (eq (length fields) 1)
      (setq ver ""))
  ver)

;;获得DLL导出宏定义
(defun project-exports()
  (concat (upcase (project-name)) "_EXPORTS"))