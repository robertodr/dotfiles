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
}

install_vim () {
    cd ~/.dotfiles/spf13-vim
    # ./bootstrap.sh
    cd ~/.dotfiles
    ./bin/vim-upgrade.sh install
}

backup_dotfiles () {
    cd ~
    for i in $dots; do
        [ -e $i ] && mv $i ~/.dotfiles.$dt
    done
}

install_dotfiles () {
    cd ~
    for i in $dots; do
        ln -sf ~/.dotfiles/$i .
    done
}

install_ssh () {
    [ -e ~/.ssh/config ] && mv ~/.ssh/config ~/.dotfiles.$dt/.ssh
    if [ -d ~/.ssh ]; then
        cd ~/.ssh
        ln -sf ~/.dotfiles/.ssh/config .
    fi
}

install_haskell_extras () {
    [ -x ~/.cabal/bin/cabal ] || return
    if [ -d ~/bin ]; then
        cd ~/bin
        ln -sf ~/.dotfiles/bin/{git-hscope,haskell-install.sh} .
    fi
    cd ~/.dotfiles/zsh-git-prompt
    [ -d dist ] && rm -rf dist
    cabal update
    cabal install --only-dep
    cabal build
}

configure_bash () {
    sed -i '/#bash-git-prompt begin/,/#bash-git-prompt end/d' ~/.bashrc
    cat << EOF >> ~/.bashrc
#bash-git-prompt begin
unset __GIT_PROMPT_DIR
GIT_PROMPT_THEME="Solarized_Single_line_NoExitState"
GIT_PROMPT_ONLY_IN_REPO=1
GIT_PROMPT_FETCH_REMOTE_STATUS=0
source ~/.dotfiles/bash-git-prompt/gitprompt.sh
#bash-git-prompt end
EOF
}

(install_submodules)
(backup_dotfiles)
(install_dotfiles)
(install_vim)
(install_haskell_extras)
(configure_bash)
#(install_ssh)

