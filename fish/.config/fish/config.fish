#! /bin/sh
export EDITOR=nvim || export EDITOR=vim
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
source $HOME/.config/fish/shortcuts.fish
source $HOME/.config/fish/colors.fish
set -gx PATH $HOME/.local/bin /usr/local/bin /opt/chromium /opt/android-sdk/platform-tools $PATH

xset r rate 300 50

alias v=$EDITOR
alias ls='exa'
alias la='exa -la'
alias df='df -h'
alias du='du -ch'
alias pass="kpcli -kdb ~/Documents/pass.kdbx"
alias ipp='curl ipinfo.io/ip'
alias sudo='sudo '
alias playlist-dl="youtube-dl -cio '%(autonumber)s-%(title)s.%(ext)s'"
alias yt='youtube-dl'
alias ytv='yt -f bestvideo'
alias yta='yt -f bestaudio'
alias py='python3'
alias md2notion='python3 -m md2notion bb4fc66b502b7027b87e7c42df243fa4fc6a043d0c6d853a1d1bbc24e0facd7fec92a2783079af92562af52f2a57a790a651ec9788aa5da55ae3c84df7e37cc22575da8f3826abb5be121047f0ca'
alias lupload='python3 -m md2notion bb4fc66b502b7027b87e7c42df243fa4fc6a043d0c6d853a1d1bbc24e0facd7fec92a2783079af92562af52f2a57a790a651ec9788aa5da55ae3c84df7e37cc22575da8f3826abb5be121047f0ca https://www.notion.so/baumig/Arbeiten-Themen-9ac2244a346e4bed8b9ce94442ecf01a'
