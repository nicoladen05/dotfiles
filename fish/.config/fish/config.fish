set -gx BUN_INSTALL "$HOME/.bun"

# Keep Fish's user paths in sync with ~/.bashrc.
fish_add_path --global --move \
    "$BUN_INSTALL/bin" \
    "$HOME/.local/bin" \
    "$HOME/.local/share/pi-node/node-v22.23.1-linux-arm64/bin"

if status is-interactive
    starship init fish | source
end
