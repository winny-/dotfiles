# Based off of Gentoo's bashrc

################################################################
# Color detection
################################################################

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

################################################################
# Debug hook to set title and command's start time
################################################################

_debug_hook() {
    if [[ ! $BASH_COMMAND =~ ^(_direnv_hook|__prompt_command) || $__noted_time ]]; then
        __start_time=$EPOCHSECONDS
        __noted_time=
    fi

    # Don't add garbage if stdout is redirected.
    if [[ ! -t 1 ]]; then
        return
    fi

    if [[ $BASH_COMMAND =~ ^(_direnv_hook|__prompt_command) ]]; then
        return
    fi

    local _command
    _command="${BASH_COMMAND//[^[:print:]]/}"
    local _s
    _s='\u@\h \w'
    set_title "${_command} — ${_s@P}"
}

trap _debug_hook DEBUG

################################################################
# Prompt command
################################################################

__noted_time=

__prompt_command() {
    local code=$?
    PS1=""

    case ${TERM} in
        screen*)
            PS1+='\[\ek\u@\h \w\e\\\]'
            ;;
        [aEkx]term*|rxvt*|gnome*|konsole*|interix|tmux*|alacritty)
            PS1+='\[\e]0;\u@\h \w\a\]'
            ;;
        *)
            ;;
    esac

    local red='' yellow='' green='' blue='' reset=''
    if [[ $__use_color == true ]]; then
       red='\[\e[1;31m\]'
       yellow='\[\033[01;33m\]'
       reset='\[\e[0m\]'
       green='\[\033[01;32m\]'
       blue='\[\033[01;34m\]'
    fi

    __noted_time=1
    local end_time
    # shellcheck disable=SC2154
    ((end_time = EPOCHSECONDS - __start_time))
    if (( end_time > 5 )); then
        PS1+='('"$(seconds_to_human "$end_time")"') '
    fi

    if (( code )); then
        PS1+="${red}${code}${reset} "
    fi

    if [[ ${VIRTUAL_ENV+set} ]]; then
        PS1+="(${VIRTUAL_ENV_PROMPT:-${VIRTUAL_ENV##*/}}) "
    fi

    if [[ ${SSH_CONNECTION+set} ]]; then
        PS1+="${yellow}ssh${reset} "
    fi

    if [[ $EUID == 0 ]]; then
        if [[ $__use_color == true ]]; then
            PS1+="${red}"
        else
            PS1+='\u'
        fi
    elif [[ ! ${ANDROID_ROOT+set} ]]; then
        PS1+="${green}\u"
    fi

    if [[ $EUID == 0 && $__use_color != true ]]; then
        PS1+='@\h '
    elif [[ $EUID != 0 && ! ${ANDROID_ROOT+set} ]]; then
        PS1+="@\h "
    elif [[ $EUID == 0 ]]; then
        PS1+='\h '
    fi

    PS1+="${blue}\w "

    if [[ $EUID == 0 ]]; then
        PS1+="${red}"'\$'"${reset} "
    else
        PS1+="${blue}"'\$'"${reset} "
    fi
}

PROMPT_COMMAND=__prompt_command
