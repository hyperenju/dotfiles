# PATH
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$HOME/.npm-global/bin:$PATH"

# Editors and pagers
export EDITOR="/usr/bin/vim"
export VISUAL="/usr/bin/vim"
export MANPAGER='nvim +Man!'

# Workaround for https://github.com/gwsw/less/issues/709
export LESS="-g -i -M -R -S -w -X"

# Fuzzy finder
export FZF_TMUX_OPTS="-p 80%"

# History widgets
function select-history() {
  BUFFER=$(history -n -r 1 | fzf-tmux $FZF_TMUX_OPTS --no-sort +m --query "$LBUFFER" --prompt="History > ")
  CURSOR=$#BUFFER
}
zle -N select-history
bindkey '^r' select-history

function clear-history() {
    clear;
    tmux clear-history;
    zle reset-prompt;
}
zle -N clear-history
bindkey '^l' clear-history

# Manual search
function m () {
    man -wK "$1" | fzf-tmux $FZF_TMUX_OPTS --reverse --preview "man -l {1} 2>/dev/null | grep -i $1 -C 3 --color=always" | xargs man -l
}

# GNU Global search
function globalx () {
    global -x $1 | fzf-tmux $FZF_TMUX_OPTS --preview-window '~3,+{2}+3/4' --reverse --preview 'bat --color=always {3}' | awk '{system("nvim +" $2 " " $3)}'
}

function globalrx () {
    global -rx $1 | fzf-tmux $FZF_TMUX_OPTS --preview-window '~3,+{2}+3/4' --reverse --preview 'bat --color=always {3}' | awk '{system("nvim +" $2 " " $3)}'
}

alias glx=globalx
alias glrx=globalrx

# ghq navigation
function cdghq(){
    REPO=$(ghq list | fzf-tmux $FZF_TMUX_OPTS)
    if [ -z $REPO ]; then
        return 1;
    fi
    cd $HOME/ghq/$REPO
}

# Mail search
function lfind_mutt() {
  local tmpdir msgid

  tmpdir="$(mktemp -d /tmp/lei-mutt.XXXXXX)" || return 1

  msgid="$(
    lei q --sort=received --limit=1000 "$@" \
    | jq -r '
        map(select(type=="object" and .m and .dt and .s and .f))[]
        | "\(.m)\t\(.f[0][0] // .f[0][1] // "-")\t\(.dt)\t\(.s)"
      ' \
    | fzf --reverse --no-sort \
          --delimiter=$'\t' \
          --nth=3 \
          --with-nth=2,3,4 \
          --preview 'lei q m:{1} --format=text | bat --color=always --paging=never --language=Email --style=plain' \
          --preview-window=right:40% \
    | cut -f1
  )" || {
    rm -rf "$tmpdir"
    return 1
  }

  [[ -n "$msgid" ]] || {
    rm -rf "$tmpdir"
    return 1
  }

  lei q --no-save -t -o "maildir:$tmpdir" "m:$msgid" >/dev/null &&
    neomutt -f "$tmpdir"

  rm -rf "$tmpdir"
}

# Misc aliases and helpers
alias gg='git grep'
alias vmc='LD_PRELOAD=~/ghq/github.com/hyperenju/vimconfig/vimconfig.so make menuconfig'
function open () {
    xdg-open "$@" &>/dev/null &
}
