#* -*- sh -*-
# 基本設定 {{{1
setopt auto_cd # cdを自動挿入
setopt auto_pushd # pushdを自動で行う
setopt pushd_ignore_dups # 重複するディレクトリは保存しない
setopt correct # command correct edition before each completion attempt
setopt list_packed # 補完候補を表示するときにつめて表示
setopt noautoremoveslash # no remove postfix slash of command line
setopt nolistbeep # no beep sound when complete list displayed
setopt nonomatch # no match *
setopt prompt_subst
setopt print_eight_bit #日本語ファイル名等8ビットを通す
setopt extended_glob # 拡張グロブで補完(~とか^とか。例えばless *.txt~memo.txt ならmemo.txt 以外の *.txt にマッチ)

zmodload -i zsh/complist
autoload -Uz compinit && compinit

#bindkey "^[u" undo
#bindkey "^[r" redo

umask 022
export WORDCHARS="*?_-.[]~&;!#$%^(){}<>" # 単語に引っかからない記号を定義

path=/usr/local:/usr/local/sbin:/usr/sbin:/bin:/sbin:/usr/local/bin:/usr/bin:
# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH
source $HOME/.nvm/nvm.sh
export HOMEBREW_NO_ENV_FILTERING=1
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export LANG=ja_JP.UTF-8
export EDITOR=vim

# zsh
export ZSHPATH=$HOME/.zsh/bin
export PATH="$ZSHPATH:$PATH"

# Go
export GOPATH=$HOME/git
export PATH="$GOPATH/bin:$PATH"

# Python
#export PYENV_ROOT="$HOME/.pyenv"
#export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init -)"

# Ruby
#export RBENV_ROOT="$HOME/.rbenv"
#export PATH="$RBENV_ROOT/bin:$PATH"
#eval "$(rbenv init - zsh)"

# anyenv
#export ANYENVPATH=$HOME/.anyenv
#export PATH="$ANYENVPATH/bin:$PATH"
#eval "$(anyenv init - zsh)"

# dotnet
#export PATH="/Library/Frameworks/Mono.framework/Commands:/Applications/Visual Studio.app/Contents/Resources:/Applications/Visual Studio.app/Contents/MacOS:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:~/.dotnet/tools:/usr/local/share/dotnet:/usr/local/share/dotnet/:$PATH"

case ${UID} in
0)
  LANG=C
  ;;
esac

#====================================================================
##  History
#====================================================================
HISTFILE=${HOME}/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt hist_ignore_dups # 直前のコマンドと同じ場合、履歴に追加しない
setopt share_history # share command history data
setopt extended_history # 履歴に日付も入れる
which git &> /dev/null && [ -f ~/.zsh/git-completion.bash ] && source ~/.zsh/git-completion.bash
[ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f ~/.zsh/zsh_`uname` ] && source ~/.zsh/zsh_`uname`
# 色設定 {{{1
autoload -Uz colors
colors
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# 色設定
#if [ -f ~/.dir_colors ]; then
#    eval `dircolors -b ~/.dir_colors`
#fi

# キーバインド設定 {{{1
bindkey -e
bindkey "^[[1~" beginning-of-line # Home gets to line head
bindkey "^[[4~" end-of-line # End gets to line end
bindkey "^[[3~" delete-char # Del

# historical backward/forward search with linehead string binded to ^P/^N
#
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end
bindkey "^?"  backward-delete-char
bindkey "^H"  backward-delete-char
bindkey "^[[3~" delete-char
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# reverse menu completion binded to Shift-Tab
#
bindkey "\e[Z" reverse-menu-complete
bindkey "^@" zaw-history

# awscli
complete -C aws_completer aws

# Alias設定 {{{1
alias ls="ls -color"
alias du='du -h'
alias df='df -h'
alias su='su -l'
alias l='ls -F'
alias ll='l -ltr'
alias la='ll -a'
alias em='emacsclient -c'
alias g='git'
alias u='cd ..'
alias uu='cd ../..'
alias uuu='cd ../../..'
alias uuuu='cd ../../../..'
alias be='bundle exec'
alias less='less -gj10R'
alias gs='git status'
alias gd='git diff'
alias gb='git branch'
alias gba='gb -a'
alias gbr='gb -r'
alias gg='git graph'
alias gga='git graphall'
alias ggat='git graphallt'
alias grv='git remote -v'
alias gs='git status'
alias gf='git fetch -p'
alias reload='exec /bin/zsh -l'

alias -g T='| tail'
alias -g H='| head'
alias -g L='| less'
alias -g G='| grep'
alias -g W='| wc -l'
alias -g R='| readlog -f ip,url,date,g'

# Unicode変換
alias -g Uni='| nkf -W -w32B0 | xxd -ps -c4 | sed "s/^0*//"'

# Prompt設定{{{1
TERM=xterm-256color
[ -f ~/.zsh/zsh_prompt ] && source ~/.zsh/zsh_prompt
DEFAULT_USERNAME='yuukiyo'

zstyle ':completion:*' verbose yes
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*:descriptions' format $YELLOW'completing %B%d%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
# グループ名に空文字列を指定すると，マッチ対象のタグ名がグループ名に使われる。
# したがって，すべての マッチ種別を別々に表示させたいなら以下のようにする
zstyle ':completion:*' group-name ''

# 関数設定 {{{1
function extract() {
  case $1 in
      *.tar.gz|*.tgz) tar xzvf $1;;
      *.tar.xz) tar Jxvf $1;;
      *.zip) unzip $1;;
      *.lzh) lha e $1;;
      *.tar.bz2|*.tbz) tar xjvf $1;;
      *.tar.Z) tar zxvf $1;;
      *.gz) gzip -dc $1;;
      *.bz2) bzip2 -dc $1;;
      *.Z) uncompress $1;;
      *.tar) tar xvf $1;;
      *.arj) unarj $1;;
    esac
}
alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=extract

function description() {
    ls -ltrF
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
        local git_status=""
        git_status=$(git status -s)
        if [ "$git_status" != "" ]; then
            echo
            echo -e "\e[0;33m--- git status ---\e[0m"
            echo "$git_status"
        fi
    fi
}

function chpwd() {
    description
}

function color256(){
    for code in {000..255}
    do
        print -nP -- "%F{$code}$code %f"
        [ $((${code} % 16)) -eq 15 ] && echo
    done
}

function peco-history-selection() {
    BUFFER=`history -n 1 | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N peco-history-selection
bindkey '^r' peco-history-selection

function peco-find() {
    files=$((find . -type f ! -regex ".*\.git.*") | peco | tr '\n' ' ')
    if [ -n "$files" ]; then
        BUFFER="$LBUFFER $files"
    fi
    zle clear-screen
}

zle -N peco-find
bindkey '^[y' peco-find

# z plugin {{{2
autoload -Uz is-at-least

# zmv
autoload -Uz zmv
alias zmv='noglob zmv -W'
# }}}1

export AWS_DEFAULT_REGION=ap-northeast-1
