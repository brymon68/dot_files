
set PATH /Users/bryce.montano/.nvm/versions/node/v18.0.0/bin:/Users/bryce.montano/.local/bin:/opt/homebrew/bin:/Users/bryce.montano/.cargo/bin:/usr/local/bin/nvim-macos/bin/:/opt/homebrew/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Users/bryce.montano/.cargo/bin:/opt/homebrew/opt/fzf/bin:$HOME/.docker/bin $PATH

eval (/opt/homebrew/bin/brew shellenv)
starship init fish | source # https://starship.rs/
complete --do-complete=dir-or-file

# set -U fish_greeting # disable fish greeting
# set -U LANG en_US.UTF-8
# set -U LC_ALL en_US.UTF-8

# set -Ux BAT_THEME Catppuccin-mocha # 'sharkdp/bat' cat clone
# set -Ux EDITOR nvim # 'neovim/neovim' text editor
# set -Ux FZF_DEFAULT_COMMAND 'fd --type f \
#   --exclude Pictures \
#   --exclude Movies \
#   --exclude venv \
#   --exclude cache \
#   --exclude .venv \
#   --exclude node_modules \
#   --exclude cache \
#   --exclude Library ' 

# set -gx FZF_CTRL_T_COMMAND 'fd --type f \
#   --exclude Pictures \
#   --exclude Movies \
#   --exclude venv \
#   --exclude cache \
#   --exclude .venv \
#   --exclude node_modules \
#   --exclude cache \
#   --exclude Library ' 


# abbr tn "tmux new -s (pwd | sed 's/.*\///g')"
