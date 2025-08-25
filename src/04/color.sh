#!/bin/bash

color_letters() {
    case "$1" in 
        1) echo 37 ;; 2) echo 31 ;; 3) echo 32 ;; # ANSI color
        4) echo 34 ;; 5) echo 35 ;; 6) echo 30 ;;
    esac
}

color_background() {
    case "$1" in
        1) echo 47 ;; 2) echo 41 ;; 3) echo 42 ;;
        4) echo 44 ;; 5) echo 45 ;; 6) echo 40 ;;
    esac 
}

paint() {
    local cb cl
    cb=$(color_background "$1"); cl=$(color_letters "$2")
    # \e[\e - начало и конец,s переменные (фон, цвет бук., сам текст),m конец SRG,[0m сброс цвета в дефолт
    printf '\e[%s;%sm%s\e[0m' "$cb" "$cl" "$3"
}

print_text() {
    local label="$1" value="$2" color1="$3" color2="$4" color3="$5" color4="$6"

    printf '%s = %s\n' \
        "$(paint "$color1" "$color2" "$label")" \
        "$(paint "$color3" "$color4" "$value")"
}

# получаем имена цветом из цифр .conf
color_name() {
    case "$1" in
        1) echo "white" ;;
        2) echo "red" ;;
        3) echo "green" ;;
        4) echo "blue" ;;
        5) echo "purple" ;;
        6) echo "black" ;;
    esac
}

print_scheme_line() {
    local title="$1" num="$2" is_def="$3"
    local name; name=$(color_name "$num")
    if [[ "$is_def" -eq 1 ]]; then
        printf '%s = default (%s)\n' "$title" "$name"
    else
        printf '%s = %s (%s)\n' "$title" "$num" "$name"
    fi
}

apply_color_defaults() {

    # defaults colors
    default_color1_cb=6 # black
    default_color1_cl=1 # white
    default_color2_cb=2 # red
    default_color2_cl=4 # blue

    # цвет фона первой колонки
    if ! [[ -v column1_background ]]; then
        column1_background="$default_color1_cb"
        is_def_color1_cb=1
    elif [ "$column1_background" = "" ]; then
        column1_background="$default_color1_cb"
        is_def_color1_cb=1
    else
        is_def_color1_cb=0
    fi

    # цвет шрифта первой колонки
    if ! [[ -v column1_letter_color ]]; then
        column1_letter_color="$default_color1_cl"
        is_def_color1_cl=1
    elif [ "$column1_letter_color" = "" ]; then
        column1_letter_color="$default_color1_cl"
        is_def_color1_cl=1
    else
        is_def_color1_cl=0
    fi

    # цвет фона второй колонки
    if ! [[ -v column2_background ]]; then
        column2_background="$default_color2_cb"
        is_def_color2_cb=1
    elif [ "$column2_background" = "" ]; then
        column2_background="$default_color2_cb"
        is_def_color2_cb=1
    else
        is_def_color2_cb=0
    fi

    # цвет фона второй колонки
    if ! [[ -v column2_letter_color ]]; then
        column2_letter_color="$default_color2_cl"
        is_def_color2_cl=1
    elif [ "$column2_letter_color" = "" ]; then
        column2_letter_color="$default_color2_cl"
        is_def_color2_cl=1
    else
        is_def_color2_cl=0
    fi
}