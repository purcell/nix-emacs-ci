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
(push '("melpa" . "https://melpa.org/packages/") package-archives)

(message "Checking we can fetch package archives")
(package-refresh-contents)
(package-initialize)

(message "Testing we can install from ELPA")
(package-install 'all)

(message "Testing we can install from MELPA")
(package-install 'unfill)
