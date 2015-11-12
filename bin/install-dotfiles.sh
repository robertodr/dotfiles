#!/bin/bash

dt=`date +%Y%m%d-%H%M`

cd ~
[ ! -d ~/.dotfiles.$dt ] && mkdir ~/.dotfiles.$dt
[ ! -d ~/.dotfiles.$dt/.ssh ] && mkdir ~/.dotfiles.$dt/.ssh

read -r -d '' dots << EOF
.aliases
.bashrc
.gitconfig
.gitignore
.git-prompt-colors
.psi4rc
.qchemrc
.vim.local
.vimrc.bundles.local
.vimrc.local
EOF

install_submodules () {
  cd ~/.dotfiles
  gisubmodule init
  gisubmodule update
}

install_vim () {
  curl https://j.mp/spf13-vim3 -L -o - | sh
  vim +BundleInstall +BundleUpdate +BundleClean! +qall
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
  [ -d dist ] && rm -rf dist
  cabal update
  cabal install --only-dep
  cabal build
}

(install_submodules)
(backup_dotfiles)
(install_dotfiles)
(install_vim)
#(install_haskell_extras)
(install_ssh)
