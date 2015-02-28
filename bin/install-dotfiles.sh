#!/bin/bash

dt=`date +%Y%m%d-%H%M`

cd $HOME
[ ! -d ~/.dotfiles.$dt ] && mkdir ~/.dotfiles.$dt
[ ! -d ~/.dotfiles.$dt/.ssh ] && mkdir ~/.dotfiles.$dt/.ssh

git submodule init
git submodule update

(cd ~/.dotfiles/spf13-vim; ./bootstrap.sh)

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

for i in $dots; do
    [ -e $i ] && mv $i .dotfiles.$dt
done

for i in $dots; do
    ln -s .dotfiles/$i .
done

if [ -d ~/bin ]; then
    cd ~/bin
    ln -s ~/.dotfiles/bin/{git-hscope,haskell-install.sh} .
    cd -
fi

# configure bash
cat << EOF >> ~/.bashrc

shopt -s extglob

GIT_PROMPT_ONLY_IN_REPO=1
. ~/.dotfiles/bash-git-prompt/gitprompt.sh

EOF

