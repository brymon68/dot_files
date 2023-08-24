function fzf-tmux-vim
    set -l selected_file (fd --type f --exclude Pictures --exclude venv --exclude node_modules --exclude .git | fzf)
    echo "BRUHHHH w"
    if test -n "$selected_file"
        tmux send-keys -t 0 "vim $selected_file" C-m
    end
end
