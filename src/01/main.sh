#!/bin/bash

if [ "$#" -ne 1 ] # если n1 не равно n2
then
echo "Need only one argument, with letters"
elif [[ "$1" =~ ^[0-9]+$ ]] # ^$ - начало и конец строки для регул.
then
echo "Input only letters, no numbers"
else
echo "$1"
fi