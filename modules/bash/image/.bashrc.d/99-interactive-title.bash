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

# This should be the last thing executed. If it is not, a string of my
# PS1 is printed to the terminal, colorized, with the bash escapes
# (\u@\h ...) intact. Weird, I know!
trap _debug_hook DEBUG
