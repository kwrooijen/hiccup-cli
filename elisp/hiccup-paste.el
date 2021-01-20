;;; Package --- Paste HTML as Hiccup syntax
;;; Commentary:
;;; Code:

(defun hiccup-paste--clipboard-string ()
  "Return the currency value of the clipboard as a string."
  (let ((clipboard-text (gui--selection-value-internal 'CLIPBOARD))
	(select-enable-clipboard t))
    (if (and clipboard-text (> (length clipboard-text) 0))
	(kill-new clipboard-text))
    (car kill-ring)))

(defun hiccup-paste--paste-as-hiccup ()
  "Paste the HTML in your clipboard as Hiccup syntax."
  (interactive)
  (write-region (hiccup-paste--clipboard-string) nil "~/tmp-hiccup-paste")
  (save-excursion
    (insert
     (shell-command-to-string
      "hiccup-cli --html-file ~/tmp-hiccup-paste"))))

(provide 'hiccup-paste)

;;; hiccup-paste.el ends here
