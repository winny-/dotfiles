case ${TERM} in
    [aEkx]term*|rxvt*|gnome*|konsole*|interix|tmux*)
        set_title() {
            printf '\e]0;%s\a' "$*"
        }
        ;;
    screen*)
        set_title() {
            # shellcheck disable=SC1003
            printf '\ek0%s\e\\' "$*"
        }
        ;;
    *)
        set_title() {
            :
        }
        ;;
esac

_title_hook() {
    # Don't add garbage if stdout is redirected.
    if [[ ! -t 1 ]]; then
        return
    fi

    local _command
    _command="${BASH_COMMAND//[^[:print:]]/}"
    local _s
    _s='\u@\h \w'
    set_title "${_command} — ${_s@P}"
}

# This should be the last thing executed. If it is not, a string of my
# PS1 is printed to the terminal, colorized, with the bash escapes
# (\u@\h ...) intact. Weird, I know!
trap _title_hook DEBUG


with-title() { ( set_title "$1"; shift; "$@"; ); }
