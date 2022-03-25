# https://github.com/jackharrisonsherlock/common

# Prompt symbol
COMMON_PROMPT_SYMBOL="λ"

# Colors
COMMON_COLORS_HOST_ME=green
COMMON_COLORS_HOST_AWS_VAULT=yellow
COMMON_COLORS_CURRENT_DIR=cyan
COMMON_COLORS_RETURN_STATUS_TRUE=magenta
COMMON_COLORS_RETURN_STATUS_FALSE=yellow
COMMON_COLORS_GIT_STATUS_DEFAULT=green
COMMON_COLORS_GIT_STATUS_STAGED=red
COMMON_COLORS_GIT_STATUS_UNSTAGED=yellow
COMMON_COLORS_GIT_PROMPT_SHA=green
COMMON_COLORS_BG_JOBS=yellow

# Left Prompt
 PROMPT='$(common_host)$(common_current_dir)$(common_bg_jobs)$(common_return_status)'

# Right Prompt
 RPROMPT='$(common_git_status)'

# Prompt with current SHA
# PROMPT='$(common_host)$(common_current_dir)$(common_bg_jobs)$(common_return_status)'
# RPROMPT='$(common_git_status) $(git_prompt_short_sha)'

# Host
common_host() {
  if [[ -n $SSH_CONNECTION ]]; then
    me="%n@%m"
  elif [[ $LOGNAME != $USER ]]; then
    me="%n"
  fi
  if [[ -n $me ]]; then
    echo "%{$fg[$COMMON_COLORS_HOST_ME]%}$me%{$reset_color%}:"
  fi
  if [[ $AWS_VAULT ]]; then
    echo "%{$fg[$COMMON_COLORS_HOST_AWS_VAULT]%}$AWS_VAULT%{$reset_color%} "
  fi
}

# Current directory
common_current_dir() {
  echo -n "%{$fg[$COMMON_COLORS_CURRENT_DIR]%}$(shrink_path -f) "
}

# Prompt symbol
common_return_status() {
  echo -n "%(?.%F{$COMMON_COLORS_RETURN_STATUS_TRUE}.%F{$COMMON_COLORS_RETURN_STATUS_FALSE})$COMMON_PROMPT_SYMBOL%f "
}

# Git status
common_git_status() {
    local message=""
    local message_color="%F{$COMMON_COLORS_GIT_STATUS_DEFAULT}"

    # https://git-scm.com/docs/git-status#_short_format
    local staged=$(git status --porcelain 2>/dev/null | grep -e "^[MADRCU]")
    local unstaged=$(git status --porcelain 2>/dev/null | grep -e "^[MADRCU? ][MADRCU?]")

    if [[ -n ${staged} ]]; then
        message_color="%F{$COMMON_COLORS_GIT_STATUS_STAGED}"
    elif [[ -n ${unstaged} ]]; then
        message_color="%F{$COMMON_COLORS_GIT_STATUS_UNSTAGED}"
    fi

    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ -n ${branch} ]]; then
        message+="${message_color}${branch}%f"
    fi

    echo -n "${message}"
}

# Git prompt SHA
ZSH_THEME_GIT_PROMPT_SHA_BEFORE="%{%F{$COMMON_COLORS_GIT_PROMPT_SHA}%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%} "

# Background Jobs
common_bg_jobs() {
  bg_status="%{$fg[$COMMON_COLORS_BG_JOBS]%}%(1j.↓%j .)"
  echo -n $bg_status
}






