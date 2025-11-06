#!/bin/bash

# Create symlinks for config files
ln -sf ~/dotfiles/.config/tmux/tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.bash_profile ~/.bash_profile

# Install TPM if not already installed
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Create .config directory and symlinks
mkdir -p ~/.config
ln -sf ~/dotfiles/.config/alacritty ~/.config/alacritty
ln -sf ~/dotfiles/.config/nvim ~/.config/nvim

echo "Setup complete. Run 'tmux' then 'prefix + I' to install tmux plugins."