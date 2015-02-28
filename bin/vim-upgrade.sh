#!/bin/sh

case $1 in
    i*) vim +BundleInstall +BundleClean! +qall ;;
    u*)
        cd $HOME/.spf13-vim-3
        git pull
        vim +BundleInstall +BundleUpdate +BundleClean! +qall ;;
    *) echo "usage: `basename $0` {install|update}" ;;
esac
