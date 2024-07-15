if [[ $PATH != *$HOME/bin* ]]; then
    export PATH="${PATH}${PATH:+:}:$HOME/bin"
fi
