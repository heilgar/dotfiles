# Path setup
export PATH="/opt/homebrew/opt/postgresql@17/bin:/opt/homebrew/bin:$HOME/.local/bin:$HOME/bin:$HOME/go/bin:/usr/local/bin:/usr/bin:$PATH"

# Starship prompt
eval "$(starship init zsh)"

# Zoxide (better cd)
eval "$(zoxide init zsh)"

# FZF
eval "$(fzf --zsh)"

# Zsh plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# Aliases
alias ls='ls -G'
alias ll='ls -lah'
alias vim='nvim'
alias cd='z'

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

# Volta (Node.js)
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

