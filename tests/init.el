(setq custom-file (make-temp-file "custom" nil ".el"))

(setq is-emacs-24+ (version<= "24" emacs-version))

;; Check we can have GNUTLS support
(when is-emacs-24+
  (unless (gnutls-available-p)
    (error "GnuTLS appears unavailable")))

(message "Testing we can talk https to GNU")
(with-temp-buffer
  (url-insert-file-contents "https://elpa.gnu.org/"))

(message "Testing we can talk https to MELPA")
(with-temp-buffer
  (url-insert-file-contents "https://melpa.org/"))

(when is-emacs-24+
  (require 'package)
  (push '("melpa" . "https://melpa.org/packages/") package-archives)

  (message "Checking we can fetch package archives")
  (package-initialize)
  (package-refresh-contents)

  (message "Testing we can install from ELPA")
  (package-install 'all)

  (message "Testing we can install from MELPA")
  (package-install 'unfill))
