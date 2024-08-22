#!/usr/bin/env bash

set -eu -o pipefail

progname="${0##*/}"
cd "${0%/*}"  # Project root.

# TODO getopts

msg() {
    tput bold setaf 2
    printf '>>> %s\n' "$*"
    tput sgr0
}

rundir() {
    for prog in "$1"/*; do
        if [[ -x $prog ]]; then
            msg "Running script $prog ..."
            ./"$prog"
        fi
    done
}

cmd_install() {
    [[ $# -eq 0 ]] && cmd_usage
    for mod in "$@"; do
	MODULE="${mod#modules/}"  # Allow omitting the full path
        msg "Installing module $MODULE ..."
        export MODULE
        TARGET="$HOME"
        export TARGET
        pushd "modules/$MODULE" &>/dev/null
	stow  --override='.*' --ignore='\.git' -vv -d '.' -t "$TARGET" --no-folding image
        rundir hooks/install
        popd &>/dev/null
    done
}

# This should be written in perl or python.
cmd_clean() {
    [[ $# -eq 0 ]] && cmd_usage
    for mod in "$@"; do
	orig_mod="$mod"
	mod="${mod#modules/}"  # Allow omitting the full path
	prefix="modules/${mod}/image/"
	if ! pushd "$prefix" >/dev/null; then
	    printf 'Module "%s" does not exist!  Skipping.\n' "$orig_mod" >&2
	    continue
	fi
	find . -type f -print0 |
	    while read -r -d $'\0'; do
		target="${HOME}/${REPLY#./}"
		if [[ -L $target && ! -e $target ]]; then
		    printf 'deleted: `%s%s\n' "$target" "'"
		    rm -f -- "$target"
		fi
	    done
	popd >/dev/null
    done
}

cmd_diff() {
    [[ $# -eq 0 ]] && cmd_usage
    for mod in "$@"; do
        echo "Command not implemented!" >&2
        exit 1
    done
}

cmd_usage() {
    printf 'Usage: %s install mod ...
           %s clean mod ...
' \
	   "$progname" "$progname"
    case $* in
	help) exit 0 ;;
	*) exit 1 ;;
    esac
}

[[ $# -eq 0 ]] && cmd_usage

case $1 in
    install)
	shift
	cmd_install "$@"
	;;
    clean)
        shift
        cmd_clean "$@"
	;;
    diff)
        cmd_diff "$@"
        ;;
    *)
	cmd_usage "$@"
	;;
esac
