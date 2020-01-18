#!/bin/sh -e
dl() {
    mkdir -p "$PWD/cache"
    cd "$PWD/cache"
    curl -OL "$1"
    cd ..
}
extract() {
    file="$CACHE/$(echo "$1" | rev | cut -d'/' -f1 | rev)"
    if echo "$file" | grep '\.zip$'; then
        unzip "$file"
    fi
    if echo "$file" | grep -E '\.tar$|\.tar\.xz$|\.tar\.gz$|\.tar\.lz4$|\.tar.bz2$'; then
        tar -xf "$file"
    fi
}
prebuild() {
    if [ $(ls | wc -l) -eq 1 ]; then
        cd ./*
    fi
}

. pkgs/"$1"

if ! [ -f "$CACHE/$(echo "$source" | rev | cut -d'/' -f1 | rev)" ]; then
    dl "$source"
fi

if [ -e "$sha512" ]; then
    echo "checksum not found"
    exit 1
fi

cd "$CACHE"
if ! echo "$sha512" | sha512sum -c -; then
    echo "checksum does not match"
    exit 1
fi

echo extracting
cd "$BUILD"
extract "$source"

echo building
cd "$BUILD"
prebuild
build

find "$DESTDIR" -type f

printf "Do you want to continue? [y/n] "
read -r yes
if ! [ "$yes" = "y" ]; then
    exit 0
fi

cd "$DESTDIR"
tar -cJf "$ROOT/$1".tar.xz .
