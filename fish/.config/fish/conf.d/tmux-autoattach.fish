# Auto-attach tmux for interactive SSH logins.
if not set -q SSH_CONNECTION; and not set -q SSH_TTY
    return
end
set -q TMUX; and return
if set -q TMUX_AUTOATTACH; and test "$TMUX_AUTOATTACH" != 1
    return
end

set -l locale $LANG
set -q LC_CTYPE; and set locale $LC_CTYPE
set -q LC_ALL; and set locale $LC_ALL
string match -q -r 'UTF-8|utf8' -- "$locale"; or set -gx LANG C.UTF-8
type -q tmux; or return

if tmux has-session 2>/dev/null
    exec tmux attach-session
end

exec tmux new-session
