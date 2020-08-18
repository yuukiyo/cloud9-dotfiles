if [ -f /etc/bashrc ]; then
    source /etc/bashrc
fi

if [ -f /bin/zsh ]; then
    exec /bin/zsh
fi
