#!/bin/bash

set -euo pipefail

# echo "$UNSET"        # -u: упадёт — переменная не задана

# false | true         # с pipefail: скрипт завершится с ошибкой

if grep foo file; then  # -e не сработает на grep, т.к. это условие
  echo found
fi