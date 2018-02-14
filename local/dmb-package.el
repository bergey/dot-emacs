(require 'package)

(package-initialize)

(eval-when-compile (require 'use-package))

(setq use-package-verbose t)

(use-package auto-compile
  :config (auto-compile-on-load-mode))

(defmacro measure-time  (name &rest body)
  "Measure the time it takes to evaluate BODY."
  `(let ((time (current-time)))
     ,@body
     (let ((dt (float-time (time-since time))))
       (if (>= dt 0.1)
           (message "%.06f in %s" dt ,name)))))

(defun time-package (pkg)
  "Measure the time it takes to require PKG"
  (measure-time pkg (require pkg)))

(defun time-packages (pkgs)
  (dolist (p pkgs)
    (time-package p)))

(defmacro with-library (symbol &rest body)
      `(condition-case nil
           (progn
             (require ,symbol)
             ,@body)
         (error  "I guess we don't have %s available." ,symbol)))
(put 'with-library 'lisp-indent-function 1)

(provide 'dmb-package)
