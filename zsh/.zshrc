eval "$(starship init zsh)"

# Export path
export PATH="$PATH:$HOME/.local/bin/"

# load pywal colors
(cat ~/.cache/wal/sequences &)
source ~/.cache/wal/colors.sh

# set transparent color for polybar
export color0_alpha="#99${color0/'#'}"

# Plugins
source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"

# aliases
alias ls="ls --color"

alias zconf="nvim ~/.zshrc"
alias bconf="nvim ~/.config/bspwm/bspwmrc"
alias sconf="nvim ~/.config/sxhkd/sxhkdrc"

alias v="nvim"
alias p="sudo pacman"
alias lg="lazygit"
