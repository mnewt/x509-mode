;; This buffer is for text that is not saved, and for Lisp evaluation.
;; To create a file, visit it with C-x C-f and enter text in its buffer.

(defun x509--process-buffer2(openssl-arguments)
  "Create new buffer named \"*x-[buffer-name]*\" and pass content of
current buffer to openssl with OPENSSL-ARGUMENTS. E.g. x509 -text"
  (interactive)
  (let* ((src-file-name (buffer-file-name))
         (buf (generate-new-buffer (generate-new-buffer-name
                                    (format "*x-%s*" (buffer-name)))))
         (args (append
                    openssl-arguments
                    (list "-in" src-file-name)))
         (process-args (append
                        (list x509-openssl-cmd nil t nil)
                        args)))
    (switch-to-buffer buf)
    (message "Calling %s" process-args)
    (apply 'call-process process-args)
    (x509-mode)
    (setq-local source-file-name src-file-name)
    (setq-local x509-args args)
    (message "sfn:%s" source-file-name)
    (message "args:%s" x509-args)
    (message "%s" (local-variable-p 'source-file-name buf))
    (message "%s" (local-variable-p 'arguments buf))
    (goto-char (point-min))
    ))

(defun x509-refresh-buffer(&optional edit)
  (interactive "P")
  (let* ((args (or (and edit (split-string-and-unquote
                              (read-from-minibuffer
                               "openssl args: "
                               (combine-and-quote-strings x509-args)
                               nil nil 'x509--viewcert-history)))
                   x509-args))
         (process-args (append (list x509-openssl-cmd nil t nil)
                               args)))
    (erase-buffer)
    (apply 'call-process process-args)
    (goto-char (point-min))
    (setq-local x509-args args)))
  



;;;###autoload
(defun x509-viewcert2 (&optional args)
  "Parse current buffer as a certificate file.
Display result in another buffer.

With \\[universal-argument] prefix, you can edit the command arguements."
  (interactive (x509--read-arguments
                "x509 args: "
                (format "x509 -nameopt utf8 -text -noout -inform %s"
                        (x509--buffer-encoding))
                'x509--viewcert-history))
  (x509--process-buffer2 (split-string-and-unquote args)))
