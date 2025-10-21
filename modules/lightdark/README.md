# lightdark

A dedicated module for an automation to turn on dark-mode at night then turn
light-mode for daytime.

## `bin/lightdark`

This script does all the heavy lifting.

## `lightdark.service` user service

Runs `lightdark auto` in "one-shot" mode.

## `lightdark.timer` user timer

Runs the `lightdark.service` regularly to ensure dark/light mode is set for the
current time of day.

This time is enabled upon installation using a hook.
