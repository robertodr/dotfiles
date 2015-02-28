#!/bin/bash

dt=`date +%Y%m%d-%H%M`

cd ~
[ ! -d ~/.dotfiles.$dt ] && mkdir ~/.dotfiles.$dt
[ ! -d ~/.dotfiles.$dt/.ssh ] && mkdir ~/.dotfiles.$dt/.ssh

read -r -d '' dots << EOF
.aliases
.bcrc
.codex
.ghci
.gitconfig
.gitignore
.haskeline
.vim.local
.vimrc.before.local
.vimrc.bundles.local
.vimrc.local
.zprofile
.zsh
.zshenv
.zshrc
EOF

install_submodules () {
    cd ~/.dotfiles
    git submodule init
    git submodule update
    cd ~/.dotfiles/spf13-vim
    ./bootstrap.sh
}

for i in $dots; do
    ln -s .dotfiles/$i .
done

backup_dotfiles () {
    for i in $dots; do
        [ -e $i ] && mv $i .dotfiles.$dt
    done
}

install_dotfiles () {
    for i in $dots; do
        ln -s .dotfiles/$i .
    done
}

install_haskell_extras () {
    if [ -d ~/bin ]; then
        cd ~/bin
        ln -s ~/.dotfiles/bin/{git-hscope,haskell-install.sh} .
    fi
}

configure_bash () {
    cat << EOF >> ~/.bashrc

    shopt -s extglob

    GIT_PROMPT_ONLY_IN_REPO=1
    . ~/.dotfiles/bash-git-prompt/gitprompt.sh

EOF
}

(backup_dotfiles)
(install_submodules)
(install_dotfiles)
(install_haskell_extras)
(configure_bash)

