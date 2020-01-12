#!/bin/sh -e
rm -rf "$ROOT/temp"
cd "$DESTDIR"

tar -xf "$ROOT/$1"

if [ -d home ]; then
    cd home
    mkdir "$(whoami)"
    mv ./* ./.* "$(whoami)"/ 2> /dev/null
fi

printf "Do you want to continue? [y/n] "
read -r yes
if ! [ "$yes" = "y" ]; then
    exit 0
fi

cp -r build /
