;;;; package.lisp

(defpackage #:salt-n-pepper
  (:use #:cl)
  (:export #:code-decode))

(defpackage #:salt-n-pepper-tests
  (:use #:cl #:lisp-unit #:salt-n-pepper))

