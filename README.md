# dotfiles
This contains all of the tools I need for day-to-day dev work.

## setup (mac)
1. Install [alacritty](https://alacritty.org/)<br>
   NOTE: Mac will complain about this Application if you double-click it. Instead, right-click, "open", and hit open.
2. Install [brew](https://brew.sh/)
3. `cd ~ && git clone https://github.com/maxcopeland/dotfiles.git`
4. `cd dotfiles && ./setup.sh` (installs Homebrew packages, symlinks these dotfiles into place with `stow`, installs tpm, and installs VS Code extensions including Claude Code)
5. `chsh -s /bin/bash` and restart login shell
6. `tmux` and `prefix + I` to install plugins

## How this is wired up
Config lives in this repo and is symlinked into place with [GNU Stow](https://www.gnu.org/software/stow/)
rather than by symlinking `~/.config` itself. `setup.sh` pre-creates `~/.config` (and `~/.config/gh`) as
real directories before stowing, so each tool's config is linked in individually. That matters: it keeps
credentials and runtime state that tools write under `~/.config` (gcloud tokens, gh's `hosts.yml`,
`configstore`, etc.) living as normal files on disk instead of inside this git working tree, where a stray
`git add -A` could commit them. New tools you install later are safe by default - only paths this repo
actually tracks get symlinked.

## Tools Included
- **Editor**: Neovim with LSP configuration
- **Terminal**: Alacritty + Tmux
- **Shell**: Bash with Starship prompt
- **AI Tools**: Claude Code (VS Code)
