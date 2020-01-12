#!/bin/sh -e
ROOT="$PWD"

DESTDIR="$PWD/dest"
rm -rf "$DESTDIR"
mkdir dest

BUILD="$PWD/build"
rm -rf "$BUILD"
mkdir build

CACHE="$PWD/cache"

help() {
    echo "usage: pm.sh build"
    echo "       pm.sh install"
}

if [ "$1" = "build" ]; then
    shift
    . "$ROOT/build.sh" "$1"
elif [ "$1" = "install" ]; then
    shift
    . "$ROOT/install.sh" "$1"
elif [ "$1" = -h ]; then
    help
    exit 0
else
    help
    exit 1
fi
