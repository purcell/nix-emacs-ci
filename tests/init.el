;; Check we can have GNUTLS support
(unless (gnutls-available-p)
 (error "GnuTLS appears unavailable"))

(message "Testing we can talk https to GNU")
(with-temp-buffer
 (url-insert-file-contents "https://elpa.gnu.org/"))

(message "Testing we can talk https to MELPA")
(with-temp-buffer
 (url-insert-file-contents "http://melpa.org/"))
