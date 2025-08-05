
# PATH AND ALIAS
export PATH=/opt/homebrew/bin:$PATH
export PATH=/usr/local/bin/nvim-macos/bin/:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=/opt/homebrew/bin:$PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.tmuxifier/bin:$PATH"
export EDITOR="nvim"
alias set_gemini_api_key='export GEMINI_API_KEY=$(op item get z57dupjh4jlw6tyorld52g5plq --vault Private --fields "password" --reveal)'

# PROMPT
export CLICOLOR=1
eval "$(starship init zsh)"


#ENVS
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# FZF
export FZF_DEFAULT_COMMAND='fd --type f '
export FZF_DEFAULT_OPTS="--layout=reverse --height=50% --bind 'f1:execute(bat {}),ctrl-y:execute-silent(echo {} | pbcopy)+abort'"

vf() {
  IFS=$'\n' files=($(fzf --ansi --query="$1" --multi --select-1 --exit-0 ))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

bindkey -s '^F' 'vf\n'

# zoxide
eval "$(zoxide init zsh)"
alias cd="z" 
alias list="eza --icons -alh"

#bat
alias cat="bat"

export HOMEBREW_BREWFILE=~/.config/Brewfile.txt
export EZA_CONFIG_DIR=~/.config/eza

# pnpm
export PNPM_HOME="/Users/$USER/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

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
