export FZF_DEFAULT_COMMAND='fd --type f '
export FZF_DEFAULT_OPTS="--layout=reverse --height=50% --bind 'f1:execute(bat {}),ctrl-y:execute-silent(echo {} | pbcopy)+abort'"

vf() {
  IFS=$'\n' files=($(fzf --ansi --query="$1" --multi --select-1 --exit-0 ))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

bindkey -s '^F' 'vf\n'


