export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# uv
export PATH="/Users/heilgar/.local/bin:$PATH"

# zoxide — initialize in all shell contexts (non-interactive included)
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"
alias cd=z
export _ZO_DOCTOR=0
