#!/bin/bash

. ./check.sh
. ./color.sh
. ./func.sh

CONFIG_FILE="./colors.conf"

# read conf

if [[ -f "$CONFIG_FILE" ]]; then
    . "$CONFIG_FILE"
fi

apply_color_defaults  

# проверка ввода из конфига \ default
param "$column1_background" "$column1_letter_color" "$column2_background" "$column2_letter_color"  
info            # собрать данные
print "$column1_background" "$column1_letter_color" "$column2_background" "$column2_letter_color"   # вывести с цветами

echo 

print_scheme_line "Column 1 background" "$column1_background" "$is_def_color1_cb"
print_scheme_line "Column 1 font color" "$column1_letter_color" "$is_def_color1_cl"
print_scheme_line "Column 2 background" "$column2_background" "$is_def_color2_cb"
print_scheme_line "Column 2 font color" "$column2_letter_color" "$is_def_color2_cl"

# echo "DBG flags: cb1=$is_def_color1_cb lc1=$is_def_color1_cl cb2=$is_def_color2_cb lc2=$is_def_color2_cl" >&2
