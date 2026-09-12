# Shared interactive Bash/Zsh setup. No macOS-only commands or dependencies.
case $- in *i*) ;; *) return ;; esac
export PATH="$HOME/.local/bin:$PATH"
export EDITOR=nvim
export STARSHIP_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--layout=reverse --height=50%'

# Read NUL-delimited filenames without losing embedded or trailing newlines.
ff() {
  local file source='fd --type f --hidden --exclude .git --print0'
  local header='Enter: open in nvim'
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    source='git ls-files --cached -z'
    header='Tracked files | Ctrl-U: include untracked files | Enter: open in nvim'
  fi
  IFS= read -r -d '' file < <(
    FZF_DEFAULT_COMMAND="$source" fzf < /dev/tty \
      --read0 --print0 --no-multi --scheme=path --prompt='Files > ' \
      --header="$header" --query="$*" \
      --bind='ctrl-u:change-header(All non-ignored files | Enter: open in nvim)+reload(fd --type f --hidden --exclude .git --print0)'
  ) || return 0
  [ -n "$file" ] || return 0
  command nvim -- "$file" < /dev/tty > /dev/tty
}

if [ -n "${ZSH_VERSION:-}" ]; then
  # Ubuntu's fzf predates `fzf --zsh`; use its packaged integration.
  [ ! -r /usr/share/doc/fzf/examples/key-bindings.zsh ] || . /usr/share/doc/fzf/examples/key-bindings.zsh
  fzf-nvim-widget() {
    zle -I
    ff
    zle reset-prompt
  }
  zle -N fzf-nvim-widget
  bindkey -M emacs '^F' fzf-nvim-widget
  bindkey -M viins '^F' fzf-nvim-widget
  command -v starship >/dev/null && eval "$(starship init zsh)"
elif [ -n "${BASH_VERSION:-}" ]; then
  [ ! -r /usr/share/doc/fzf/examples/key-bindings.bash ] || . /usr/share/doc/fzf/examples/key-bindings.bash
  bind -m emacs-standard -x '"\C-f":ff'
  bind -m vi-insert -x '"\C-f":ff'
  command -v starship >/dev/null && eval "$(starship init bash)"
fi
