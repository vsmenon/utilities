;; Chrome / Blink style
(load-file "~/utilities/elisp/google-c-style.el")
(require 'google-c-style)

(load-file "~/git/dartium/src/tools/emacs/flymake-chromium.el")
(load-file "~/git/dartium/src/tools/emacs/chrome-filetypes.el")

(add-hook 'change-log-mode-hook
	  (function (lambda () (setq indent-tabs-mode nil))))

(c-add-style "WebKit" '("Google"
			(c-basic-offset . 4)
			(c-offsets-alist . ((innamespace . 0)
					    (access-label . -)
					    (case-label . 0)
					    (member-init-intro . +)
					    (topmost-intro . 0)))))

;; For dealing with WebKit long lines and word wrapping.
(defun c-mode-adaptive-indent (beg end)
  "Set the wrap-prefix for the the region between BEG and END with adaptive filling."
  (goto-char beg)
  (while
      (let ((lbp (line-beginning-position))
	    (lep (line-end-position)))
	(put-text-property lbp lep 'wrap-prefix (concat (fill-context-prefix lbp lep) (make-string c-basic-offset ? )))
	(search-forward "\n" end t))))

(define-minor-mode c-adaptive-wrap-mode
  "Wrap the buffer text with adaptive filling for c-mode."
  :lighter ""
  (save-excursion
    (save-restriction
      (widen)
      (let ((buffer-undo-list t)
	    (inhibit-read-only t)
	    (mod (buffer-modified-p)))
	(if c-adaptive-wrap-mode
	    (jit-lock-register 'c-mode-adaptive-indent)
	  (jit-lock-unregister 'c-mode-adaptive-indent)
	  (remove-text-properties (point-min) (point-max) '(wrap-prefix pref)))
	(restore-buffer-modified-p mod)))))

(defun c-adaptive-wrap-mode-for-webkit ()
  "Turn on visual line mode and adaptive wrapping for WebKit source files."
  (if (or (string-equal "webkit" c-indentation-style)
	  (string-equal "WebKit" c-indentation-style))
      (progn
	(visual-line-mode t)
	(c-adaptive-wrap-mode t))))

(add-hook 'c-mode-common-hook 'c-adaptive-wrap-mode-for-webkit)
(add-hook 'hack-local-variables-hook 'c-adaptive-wrap-mode-for-webkit)

(defun cc-other-file()
  "Toggles source/header file"
  (interactive)
  (let ((buf (current-buffer))
	(name (file-name-sans-extension (buffer-file-name)))
	(other-extens
	 (cadr (assoc (concat "\\."
			      (file-name-extension (buffer-file-name))
			      "\\'")
		      cc-other-file-alist))))
    (dolist (e other-extens)
      (if (let ((f (concat name e)))
	    (and (file-exists-p f) (find-file f)))
	  (return)))
    )
  )

(require 'whitespace)
(setq whitespace-style '(face indentation::space trailing empty lines-tail))
(setq whitespace-line-column nil)
(set-face-attribute 'whitespace-line nil
		    :background "purple"
		    :foreground "white"
		    :weight 'bold)
(global-whitespace-mode 1)

(defun ami-summarize-indentation-at-point ()
   "Echo a summary of how one gets from the left-most column to
   POINT in terms of indentation changes."
   (interactive)
   (save-excursion
     (let ((cur-indent most-positive-fixnum)
	   (trace '()))
       (while (not (bobp))
	 (let ((current-line (buffer-substring (line-beginning-position)
					       (line-end-position))))
	   (when (and (not (string-match "^\\s-*$" current-line))
		      (< (current-indentation) cur-indent))
	     (setq cur-indent (current-indentation))
	     (setq trace (cons current-line trace))
	     (if (or (string-match "^\\s-*}" current-line)
		     (string-match "^\\s-*else " current-line)
		     (string-match "^\\s-*elif " current-line))
		 (setq cur-indent (1+ cur-indent)))))
	 (forward-line -1))
       (message "%s" (mapconcat 'identity trace "\n")))))

(require 'cl)
 (defun ami-summarize-preprocessor-branches-at-point ()
   "Summarize the C preprocessor branches needed to get to point."
   (interactive)
   (flet ((current-line-text ()
	       (buffer-substring (line-beginning-position) (line-end-position))))
     (save-excursion
       (let ((eol (or (end-of-line) (point)))
	     deactivate-mark directives-stack)
	 (goto-char (point-min))
	 (while (re-search-forward "^#\\(if\\|else\\|endif\\)" eol t)
	   (if (or (string-prefix-p "#if" (match-string 0))
		   (string-prefix-p "#else" (match-string 0)))
	       (push (current-line-text) directives-stack)
	     (if (string-prefix-p "#endif" (match-string 0))
		 (while (string-prefix-p "#else" (pop directives-stack)) t))))
	 (message "%s" (mapconcat 'identity (reverse directives-stack) "\n"))))))

 ; Turn off VC git for chrome
 (when (locate-library "vc")
 (defadvice vc-registered (around nochrome-vc-registered (file))
 (message (format "nochrome-vc-registered %s" file))
 (if (string-match ".*chrome/src.*" file)
 (progn
 (message (format "Skipping VC mode for %s" % file))
 (setq ad-return-value nil)
 )
 ad-do-it)
 )
 (ad-activate 'vc-registered)
 )

;; Dart
(require 'dart-mode)
