
# PATH AND ALIAS
export PATH=/opt/homebrew/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=/opt/homebrew/bin:$PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.config/tmux:$PATH"
export PATH="/Users/bryce.montano/.local/share/bob/nvim-bin/:$PATH"
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

function sesh-sessions() {
  {
    exec </dev/tty
    exec <&1
    local session
    session=$(sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
    zle reset-prompt > /dev/null 2>&1 || true
    [[ -z "$session" ]] && return
    sesh connect $session
  }
}

bindkey -s '^F' 'sesh connect $(sesh list | fzf)\n'

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

