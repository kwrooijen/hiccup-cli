;;; hiccup-cli.el --- Convert HTML to Hiccup syntax -*- lexical-binding: t; -*-

;; Copyright (C) 2021  Kevin W. van Rooijen
;;
;; Author: Kevin W. van Rooijen
;; URL: https://github.com/kwrooijen/hiccup-cli

;; Version  : 0.1.0
;; Keywords: tools
;; Package-Requires: ((emacs "25.1"))


;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; Available functions:
;;
;; hiccup-cli--paste-as-hiccup
;; hiccup-cli--region-as-hiccup
;; hiccup-cli--yank-as-hiccup

;;; Code:

(defgroup hiccup-cli nil
  "Hiccup-cli group."
  :prefix "hiccup-cli-"
  :group 'tools)

(defcustom hiccup-cli-custom-path-to-bin
  (or (executable-find "hiccup-cli")
      "hiccup-cli")
  "Custom path to the hiccup-cli executable."
  :type 'file
  :group 'hiccup-cli)

(defcustom hiccup-cli-custom-path-to-tmp-file
  "/tmp/hiccup-cli"
  "Custom path to the hiccup-cli tmp file."
  :type 'file
  :group 'hiccup-cli)

(defun hiccup-cli--clipboard-string ()
  "Return the currency value of the clipboard as a string."
  (let ((clipboard-text (gui--selection-value-internal 'CLIPBOARD))
	(select-enable-clipboard t))
    (if (and clipboard-text (> (length clipboard-text) 0))
	(kill-new clipboard-text))
    (car kill-ring)))

(defun hiccup-cli--write-to-tmp-file (string)
  "Write STRING to `hiccup-cli--custom-path-to-tmp-file`."
  (write-region string nil hiccup-cli-custom-path-to-tmp-file))

(defun hiccup-cli--insert ()
  "Insert converted Hiccup from `hiccup-cli--custom-path-to-tmp-file` into buffer."
  (save-excursion
    (insert
     (shell-command-to-string
      (format "%s --html-file %s"
              hiccup-cli-custom-path-to-bin
              hiccup-cli-custom-path-to-tmp-file)))))

;;;###autoload
(defun hiccup-cli-paste-as-hiccup ()
  "Paste the HTML in your clipboard as Hiccup syntax."
  (interactive)
  (hiccup-cli--write-to-tmp-file (hiccup-cli--clipboard-string))
  (hiccup-cli--insert))

;;;###autoload
(defun hiccup-cli-region-as-hiccup (start end)
  "Replace the HTML in your selected START END region with Hiccup syntax."
  (interactive "r")
  (if (use-region-p)
      (let ((region-str (buffer-substring start end)))
        (kill-region start end)
        (hiccup-cli--write-to-tmp-file region-str)
        (hiccup-cli--insert))))

;;;###autoload
(defun hiccup-cli-yank-as-hiccup ()
  "Paste the HTML in your `kill-ring` as Hiccup syntax."
  (interactive)
  (hiccup-cli--write-to-tmp-file (substring-no-properties (car kill-ring)))
  (hiccup-cli--insert))

(provide 'hiccup-cli)

;;; hiccup-cli.el ends here
