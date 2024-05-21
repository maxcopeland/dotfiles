# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/bash_profile.pre.bash" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/bash_profile.pre.bash"
eval "$(starship init bash)"

alias ls='ls -lh'
alias python='python3'
export BASH_SILENCE_DEPRECATION_WARNING=1

# Adding this HomeBrew path to PATH for tmux
# https://github.com/tmux-plugins/tpm/issues/67

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/bash_profile.post.bash" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/bash_profile.post.bash"
