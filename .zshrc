# Respect per-machine XDG locations; empty values use the standard defaults.
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export STARSHIP_CONFIG="${STARSHIP_CONFIG:-$XDG_CONFIG_HOME/starship.toml}"

autoload -U compinit; compinit -i -C
# PATH AND ALIAS
export PATH=/opt/homebrew/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=/opt/homebrew/bin:$PATH
export PATH="$XDG_CONFIG_HOME/tmux:$PATH"
export PATH="$XDG_DATA_HOME/bob/nvim-bin/:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export EDITOR="nvim"
alias set_gemini_api_key='export GEMINI_API_KEY=$(op item get tjtl55t4leyvf4gotqtap3yy3u --vault Private --fields "password" --reveal)'
alias set_claude_api_key='export ANTHROPIC_API_KEY=$(op item get lcjd4fhsyglbwcye5yc4jdvr5y --vault Private --fields "password" --reveal)'
export HOMEBREW_BREWFILE="${HOMEBREW_BREWFILE:-$HOME/Brewfile.txt}"
export EZA_CONFIG_DIR="${EZA_CONFIG_DIR:-$XDG_CONFIG_HOME/eza}"


# ZSH
export HISTFILE=~/.zsh_history

# History limit of the file on disk (set to a large number or essentially unlimited)
export HISTFILESIZE=1000000
# Share history across multiple sessions
setopt SHARE_HISTORY

# Append to history file immediately after command execution
setopt INC_APPEND_HISTORY

# Save each command's beginning timestamp and duration to the history file
setopt EXTENDED_HISTORY

# Wait for command completion before writing the history entry with duration
setopt INC_APPEND_HISTORY_TIME

# Do not save command lines that match the previous command line
setopt HIST_IGNORE_DUPS


# PROMPT
export CLICOLOR=1
eval "$(starship init zsh)"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# FZF
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--layout=reverse --height=50% --bind 'f1:execute(bat {}),ctrl-y:execute-silent(echo {} | pbcopy)+abort'"
# theme skill: source generated fzf colors for current macOS appearance
if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q Dark; then
  [ -f "$XDG_CONFIG_HOME/fzf/theme-dark.zsh" ] && source "$XDG_CONFIG_HOME/fzf/theme-dark.zsh"
else
  [ -f "$XDG_CONFIG_HOME/fzf/theme-light.zsh" ] && source "$XDG_CONFIG_HOME/fzf/theme-light.zsh"
fi
eval "$(fzf --zsh)"
# Use Git's index to avoid walking the entire monorepo on every invocation.
# NUL delimiters preserve spaces and newlines in filenames; Esc opens nothing.
ff() {
  local file source='fd --type f --hidden --exclude .git --print0'
  local header='Enter: open in nvim'
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    source='git ls-files --cached -z'
    header='Tracked files | Ctrl-U: include untracked files | Enter: open in nvim'
  fi
  # Keep fzf in the foreground with terminal input, as in its Zsh integration.
  file=$(FZF_DEFAULT_COMMAND="$source" fzf < /dev/tty \
    --read0 --print0 --no-multi --scheme=path --prompt='Files > ' \
    --header="$header" --query="$*" \
    --bind='ctrl-u:change-header(All non-ignored files | Enter: open in nvim)+reload(fd --type f --hidden --exclude .git --print0)'
  ) || return 0
  file=${file%$'\0'}
  [[ -n "$file" ]] || return 0
  command nvim -- "$file" < /dev/tty > /dev/tty
}
fzf-nvim-widget() {
  zle -I
  ff
  zle reset-prompt
}
zle -N fzf-nvim-widget
bindkey '^F' fzf-nvim-widget

# zoxide
eval "$(zoxide init zsh)"

#bat
alias cat="bat"

# pnpm
if [[ "$OSTYPE" == darwin* ]]; then
  export PNPM_HOME="${PNPM_HOME:-$HOME/Library/pnpm}"
else
  export PNPM_HOME="${PNPM_HOME:-$XDG_DATA_HOME/pnpm}"
fi
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Added by LM Studio CLI (lms)
export PATH="$PATH:$HOME/.lmstudio/bin"

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
if [ -f "$HOME/.zsh-workrc" ]; then
  source "$HOME/.zsh-workrc"
fi


# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun completions
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# OpenAI shrc (if customising, comment out to prevent it getting readded)
for file in "$HOME/.openai/shrc"/*(N); do
    [[ ! -f "$file" ]] || source "$file"
done
# Override API_REPO_PATH in ~/.zsh-workrc on machines with another checkout.
export API_REPO_PATH="${API_REPO_PATH:-$HOME/code/openai/api}"
[[ ! -r "$HOME/.api_shell_include" ]] || source "$HOME/.api_shell_include"
[[ ! -r "$API_REPO_PATH/applied-devtools/completions/applied_completions.zsh" ]] || source "$API_REPO_PATH/applied-devtools/completions/applied_completions.zsh"

# Optional per-machine settings and personal aliases (never tracked).
[[ ! -r "$HOME/.zshrc.local" ]] || source "$HOME/.zshrc.local"
