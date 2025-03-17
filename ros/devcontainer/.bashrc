if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

source /opt/ros/humble/setup.bash
eval "$(starship init bash)"