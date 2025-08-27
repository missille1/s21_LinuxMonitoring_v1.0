#!/bin/bash

info() {
  local DIR="$1"
  folders_total "$DIR"
  top5_folders "$DIR"
  files_total "$DIR"
  # files_kinds "$DIR"
  # top10_files "$DIR"
  # top10_execs "$DIR"
}

# === Общее число папок ===
folders_total() {
    local DIR="$1"
    folders_total=$(find "$DIR" -mindepth 1 -type d 2>/dev/null | wc -l)
    echo "Total number of folders (including all nested ones) = $folders_total"
}

# === Топ 5 папок с самым большим весом в порядке убывания. Путь и размер ===
top5_folders() { 
    local DIR="$1"
    echo "TOP 5 folders of maximum size arranged in descending order (path and size):"

    top5=$(du -h "$DIR" 2>/dev/null \
        | awk -v r="$DIR" '$2 != r' \
        | sort -hr \
        | head -n 5)

    if [ -z "$top5" ]; then
        echo "(no subfolderers)"
    else
        i=1
        # IFS - обработка имен с пробелами 
        while IFS=$'\t' read -r size path; do
            [ -z "$size" ] && continue
            [[ "$path" != */ ]] && path="$path/"
            printf "%d - %s, %s\n" "$i" "$path" "$size"
            i=$((i+1))
        done <<< "$top5"
    fi
}

files_total () {
    local DIR="$1"
    files_total=$(find "$DIR" -mindepth 1 -type f 2>/dev/null | wc -l)
    echo "Total number of files = $files_total"
}

