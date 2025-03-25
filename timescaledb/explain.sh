#!/bin/bash

for file in "$(dirname "$0")/queries"/*.sql; do
    echo "\n$file\n"

    query="$(cat "$file")"
    # We echo the query without any line breaks
    echo "$(tr '\n' ' ' < "$file" | tr -s " ")"
    sudo -u postgres psql --dbname=test --no-psqlrc --tuples-only --command "EXPLAIN (analyze, buffers) $query"
done
