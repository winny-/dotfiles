# Try to set up bash completion if it hasn't been set up already.  Needed for
# Debian.
if [[ -z $(complete -p) && -f /etc/bash_completion ]]; then
    . /etc/bash_completion
fi

################################################################

for cmd in jhmod vultr-cli flyctl; do
    if command -v "$cmd" >/dev/null; then
        # shellcheck disable=SC1090
        source <("$cmd" completion bash)
    fi
done
command -v dgltool >/dev/null && eval "$(_DGLTOOL_COMPLETE=bash_source dgltool)"
