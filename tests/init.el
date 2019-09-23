(setq custom-file (make-temp-file "custom" nil ".el"))

;; Check we can have GNUTLS support
(unless (gnutls-available-p)
  (error "GnuTLS appears unavailable"))

(message "Testing we can talk https to GNU")
(with-temp-buffer
  (url-insert-file-contents "https://elpa.gnu.org/"))

(message "Testing we can talk https to MELPA")
(with-temp-buffer
  (url-insert-file-contents "https://melpa.org/"))

(require 'package)
(setq package-check-signature nil) ;; Don't rely on having gpg available
(push '("melpa" . "https://melpa.org/packages/") package-archives)

(message "Checking we can fetch package archives")
(package-initialize)
(package-refresh-contents)

(message "Testing we can install from ELPA")
(package-install 'all)

(message "Testing we can install from MELPA")
(package-install 'unfill)
