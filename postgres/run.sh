#!/bin/bash

TRIES=3

for file in "$(dirname "$0")/queries"/*.sql; do
    sync
    echo 3 | sudo tee /proc/sys/vm/drop_caches

    query="$(cat "$file")"
    # We echo the query without any line breaks
    echo "$(tr '\n' ' ' < "$file" | tr -s " ")"
    for i in $(seq 1 $TRIES); do
        sudo -u postgres psql --dbname=test --no-psqlrc --tuples-only \
            --command "\timing on" \
            --command "$query" | grep 'Time'
    done;
done;
