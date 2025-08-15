# PATH AND ALIAS
export PATH=/opt/homebrew/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=/opt/homebrew/bin:$PATH
export PATH="$HOME/.config/tmux:$PATH"
export PATH="$HOME/.local/share/bob/nvim-bin/:$PATH"
export EDITOR="nvim"
alias set_gemini_api_key='export GEMINI_API_KEY=$(op item get tjtl55t4leyvf4gotqtap3yy3u --vault Private --fields "password" --reveal)'
alias set_claude_api_key='export ANTHROPIC_API_KEY=$(op item get lcjd4fhsyglbwcye5yc4jdvr5y --vault Private --fields "password" --reveal)'
export HOMEBREW_BREWFILE=~/.config/Brewfile.txt
export EZA_CONFIG_DIR=~/.config/eza

# PROMPT
export CLICOLOR=1
eval "$(starship init zsh)"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# FZF
export FZF_DEFAULT_COMMAND='fd --type f '
export FZF_DEFAULT_OPTS="--layout=reverse --height=50% --bind 'f1:execute(bat {}),ctrl-y:execute-silent(echo {} | pbcopy)+abort'"
eval "$(fzf --zsh)"
bindkey -s '^F' 'nvim $(fzf)\n'

# zoxide
eval "$(zoxide init zsh)"
alias cd="z" 

#bat
alias cat="bat"

# pnpm
export PNPM_HOME="/Users/$USER/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/$USER/.lmstudio/bin"

#yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# work work file if exists
if [ -f "$HOME/.zshrc-workrc" ]; then
  source "$HOME/.zshrc-workrc"
fi
