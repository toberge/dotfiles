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

        # Store first and last part of README
        head -n $(( $start - 1 )) README.md > /tmp/beginning
        tail -n $(( $lines - $end + 1 )) README.md > /tmp/ending
        # Rebuild README
        rm README.md
        cat /tmp/beginning > README.md
        # Ignore README and Emacs temp files when building tree
        tree -a --noreport -I 'README.md|#*#' . >> README.md
        cat /tmp/ending >> README.md
    } || echo 'no readme here'
    popd
done


