# Auto-attach tmux for interactive SSH logins.
[ -n "$SSH_CONNECTION$SSH_TTY" ] || return 0
[ -z "$TMUX" ] || return 0
[ "${TMUX_AUTOATTACH:-1}" = 1 ] || return 0
case "${LC_ALL:-${LC_CTYPE:-$LANG}}" in
    *UTF-8*|*utf8*) ;;
    *) export LANG=C.UTF-8 ;;
esac
command -v tmux >/dev/null 2>&1 || return 0

if tmux has-session 2>/dev/null; then
    exec tmux attach-session
fi

exec tmux new-session
