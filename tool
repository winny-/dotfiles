#!/usr/bin/env bash

set -eu -o pipefail

progname="${0##*/}"
cd "${0%/*}"  # Project root.

# TODO getopts

cmd_install() {
	[[ $# -eq 0 ]] && cmd_usage
	for mod in "$@"; do
		# TODO ensure stow is ran from correct directory (project root).
		mod="${mod#modules/}"  # Allow omitting the full path
		stow -vv -S -d "modules/$mod" -t "$HOME" --no-folding image
	done
}

cmd_usage() {
	printf 'Usage: %s install mod ...\n' \
		"$progname"
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
	*|help)
		cmd_usage "$@"
		;;
esac

