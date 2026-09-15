;;; init.el --- N Λ N O -*- lexical-binding: t; -*-

(add-to-list 'load-path (expand-file-name "nano-emacs" "~/.local/share"))
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(require 'nano)
(use-package evil
  :ensure t
  :config
  (evil-mode 1)
  (evil-define-key '(normal motion visual operator) 'global
    "h" #'evil-backward-char
    "n" #'evil-next-line
    "e" #'evil-previous-line
    "i" #'evil-forward-char
    "j" #'evil-search-next
    "J" #'evil-search-previous
    "l" #'evil-forward-word-end
    "L" #'evil-forward-WORD-end
    "N" #'evil-join
    "E" #'evil-lookup
    "I" #'evil-window-bottom)
  (evil-define-key '(normal visual) 'global "k" #'evil-insert)
  (evil-define-key 'normal 'global "K" #'evil-insert-line)
  (evil-define-key 'visual 'global "K" #'evil-insert)
  (define-key evil-operator-state-map (kbd "k") evil-inner-text-objects-map)
  (define-key evil-window-map (kbd "h") #'evil-window-left)
  (define-key evil-window-map (kbd "C-h") #'evil-window-left)
  (define-key evil-window-map (kbd "n") #'evil-window-down)
  (define-key evil-window-map (kbd "C-n") #'evil-window-down)
  (define-key evil-window-map (kbd "e") #'evil-window-up)
  (define-key evil-window-map (kbd "C-e") #'evil-window-up)
  (define-key evil-window-map (kbd "i") #'evil-window-right)
  (define-key evil-window-map (kbd "C-i") #'evil-window-right))
(nano-theme-set-dark)
(nano-refresh-theme)
(load custom-file t)
