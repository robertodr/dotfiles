PS1='%m:%~%# '
PS2='%_> '

export CLICOLOR=1

setopt nobeep histbeep complete_in_word auto_pushd pushd_minus
setopt pushd_ignore_dups extended_glob #noclobber
setopt no_bg_nice hist_ignore_dups hist_allow_clobber ignore_eof
setopt list_types no_auto_remove_slash no_notify
setopt autocd hist_verify multios

KEYTIMEOUT=1

. $HOME/.zsh/completion
. $HOME/.zsh/keybindings

fpath=($fpath ~/.zsh/functions)
autoload -U compinit
compinit -u

autoload ndir autobg
autoload autobg
#autoload statusbar; statusbar

function precmd() {
    autobg
}

if [ -f ~/.dotfiles/zsh-git-prompt/zshrc.sh ]; then
    . ~/.dotfiles/zsh-git-prompt/zshrc.sh
    PROMPT='%m$(git_super_status):%~%# '
fi

limit coredumpsize 0
umask 022

# watch=( notme )
fignore=(.o ~)

DIRSTACKSIZE=10
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=500
READNULLCMD=less

if [ -r ~/.aliases ]; then
    . ~/.aliases
fi

chpwd () {
    [[ -t 1 ]] || return
    case $TERM in
        (*xterm*|rxvt|(dt|k|E)term) print -Pn "\e]2;%n@%m %~\a"
        ;;
    esac
}
chpwd

export EDITOR=vim
export PAGER=less
export LESS=-MiSXR
[ -f ~/.bcrc ] &&  export BC_ENV_ARGS="-l $HOME/.bcrc"

command -v lesspipe >/dev/null
[ $? = 0  ] && eval "$(lesspipe)"

# load my named directories
. ~/.zsh/hash-d.rc

# make path contain _only_ unique entries
typeset -U path cdpath
# cdpath=(~)

path+=(/opt/bin ~/.cabal/bin ~/bin /usr/local/bin)

[ -f ~/.local/share/zsh/zshrc ] && . ~/.local/share/zsh/zshrc
