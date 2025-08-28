#!/bin/bash

info() {
  local DIR="$1"
  folders_total "$DIR"
  top5_folders "$DIR"
  files_total "$DIR"
  files_type "$DIR"
  top10_files "$DIR"
  top10_execs "$DIR"
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

files_total() {
    local DIR="$1"
    files_total=$(find "$DIR" -mindepth 1 -type f 2>/dev/null | wc -l)
    echo "Total number of files = $files_total"
}

files_type() {
    local DIR="$1"

    conf=$(find "$DIR" -mindepth 1 -type f -iname '*.conf' 2>/dev/null | wc -l)

    log=$(find "$DIR" -mindepth 1 -type f -iname '*.log' 2>/dev/null | wc -l)

    exec=$(find "$DIR" -mindepth 1 -type f -executable 2>/dev/null | wc -l)

    symlink=$(find "$DIR" -mindepth 1 -type l 2>/dev/null | wc -l)

    archive=$(find "$DIR" -mindepth 1 -type f \
        \( -iname '*.zip' -o -iname '*.tar' -o -iname '*.tgz' \
        -o -iname '*.rar' -o -iname '*.7z' -o -iname '*.gz' \
        -o -iname '*.deb' -o -iname '*.tar.gz' -o -iname '*.tar.xz' \) \
        2>/dev/null | wc -l)

    txt=$(find "$DIR" -mindepth 1 -type f -iname '*.txt' 2>/dev/null | wc -l)

    echo "Number of:"
    echo "Configuration files (with the .conf extension) = $conf"
    echo "Text files = $txt"
    echo "Executable files = $exec"
    echo "Log files (with the extension .log) = $log"
    echo "Archive files = $archive"
    echo "Symbolic links = $symlink"
}

top10_files() {
    local DIR="$1"

    echo "TOP 10 files of maximum size arranged in descending order (path, size and type):"
    # add maxdepth 1 если только по этому каталогу
    top10=$(find "$DIR" -mindepth 1 -type f -print0 2>/dev/null \
        | du -h --files0-from=- 2>/dev/null \
        | sort -hr \
        | head -n 10)

    if [ -z "$top10" ]; then
    echo "(no files)"
    return
    fi

    i=1
    while IFS=$'\t' read -r size path; do
        [ -z "$size" ] && continue
        # обрезаем все до name.log
        base="${path##*/}" 
        # обрезаем все до .log 
        if [[ "$base" == *.* ]]; then
            ext="${base##*.}"
        else
            ext="-"
        fi
        printf "%d - %s, %s, %s\n" "$i" "$path" "$size" "$ext"
        i=$((i+1))
    done <<< "$top10"
}

top10_execs() {
    local DIR="$1"
    
    echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file):"

    top10=$(
    find "$DIR" -mindepth 1 -type f -executable -print0 2>/dev/null \
      | du -h --files0-from=- 2>/dev/null \
      | sort -hr \
      | head -n 10)
    
    if [ -z "$top10" ]; then
        echo "(no executable files)"
        return
    fi

    local i=1 hash
    while IFS=$'\t' read -r size path; do 
        [ -z "$size" ] && continue

        if command -v md5sum >/dev/null 2>&1; then
            hash=$(md5sum "$path" | awk '{print $1}')
        else
            hash="md5-not-available"
        fi

        printf "%d - %s, %s, %s\n" "$i" "$path" "$size" "$hash"
        i=$((i+1))
    done <<< "$top10"
}

print_exec_time() {
    local start="$1"
    
    end=$(date +%s.%N)
    # найдем разницу концом и стартом и оставим 3 знака после .
    dur=$(awk -v s="$start" -v e="$end" 'BEGIN{printf "%.3f", e - s }')
    echo "Script execution time (in seconds) = $dur"
}