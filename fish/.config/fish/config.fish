#! /bin/sh
set fish_greeting
export EDITOR=nvim || export EDITOR=vim
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
source $HOME/.config/fish/shortcuts.fish
source $HOME/.config/fish/colors.fish
set -gx PATH $HOME/.local/bin /usr/local/bin /opt/chromium /opt/android-sdk/platform-tools /opt/homebrew/bin $PATH

switch (uname)
case "*Darwin"
    alias lsblk="diskutil list"
case '*Linux'
    :
end

# Useful shortcuts
alias v=$EDITOR
alias py=python
alias venv="python -m venv"
alias p="sudo pacman"
alias ls="exa --icons"
alias lg=lazygit
alias btw=uwufetch
alias fontfix="/home/nico/repos/polybar-orig/setup.sh"

# Yay shortcuts
alias install="yay -S"
alias remove="yay -Rns"
alias update="yay -Syu"
alias search="yay -Ss"

# Fancy sudo prompt
alias sudo="sudo -p '   '"
