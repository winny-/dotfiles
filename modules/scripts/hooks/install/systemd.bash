#!/usr/bin/env bash
set -eu -o pipefail
# https://superuser.com/questions/1017959/how-to-know-if-i-am-using-systemd-on-linux
if [[ $(ps --no-headers -o comm 1) = *systemd* ]]; then
    systemctl --user daemon-reload
fi

default_timers=(cleansignal)
for timer in "${default_timers[@]}"; do
    systemctl --user enable "${timer}.timer"
done
