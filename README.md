# dotfiles
This contains all of the tools I need for day-to-day dev work.

## setup (mac)
1. Install [alacritty](https://alacritty.org/)<br>
   NOTE: Mac will complain about this Application if you double-click it. Instead, right-click, "open", and hit open.
2. Install [brew](https://brew.sh/)
3. `cd ~ && git clone https://github.com/maxcopeland/dotfiles.git`
4. `cd dotfiles && git submodule update && brew bundle install`
5. `./setup.sh` (this will also install VS Code extensions including Claude Code)
6. `chsh -s /bin/bash` and restart login shell
7. `tmux` and `prefix + I` to install plugins

## Tools Included
- **Editor**: Neovim with LSP configuration
- **Terminal**: Alacritty + Tmux
- **Shell**: Bash with Starship prompt
- **AI Tools**: Claude Code (VS Code)
