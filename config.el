;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq-default evil-escape-key-sequence "kj")
(setq-default confirm-kill-emacs nil)
(map! :i "C-x C-s" #'save-buffer)
(setq mouse-yank-at-point t)
(setq x-select-enable-primary t)
(setq x-select-enable-clipboard nil)
 
;; have no idea why this is the only way
;; to add company-dabbrev-code to the
;; backend. Just follow https://github.com/emacs-ess/ESS/issues/955
(require 'company-dabbrev-code)
(add-to-list 'company-backends #'company-dabbrev-code)
(setq company-idle-delay 0)
(setq company-show-numbers t)
(after! ess-r-mode
  (set-company-backend! 'ess-r-mode
    '(:separate company-R-library company-R-args company-R-objects company-dabbrev-code)))
(after! ess-r-mode
  (progn
    (setq-default ess-style 'RStudio-)
    (setq ess-eval-visibly 't)))

(defun ess-r-tinytest ()
  "Interface to tinytest"
  (interactive)
  (projectile-save-project-buffers)
  (ess-r-package-eval-linewise
   "pkgload::load_all(); tinytest::test_all()"
   "Load package. Test with tinytest"
   ))
(map! :leader
      :desc "ess-r-tinytest"
      "m p t" #'ess-r-tinytest)


(defun ess-print-at-point ()
  "print of whats at point"
  (interactive)
  (let ((target (thing-at-point 'symbol)))
    (ess-eval-linewise
     (format "%s" target)
     (format "Print instance: %s" target)
     ))
  )
(map! :leader
      :desc "ess-print-at-point"
      "m i p" #'ess-print-at-point)

(defun ess-head-at-point ()
  "prints head of whats at point"
  (interactive)
  (let ((target (thing-at-point 'symbol)))
    (ess-eval-linewise
     (format "head(%s)" target)
     (format "Head of instance: %s" target)
     ))
  )
(map! :leader
      :desc "ess-head-at-point"
      "m i h" #'ess-head-at-point)

(defun ess-tail-at-point ()
  "prints tail of whats at point"
  (interactive)
  (let ((target (thing-at-point 'symbol)))
    (ess-eval-linewise
     (format "tail(%s)" target)
     (format "Tail of instance: %s" target)
     ))
  )
(map! :leader
      :desc "ess-tail-at-point"
      "m i t" #'ess-tail-at-point)

(defun drake-load-at-point ()
  "load drake-target at point"
  (interactive)
  (let ((target (thing-at-point 'symbol)))
    (ess-eval-linewise
     (format "drake::loadd(%s)" target)
     (format "Load target: %s" target)
     ))
  )
(map! :leader
      :desc "drake-load-at-point"
      "d l" #'drake-load-at-point)

(defun drake-load-at-point-and-print ()
  "load drake-target at point and print"
  (interactive)
  (drake-load-at-point)
  (ess-print-at-point)
  )
(map! :leader
      :desc "drake-load-at-point-and-print"
      "d i p" #'drake-load-at-point-and-print)

(defun drake-load-at-point-and-head ()
  "load drake-target at point and print head"
  (interactive)
  (drake-load-at-point)
  (ess-head-at-point)
  )
(map! :leader
      :desc "drake-load-at-point-and-head"
      "d i" #'drake-load-at-point-and-head)

(defun drake-prep-run ()
  "prep drake run"
  (interactive)
  (projectile-save-project-buffers)
  (ess-eval-linewise
   "source('prep_drake_run.R')"
   "Prepare next drake run"
   ))
(map! :leader
      :desc "drake-prep-run"
      "d p" #'drake-prep-run)

(defun drake-exec-run ()
  "execute drake run"
  (interactive)
  (projectile-save-project-buffers)
  (ess-eval-linewise
   "execute_plans(confirm = FALSE)"
   "Execute drake run"
   ))
(map! :leader
      :desc "drake-exec-run"
      "d e" #'drake-exec-run)
