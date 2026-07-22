---
name: update-dotfiles
description: Use when changing the user's dotfiles or configuration files.
---

My dotfiles are stored in a git repository at .dotfiles. They are symlinked to their location using GNU Stow.

Before editing, resolve the target (or its nearest existing parent) with `readlink -f`. If it points inside `~/.dotfiles`, make and validate the change there, then stage only the requested files, commit, and push from `~/.dotfiles`. Never include unrelated changes. Do not create new branches, commit and push on main.
