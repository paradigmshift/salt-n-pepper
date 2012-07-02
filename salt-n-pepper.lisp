;;;; usage: (code-decode [passphrase] [message])

(defun switch (a b lst)
  "Switch elements at position a & b with each other"
  (let ((newlst (copy-list lst)))
    (psetf (nth a newlst) (nth b newlst)
           (nth b newlst) (nth a newlst))
    newlst))

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
                      (nth n lst)
                      (nth (mod n (length key-list))
                           key-list))
                   (length key-list)))
      (setq lst (switch n j lst)))
    lst))

(defun output-generator (i j s msg result)
  (setq i (mod (+ i 1) 256))
  (setq j (mod (+ j (nth i s)) 256))
  (setq s (switch (nth i s)
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
    (mapcar (lambda (x)
              (format t "~a" (code-char x)))
            result)))
