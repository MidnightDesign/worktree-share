#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOKS_DIR="$SCRIPT_DIR/hooks"

existing=$(git config --global core.hooksPath 2>/dev/null || true)

if [[ -n "$existing" && "$existing" != "$HOOKS_DIR" ]]; then
    echo "error: core.hooksPath is already set to: $existing"
    echo ""
    echo "If you have other global hooks there, copy them into:"
    echo "  $HOOKS_DIR"
    echo "Then re-run this script, or set it manually:"
    echo "  git config --global core.hooksPath \"$HOOKS_DIR\""
    exit 1
fi

chmod +x "$HOOKS_DIR/post-checkout"
chmod +x "$SCRIPT_DIR/bin/wt-share"

git config --global core.hooksPath "$HOOKS_DIR"

echo "Installed."
echo ""

# Detect shell profile
case "${SHELL##*/}" in
    zsh)  profile="$HOME/.zshrc" ;;
    bash) profile="$HOME/.bashrc" ;;
    fish) profile="${XDG_CONFIG_HOME:-$HOME/.config}/fish/config.fish" ;;
    *)    profile="" ;;
esac

PATH_LINE="export PATH=\"$SCRIPT_DIR/bin:\$PATH\""
FISH_LINE="fish_add_path \"$SCRIPT_DIR/bin\""

if [[ -z "$profile" ]]; then
    echo "Add the following to your shell profile to use wt-share:"
    echo "  $PATH_LINE"
else
    echo "To use wt-share, your PATH needs to be updated."
    echo "Add to $profile: $PATH_LINE"
    echo ""
    read -r -p "Add it now? [y/N] " answer
    if [[ "${answer,,}" == "y" ]]; then
        if [[ "${SHELL##*/}" == "fish" ]]; then
            echo "$FISH_LINE" >> "$profile"
        else
            echo "$PATH_LINE" >> "$profile"
        fi
        echo "Added. Restart your shell or run: source $profile"
    else
        echo "Skipped. Add it manually when ready."
    fi
fi
