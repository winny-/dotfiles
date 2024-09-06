nixbin="$HOME/.nix-profile/bin"
if [[ $PATH != *$nixbin* && -d $nixbin ]]; then
    export PATH="${PATH}${PATH:+:}$nixbin"
fi
unset nixbin
