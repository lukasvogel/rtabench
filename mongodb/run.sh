#!/bin/bash

TRIES=3

for file in "$(dirname "$0")/queries"/*.js; do
    sync
    echo 3 | sudo tee /proc/sys/vm/drop_caches >/dev/null

    query="$(cat "$file")"
    echo "$(tr '\n' ' ' < "$file" | tr -s " ")"
    for i in $(seq 1 $TRIES); do
        mongosh 'mongodb://localhost:27017/test' "$file"
    done
done;
