# lightdark

A dedicated module for an automation to turn on dark-mode at night then turn
light-mode for daytime.

## `bin/lightdark`

This script does all the heavy lifting.  You'll need to supply a `config.toml`.

### `config.toml`

Install at `~/.config/lightdark/config.toml`

Should contain a minimum configuration to set location:

```toml
[location]
mode = "manual"
lat = 40.73
long = -73.94
```

### Dependencies

```sh
apt install python3-click python3-sh python3-suntime python3-xdg
```

## `lightdark.service` user service

Runs `lightdark auto` in "one-shot" mode.

## `lightdark.timer` user timer

Runs the `lightdark.service` regularly to ensure dark/light mode is set for the
current time of day.

This time is enabled upon installation using a hook.
