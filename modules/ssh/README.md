# SSH configuration module

SSH configuration.  Note ssh is overridden to search for keys in path
`~/.ssh/keys`.  Add an additional file to `~/.ssh/config.d/` starting
with a number (see [`.ssh/config`](./image/.ssh/config)).  To
auto-load keys refer to the bash module's `keychain.bash` script.
