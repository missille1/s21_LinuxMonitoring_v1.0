#!/bin/bash 

source ./check.sh
source ./func.sh

start_time=$(date +%s.%N)

DIR="$1"
check "$DIR" 
info "$DIR"

print_exec_time "$start_time"


