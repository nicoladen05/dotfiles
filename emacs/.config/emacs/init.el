;;; init.el --- N Λ N O -*- lexical-binding: t; -*-

(add-to-list 'load-path (expand-file-name "nano-emacs" "~/.local/share"))
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(require 'nano)
(use-package evil
  :ensure t
  :config (evil-mode 1))
(nano-theme-set-dark)
(nano-refresh-theme)
(load custom-file t)
