##################################################
# Linux用の設定ファイル
##################################################
alias ls="ls --color"
alias -g R='| readlog -f ip,url,date,g'

# 色設定
if [ -f ~/.dir_colors ]; then
    eval `dircolors -b ~/.dir_colors`
fi

PATH=/home/y/bin64:/home/y/bin:$PATH
CDPATH=.:/home/y/logs:/home/y

# tmuxのセッションが切れた時にssh出来ない問題を削除する用に変更
if [ ! -r "$HOME/.ssh/auth_sock" -a -z "$YROOT_NAME" ] ; then
    if [ "$SSH_AUTH_SOCK" -a "$SSH_AUTH_SOCK" != "$HOME/.ssh/auth_sock" ]; then
        ln -fs $SSH_AUTH_SOCK $HOME/.ssh/auth_sock
    fi
fi
export SSH_AUTH_SOCK=$HOME/.ssh/auth_sock

# オラクル設定 safety
# export ORACLE_HOME="/home/y/lib64/ora11gclient"
# export TNS_ADMIN="/home/y/conf/oracle"
# export NLS_DATE_FORMAT="YYYY-MM-DD"
# export NLS_LANG="Japanese_Japan.AL32UTF8"
# export LD_LIBRARY_PATH="/home/y/lib64/ora11gclient/"
