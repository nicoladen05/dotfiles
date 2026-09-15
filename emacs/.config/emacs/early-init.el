;;; early-init.el --- Early Emacs settings -*- lexical-binding: t; -*-

(setq package-user-dir (expand-file-name "emacs/elpa" "~/.local/share")
      auto-save-list-file-prefix (expand-file-name "emacs/auto-save-list/.saves-" "~/.cache")
      custom-file (expand-file-name "emacs-custom.el" "~/.local/state"))
(startup-redirect-eln-cache (expand-file-name "emacs/eln-cache" "~/.cache"))
