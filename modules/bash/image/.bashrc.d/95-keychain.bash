# Use keychain to manage gpg-agent and ssh-agent.  Otherwise stick the
# following line in another file to use ssh-agent directly YMMV:
#
# export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
#
# More info about keychain https://www.funtoo.org/Keychain

keys=''
file="${BASH_SOURCE[0]}"
[[ -f ${file%/*}/keychain.keys ]] && keys=$(< "${file%/*}/keychain.keys")

# shellcheck disable=SC2086
keychain -q --agents ssh,gpg ${keys//\~/$HOME}

unset keys
unset file

# shellcheck disable=SC1090
. "${HOME}/.keychain/${HOSTNAME}-sh" 
# shellcheck disable=SC1090
. "${HOME}/.keychain/${HOSTNAME}-sh-gpg"
