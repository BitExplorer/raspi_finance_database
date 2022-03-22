#!/bin/sh

date=$(date '+%Y-%m-%d')
port=5432

if [ "$OS" = "Darwin" ]; then
  server=$(ipconfig getifaddr en0)
else
  # server=$(hostname -i | awk '{print $1}')
  server=$(uname -n)
fi

if [ $# -ne 1 ] && [ $# -ne 2 ]; then
  echo "Usage: $0 [server] [port]"
  echo "$0 192.168.10.25 5432"
  exit 1
fi

if [ -n "$1" ]; then
  server=$1
fi

if [ -n "$2" ]; then
  port=$2
fi

echo "server is '$server', port is set to '$port'."
echo "Press enter to continue"
read -r x
echo "$x" > /dev/null

echo enter postgres user password to add finance_test_db objects
psql -h "${server}" -p "${port}" -d postgres -U henninb < finance_test_db-create-int.sql | tee -a "finance_test_db-create-int-${date}.log"
psql -h "${server}" -p "${port}" -d postgres -U henninb < finance_test_db-create-func.sql | tee -a "finance_test_db-create-func-${date}.log"

echo psql finance_test_db -U henninb -h "${server}" -p "${port}"

exit 0
