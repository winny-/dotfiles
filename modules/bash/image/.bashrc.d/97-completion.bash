for cmd in jhmod vultr-cli flyctl; do
    if command -v "$cmd" >/dev/null; then
        # shellcheck disable=SC1090
        source <("$cmd" completion bash)
    fi
done
command -v dgltool >/dev/null && eval "$(_DGLTOOL_COMPLETE=bash_source dgltool)"
