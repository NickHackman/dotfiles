;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Scott Nicholas Hackman"
      user-mail-address "snickhackman@gmail.com")

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
(setq doom-font (font-spec :family "Fira Code" :size 16))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

;; Custom

;; Maximize Emacs when opened
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Add pylint and thereby mypy as python checkers
(add-hook! python-mode
  (after! lsp
    (flycheck-add-next-checker 'lsp 'python-pylint)))

;; Rust-mode set lsp to rust-analyzer
(setq rustic-lsp-server 'rust-analyzer)

;; Allow treemacs to be resizable
(setq treemacs--width-is-locked nil)

;; Set company completion idle time
(setq company-idle-delay 0.25)

;; Tab bar set highlight to under
(setq centaur-tabs-set-bar 'under)
;; Disable tabs for eshell toggle terminal
(add-hook 'eshell-mode-hook 'centaur-tabs-local-mode)

;; Keybinds

(defun dired-current-win (path)
  ;; Open path in Dired in current buffer
  (dired (expand-file-name path)))

(defun dired-other-win (path)
  ;; Open path in Dired in new buffer
  (dired-other-window (expand-file-name path)))

;; Map SPC-o r and SPC-o h to dired open / and dired open ~ respectively
(map! :leader
      (:prefix-map ("o" . "open")
        ;; Open in current buffer
        :desc "Open ~/ here" "H" (lambda () (interactive) (dired-current-win "~"))
        :desc "Open / here" "R" (lambda () (interactive) (dired-current-win "/"))
        :desc "Open ~/.config here" "C" (lambda () (interactive) (dired-current-win "~/.config"))
        :desc "Open ~/Projects here" "P" (lambda () (interactive) (dired-current-win  "~/Projects"))

        ;; Open in new buffer
        :desc "Open ~/ new window" "h" (lambda () (interactive) (dired-other-win "~/."))
        :desc "Open / new window" "r" (lambda () (interactive) (dired-other-win "/"))
        :desc "Open ~/.config new window" "c" (lambda () (interactive) (dired-other-win "~/.config"))
        :desc "Open ~/Projects new window" "p" (lambda () (interactive) (dired-other-win  "~/Projects"))

        ;; More intuitive keybinding for term
        :desc "Open eshell" "t" #'+eshell/toggle
        ;; Open Files with Treemacs
        :desc "Open treemacs" "f" #'+treemacs/toggle
      ))
