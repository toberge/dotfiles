#!/usr/bin/env bash

# stand in .dotfiles and run
# . _setup/update_readme.sh

for dir in $(ls -F . | grep -E '^[^_].+/$')
do
    echo $dir
    pushd "$dir"
    [[ -f README.md ]] && {
        start=$(grep -n '^\.$' README.md | cut -d':' -f1)
        end=$(cat -n README.md | grep '```' | tail -n 1 | awk '{print $1}')
        lines=$(cat README.md | wc -l)

        # Store last part of README
        tail -n $(( $lines - $end + 1 )) README.md > /tmp/ending
        # Rebuild README
        head -n $(( $start - 1 )) README.md | tee README.md
        tree -a --noreport -I 'README.md' . >> README.md
        cat /tmp/ending >> README.md
    } || echo 'no readme here'
    popd
done


