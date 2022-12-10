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
