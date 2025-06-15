### Coreutils
alias ls='ls --color=auto'
alias l='ls -l'
alias ll='ls -l'
alias la='l -a'
# Confirm a stray star, but not a dozen strays.
alias rm='rm --interactive=once'

alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'

alias mpvc='mpvc -S ~/.config/mpv/mpv.socket'
alias g=git
alias t=tmux

### Operator
alias sys=systemctl
alias sysu='sys --user'
alias j=journalctl
alias ju='j --user'
alias d=docker
alias dc='docker-compose'
alias h=heroku
alias fly=flyctl
alias tf=terraform
alias hw-probe='sudo -E hw-probe -all -upload -inventory LHW-ADDA-1F0A-C507-1BF1'

### Literary
alias d=wdict
