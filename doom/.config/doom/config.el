;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font"))

;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'omarchy)
(load (expand-file-name "omarchy" doom-emacs-dir))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; Use lambda-line in place of Doom's built-in modeline.
;; (use-package! lambda-line
;;   :demand t
;;   :config
;;   (lambda-line-mode 1))

;; Only show Centaur Tabs when the current tab group has multiple buffers.
(after! centaur-tabs
  (defvar-local my/centaur-tabs-hidden-for-single-tab nil)

  (defun my/centaur-tabs-hide-single-tab-h ()
    (when (centaur-tabs-mode-on-p)
      (let* ((tabset (centaur-tabs-current-tabset t))
             (single-tab-p
              (or (null tabset)
                  (null (cdr (centaur-tabs-tabs tabset))))))
        (cond
         ((and single-tab-p
               (not centaur-tabs-local-mode))
          (centaur-tabs-local-mode 1)
          (setq my/centaur-tabs-hidden-for-single-tab t))
         ((and (not single-tab-p)
               my/centaur-tabs-hidden-for-single-tab)
          (centaur-tabs-local-mode -1)
          (setq my/centaur-tabs-hidden-for-single-tab nil))))))

  (add-hook 'buffer-list-update-hook
            #'my/centaur-tabs-hide-single-tab-h)
  (add-hook 'doom-switch-buffer-hook
            #'my/centaur-tabs-hide-single-tab-h)
  (add-hook 'centaur-tabs-mode-hook
            #'my/centaur-tabs-hide-single-tab-h))

;; Match the custom navigation layout in ~/.config/nvim:
;; h/n/e/i = left/down/up/right; k/j/l retain the displaced commands.
(after! evil
  (map! :mnvo "h" #'evil-backward-char
        :mnvo "n" #'evil-next-line
        :mnvo "e" #'evil-previous-line
        :mnvo "i" #'evil-forward-char

        :nv "k" #'evil-insert
        :n "K" #'evil-insert-line
        :v "K" #'evil-insert
        :m "k" nil
        :m "K" nil

        :mnvo "j" #'evil-search-next
        :mnvo "J" #'evil-search-previous
        :nv "N" #'evil-join
        :m "N" nil

        :mnv "E" #'evil-lookup
        :o "E" nil
        :mnvo "I" #'evil-window-bottom

        :mnvo "l" #'evil-forward-word-end
        :mnvo "L" #'evil-forward-WORD-end

        :map evil-window-map
        "h" #'evil-window-left
        "C-h" #'evil-window-left
        "n" #'evil-window-down
        "C-n" #'evil-window-down
        "e" #'evil-window-up
        "C-e" #'evil-window-up
        "i" #'evil-window-right
        "C-i" #'evil-window-right)

  ;; Keep k as insert in normal/visual state, but use it as Vim's inner-text
  ;; object prefix in operator state (for example, dkw instead of diw).
  (define-key evil-operator-state-map (kbd "k")
              evil-inner-text-objects-map))

(after! treemacs-evil
  (map! :map evil-treemacs-state-map
        "h" #'treemacs-COLLAPSE-action
        "n" #'treemacs-next-line
        "e" #'treemacs-previous-line
        "i" #'treemacs-RET-action))

;; Open the persistent Ghostel terminal on the right.
(set-popup-rule! "^\\*doom:ghostel-popup"
  :side 'right
  :size 0.4
  :select t
  :quit nil
  :ttl nil)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; Search and manage Raindrop.io bookmarks, including Org dynamic blocks.
;; The token is read from auth-source first, then RAINDROP_TOKEN.
(use-package! raindrop
  :commands (raindrop-clear-cache)
  :init
  (setq raindrop-token-source '(auth-source env)))

(use-package! raindrop-search
  :commands (raindrop-search
             raindrop-search-toggle-enter-action
             raindrop-search-create-bookmark
             raindrop-search-create-from-browser
             raindrop-search-create-from-kill-ring))

(use-package! raindrop-org
  :commands (raindrop-insert-or-update-links-under-heading))

(after! org
  (add-to-list 'org-babel-load-languages '(raindrop . t))
  (org-babel-do-load-languages
   'org-babel-load-languages
   org-babel-load-languages))

(map! :leader
      :desc "Search Raindrop bookmarks" "s r" #'raindrop-search
      (:prefix "n"
               (:prefix ("r" . "raindrop")
                :desc "Search bookmarks" "s" #'raindrop-search
                :desc "Create bookmark" "c" #'raindrop-search-create-bookmark
                :desc "Create from clipboard" "b" #'raindrop-search-create-from-browser
                :desc "Create from kill ring" "y" #'raindrop-search-create-from-kill-ring
                :desc "Toggle search open target" "o" #'raindrop-search-toggle-enter-action
                :desc "Clear Raindrop cache" "x" #'raindrop-clear-cache)))

(map! :map org-mode-map
      :localleader
      (:prefix ("r" . "raindrop")
       :desc "Update links from heading tags" "u"
       #'raindrop-insert-or-update-links-under-heading))

;; Astro files use web-mode for editing and Astro's language server via Eglot.
(use-package! web-mode
  :mode ("\\.astro\\'" . astro-mode)
  :config
  (define-derived-mode astro-mode web-mode "Astro"))

(after! eglot
  (add-to-list
   'eglot-server-programs
   '(astro-mode
     . ("astro-ls" "--stdio"
        :initializationOptions
        (:typescript
         (:tsdk "./node_modules/typescript/lib"))))))

(add-hook 'astro-mode-hook #'eglot-ensure)

;; Use bash mode for .env files
(add-to-list 'auto-mode-alist
             '("\\.env\\(?:\\..*\\)?\\'" . bash-ts-mode))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
