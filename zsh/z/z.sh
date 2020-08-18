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
# setopt globdots # 明確なドットの指定なしで.から始まるファイルをマッチ
watch="all"
## Completion configuration
autoload -Uz compinit
compinit

bindkey "^[u" undo
bindkey "^[r" redo

umask 022
export WORDCHARS="*?_-.[]~&;!#$%^(){}<>" # 単語に引っかからない記号を定義

PATH=/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin

#====================================================================
##  History
#====================================================================
HISTFILE=${HOME}/.zsh/zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt hist_ignore_dups # 直前のコマンドと同じ場合、履歴に追加しない
setopt share_history # share command history data
setopt extended_history # 履歴に日付も入れる

# 環境依存ファイルの読み込み {{{1
[ -f ~/.zsh/git-completion.bash ] && source ~/.zsh/git-completion.bash
[ -f ~/.zsh/zsh_local ] && source ~/.zsh/zsh_local
[ -f ~/.zsh/zaw/zaw.zsh ] && source ~/.zsh/zaw/zaw.zsh
[ -f ~/.zsh/zsh_`uname` ] && source ~/.zsh/zsh_`uname`
# 色設定 {{{1
autoload -Uz colors
colors

local BLACK=$'%{\e[0;30m%}'
local RED=$'%{\e[0;31m%}'
local GREEN=$'%{\e[0;32m%}'
local BROWN=$'%{\e[0;33m%}'
local BLUE=$'%{\e[0;34m%}'
local PURPLE=$'%{\e[0;35m%}'
local CYAN=$'%{\e[0;36m%}'
local LIGHT_GRAY=$'%{\e[0;37m%}'
local DARK_GRAY=$'%{\e[1;30m%}'
local LIGHT_RED=$'%{\e[1;31m%}'
local LIGHT_GREEN=$'%{\e[1;32m%}'
local YELLOW=$'%{\e[1;33m%}'
local LIGHT_BLUE=$'%{\e[1;34m%}'
local LIGHT_PURPLE=$'%{\e[1;35m%}'
local LIGHT_CYAN=$'%{\e[1;36m%}'
local WHITE=$'%{\e[1;37m%}'
local DEFAULT=$'%{\e[1;m%}'

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

TERM=xterm-256color

# Prompt設定{{{1
[ -f ~/.zsh/git-prompt.sh ] && source ~/.zsh/git-prompt.sh # Git Prompt
local BRANCH='$(__git_ps1 "%s ")'

case ${UID} in
0)
  PROMPT="${LIGHT_PURPLE}%* ${LIGHT_BLUE}${USER} %(!.#.>) ${reset_color}"
  RPROMPT="[%~]"
  SPROMPT="%B%{${fg[blue]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
  ;;
*)
  PROMPT="${LIGHT_PURPLE}%* ${LIGHT_GRAY}%m %(!.#.>) "
  PROMPT2="%{${fg[cyan]}%}%_%%%{${reset_color}%}"
  RPROMPT="${BRANCH}${LIGHT_PURPLE}[%~]${LIGHT_GRAY}"
  SPROMPT="%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
  ;;
esac

zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format $YELLOW'completing %B%d%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
# グループ名に空文字列を指定すると，マッチ対象のタグ名がグループ名に使われる。
# したがって，すべての マッチ種別を別々に表示させたいなら以下のようにする
zstyle ':completion:*' group-name ''

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

# reverse menu completion binded to Shift-Tab
#
bindkey "\e[Z" reverse-menu-complete
bindkey "^@" zaw-history

# Alias設定 {{{1
alias du='du -h'
alias df='df -h'
alias su='su -l'
alias l='ls -F'
alias ll='l -ltr'
alias la='ll -a'
alias vi='vim'
alias em='emacs'
alias g='git'
alias u='cd ..'
alias uu='cd ../..'
alias uuu='cd ../../..'
alias uuuu='cd ../../../..'
alias be='bundle exec'
alias less='less -gj10R'
alias grv='git remote -v'
alias gs='git status'
alias gd='git diff'
alias gb='git branch'
alias gba='gb -a'
alias gbr='gb -r'
alias reload='exec /bin/zsh -l'

alias -g T='| tail'
alias -g H='| head'
alias -g L='| less'
alias -g G='| grep'
alias -g W='| wc -l'
alias -g V='| vim -R -'

# 関数設定 {{{1
function mkcd() {
    if [ -d $1 ]; then
        cd $1
    else
        mkdir -p $1
        cd $1
    fi
}

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

chpwd() {
    ls_abbrev
}
ls_abbrev() {
    # -a : Do not ignore entries starting with ..
    # -C : Force multi-column output.
    # -F : Append indicator (one of */=>@|) to entries.
    local cmd_ls='ls'
    local -a opt_ls
    opt_ls=('-ltrF' '--color=always')
    case "${OSTYPE}" in
        freebsd*|darwin*)
            if type gls > /dev/null 2>&1; then
                cmd_ls='gls'
            else
                # -G : Enable colorized output.
                opt_ls=('-ltrF')
            fi
            ;;
    esac

    local ls_result
    ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')

    local ls_lines=$(echo "$ls_result" | wc -l | tr -d ' ')

    if [ $ls_lines -gt 20 ]; then
        echo "$ls_result" | head -n 5
        echo '...'
        echo "$ls_result" | tail -n 15
        echo "$ls_lines files exist"
    else
        echo "$ls_result"
    fi
}

function do_enter() {
    if [ -n "$BUFFER" ]; then
        zle accept-line
        return 0
    fi
    echo
    ls -ltrF
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
        echo
        echo -e "\e[0;33m--- git status ---\e[0m"
        git status -sb
    fi
    zle reset-prompt
    return 0
}
zle -N do_enter
bindkey '^j' do_enter

autoload -Uz is-at-least

# Treat hook functions as array
typeset -ga chpwd_functions
typeset -ga precmd_functions
typeset -ga preexec_functions

# Simulate hook functions for older versions
if ! is-at-least 4.2.7; then
  function chpwd() { local f; for f in $chpwd_functions; do $f; done }
  function precmd() { local f; for f in $precmd_functions; do $f; done }
  function preexec() { local f; for f in $preexec_functions; do $f; done }
fi

function load-if-exists() { test -e "$1" && source "$1" }

# z - jump around {{{2
# https://github.com/rupa/z
_Z_CMD=j
_Z_DATA=~/.z
if is-at-least 4.3.9; then
  load-if-exists .zsh/z/z.sh
else
  _Z_NO_PROMPT_COMMAND=1
  load-if-exists .zsh/z/z.sh && {
    function precmd_z() {
      _z --add "$(pwd -P)"
    }
    precmd_functions+=precmd_z
  }
fi
test $? || unset _Z_CMD _Z_DATA _Z_NO_PROMPT_COMMAND

# }}}1

# vim:fdm=marker:fdc=3:fdl=0
