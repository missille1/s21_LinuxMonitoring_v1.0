#!/bin/bash

info() {

    local DIR="$1"

    # === Общее число папок === 
    folders_total=$(find "$DIR" -mindepth 1 -type d 2>/dev/null | wc -l)
    echo "Total number of folders (including all nested ones) = $folders_total"

}