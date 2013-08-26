;;;; salt-n-pepper.lisp

(in-package #:salt-n-pepper)

;;; "salt-n-pepper" goes here. Hacks and glory await!

;;;; usage: (code-decode [passphrase] [message])

(defun key-init (key)
  (let* ((key-char (coerce key 'list))
         (key-list (mapcar #'char-code key-char)))
    key-list))

(defun list-init ()
  (loop for i from 0 to 255
        collect i))

(defun scramble (lst key-list)
  (let ((j 0))
    (dotimes (n 255)
      (setq j (mod (+ j
                      (elt lst n)
                      (elt key-list
                           (mod n (length key-list))))
                   (length key-list)))
      (rotatef (elt lst n) (elt lst j)))
    lst))

(defun output-generator (i j s msg result)
  (setq i (mod (+ i 1) 256))
  (setq j (mod (+ j (nth i s)) 256))
  (setq s (l-swap (nth i s)
                  (nth j s) s))
  (push (boole boole-xor (mod (+ (nth i s)
                                 (nth j s))
                              256)
               (car msg)) result)
  (if (> (length msg) 1)
      (output-generator (+ 1 i)
                        (+ 1 j)
                        s
                        (subseq msg 1)
                        result)
      (reverse result)))

(defun code-decode (key txt)
  (let ((msg '())
        (result nil))
    (mapcar (lambda (x)
              (push (char-code x) msg))
            (coerce txt 'list))
    (setq result
          (output-generator 0 0 (scramble (list-init) (key-init key)) (reverse msg) '()))
    (map 'string (lambda (x)
                   (code-char x))
         result)))

