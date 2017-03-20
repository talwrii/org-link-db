;;; org-link-db.el - Support for links to manpages in Org-mode
;;; GPLv3 adapted from Carsten Dominik's org-man
;;; Commentary:
;;; Add a layer of indirection to links to avoid repeating yourself
;;; Similar to org-ref... but actually supports export (org-ref is relying on latex for format)
;;; Written in native elsips

;;; The link format is db:db-file.org:Heading1.Heading2.Heading2
;;; Where db-file.org is a file that contains a tree of headings containing
;;;   links that should be followed

(require 'org)
(require 's)
(require 'cl)



(org-add-link-type "db" 'org-ldb-open 'org-ldb-export)

(defvar org-ldb-log nil "Should we print log messages")

(defun org-ldb-log (&rest rest)
  (if org-ldb-log
      (apply 'message rest)))

(defun org-ldb-open (link)
  "Visit the manpage on PATH.
PATH should be a topic that can be thrown at the man command."
  (org-open-link-from-string (org-ldb--lookup link)))


(defun org-ldb--parse (link)
  (let (headings parts)
    (setq parts (s-split ":" link))
    (setq file (car parts))
    (setq path (cadr parts))
    (message "%S" path)
    (setq headings (s-split "\\." path))
    (list file headings)))


(defun org-ldb--node-contents (point)
  "Return the string contents of the org tree at POINT."
  (save-excursion
    (goto-char point)
    (org-back-to-heading 't)
    (buffer-substring-no-properties
     (point)
     (org-end-of-subtree))))


(defun org-ldb--lookup (link)
  "Lookup LINK in the database"
  (org-ldb-log "Looking up link for %S" link)
  (let (body heading-location)
  (destructuring-bind (file headings) (org-ldb--parse link)
    ;;; We should
    (with-temp-buffer
      (insert-file-contents file)
      (org-mode)
      (message "%S" headings)
      (setq heading-location (org-find-olp headings 't))
      (org-ldb-log "Heading %S is at %S" headings heading-location)
      (goto-char heading-location)
      (setq body (cadr (s-split-up-to "\n" (org-ldb--node-contents (point)) 1)))

      body

      ))))

(defun org-ldb--parse-org-link (link)
  (let (info details-begin details-end details)
    (with-temp-buffer
      (insert link)
      (org-mode)
      (goto-char (point-min))
      (setq info (org-element-link-parser))
      (setq details-begin (plist-get (cadr info) :contents-begin ))
      (setq details-end (plist-get (cadr info) :contents-end ))
      (setq details (buffer-substring-no-properties details-begin details-end))
      (list details info))))


(defun org-ldb-export (link-text description format)
  "Export a link"
  (org-ldb-log "Exporting: %S %S" link-text description)

  (let (formatter looked-up-link link-details link)
    (setq formatter (cdr (assq 'link (org-export-get-all-transcoders format))))
    (setq looked-up-link (org-ldb--lookup link-text))
    (setq link-details (org-ldb--parse-org-link looked-up-link))
    (setq link-description (car link-details))
    (setq link (cadr link-details))
    (org-ldb-log "Link details: %S" link)
    (funcall formatter link (or description link-description) nil)))


(provide 'org-link-db)

;;; org-man.el ends here
