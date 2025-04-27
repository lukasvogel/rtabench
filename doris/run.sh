#!/bin/bash

TRIES=3

for file in "$(dirname "$0")/queries"/*.sql; do
    sync

    query="$(cat "$file")"

    # We echo the query without any line breaks
    echo "$(tr '\n' ' ' < "$file" | tr -s " ")"
    for i in $(seq 1 $TRIES); do
        mysql -vvv -P 9030 -h 127.0.0.1 -u root -D rta -e "$query"
    done;
done;
