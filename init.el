(require 'auth-source)
(setq auth-sources '("~/.authinfo.gpg"))

;; Set your default GPG key ID for all EasyPG / EPA operations
(setq epa-file-encrypt-to '("D377615D1BC24A0D"))  ; Replace with your key ID
;; Avoid getting prompted all the time for the password to your plstore
(setq plstore-cache-passphrase-for-symmetric-encryption t)
;; Disable key selection prompting completely
(setq epa-file-select-keys nil)
;; Ensure plstore also uses non-interactive key selection
(with-eval-after-load 'plstore
  (setq plstore-select-keys nil
        plstore-encrypt-to "D377615D1BC24A0D"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   Basic settings for quick startup and convenience
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
(setopt use-short-answers t) ; answer with y or n
(setopt initial-major-mode 'fundamental-mode)  ; default mode for the *scratch* buffer
(setopt display-time-default-load-average nil) ; this information is useless for most

;; theme
;; (load-theme 'modus-operandi t)
(load-theme 'modus-vivendi t)

;; Package initialization
(with-eval-after-load 'package
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; General appearance
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(menu-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-screen t)
(setq-default
 display-line-numbers-type 'relative)
(global-display-line-numbers-mode)
(add-hook 'pdf-view-mode-hook
          (lambda () (setq-local display-line-numbers nil)))
(add-hook 'org-timegrid-mode-hook
          (lambda () (display-line-numbers-mode -1)))
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

;; Replace list-buffers with ibuffer
(global-set-key [remap list-buffers] 'ibuffer)

;; Better other window
(global-set-key (kbd "M-o") 'other-window)

;; Tramp/Dired copy/paste DWIM
(setq dired-dwim-target t)

;; delete to trash, undo limit, kill ring max
(setq delete-by-moving-to-trash t
      undo-limit 80000000
      kill-ring-max 200)

;; Calendar
(with-eval-after-load 'holidays
  ;; BC statutory holidays
  (setq holiday-local-holidays
        '((holiday-fixed 1 1 "New Year's Day")
          (holiday-float 2 1 3 "Family Day")             ; 3rd Monday in Feb
          (holiday-float 5 1 -1 "Victoria Day" 24)       ; Monday before May 25
          (holiday-fixed 7 1 "Canada Day")
          (holiday-float 8 1 1 "BC Day")                 ; 1st Monday in Aug
          (holiday-float 9 1 1 "Labour Day")             ; 1st Monday in Sept
          (holiday-fixed 9 30 "National Day for Truth and Reconciliation")
          (holiday-float 10 1 2 "Thanksgiving")          ; 2nd Monday in Oct
          (holiday-fixed 11 11 "Remembrance Day")
          (holiday-fixed 12 25 "Christmas Day")))
  ;; Only show BC holidays plus Easter/Good Friday (Christian list).
  ;; This replaces the default US, Hebrew, Islamic, etc. lists.
  (setq calendar-holidays
        (append holiday-local-holidays
                holiday-christian-holidays)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package manager
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
;; Whole line or region (better C-w)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package whole-line-or-region)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Completion framework
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; * `vertico`, `consult`, `orderless`, `marginalia` — completion framework
;; Vertico: the vertical completion UI 
;; Orderless: flexible space-separated matching
;; Marginalia: annotations next to candidates
;; Consult: 
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
;; save history
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package savehist
  :init
  (savehist-mode 1)
  :custom
  (history-length 10000)
  (savehist-additional-variables
   '(kill-ring
     search-ring
     regexp-search-ring)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helpful keybinding hints
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq which-key-idle-delay 0.01)

(use-package which-key
  :config
  (which-key-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Rainbow delimiters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; God mode
;; g is Meta
;; . is repeat
;; The literal key (SPC) is sticky.
;; This means you don't have to enter SPC repeatedly for key bindings such as C-x r t.
;; Entering the literal key again toggles its state.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (setq god-mode-enable-function-key-translation nil) ;; function keys remain function keys
;; (use-package god-mode)
;; (god-mode) ;; activate god mode
;; (global-set-key (kbd "<escape>") #'god-local-mode)
;; (custom-set-faces
;;  '(god-mode-lighter ((t (:inherit error)))))
;; (defun my-god-mode-update-cursor-type ()
;;   (setq cursor-type (if (or god-local-mode buffer-read-only) 'box 'bar)))
;; (add-hook 'post-command-hook #'my-god-mode-update-cursor-type)
;; (define-key god-local-mode-map (kbd ".") #'repeat)
;; (define-key god-local-mode-map (kbd "i") #'god-local-mode)
;; (global-set-key (kbd "<escape>") #'(lambda () (interactive) (god-local-mode 1)))
;; (which-key-enable-god-mode-support)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Hydra
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package hydra)

;; Outline 
(defhydra hydra-outline (:color pink :hint nil)
  "
^Navigate^              ^Visibility^           ^Structure^
^^^^^^^^----------------------------------------------------------------
_n_: next heading       _TAB_: cycle           _h_: promote
_p_: prev heading       _a_: show all          _l_: demote
_f_: forward same lvl   _s_: show subtree      _k_: move up
_b_: backward same lvl  _S_: hide subtree      _j_: move down
_u_: up heading         _d_: hide body         _/_: insert heading
^ ^                     _q_: hide leaves
^^^^^^^^----------------------------------------------------------------
_<ESC>_: quit
"
  ;; Navigate
  ("n" outline-next-visible-heading)
  ("p" outline-previous-visible-heading)
  ("f" outline-forward-same-level)
  ("b" outline-backward-same-level)
  ("u" outline-up-heading)

  ;; Visibility
  ("TAB" outline-toggle-children)
  ("a" outline-show-all)
  ("s" outline-show-subtree)
  ("S" outline-hide-subtree)
  ("d" outline-hide-body)
  ("q" outline-hide-leaves)

  ;; Structure
  ("h" outline-promote)
  ("l" outline-demote)
  ("k" outline-move-subtree-up)
  ("j" outline-move-subtree-down)
  ("/" outline-insert-heading)

  ("<ESC>" nil :exit t))

;; Bind the hydra — pick whichever key you prefer
(global-set-key (kbd "C-c o") 'hydra-outline/body)

;; Window Management
(winner-mode 1)

(defun ace-maximize-window ()
  "Toggle between maximizing the current window and restoring previous layout."
  (interactive)
  (if (one-window-p)
      (winner-undo)
    (delete-other-windows)))

(defun hydra-move-splitter-left (arg)
  (interactive "p")
  (if (window-in-direction 'right)
      (enlarge-window-horizontally (- arg))
    (enlarge-window-horizontally arg)))

(defun hydra-move-splitter-down (arg)
  (interactive "p")
  (if (window-in-direction 'up)
      (enlarge-window arg)
    (shrink-window arg)))

(defun hydra-move-splitter-up (arg)
  (interactive "p")
  (if (window-in-direction 'down)
      (enlarge-window arg)
    (shrink-window arg)))

(defun hydra-move-splitter-right (arg)
  (interactive "p")
  (if (window-in-direction 'right)
      (enlarge-window-horizontally arg)
    (enlarge-window-horizontally (- arg))))

(defhydra hydra-window ()
  "
Movement^^        ^Split^         ^Switch^		^Resize^
----------------------------------------------------------------
_h_ ←       	_\\_ vertical    _b_uffer		_H_ X←
_j_ ↓        	_-_ horizontal	_f_ind files	_J_ X↓
_k_ ↑        	_z_ undo      	_a_ce 1		_K_ X↑
_l_ →        	_Z_ reset      	_s_wap		_L_ X→
_F_ollow		_D_lt Other   	_S_ave		max_i_mize
_SPC_ cancel	_o_nly this   	_d_elete	
"
  ("h" windmove-left )
  ("j" windmove-down )
  ("k" windmove-up )
  ("l" windmove-right )
  ("H" hydra-move-splitter-left)
  ("J" hydra-move-splitter-down)
  ("K" hydra-move-splitter-up)
  ("L" hydra-move-splitter-right)
  ("b" switch-to-buffer)     ;; Replaced helm-mini with built-in
  ("f" find-file)            ;; Replaced helm-find-files with built-in
  ("F" follow-mode)
  ("a" (lambda ()
         (interactive)
         (ace-window 1)
         (add-hook 'ace-window-end-once-hook
                   'hydra-window/body))
   )
  ("\\" (lambda ()
          (interactive)
          (split-window-right)
          (windmove-right))
   )
  ("-" (lambda ()
         (interactive)
         (split-window-below)
         (windmove-down))
   )
  ("s" (lambda ()
         (interactive)
         (ace-window 4)
         (add-hook 'ace-window-end-once-hook
                   'hydra-window/body)))
  ("S" save-buffer)
  ("d" delete-window)
  ("D" (lambda ()
         (interactive)
         (ace-window 16)
         (add-hook 'ace-window-end-once-hook
                   'hydra-window/body))
   )
  ("o" delete-other-windows)
  ("i" ace-maximize-window)
  ("z" (progn
         (winner-undo)
         (setq this-command 'winner-undo))
   )
  ("Z" winner-redo)
  ("SPC" nil)
  )

(global-set-key (kbd "C-c b") 'hydra-window/body)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Avy - jump around text
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package avy)
(require 'avy)
(global-set-key (kbd "C-c j") 'avy-goto-char-timer)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Avy-zap - zap to jump
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package avy-zap)
(global-set-key (kbd "M-Z") 'avy-zap-up-to-char-dwim)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Project support
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Detects the "current project," usually by finding a version-control root (a .git directory, for example)
;; Provides commands scoped to that project, all under the C-x p prefix:
;; C-x p f: find file in project
;; C-x p g: grep (ripgrep/grep) in project
;; C-x p b: switch to a project buffer
;; C-x p p: switch to another project
;; C-x p d: open Dired at the project root
;; C-x p k: kill all project buffers
;; C-x p ! / C-x p &: run a shell command at the project root

(use-package project)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Treesitter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package treesit-auto
  :config
  (global-treesit-auto-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start server
;; Allows emacsclient to reuse sessions.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(server-start)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Shows changed lines in the fringe:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package diff-hl
  :config
  (global-diff-hl-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; formats on save
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package apheleia
  :config
  (apheleia-global-mode +1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Git
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package magit)
(global-set-key
 (kbd "C-x g")
 #'magit-status)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Company completion
;; in buffer completion
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
(use-package ghostel)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; File tree
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package treemacs)
(global-set-key (kbd "C-c e") #'treemacs)

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
;; Org mode
;;
;; Useful for notes and project planning.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package org)

(setq org-directory
      (expand-file-name "~/Dropbox/AssistantProf_BCCHRI/Zotero_Obsidian/Obsidian/org/"))

(setq org-agenda-files
      (mapcar (lambda (file) (expand-file-name file org-directory))
              '("inbox.org" "todo.org" "schedule.org"
                "caloutlook.org" "weberlab.org" "family.org" "gcal.org")))

;; Global entry points Doom gave you under SPC o a / SPC X
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)
(global-set-key (kbd "C-c l") #'org-store-link)
;; Your GTD agenda uses NEXT, so uncomment/adjust if you rely on it globally:
;; (setq org-todo-keywords
;;       '((sequence "TODO(t)" "NEXT(n)" "WAIT(w)" "|" "DONE(d)" "KILL(k)")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org-roam (+ UI) -- keys live under C-c r because C-c n
;; is already your "no new students" snippet.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package org-roam
  :custom
  (org-roam-directory
   (expand-file-name "~/Dropbox/AssistantProf_BCCHRI/Zotero_Obsidian/Obsidian/org/roam/"))
  :bind (("C-c r f" . org-roam-node-find)
         ("C-c r i" . org-roam-node-insert)
         ("C-c r l" . org-roam-buffer-toggle)
         ("C-c r c" . org-roam-capture))
  :config
  (org-roam-db-autosync-mode))

(use-package websocket
  :after org-roam)

(use-package org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org attachments / images
;;
;; Timestamp-based attachment folders instead of random IDs.
;; org-attach ships with Org, so no use-package/straight here.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(with-eval-after-load 'org-attach
  (setq org-attach-auto-tag nil
        org-attach-store-link-p 'file
        org-attach-id-to-path-function-list
        '(org-attach-id-ts-folder-format
          org-attach-id-uuid-folder-format
          org-attach-id-fallback-folder-format)))

(use-package org-download
  :after org
  :config
  ;; Doom sets this to 'attach so pasted images go through org-attach.
  (setq org-download-method 'attach
        org-download-image-org-width 450))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org capture (Inbox, Schedule, and mu4e email workflow)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq org-capture-templates
      '(("i" "Inbox" entry
         (file "inbox.org")
         "* TODO %?\n/Entered on/ %U")
        
        ("s" "Schedule Meeting" entry
         (file+headline "agenda.org" "Future")
         "* %? :meeting:\n<%<%Y-%m-%d %a %H:00>>")
        
        ("m" "Email Workflow")
        ("md" "Inbox Todo w Deadline" entry
         (file+headline "todo.org" "Inbox")
         "* TODO %:subject\n%:fromname due %a\nDEADLINE: %^t\n\n%i"
         :immediate-finish t
         :prepend t)
        ("mt" "Inbox Todo w Schedule" entry
         (file+headline "todo.org" "Inbox")
         "* TODO %:subject\n%:fromname entered on %a\nSCHEDULED:%t\n\n%i"
         :immediate-finish t
         :prepend t)

        ("t" "Todo")
        ("td" "Todo w Deadline" entry
         (file+headline "todo.org" "Inbox")
         "* TODO %?\nDue by DEADLINE: %^t\n%i"
         :prepend t)
        ("tt" "Todo w Schedule" entry
         (file+headline "todo.org" "Inbox")
         "* TODO %?\nEntered on %a\nSCHEDULED:%t\n%i"
         :prepend t)

        ;; Google Calendar Sub-Menu (Time Ranges via %^T)
        ;;   (setq org-capture-templates
        ;; `(("a" "Appointment" entry (file ,(concat org-directory "/gcal.org"))
        ;;   "* %?\n:PROPERTIES:\n:calendar-id:\tFirst.Last@gmail.com\n:END:\n:org-gcal:\n%^T--%^T\n:END:\n\n" :jump-to-captured t)))
        ("c" "Calendar")
        ("cg" "Primary Google Calendar" entry
         (file "~/Dropbox/AssistantProf_BCCHRI/Zotero_Obsidian/Obsidian/org/gcal.org")
         "* %? :Primary:\n")
        ("cf" "Family Calendar" entry
         (file "~/Dropbox/AssistantProf_BCCHRI/Zotero_Obsidian/Obsidian/org/family.org")
         "* %? :Family:\n")
        ("cw" "WeberLab Calendar" entry
         (file "~/Dropbox/AssistantProf_BCCHRI/Zotero_Obsidian/Obsidian/org/weberlab.org")
         "* %? :WeberLab:\n")))

(defun org-capture-inbox ()
  "Store a link to the current thing, then capture to the inbox."
  (interactive)
  (call-interactively 'org-store-link)
  (org-capture nil "i"))

(global-set-key (kbd "C-c i") #'org-capture-inbox)

;; delete frame when done
(add-hook 'org-capture-after-finalize-hook
          (lambda ()
            (when (equal (frame-parameter nil 'name) "org-capture")
              (delete-frame))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Sync org and gcal
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; if you need to force a reset:
;; (progn
;; (setq org-gcal--sync-tokens nil)
;; (org-gcal-fetch))
(use-package org-gcal
  :ensure t
  :init
  (let* ((auth (car (auth-source-search :max 1
                                        :host "google-calendar"
                                        :require '(:user :secret))))
         (client-id (and auth (or (plist-get auth :user) (plist-get auth :login))))
         (client-secret (and auth (auth-info-password auth))))
    (if (and client-id client-secret)
        (setq org-gcal-client-id client-id
              org-gcal-client-secret client-secret)
      (message "Warning: Could not load google-calendar credentials from auth-source!")))
  :config
  (setq org-gcal-file-alist
        '(("9cb3fa6ea68155398c47cb0d3bcc75a325bbb754adbe80d3b8dbf62970a5323f@group.calendar.google.com" . "~/Dropbox/AssistantProf_BCCHRI/Zotero_Obsidian/Obsidian/org/family.org")
          ("weberam2@gmail.com" . "~/Dropbox/AssistantProf_BCCHRI/Zotero_Obsidian/Obsidian/org/gcal.org")
          ("sns1ipmdf7kklu77b3q9ibg0nk@group.calendar.google.com" . "~/Dropbox/AssistantProf_BCCHRI/Zotero_Obsidian/Obsidian/org/weberlab.org")))
  (defun my-org-gcal-set-calendar-tags (calendar-id &optional _event _update-mode)
    "Automatically add tags to headlines based on CALENDAR-ID or headline property."
    (let* ((cal-id (or calendar-id (org-entry-get (point) "calendar-id") ""))
           (tag (cond
                 ((string-match-p "9cb3f" cal-id) "Family")
                 ((string-match-p "sns1i" cal-id) "WeberLab")
                 ((string-match-p "weberam2@gmail\\.com" cal-id) "Primary")
                 (t nil))))
      (when tag
        (let ((current-tags (org-get-tags nil t)))
          (unless (member tag current-tags)
            (org-set-tags (cons tag current-tags)))))))

  ;; Attach to org-gcal hook
  (add-hook 'org-gcal-after-update-entry-functions #'my-org-gcal-set-calendar-tags))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org agenda
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; start on today
(setq org-agenda-start-on-weekday nil)

;; fancy priorities
(use-package org-fancy-priorities
  :hook (org-mode . org-fancy-priorities-mode)
  :config
  (setq org-fancy-priorities-list '((?A . "🚨")
                                    (?B . "🔶")
                                    (?C . "⭐"))))

(setq org-agenda-block-separator 8411)

(setq org-agenda-custom-commands
      '(("v" "A better agenda view"
         ((agenda ""
                  ((org-agenda-span 1)
                   (org-agenda-start-day "0d")
                   (org-agenda-entry-types '(:deadline))
                   (org-deadline-warning-days 0)
                   (org-agenda-prefix-format "  %?-12t% s %5e ")
                   (org-agenda-overriding-header "Due today:")))
          (agenda ""
                  ((org-agenda-prefix-format "  %?-12t% s %5e ")))
          (alltodo ""
                   ((org-agenda-prefix-format "  %i %-12:c %5e ")))))
        ("g" "Get Things Done (GTD)"
         ((agenda ""
                  ((org-agenda-skip-function
                    '(org-agenda-skip-entry-if 'deadline))
                   (org-deadline-warning-days 0)))
          (todo "NEXT"
                ((org-agenda-skip-function
                  '(org-agenda-skip-entry-if 'deadline))
                 (org-agenda-prefix-format "  %i %-12:c [%e] ")
                 (org-agenda-overriding-header "\nTasks\n")))
          (agenda nil
                  ((org-agenda-entry-types '(:deadline))
                   (org-agenda-format-date "")
                   (org-deadline-warning-days 7)
                   (org-agenda-skip-function
                    '(org-agenda-skip-entry-if 'notregexp "\\* NEXT"))
                   (org-agenda-overriding-header "\nDeadlines")))
          (tags-todo "inbox"
                     ((org-agenda-prefix-format "  %?-12t% s")
                      (org-agenda-overriding-header "\nInbox\n")))
          (tags "CLOSED>=\"<today>\""
                ((org-agenda-overriding-header "\nCompleted today\n")))))))

(with-eval-after-load 'org-agenda
  (set-face-attribute 'org-agenda-current-time nil
                      :foreground "red" :weight 'bold))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org timegrid
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package org-timegrid
  :straight (:host github :repo "Gleek/org-timegrid")
  :demand t
  :bind (("C-c T" . org-timegrid-week))
  :init
  ;; The symbol `agenda' means: read events from `org-agenda-files'.
  (setq org-timegrid-org-files 'agenda

        ;; Center today (or a date you jump to) in the visible range.
        org-timegrid-range-alignment 'left

        ;; Recommended compact scale; use 1.0 to match Emacs's default font.
        org-timegrid-default-zoom 0.7

        org-timegrid-start-hour 7

        org-timegrid-org-capture-file
        (expand-file-name "calendar.org" org-directory)
        org-timegrid-org-capture-template
        '(:target file
                  :template "* %{title}\n%{time-range}\n%?")

        ;; Save Org buffers immediately after edits made in the calendar.
        org-timegrid-org-auto-save t

        ;; Set this to nil if repeating entries should be hidden.
        org-timegrid-org-show-repeaters t

        ;; The first matching tag supplies an event's colour.
        org-timegrid-org-tag-color-alist
        '(("Work"     . indigo)
          ("Family" . green)
          ("Primary"  . yellow)
          ("WeberLab"   . cyan)))
  :config
  (require 'org-timegrid-org))

;; ;; This is part of the same package. It adds a read-only day strip to Org
;; ;; Agenda; pressing RET on the strip opens the editable week view.
;; (use-package org-timegrid-agenda
;;   :straight nil
;;   :after org-agenda
;;   :demand t
;;   :init
;;   ;; nil inserts the strip at the top. To place it after a particular custom
;;   ;; agenda block, use a regexp matching that block's heading instead.
;;   (setq org-timegrid-agenda-insert-after nil
;;         org-timegrid-agenda-separator t
;;         org-timegrid-agenda-minutes-before 180
;;         org-timegrid-agenda-minutes-after 180)
;;   :config
;;   (org-timegrid-agenda-mode 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org journal
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package org-journal
  :bind ("C-c J" . org-journal-new-entry)
  :custom
  (org-journal-file-format "%Y-%m-%d.org")
  ;; ASSUMPTION: adjust if your journal files lived somewhere else under Doom.
  (org-journal-dir (expand-file-name "journal/" org-directory)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; .eml files: HTML mode, RET inserts <br>
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'auto-mode-alist '("\\.eml\\'" . html-mode))

(defun my/insert-br-newline ()
  "Insert <br> followed by a newline."
  (interactive)
  (insert "<br>\n"))

(add-hook 'html-mode-hook
          (lambda ()
            (local-set-key (kbd "RET") #'my/insert-br-newline)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Email: mu4e
;;
;; mu4e is NOT installed through straight/MELPA. It ships
;; with the `mu' program, so we load it from the system
;; install. ASSUMPTION: mu was installed under /usr/local
;; (your mu binary is /usr/local/bin/mu). Verify with:
;;   ls /usr/local/share/emacs/site-lisp/mu4e
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq mu4e-use-fancy-chars t)
(setq mu4e-headers-unread-mark    '("u" . "📩 "))
(setq mu4e-headers-draft-mark     '("D" . "🚧 "))
(setq mu4e-headers-flagged-mark   '("F" . "🚩 "))
(setq mu4e-headers-new-mark       '("N" . "✨ "))
(setq mu4e-headers-passed-mark    '("P" . "↪ "))
(setq mu4e-headers-replied-mark   '("R" . "↩ "))
(setq mu4e-headers-seen-mark      '("S" . " "))
(setq mu4e-headers-trashed-mark   '("T" . "🗑️"))
(setq mu4e-headers-attach-mark    '("a" . "📎 "))
(setq mu4e-headers-encrypted-mark '("x" . "🔑 "))
(setq mu4e-headers-signed-mark    '("s" . "🖊 "))
(setq mu4e-headers-personal-mark '("p" . ""))

(setq message-kill-buffer-on-exit t) ;; kill buffer after send

(use-package org-mime
  :config
  (setq org-mime-export-options '(:section-numbers nil
                                                   :with-author nil
                                                   :with-toc nil)))

(use-package mu4e
  :straight nil
  :load-path "/usr/local/share/emacs/site-lisp/mu4e"
  :commands (mu4e mu4e-compose-new)
  :bind ("C-c m" . mu4e)
  :config
  ;; Basic settings
  (setq mu4e-mu-binary "/usr/local/bin/mu"
        mu4e-maildir "~/.mail/"
        mu4e-attachment-dir "~/Downloads"
        mu4e-get-mail-command "mbsync -a"
        mu4e-update-interval 300        ; Update every 5 minutes
        mu4e-compose-format-flowed t
        mu4e-change-filenames-when-moving t
        mu4e-headers-show-threads nil
        mu4e-headers-include-related nil
        message-signature-file "~/.mail/.signature"
        message-send-mail-function 'smtpmail-send-it
        gnutls-trustfiles
        (append gnutls-trustfiles
                '("~/.config/protonmail/cert.pem")))
  
  (setq mu4e-contexts
        (list
         ;; BCCHR
         (make-mu4e-context
          :name "BCCHR"
          :match-func
          (lambda (msg)
            (when msg
              (string-prefix-p "/bcchr" (mu4e-message-field msg :maildir))))
          :vars '((user-full-name . "Alexander Weber")
                  (user-mail-address . "aweber@bcchr.ca")
                  (mu4e-sent-folder . "/bcchr/Sent")
                  (mu4e-drafts-folder . "/bcchr/Drafts")
                  (mu4e-trash-folder . "/bcchr/Trash")
                  (smtpmail-smtp-server . "localhost")
                  (smtpmail-smtp-user . "aweber@bcchr.ca")
                  (smtpmail-stream-type . plain)
                  (smtpmail-smtp-service . 1026)))
         ;; ProtonMail
         (make-mu4e-context
          :name "ProtonMail"
          :match-func
          (lambda (msg)
            (when msg
              (string-prefix-p "/proton" (mu4e-message-field msg :maildir))))
          :vars '((user-full-name . "Alexander Weber")
                  (user-mail-address . "weberam2@proton.me")
                  (mu4e-sent-folder . "/proton/Sent")
                  (mu4e-drafts-folder . "/proton/Drafts")
                  (mu4e-trash-folder . "/proton/Trash")
                  (mu4e-refile-folder . "/proton/Archive")
                  (smtpmail-smtp-server . "127.0.0.1")
                  (smtpmail-smtp-user . "weberam2@proton.me")
                  (smtpmail-stream-type . starttls)
                  (smtpmail-smtp-service . 1025)))))
  
  (setq mu4e-bookmarks
        '((:name "BCCHR Inbox" :query "maildir:/bcchr/Inbox AND flag:unread" :key ?b)
          (:name "ProtonMail Inbox" :query "maildir:/proton/Inbox AND flag:unread" :key ?p)
          (:name "Gmail archive" :query "maildir:\"/gmail/[Gmail]/All Mail\"" :key ?g)
          (:name "All Unread" :query "(maildir:/bcchr/Inbox OR maildir:/proton/Inbox) AND flag:unread" :key ?u)
          (:name "Today's messages" :query "(maildir:/bcchr/Inbox OR maildir:/proton/Inbox) AND date:today..now" :key ?t)))
  
  (setq mu4e-maildir-shortcuts
        '((:maildir "/bcchr/Inbox"  :key ?i)
          (:maildir "/proton/Inbox" :key ?I)
          (:maildir "/bcchr/Sent"   :key ?s)
          (:maildir "/proton/Sent"  :key ?S)
          (:maildir "/bcchr/Trash"  :key ?t)
          (:maildir "/proton/Trash" :key ?T)))
  
  ;; Org links / capture from mu4e (needed for %:subject, %:fromname, %a)
  (require 'mu4e-org nil t)
  
  ;; Capture actions
  ;; taken from https://github.com/daviwil/emacs-from-scratch/blob/master/show-notes/Emacs-Mail-05.org
  (defun efs/capture-mail-todo (msg)
    (interactive)
    (call-interactively 'org-store-link)
    (org-capture nil "mt"))
  
  (defun efs/capture-mail-tododeadline (msg)
    (interactive)
    (call-interactively 'org-store-link)
    (org-capture nil "md"))
  
  (add-to-list 'mu4e-headers-actions '("todo" . efs/capture-mail-todo) t)
  (add-to-list 'mu4e-view-actions '("todo" . efs/capture-mail-todo) t)
  (add-to-list 'mu4e-view-actions '("deadline" . efs/capture-mail-tododeadline) t)
  (add-to-list 'mu4e-headers-actions '("deadline" . efs/capture-mail-tododeadline) t)
  
  ;; Context switching
  (setq mu4e-context-policy 'pick-first
        mu4e-compose-context-policy 'ask)
  
  ;; Use the gnus message view engine, which enables iCal support.
  (setq mu4e-view-use-gnus t)
  (require 'mu4e-icalendar)
  (mu4e-icalendar-setup)
  
  ;; Org integration for calendar invites.
  ;; **IMPORTANT**: the file and headline must exist in todo.org!
  (setq gnus-icalendar-org-capture-file (concat org-directory "todo.org"))
  (setq gnus-icalendar-org-capture-headline '("Calendar"))
  (gnus-icalendar-org-setup)
  
  ;; Write in org, send as HTML
  (add-hook 'message-send-hook 'org-mime-htmlize)
  
  (defun my-do-compose-stuff ()
    "My settings for message composition."
    (set-fill-column 72)
    (flyspell-mode))
  (add-hook 'mu4e-compose-mode-hook #'my-do-compose-stuff))

;; Email signature
(defun my-insert-signature ()
  "Insert my standard email signature."
  (interactive)
  (insert "Cheers,\n\nAlex W.\n\n"))

;; "No new students" reply, followed by signature
(defun my-insert-no-students-response ()
  "Insert a polite refusal for new students, followed by my signature."
  (interactive)
  (insert "Thank you for reaching out. Unfortunately, I am not taking on any new students at the moment. \n\nBest of luck with your academic pursuits.\n\n")
  (my-insert-signature))

(with-eval-after-load 'message
  (define-key message-mode-map (kbd "C-c s") #'my-insert-signature)
  (define-key message-mode-map (kbd "C-c n") #'my-insert-no-students-response))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Music: Subsonic (needs `mpv' installed)
;;
;; Doom needed evil-state overrides and RET remaps for the
;; subsonic buffers; without evil the package defaults work.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package subsonic
  :commands subsonic
  :bind (("<f6>"  . subsonic)
         ("<f7>"  . subsonic-toggle-playing)
         ("<f8>"  . subsonic-skip-track)
         ("<f9>"  . subsonic-prev-track)
         ("<f10>" . subsonic-toggle-playlist))
  :custom
  (subsonic-host "192.168.0.103:4533")
  (subsonic-enable-art t)
  (subsonic-ssl nil)
  (subsonic-scrobble-plays t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EPUB reading
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package nov
  :mode ("\\.epub\\'" . nov-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; AI coding support
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
;; Smartparens
;; Automatically inserts matching delimiters and
;; makes editing parentheses easier.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package smartparens
  :config
  (require 'smartparens-config)
  (smartparens-global-mode 1)
  (show-smartparens-global-mode 1))

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TODO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

;; Virtual environments
(use-package pyvenv
  :config
  (pyvenv-mode))

;; Jupyter support
;; M-x jupyter-run-repl
(use-package jupyter)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; R support
;; ESS is the gold standard for R in Emacs.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package ess)

;; R markdown
(use-package poly-R
  :mode ("\\.[rR]md\\'" . poly-gfm+r-mode))

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

;; Markdown face definitions
(defface my-markdown-citation-face
  '((t (:foreground "#F54927"
                    :weight bold)))
  "Face used for Pandoc citations.")
(font-lock-add-keywords
 'markdown-mode
 '(("\\(\\[@[^]]+\\]\\)"
    1 'my-markdown-citation-face t)))

;; Math preview
(use-package math-preview)
;; (add-hook 'markdown-mode-hook
;;           (lambda ()
;;             (when (and buffer-file-name
;;                        (string-match-p "\\.qmd\\'" buffer-file-name))
;;               (math-preview-all))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Quarto
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; https://gist.github.com/fast-90/3d7ce3252fff59b0f6d6d1bcadcf4938
(use-package quarto-mode
  :bind (:map poly-quarto-mode-map
              ("C-c q p" . quarto-preview)))

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
;; Citations
;;
;; Works beautifully with BetterBibTeX + Zotero.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package citar
  :custom
  (citar-bibliography
   '("~/references/references.bib")))

;; Insert citations with C-c ]
(with-eval-after-load 'markdown-mode
  (define-key markdown-mode-map
              (kbd "C-c ]")
              #'citar-insert-citation))


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
;; YAML support
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package yaml-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; JSON support
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package json-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom keybindings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun insert-current-date ()
  "Insert current date in yyyy-mm-dd format."
  (interactive)
  (insert (format-time-string "%Y-%m-%d")))

(global-set-key (kbd "C-c d") #'insert-current-date)


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
