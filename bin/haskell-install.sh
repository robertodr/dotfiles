#!/bin/sh

cd $HOME


chkpkg () {
    err=""
    for i in $*; do
        dpkg -s $i >/dev/null 2>&1
        [ $? != 0 ] && err="$i $err"
    done
    if [ "x$err" != "x" ]; then
        echo "*** Missing system depedencies, please install:"
        echo "$err"
        exit 1
    fi
}

cabal_update () {
    cabal update
    cabal install cabal-install
}

cabal_reset () {
    [ -e .cabal.bak ] && rm -rf .cabal.bak
    [ -e .cabal ] && mv .cabal .cabal.bak

    [ -e .ghc.bak ] && rm -rf .ghc.bak
    [ -e .ghc ] && mv .ghc .ghc.bak

    mkdir .cabal
    [ -e .cabal.bak ] && cp .cabal.bak/config .cabal
    cabal_update
}

_base () {
    cabal install alex happy
    cabal install cpphs hscolour hlint haddock
    cabal install parallel
    cabal install tasty tasty-quickcheck tasty-hunit tasty-smallcheck
}

_vim () {
    chkpkg curl libcurl4-nss-dev
    cabal install hdevtools
    cabal install ghc-mod hasktags hscope pointfree pointful hoogle
    cabal install codex stylish-haskell
}

_xmonad () {
    chkpkg libxft-dev libxinerama-dev libx11-dev libxrender-dev
    cabal install yeganesh xmonad xmonad-contrib xmonad-extras xmonad-utils
}

_web () {
    cabal install scotty
    cabal install aeson
    cabal install shakespeare blaze-html blaze-markup
    cabal install fay fay-base
}

_extras () {
    cabal install pandoc
}

case $1 in
    "reset") cabal_reset ;;
    "base") _base ;;
    "vim") _vim ;;
    "xmonad") _xmonad ;;
    "web") _web ;;
    "extras") _extras ;;
    "all")
        _base
        _vim
        _xmonad
        _web
        _extras
        ;;
    *) echo "usage: `basename $0` {reset|base|vim|xmonad|web|extras|all}" ;;
esac

