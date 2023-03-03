set_title() {
    case ${TERM} in
        [aEkx]term*|rxvt*|gnome*|konsole*|interix|tmux*)
            printf '\e]0;%s\a' "$*"
            ;;
        screen*)
            echo screen
            printf '\ek%s\e\\' "$*"
            ;;
        *)
            ;;
    esac
}

seconds_to_hms() {
    local raw=$1
    local hours
    local minutes
    local seconds
    let 'hours=raw/(60*60)'
    let 'raw=raw%(60*60)'
    let 'minutes=raw/60'
    let 'seconds=raw%60'
    local ret=''
    (( hours )) && ret+="${hours}h"
    (( minutes )) && ret+="${minutes}m"
    (( seconds )) && ret+="${seconds}s"
    echo "$ret"
}

_script_dir() {
    local file="${BASH_SOURCE[0]}"
    echo "${file%/*}"
}
