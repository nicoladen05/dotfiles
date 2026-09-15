;;; init.el --- N Λ N O -*- lexical-binding: t; -*-

(startup-redirect-eln-cache (expand-file-name "emacs/eln-cache" "~/.cache"))
(add-to-list 'load-path (expand-file-name "nano-emacs" "~/.local/share"))
(require 'nano)
(nano-theme-set-dark)
(nano-refresh-theme)
