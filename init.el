;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Basic settings for quick startup and convenience
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; save history
(use-package savehist
  :init
  (savehist-mode 1)
  :custom
  (history-length 10000)
  (savehist-additional-variables
   '(kill-ring
     search-ring
     regexp-search-ring)))

;; Startup speed, annoyance suppression
(setq gc-cons-threshold 10000000)
(setq byte-compile-warnings '(not obsolete))
(setq warning-suppress-log-types '((comp) (bytecomp)))
(setq native-comp-async-report-warnings-errors 'silent)

;; Silence stupid startup message
(setq inhibit-startup-echo-area-message (user-login-name))

;; Default frame configuration: full screen, good-looking title bar on macOS
(setq frame-resize-pixelwise t)
(tool-bar-mode -1)                      ; All these tools are in the menu-bar anyway
(setq default-frame-alist '((fullscreen . maximized)
                            (ns-appearance . dark)
                            (ns-transparent-titlebar . t)))

;; turn off the welcome screen
(setopt inhibit-splash-screen t)
(setopt make-backup-files nil)
(setopt create-lockfiles nil)

(setopt initial-major-mode 'fundamental-mode)  ; default mode for the *scratch* buffer
(setopt display-time-default-load-average nil) ; this information is useless for most

;; (global-set-key (kbd "<escape>") 'keyboard-quit)  ;; escape as C-g

;; theme
(load-theme 'modus-operandi t)

;; Package initialization

(with-eval-after-load 'package
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; General appearance
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(menu-bar-mode -1)
(scroll-bar-mode -1)

(setq inhibit-startup-screen t)

(global-display-line-numbers-mode)

(column-number-mode)

(setq ring-bell-function 'ignore)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Better defaults
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq auto-save-default nil)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(save-place-mode 1)
(recentf-mode 1)

;; M-a and M-e
(setq sentence-end-double-space nil)

;; This configuration uses:
;; 
;; * `straight.el` — package manager
;; * `use-package` — organize package configuration
;; * `vertico`, `consult`, `orderless`, `marginalia` — completion framework
;; * `eglot` — language servers

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package manager
;;
;; straight.el installs packages directly from source.
;; use-package makes package configuration easier to read.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar bootstrap-version)

(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        user-emacs-directory))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)

(setq straight-use-package-by-default t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helpful keybinding hints
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package which-key
  :config
  (which-key-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Completion framework
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package vertico
  :init
  (vertico-mode))
(with-eval-after-load 'vertico
  (define-key vertico-map (kbd "DEL") #'vertico-directory-delete-char))

(use-package orderless
  :custom
  (completion-styles '(orderless basic)))

(use-package marginalia
  :init
  (marginalia-mode))

(use-package consult)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Avy - jump around
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package avy)
(require 'avy)
(global-set-key (kbd "C-c j") 'avy-goto-char-timer)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Project support
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package project)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Treesitter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package treesit-auto
  :config
  (global-treesit-auto-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LSP mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (use-package lsp-mode)
;; (require 'lsp-mode)
;; ;; Enable global lsp-mode (optional, but convenient for many languages)
;; (setq lsp-mode-hook
;;       '(lsp-enable-which-key-integration t)) ; Optional: Integrate with which-key if you use it
;; (global-lsp-mode)

;; ;; Or, enable it per-mode:
;; ;; (add-hook 'python-mode-hook #'lsp)       ; For Python
;; ;; (add-hook 'c++-mode-hook #'lsp)         ; For C++
;; ;; (add-hook 'js-mode-hook #'lsp)          ; For JavaScript
;; ;; (add-hook 'typescript-mode-hook #'lsp)  ; For TypeScript
;; ;; (add-hook 'rust-mode-hook #'lsp)        ; For Rust

;; ;; Optional: Improve UI with lsp-ui
;; (add-hook 'lsp-mode-hook #'lsp-ui-mode)

;; ;; Optional: Use company-lsp for completion
;; (add-hook 'lsp-mode-hook #'company-lsp-mode)
;; (setq company-idle-delay 0.0) ; Aggressive completion

;; ;; Other common settings
;; (setq lsp-log-io t) ; Enable logging for debugging
;; (setq lsp-enable-symbol-code-actions t)
;; (setq lsp-eldoc-render-all t)
;; (setq lsp-signature-auto-activate t)
;; (setq lsp-completion-show-detail t)
;; (setq lsp-completion-show-kind t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Git
;;
;; C-x g opens Magit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package magit)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Company completion
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package company
  :config
  (global-company-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Syntax checking
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package flymake)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Language servers
;;
;; Built into Emacs 29+
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package eglot)

(add-hook 'python-mode-hook 'eglot-ensure)
(add-hook 'ess-r-mode-hook 'eglot-ensure)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Python support
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package python-mode)

(setq python-shell-interpreter "python3")

(use-package python
  :init
  (defun python-comint-filter (output)
    "Filter out '__PYTHON_EL_' when sending region to inferior Python shell.
See also: https://stackoverflow.com/questions/75103221/emacs-remove-python-el-eval-message"
    (let* ((regexp "^.*__PYTHON_EL_\\(.*\\)\\(.*\\)[[:space:]]*$")
           (lines (split-string output "\n"))
           (filtered-lines (cl-remove-if (lambda (line)
                                           (or (string-match-p regexp line)
                                               (string-match-p "^\\s-*$" line))) 
                                         lines)))

      (if (equal (length lines) (length filtered-lines))
          output
        (mapconcat 'identity filtered-lines "\n"))))
  :hook
  (comint-preoutput-filter-functions . python-comint-filter)
  :custom
  (python-indent-guess-indent-offset-verbose nil)
  (python-shell-completion-native-enable nil))

(use-package pet
  :hook
  (python-base-mode-hook . dn/python-pet-hook)
  :init
  (defun dn/python-pet-hook ()
    "Activate pet mode, and set the local variables to identify the correct executables."
    (pet-mode)
    (setq-local pyvenv-activate (pet-virtualenv-root))
    (setq-local python-shell-interpreter (pet-executable-find "python"))
    (setq-local python-shell-interpreter-args "-i")
    (when-let ((black-executable (pet-executable-find "black")))
      (setq-local python-black-command black-executable))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Virtual environments
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package pyvenv
  :config
  (pyvenv-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Jupyter support
;;
;; Run:
;;
;; M-x jupyter-run-repl
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package jupyter)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; R support
;;
;; ESS is the gold standard for R in Emacs.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package ess)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Markdown mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package markdown-mode
  :mode ("\\.qmd\\'" . markdown-mode))

(add-hook 'markdown-mode-hook #'visual-line-mode)

(with-eval-after-load 'markdown-mode
  (set-face-attribute 'markdown-header-face-1 nil
                      :height 1.6
                      :weight 'bold)

  (set-face-attribute 'markdown-header-face-2 nil
                      :height 1.45
                      :weight 'bold)

  (set-face-attribute 'markdown-header-face-3 nil
                      :height 1.3
                      :weight 'bold)

  (set-face-attribute 'markdown-header-face-4 nil
                      :height 1.15
                      :weight 'bold))

;; max image size
(setq markdown-max-image-size '(500 . 300))

;; word count
;; (defun my/count-words-qmd ()
;;   "Count words in a Quarto buffer, excluding YAML front matter,
;; markdown tables, images, lines starting with ':', inline
;; citations (@), and everything from '# References {.unnumbered}'
;; onward. If a region is active, count only within it."
;;   (interactive)
;;   (let ((start (cond
;;                 ((use-region-p) (region-beginning))
;;                 ((save-excursion
;;                    (goto-char (point-min))
;;                    (looking-at "---"))
;;                  (save-excursion
;;                    (goto-char (point-min))
;;                    (forward-line 1)
;;                    (if (re-search-forward "^---" nil t)
;;                        (line-beginning-position 2)
;;                      (point-min))))
;;                 (t (point-min))))
;;         (end (if (use-region-p) (region-end) (point-max))))
;;     (let ((count 0)
;;           (done nil))
;;       (save-excursion
;;         (goto-char start)
;;         (while (and (not done) (< (point) end))
;;           (if (and (not (use-region-p))
;;                    (looking-at "^# References {.unnumbered}"))
;;               (setq done t)
;;             (if (looking-at (rx (or (: bol "|")
;;                                     (: bol "![")
;;                                     (: bol ":")
;;                                     (: bol "<")
;;                                     (: bol "{"))))
;;                 (forward-line 1)
;;               (let* ((line-end (min (line-beginning-position 2) end))
;;                      (line (buffer-substring-no-properties (point) line-end))
;;                      (cleaned (replace-regexp-in-string "\\[\\?@[^]]+\\]\\|@[[:alnum:]_-]+" "" line)))
;;                 (with-temp-buffer
;;                   (insert cleaned)
;;                   (setq count (+ count (count-words-region (point-min) (point-max)))))
;;                 (goto-char line-end))))))
;;       (message "Word count: %d" count))))

(defun my/count-words-qmd ()
  "Count words in a Quarto buffer, excluding YAML front matter,
markdown tables, images, lines starting with ':', inline
citations (@), everything between ':::' and ':::', and everything
from '# References {.unnumbered}' onward. If a region is active,
count only within it."
  (interactive)
  (let ((start (cond
                ((use-region-p) (region-beginning))
                ((save-excursion
                   (goto-char (point-min))
                   (looking-at "---"))
                 (save-excursion
                   (goto-char (point-min))
                   (forward-line 1)
                   (if (re-search-forward "^---" nil t)
                       (line-beginning-position 2)
                     (point-min))))
                (t (point-min))))
        (end (if (use-region-p) (region-end) (point-max))))
    (let ((count 0)
          (done nil))
      (save-excursion
        (goto-char start)
        (while (and (not done) (< (point) end))
          (cond
           ;; 1. Check for ::: block start and skip content until next :::
           ((looking-at "^:::")
            ;; Move past the opening ::: line
            (forward-line 1)
            (let ((next-triple-colon (re-search-forward "^:::" end t)))
              (if next-triple-colon
                  ;; Found closing :::, move past its line
                  (goto-char (line-end-position))
                ;; No closing ::: found in region, skip till end of region
                (setq done t))))

           ((looking-at "^\$\$")
            ;; Move past the opening $$ line
            (forward-line 1)
            (let ((double-money (re-search-forward "^\$\$" end t)))
              (if double-money
                  ;; Found closing $$, move past its line
                  (goto-char (line-end-position))
                ;; No closing $$ found in region, skip till end of region
                (setq done t))))

           ;; 2. Check for # References {.unnumbered} and stop
           ((and (not (use-region-p))
                 (looking-at "^# References {.unnumbered}"))
            (setq done t))

           ;; 3. Check for other line-start exclusions (tables, images, generic :, html/divs)
           ((looking-at (rx (or (: bol "|")
                                (: bol "![")
                                (: bol ":")
                                (: bol "<")
                                (: bol "{"))))
            (forward-line 1))

           ;; 4. If none of the above, process the line for word count
           (t
            (let* ((line-end (min (line-beginning-position 2) end))
                   (line (buffer-substring-no-properties (point) line-end))
                   ;; Remove inline citations like [@author2020] or @author2020
                   (cleaned (replace-regexp-in-string "\\[\\?@[^]]+\\]\\|@[[:alnum:]_-]+" "" line)))
              (with-temp-buffer
                (insert cleaned)
                (setq count (+ count (count-words-region (point-min) (point-max)))))
              (goto-char line-end))))))
      (message "Word count: %d" count))))

(global-set-key (kbd "C-c w") #'my/count-words-qmd)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Polymode
;;
;; Provides proper editing of code chunks inside qmd files.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package polymode)

(use-package poly-markdown)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; YAML support
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package yaml-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; JSON support
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package json-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Citations
;;
;; Works beautifully with BetterBibTeX + Zotero.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package citar
  :custom
  (citar-bibliography
   '("~/references/references.bib")))

(defun my/qmd-bibliography ()
  "Extract bibliography paths from Quarto YAML front matter."
  (save-excursion
    (goto-char (point-min))
    (when (re-search-forward "^bibliography:[ \t]*\\(.*\\)$" nil t)
      (let ((raw (match-string 1)))
        (split-string raw "[, ]+" t)))))
(defun my/setup-citar-from-qmd-yaml ()
  "Set `citar-bibliography` from QMD YAML front matter."
  (when (and buffer-file-name
             (string-match-p "\\.qmd\\'" buffer-file-name))
    (setq-local citar-bibliography (my/qmd-bibliography))))
(add-hook 'find-file-hook #'my/setup-citar-from-qmd-yaml)
(add-hook 'after-save-hook #'my/setup-citar-from-qmd-yaml)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Insert citations with C-c ]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'markdown-mode
  (define-key markdown-mode-map
              (kbd "C-c ]")
              #'citar-insert-citation))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Optional notes directory
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq citar-library-paths
      '("~/papers"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; BibTeX mode improvements
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package bibtex)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LaTeX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package auctex)

(setq TeX-auto-save t)
(setq TeX-parse-self t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PDF viewing
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package pdf-tools
  :config
  (pdf-tools-install))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Snippets
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package yasnippet
  :config
  (yas-global-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Spell checking
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq ispell-program-name "aspell")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Terminal inside Emacs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package vterm)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; File tree
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package treemacs)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Multiple cursors
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package multiple-cursors)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Recent files
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(global-set-key
 (kbd "C-x C-r")
 #'consult-recent-file)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Better searching
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (global-set-key
;;  (kbd "C-s")
;;  #'consult-line)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ripgrep project search
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(global-set-key
 (kbd "C-c g")
 #'consult-ripgrep)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Useful shortcuts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(global-set-key
 (kbd "C-x g")
 #'magit-status)

(global-set-key
 (kbd "C-c c")
 #'compile)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org mode
;;
;; Useful for notes and project planning.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package org)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Optional AI coding support
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package gptel
  :config
  ;; Create the Gemini backend, reading the key from authinfo
  (setq gptel-backend
        (gptel-make-gemini "Gemini"
          :key #'gptel-api-key-from-auth-source
          :stream t)))

;; Set default model
(setq gptel-model 'gemini-2.5-flash)
(setq gptel-default-mode 'org-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start server
;;
;; Allows emacsclient to reuse sessions.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(server-start)

;; TODO
(use-package hl-todo
  :custom
  (hl-todo-keyword-faces
   '(("TODO"  . (:foreground "black" :background "#7FDBFF" :weight bold))
     ("FIXME" . (:foreground "black" :background "#ff6666" :weight bold))
     ("NOTE"  . (:foreground "black" :background "#66ff66" :weight bold))
     ("HACK"  . (:foreground "black" :background "#cc66ff" :weight bold))))
  :config
  (global-hl-todo-mode))

(global-set-key (kbd "C-c t n") 'hl-todo-next)
(global-set-key (kbd "C-c t p") 'hl-todo-previous)

;; Quarto
;; https://gist.github.com/fast-90/3d7ce3252fff59b0f6d6d1bcadcf4938
(use-package quarto-mode
  :bind (:map poly-quarto-mode-map
              ("C-c q p" . quarto-preview)))

;; Math preview
(use-package math-preview)
;; (add-hook 'markdown-mode-hook
;;           (lambda ()
;;             (when (and buffer-file-name
;;                        (string-match-p "\\.qmd\\'" buffer-file-name))
;;               (math-preview-all))))

;; Shows changed lines in the fringe:
(use-package diff-hl
  :config
  (global-diff-hl-mode))

;; formats on save
(use-package apheleia
  :config
  (apheleia-global-mode +1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Smartparens
;;
;; Automatically inserts matching delimiters and
;; makes editing parentheses easier.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package smartparens
  :config
  (require 'smartparens-config)
  (smartparens-global-mode 1)
  (show-smartparens-global-mode 1))

;; Markdown face definitions
(defface my-markdown-citation-face
  '((t (:foreground "#F54927"
                    :weight bold)))
  "Face used for Pandoc citations.")
(font-lock-add-keywords
 'markdown-mode
 '(("\\(\\[@[^]]+\\]\\)"
    1 'my-markdown-citation-face t)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; minimap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package minimap
  :config
  ;; Fix for Quarto / Polymode buffers:
  ;; Force the minimap to always track the base (parent) buffer
  (advice-add 'minimap-get-buffer :around
              (lambda (orig-fun &rest args)
                (let ((buf (apply orig-fun args)))
                  (if (and buf (buffer-base-buffer buf))
                      (buffer-base-buffer buf)
                    buf)))))
(setq minimap-window-location 'right) ; Put it on the right side
(setq minimap-update-delay 0.05)      ; Make scrolling responsive
(setq minimap-width-fraction 0.15)    ; Take up 15% of the window width
(with-eval-after-load 'minimap
  (add-to-list 'minimap-major-modes 'markdown-mode))

;; ## External software you'll want installed
;; 
;; ### Python
;; 
;; ```bash
;; pip install jupyter jupyterlab python-lsp-server
;; ```
;; 
;; ### R
;; 
;; ```r
;; install.packages(c(
;;   "languageserver",
;;   "tidyverse"
;; ))
;; ```
;; 
;; ### Quarto
;; 
;; ```bash
;; sudo apt install quarto
;; ```
;; 
;; ### Ripgrep
;; 
;; ```bash
;; sudo apt install ripgrep
;; ```
;; 
;; ### Aspell
;; 
;; ```bash
;; sudo apt install aspell
;; ```
;; 
;; ### BetterBibTeX
;; 
;; Use Zotero with BetterBibTeX and continuously export:
;; 
;; ```text
;; references.bib
;; ```
;; 
;; 
;; **Python REPL**
;; 
;; ```
;; M-x run-python
;; ```
;; 
;; ---
;; 
;; **Jupyter kernel**
;; 
;; ```
;; M-x jupyter-run-repl
;; ```
;; 
;; ---
;; 
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("e14289199861a5db890065fdc5f3d3c22c5bac607e0dbce7f35ce60e6b55fc52" "dd4582661a1c6b865a33b89312c97a13a3885dc95992e2e5fc57456b4c545176" "aec7b55f2a13307a55517fdf08438863d694550565dee23181d2ebd973ebd6b8" "9e5e0ff3a81344c9b1e6bfc9b3dcf9b96d5ec6a60d8de6d4c762ee9e2121dfb2" "d481904809c509641a1a1f1b1eb80b94c58c210145effc2631c1a7f2e4a2fdf4" "3613617b9953c22fe46ef2b593a2e5bc79ef3cc88770602e7e569bbd71de113b" "0325a6b5eea7e5febae709dab35ec8648908af12cf2d2b569bedc8da0a3a81c1" "720838034f1dd3b3da66f6bd4d053ee67c93a747b219d1c546c41c4e425daf93" "e184d8607cc9933f2ba8e180699365bdf8b6f311834a9e15c71947b38be0caa3" default)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
