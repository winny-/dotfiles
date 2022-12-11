# Based off of Gentoo's bashrc

__noted_time=

__prompt_command() {
    local code=$?
    PS1=""

    case ${TERM} in
        screen*)
            PS1+='\[\ek\u@\h \w\e\\\]'
            ;;
        [aEkx]term*|rxvt*|gnome*|konsole*|interix|tmux*)
            PS1+='\[\e]0;\u@\h \w\a\]'
            ;;
        *)
            ;;
    esac

    __noted_time=1
    local end_time
    ((end_time = EPOCHSECONDS - __start_time))
    if (( end_time > 5 )); then
        PS1+='('"$(seconds_to_hms "$end_time")"') '
    fi

    if (( code )); then
        if [[ $__use_color ]]; then
            PS1+='\[\e[1;31m\]'"$code"'\[\e[0m\] '
        else
            PS1+="$code "
        fi
    fi

    if [[ $__use_color ]]; then
	if [[ ${EUID} == 0 ]] ; then
	    PS1+='\[\033[01;31m\]\h\[\033[01;34m\] \w \$\[\033[00m\] '
	else
	    PS1+='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
	fi
    else
	# show root@ when we don't have colors
	PS1+='\u@\h \w \$ '
    fi
}

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.
# We run dircolors directly due to its changes in file syntax and
# terminal name patching.
__use_color=false
if type -P dircolors >/dev/null ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	LS_COLORS=
	if [[ -f ~/.dir_colors ]] ; then
		eval "$(dircolors -b ~/.dir_colors)"
	elif [[ -f /etc/DIR_COLORS ]] ; then
		eval "$(dircolors -b /etc/DIR_COLORS)"
	else
		eval "$(dircolors -b)"
	fi
	# Note: We always evaluate the LS_COLORS setting even when it's the
	# default.  If it isn't set, then `ls` will only colorize by default
	# based on file attributes and ignore extensions (even the compiled
	# in defaults of dircolors). #583814
	if [[ -n ${LS_COLORS:+set} ]] ; then
		__use_color=true
	else
		# Delete it if it's empty as it's useless in that case.
		unset LS_COLORS
	fi
else
	# Some systems (e.g. BSD & embedded) don't typically come with
	# dircolors so we need to hardcode some terminals in here.
	case ${TERM} in
	[aEkx]term*|rxvt*|gnome*|konsole*|screen|cons25|*color) __use_color=true;;
	esac
fi

PROMPT_COMMAND=__prompt_command
