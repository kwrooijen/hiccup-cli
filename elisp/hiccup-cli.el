;;; Package --- Paste HTML as Hiccup syntax
;;; Commentary:
;;; Code:

(defun hiccup-cli--clipboard-string ()
  "Return the currency value of the clipboard as a string."
  (let ((clipboard-text (gui--selection-value-internal 'CLIPBOARD))
	(select-enable-clipboard t))
    (if (and clipboard-text (> (length clipboard-text) 0))
	(kill-new clipboard-text))
    (car kill-ring)))

(defun hiccup-cli--paste-as-hiccup ()
  "Paste the HTML in your clipboard as Hiccup syntax."
  (interactive)
  (write-region (hiccup-cli--clipboard-string) nil "~/tmp-hiccup-cli")
  (save-excursion
    (insert
     (shell-command-to-string
      "hiccup-cli --html-file ~/tmp-hiccup-cli"))))

(provide 'hiccup-cli)

;;; hiccup-cli.el ends here
