#!/bin/bash

TRIES=3

for file in "$(dirname "$0")/queries"/*.sql; do
    sync
#    echo 3 | sudo tee /proc/sys/vm/drop_caches

    query="$(cat "$file")"
    cli_params=()
    cli_params+=("-c")
    cli_params+=(".timer on")
    for i in $(seq 1 $TRIES); do
      cli_params+=("-c")
      cli_params+=("${query}")
    done;
    duckdb rtabench.db "${cli_params[@]}"
done;
