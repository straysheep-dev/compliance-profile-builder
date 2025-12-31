#!/bin/bash

# GPL-3.0 License

# This script parses all tag lists, and creates csv files ready-to-use
# with ansible-playbook by ignoring all commented lines.

TAGS_LIST=$(find ../ -maxdepth 2 -name "tags-*.txt" | awk -F'/' '{print $3}')

CreateCSV() {
    for tag_file in $TAGS_LIST;
    do
        if [[ $(grep -Pv '^(#|$)' $tag_file | wc -l | awk '{print $1}') != '0' ]]; then
            grep -Pv '^(#|$)' < "$tag_file" | tr '\n' ',' | sed 's/,$//' | tee "${tag_file%.txt}.csv" > /dev/null
            echo "[*]Creating ${tag_file%.txt}.csv..."
        fi
    done
}

CreateCSV