shrink_path () {
        setopt localoptions
        setopt rc_quotes null_glob

        typeset -i lastfull=0
        typeset -i short=0
        typeset -i tilde=0
        typeset -i named=0
        typeset -i length=1
        typeset ellipsis=""
        typeset -i quote=0

        if zstyle -t ':prompt:shrink_path' fish; then
                lastfull=1
                short=1
                tilde=1
        fi
        if zstyle -t ':prompt:shrink_path' nameddirs; then
                tilde=1
                named=1
        fi
        zstyle -t ':prompt:shrink_path' last && lastfull=1
        zstyle -t ':prompt:shrink_path' short && short=1
        zstyle -t ':prompt:shrink_path' tilde && tilde=1
        zstyle -t ':prompt:shrink_path' glob && ellipsis='*'
        zstyle -t ':prompt:shrink_path' quote && quote=1

        while [[ $1 == -* ]]; do
                case $1 in
                        --)
                                shift
                                break
                        ;;
                        -f|--fish)
                                lastfull=1
                                short=1
                                tilde=1
                        ;;
                        -h|--help)
                                print 'Usage: shrink_path [-f -l -s -t] [directory]'
                                print ' -f, --fish      fish-simulation, like -l -s -t'
                                print ' -g, --glob      Add asterisk to allow globbing of shrunk path (equivalent to -e "*")'
                                print ' -l, --last      Print the last directory''s full name'
                                print ' -s, --short     Truncate directory names to the number of characters given by -#. Without'
                                print '                 -s, names are truncated without making them ambiguous.'
                                print ' -t, --tilde     Substitute ~ for the home directory'
                                print ' -T, --nameddirs Substitute named directories as well'
                                print ' -#              Truncate each directly to at least this many characters inclusive of the'
                                print '                 ellipsis character(s) (defaulting to 1).'
                                print ' -e SYMBOL       Postfix symbol(s) to indicate that a directory name had been truncated.'
                                print ' -q, --quote     Quote special characters in the shrunk path'
                                print 'The long options can also be set via zstyle, like'
                                print '  zstyle :prompt:shrink_path fish yes'
                                return 0
                        ;;
                        -l|--last) lastfull=1 ;;
                        -s|--short) short=1 ;;
                        -t|--tilde) tilde=1 ;;
                        -T|--nameddirs)
                                tilde=1
                                named=1
                        ;;
                        -[0-9]|-[0-9][0-9])
                                length=${1/-/}
                        ;;
                        -e)
                                shift
                                ellipsis="$1"
                        ;;
                        -g|--glob)
                                ellipsis='*'
                        ;;
                        -q|--quote)
                                quote=1
                        ;;
                esac
                shift
        done

        typeset -i elllen=${#ellipsis}
        typeset -a tree expn
        typeset result part dir=${1-$PWD}
        typeset -i i

        [[ -d $dir ]] || return 0

        if (( named )) {
                for part in ${(k)nameddirs}; {
                        [[ $dir == ${nameddirs[$part]}(/*|) ]] && dir=${dir/#${nameddirs[$part]}/\~$part}
                }
        }
        (( tilde )) && dir=${dir/#$HOME/\~}
        tree=(${(s:/:)dir})
        (
                if [[ $tree[1] == \~* ]] {
                        cd -q ${~tree[1]}
                        result=$tree[1]
                        shift tree
                } else {
                        cd -q /
                }
                for dir in $tree; {
                        if (( lastfull && $#tree == 1 )) {
                                result+="/$tree"
                                break
                        }
                        expn=(a b)
                        part=''
                        i=0
                        until [[ $i -gt 99 || ( $i -ge $((length - ellen)) || $dir == $part ) && ( (( ${#expn} == 1 )) || $dir = $expn ) ]]; do
                                (( i++ ))
                                part+=$dir[$i]
                                expn=($(echo ${part}*(-/)))
                                (( short )) && [[ $i -ge $((length - ellen)) ]] && break
                        done

                        typeset -i dif=$(( ${#dir} - ${#part} - ellen ))
                        if [[ $dif -gt 0 ]]
                        then
                            (( quote )) && part=${(q)part}
                            part+="$ellipsis"
                        else
                            part="$dir"
                            (( quote )) && part=${(q)part}
                        fi
                        result+="/$part"
                        cd -q $dir
                        shift tree
                }
                echo ${result:-/}
        )
}
