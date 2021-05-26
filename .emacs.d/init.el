;; ==== Global Settings ====
;; == Behaviour ==
(global-set-key (kbd "<escape>") 'keyboard-escape-quit) ;; Esc to quit

;; mouse scroll by single line
(define-key global-map (kbd "<mouse-5>") (kbd "C-u 1 C-v"))
(define-key global-map (kbd "<mouse-4>") (kbd "C-u 1 M-v"))
(define-key global-map (kbd "<mouse-9>") 'undo)


(setq inhibit-startup-message t) ;; Disable greeting screen
(setq custom-file "~/.emacs.d/custom.el") ;; move easy custom file
(setq vc-follow-symlinks t)  ;; follow symlinks by default
;;(load-file custom-file)

;; == Appearance ==
(scroll-bar-mode -1) ;; Disable scrollbar
(tool-bar-mode -1 )  ;; Disable toolbar
(menu-bar-mode -1)   ;; Disable menu bar
;;(column-number-mode)
(global-display-line-numbers-mode t)

;;(load-theme 'wombat)
;; Default font
(set-face-attribute 'default nil
		    :font "DejaVu Sans Mono"
		    :height 120)
;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil
                    :font "DejaVu Sans Mono"
                    :height 120)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil
                    :font "Noto Sans"
		    :height 120)

;; ==== Packages ====
;; == Setup ==
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org"   . "https://orgmode.org/elpa")
                         ("elpa"  . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; == Tools ==
(use-package command-log-mode) ;; C-c o
(use-package counsel)          ;; Command autocomplete
(use-package magit)            ;; Git interface
(use-package which-key         ;; display available keybindings
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))
(use-package ivy               ;; Autocomplete
  :diminish                      ;; hide mode-name
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-k" . ivy-previous-line)
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

;; == Appearance ==
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))
(use-package doom-modeline ;; M-x all-the-icons-install-fonts
  :ensure t
  :init (doom-modeline-mode 1))
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-tomorrow-night t))

;; == Org Mode ==
(defun my/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)) ;; enable word-wrap and visual line editing

(use-package org
  :hook (org-mode . my/org-mode-setup)
  :config
  (setq org-agenda-files '("~/org/tasks.org"
			   "~/ETH/VMP/events/events.org"
			   "~/org/birthdays.org")))
  

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "
●")))

(require 'org-faces)
(dolist (face '((org-level-1 . 1.2)
                (org-level-2 . 1.15)
                (org-level-3 . 1.1)
                (org-level-4 . 1.05))))

;; Ensure corrent fonts for org environemnts
(set-face-attribute 'org-table    nil :inherit 'fixed-pitch)
(set-face-attribute 'org-code     nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-block    nil :foreground nil :inherit 'fixed-pitch)
(set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))


;; Add padding to org mode
(defun my/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . my/org-mode-visual-fill))
