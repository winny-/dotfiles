set_title() {
    case ${TERM} in
        [aEkx]term*|rxvt*|gnome*|konsole*|interix|tmux*|alacritty)
            printf '\e]0;%s\a' "$*"
            ;;
        screen*)
            echo screen
            # shellcheck disable=SC1003
            printf '\ek%s\e\\' "$*"
            ;;
        *)
            ;;
    esac
}

seconds_to_human() {
    local raw=$1
    local days hours minutes seconds
    (( days=raw/(60*60*24) ))
    (( raw=raw%(60*60*24) ))
    (( hours=raw/(60*60) ))
    (( raw=raw%(60*60) ))
    (( minutes=raw/60 ))
    (( seconds=raw%60 ))

    local ret=''
    (( days )) && ret+="${days}d"
    (( hours )) && ret+="${hours}h"
    (( minutes )) && ret+="${minutes}m"
    (( seconds )) && ret+="${seconds}s"
    echo "$ret"
}

_script_dir() {
    local file="${BASH_SOURCE[0]}"
    echo "${file%/*}"
}
