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

(defun hiccup-cli--insert ()
  "docstring"
  (save-excursion
    (insert
     (shell-command-to-string
      "hiccup-cli --html-file /tmp/hiccup-cli"))))

(defun hiccup-cli--paste-as-hiccup ()
  "Paste the HTML in your clipboard as Hiccup syntax."
  (interactive)
  (write-region (hiccup-cli--clipboard-string) nil "/tmp/hiccup-cli")
  (hiccup-cli--insert))

(defun hiccup-cli--region-as-hiccup (start end)
  "Replace the HTML in your selected region with Hiccup syntax."
  (interactive "r")
  (if (use-region-p)
      (let ((region-str (buffer-substring start end)))
        (kill-region start end)
        (write-region region-str nil "/tmp/hiccup-cli")
        (hiccup-cli--insert))))


(defun hiccup-cli--yank-as-hiccup (start end)
  "Paste the HTML in your kill-ring as Hiccup syntax."
  (interactive "r")
  (write-region (substring-no-properties (car kill-ring)) nil "/tmp/hiccup-cli")
  (hiccup-cli--insert))

(provide 'hiccup-cli)

;;; hiccup-cli.el ends here
