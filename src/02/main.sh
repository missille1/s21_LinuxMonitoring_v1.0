#!/bin/bash

. ./func.sh

out="$(printinfo)"
printf '%s\n' "$out"
question "$out" # out передаем в $1

