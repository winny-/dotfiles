# shellcheck shell=bash

# This bashrc was originally based off gentoo's. Then I added sensible
# bash. Then I saw a blog post recommending splitting .bashrc into
# different files in the from of .bashrc.d and I'm inclined to think
# that's a great idea, given how ridiculously busy shell startup files
# get.

###################################################
# This should be the first thing ran in the bashrc
###################################################

if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

##################################################
# Source the numerically prefixed startup files in
# .bashrc.d/
##################################################

# Uncomment to trace
#set -x

for i in ~/.bashrc.d/[0-9]*; do
    # shellcheck disable=SC1090
    . "$i"
done
unset i

##################################################
# And a ~/.bashrc.local that is to never exist in this git repository.
##################################################

if [[ -f ~/.bashrc.local ]]; then
    # shellcheck disable=SC1090
    . ~/.bashrc.local
fi

# Non-zero exit codes appear in this module's Bash prompt; ergo ensure the very
# last command in the .bashrc has a zero exit code.
:
