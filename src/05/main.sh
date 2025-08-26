#!/bin/bash 

source ./check.sh
source ./func.sh

start_ts=$(date +%s.%N)

DIR="$1"
check "$DIR" 
info "$DIR"

