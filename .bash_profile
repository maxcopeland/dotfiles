# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/bash_profile.pre.bash" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/bash_profile.pre.bash"

# PATH additions apply to every shell, interactive or not, so that
# non-interactive login shells (e.g. `bash -lc "cmd"`, how many CLI
# agent tools - including Claude Code - run subprocesses) still resolve
# these tools. Homebrew must come early to override system python.
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.antigravity-ide/antigravity-ide/bin:$PATH"

# If not running interactively, don't do anything further
[[ $- != *i* ]] && return

eval "$(starship init bash)"

# Enable vi mode for command line editing
set -o vi

alias ls='ls -lh'
alias tf='terraform'
alias python='python3'
export BASH_SILENCE_DEPRECATION_WARNING=1

# Auto-start tmux, but not inside VS Code/other IDE terminals, CI, or
# agent-spawned shells. Set TMUX_AUTOSTART_DISABLE=1 to opt out from
# any other tool that spawns an interactive-looking login shell.
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ] && [ -z "$VSCODE_INJECTION" ] && [ -z "$CI" ] && [ -z "$TMUX_AUTOSTART_DISABLE" ]; then
  exec tmux new-session -A -s main
fi

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/bash_profile.post.bash" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/bash_profile.post.bash"
