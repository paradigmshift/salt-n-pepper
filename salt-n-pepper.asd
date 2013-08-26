;;;; salt-n-pepper.asd

(asdf:defsystem #:salt-n-pepper
  :serial t
  :description "RC4 encryption library"
  :author "Mozart Reina <mozart@mozartreina.com>"
  :license "FreeBSD License"
  :depends-on (#:my-tools)
  :components ((:file "package")
               (:file "salt-n-pepper")
               (:file "salt-n-pepper-tests")))

