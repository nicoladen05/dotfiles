eval "$(starship init zsh)"

# Export path
export PATH="$PATH:$HOME/.local/bin/"

# Plugins
source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"

# aliases
alias ls="ls --color"
alias ll="ls -l --color"

alias zconf="nvim ~/.zshrc"

alias v="nvim"
alias lg="lazygit"

alias protontricks='flatpak run com.github.Matoking.protontricks'

# Save history
HISTFILE=~/.zsh-history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory
