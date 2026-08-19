#    ╭──────────────────────────────────────────────╮
#    │    Source this file in your stock .bashrc    │
#    ╰──────────────────────────────────────────────╯

#  ────────────── Env ───────────────
export EDITOR="nvim"
export MANPAGER="nvim +Man!"

#  ──────────── Aliases ─────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias t='tmux attach || tmux new -s Work'
alias g='git'

n() { if [ "$#" -eq 0 ]; then command nvim .; else command nvim "$@"; fi; }

#  ─────────── Functions ────────────
# Rsync-on-change watchers: rsw starts one in the background, lsw lists, dsw stops
rsw() {
    (($# != 2)) && echo "Usage: rsw <source> <destination>" && return 1
    local src="${1%/}" dest="$2"
    # Reuse one SSH connection per login, so 1Password only prompts once.
    local sockets="${XDG_RUNTIME_DIR:-$HOME/.ssh/sockets}"
    mkdir -p "$sockets"
    local rsh="ssh -o ControlMaster=auto -o ControlPath=$sockets/rsw-%r@%h:%p -o ControlPersist=yes"
    setsid --fork env RSYNC_RSH="$rsh" bash -c 'rsync -a "$1/" "$2"; while inotifywait -r -q -e modify,create,delete,move "$1"; do rsync -a "$1/" "$2"; done' rsw-watch "$src" "$dest" >/dev/null 2>&1
    echo "Watching $src -> $dest"
}

lsw() {
    local pid cmd rest found=0
    while read -r pid cmd; do
        rest="${cmd##*rsw-watch }"
        echo "$pid: ${rest% *} -> ${rest##* }"
        found=1
    done < <(pgrep -af 'rsw-watch ')
    ((found)) || echo "No active watches"
}

dsw() {
    local pid found=0
    for pid in $(pgrep -f 'rsw-watch '); do
        kill -- -"$pid" 2>/dev/null && echo "Stopped watch (pid $pid)" && found=1
    done
    ((found)) || echo "No active watches"
}

# SSH Port Forwarding Functions
fip() {
    (($# < 2)) && echo "Usage: fip <host> <port1> [port2] ..." && return 1
    local host="$1"
    shift
    for port in "$@"; do
        ssh -f -N -L "${port}:localhost:${port}" "$host" && echo "Forwarding localhost:$port -> $host:$port"
    done
}

dip() {
    (($# == 0)) && echo "Usage: dip <port1> [port2] ..." && return 1
    for port in "$@"; do
        pkill -f "ssh.*-L ${port}:localhost:${port}" && echo "Stopped forwarding port $port" || echo "No forwarding on port $port"
    done
}

lip() {
    pgrep -af "ssh.*-L [0-9]+:localhost:[0-9]+" || echo "No active forwards"
}

#  ───────────── Extras ─────────────
# cd with zoxide if present
if command -v zoxide &>/dev/null; then
    alias cd="zd"
    zd() {
        if (($# == 0)); then
            builtin cd ~ || return
        elif [[ -d $1 ]]; then
            builtin cd "$1" || return
        else
            if ! z "$@"; then
                echo "Error: Directory not found"
                return 1
            fi

            printf "\U000F17A9 "
            pwd
        fi
    }
fi

# Blank line between prompts
_starship_first_prompt=1

_starship_prompt_spacing() {
    if ((_starship_first_prompt)); then
        _starship_first_prompt=0
    else
        printf '\n'
    fi
}

function clear {
    command clear "$@"
    local clear_status=$?
    _starship_first_prompt=1
    return "$clear_status"
}

starship_precmd_user_func="_starship_prompt_spacing"

#  ─────────── Init tools ───────────
if command -v mise &>/dev/null; then
    eval "$(mise activate bash)"
fi

if [[ $- == *i* ]] && [[ ${TERM:-} != "dumb" ]] && command -v starship &>/dev/null; then
    eval "$(starship init bash)"
fi

if command -v zoxide &>/dev/null; then
    eval "$(zoxide init bash)"
fi
