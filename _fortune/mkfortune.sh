#!/usr/bin/env sh

for fortune
do
    echo baking "$fortune"
    strfile "$fortune" -o "/usr/share/fortune/$fortune.dat"
    cp "$fortune" /usr/share/fortune
done

# to deal with everything:
# find . -type f -not -name "*.sh" -exec ./mkfortune.sh {} +"

