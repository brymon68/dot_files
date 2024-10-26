
# PATH AND ALIAS
export PATH=/opt/homebrew/bin:$PATH
export PATH=/usr/local/bin/nvim-macos/bin/:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=/opt/homebrew/bin:$PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.tmuxifier/bin:$PATH"

# PROMPT
export CLICOLOR=1
eval "$(starship init zsh)"


#ENVS
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


#FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# zoxide
eval "$(zoxide init zsh)"
alias cd="z" 

#bat
alias cat="bat"

export HOMEBREW_BREWFILE=~/.config/Brewfile.txt
