#### FIG ENV VARIABLES #### Please make sure this block is at the start of this file.  [ -s ~/.fig/shell/pre.sh ] && source ~/.fig/shell/pre.sh ### END FIG ENV VARIABLES ####

# fig
export PROMPT="
%{$fg[white]%}(%D %*) <%?> [%~] $program %{$fg[default]%}
%{$fg[cyan]%}%m %#%{$fg[default]%} "


#fzf / ripgrep
if type rg &> /dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden -g "!{node_modules/*,.git/*,build/*}" '
    export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
fi
export FZF_DEFAULT_OPTS=' -d ":" -n 2 --height 98% --ansi --preview-window "down:60%:+{2}" --preview "bat --style=numbers --color=always --highlight-line {2} {1}" --layout=reverse --border' 

export RPROMPT=

set-title() {
    echo -e "\e]0;$*\007"
}

ssh() {
    set-title $*;
    /usr/bin/ssh -2 $*;
    set-title $HOST;
}

export HISTSIZE=5000000
export HISTFILESIZE=5000000

alias bb=brazil-build
alias vim="/Users/brycesec/.local/bin/lvim"
alias bre='brazil-runtime-exec'
alias bws='brazil ws'
alias bwscreate='bws create -n'
alias brc=brazil-recursive-cmd
alias bball='brc --allPackages'
alias bbb='brc --allPackages brazil-build'
alias bbra='bbr apollo-pkg'
alias tmux='TERM=xterm-256color tmux'
alias awsdw='psql -h awsdw-rs-adhoc2.db.amazon.com -p 8192 -U brycesec -d awsdw'
export PATH=$HOME/.toolbox/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$PATH:$HOME/.local/python-3.8.3/bin
export PATH=$PATH:/usr/bin
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin/
export PATH=/usr/local/bin:$PATH
export ZSH="/Users/brycesec/.oh-my-zsh"
export RIPGREP_CONFIG_PATH="/Users/brycesec/.ripgreprc"
plugins=(git)

source $ZSH/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias logmein='mwinit --aea && ssh-add'


# opam configuration
test -r /Users/brycesec/.opam/opam-init/init.zsh && . /Users/brycesec/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

function sauron_fe_daily() {
  ada credentials update --account=784119898975 --provider=isengard --role=NpmRole  --once
  aws codeartifact login --tool npm --repository sauron --domain amazon --domain-owner 149122183214  --region us-west-2
}


#### FIG ENV VARIABLES ####
# Please make sure this block is at the end of this file.
# [ -s ~/.fig/fig.sh ] && source ~/.fig/fig.sh
#### END FIG ENV VARIABLES ####
PROMPT='%F{blue}%n%F{green} %F{yellow}$ %F{green}%~%f %F{magenta}> %{$reset_color%} '
export JAVA_TOOLS_OPTIONS="-Dlog4j2.formatMsgNoLookups=true"
