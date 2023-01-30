eval "$(starship init zsh)"

# Export path
export PATH="$PATH:$HOME/.local/bin/"

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
