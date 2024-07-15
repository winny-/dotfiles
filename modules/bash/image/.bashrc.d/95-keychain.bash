# Use keychain to manage gpg-agent and ssh-agent.  Otherwise stick the
# following line in another file to use ssh-agent directly YMMV:
#
# export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
#
# More info about keychain https://www.funtoo.org/Keychain

if command -v keychain &> /dev/null; then
    [[ -f $(_script_dir)/keychain.keys ]] && keys=$(< "$(_script_dir)/keychain.keys")

    # shellcheck disable=SC1090
    [[ -r ${HOME}/.keychain/${HOSTNAME}-sh ]] && . "${HOME}/.keychain/${HOSTNAME}-sh"
    # shellcheck disable=SC1090
    [[ -r ${HOME}/.keychain/${HOSTNAME}-sh-gpg ]] && . "${HOME}/.keychain/${HOSTNAME}-sh-gpg"

    # shellcheck disable=SC2086
    eval "$(keychain --eval -q --inherit any --agents ssh,gpg ${keys//\~/$HOME})"

    unset keys
    unset file
fi
