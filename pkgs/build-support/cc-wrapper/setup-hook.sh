export NIX_CC=@out@

addCVars () {
    if [ -d $1/include ]; then
        export NIX_CFLAGS_COMPILE+=" ${ccIncludeFlag:--isystem} $1/include"
    fi

    if [ -d $1/lib64 -a ! -L $1/lib64 ]; then
        export NIX_LDFLAGS+=" -L$1/lib64"
    fi

    if [ -d $1/lib ]; then
        export NIX_LDFLAGS+=" -L$1/lib"
    fi

    if test -d $1/Library/Frameworks; then
        export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -F$1/Library/Frameworks"
    fi
}

envHooks+=(addCVars)

# Note: these come *after* $out in the PATH (see setup.sh).

if [ -n "@cc@" ]; then
    addToSearchPath _PATH @cc@/bin
fi

if [ -n "@binutils_bin@" ]; then
    addToSearchPath _PATH @binutils_bin@/bin
fi

if [ -n "@libc_bin@" ]; then
    addToSearchPath _PATH @libc_bin@/bin
fi

if [ -n "@coreutils_bin@" ]; then
    addToSearchPath _PATH @coreutils_bin@/bin
fi

if [ -z "$crossConfig" ]; then
    export CC=@real_cc@
    export CXX=@real_cxx@
else
    export BUILD_CC=@real_cc@
    export BUILD_CXX=@real_cxx@
fi
