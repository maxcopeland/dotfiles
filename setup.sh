#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
cd "$DOTFILES_DIR"

if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Install it first: https://brew.sh/" >&2
    exit 1
fi

echo "Installing Homebrew packages..."
brew bundle install

# ~/.config must be a real directory, not one big symlink into this repo -
# otherwise every tool that writes there (gcloud, gh, etc.) would write
# straight into the git working tree. mkdir'ing these paths first forces
# stow to symlink individual files/dirs into them instead of folding the
# whole directory into a single symlink. gh mixes tracked config (config.yml)
# with untracked runtime secrets (hosts.yml), so it needs this explicitly;
# other tools that only ever touch ~/.config/<toolname> and never overlap
# with a tracked path don't.
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.config/gh"

echo "Symlinking dotfiles..."
stow --restow --target="$HOME" --dir="$DOTFILES_DIR" .

# bin/ is excluded from the stow package (see .stow-local-ignore) because it
# doesn't mirror a $HOME path - ~/.local already holds real, unrelated
# content (uv/pipx installs, the Claude Code binary, ...) that a whole-dir
# symlink would risk shadowing. Link the one script in directly instead.
mkdir -p "$HOME/.local/bin"
ln -sf "$DOTFILES_DIR/bin/tmux-sessionizer" "$HOME/.local/bin/tmux-sessionizer"

# tmux.conf expects tpm here; tpm then self-manages the other plugins
# declared in tmux.conf alongside itself on the next 'prefix + I'.
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing tpm..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

if command -v code &> /dev/null; then
    echo "Installing VS Code extensions..."
    grep -v '^#' "$DOTFILES_DIR/.config/vscode/extensions.txt" | grep -v '^$' | xargs -L 1 code --install-extension
else
    echo "VS Code not found. Skipping extension installation."
fi

echo "Setup complete. Run 'tmux' then 'prefix + I' to install tmux plugins."
