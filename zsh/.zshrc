eval "$(starship init zsh)"

# Export path
export PATH="$PATH:$HOME/.local/bin/"

export XDG_RUNTIME_DIR=/run/user/1000/

# Plugins
#source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
#source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.cargo/env"

# aliases
alias ls="ls --color"

alias zconf="nvim ~/.zshrc"
alias bconf="nvim ~/.config/bspwm/bspwmrc"
alias sconf="nvim ~/.config/sxhkd/sxhkdrc"
alias pconf="nvim ~/.config/polybar/config.ini"

alias v="nvim"
alias p="sudo pacman"
alias lg="lazygit"
