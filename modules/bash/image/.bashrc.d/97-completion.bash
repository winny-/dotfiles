# shellcheck disable=SC1090
if command -v jhmod >/dev/null; then
    source <(jhmod completion bash)
fi
