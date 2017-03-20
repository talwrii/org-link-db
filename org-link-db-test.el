(message (org-version))

(require 'org-link-db)

(setq org-ldb-log 't)
;(setq debug-on-error 't)


(progn
  (with-current-buffer (find-file "testdata/exported.org")
    (org-html-export-as-html)
    (with-current-buffer "*Org HTML Export*"
      (message "%S" (buffer-string)))))
