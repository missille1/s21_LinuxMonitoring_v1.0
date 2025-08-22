#!/bin/bash

. ./check.sh
. ./color.sh
. ./func.sh

# $@ - "S1", "S2" ...
param "$@"      # проверка ввода
info            # собрать данные
print "$@"      # вывести с цветами