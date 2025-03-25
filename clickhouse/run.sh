#!/bin/bash

TRIES=3

for file in "$(dirname "$0")/queries"/*.sql; do
    sync
    echo 3 | sudo tee /proc/sys/vm/drop_caches >/dev/null

    query="$(cat "$file")"
    echo -n "["
    for i in $(seq 1 $TRIES); do
        RES=$(clickhouse client --host "${CLICKHOUSE_HOST:=localhost}" --password "${CLICKHOUSE_PASSWORD:=}" --time --format=Null --query="$query" --progress 0 2>&1 ||:)
        if [[ "$?" == "0" ]] && [[ "$RES" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
            echo -n "${RES}"
        else
            echo -n "-1"
        fi
        [[ "$i" != $TRIES ]] && echo -n ", "

        echo "${QUERY_NUM},${i},${RES}" >> result.csv
    done
    echo "],"

    QUERY_NUM=$((QUERY_NUM + 1))

done;

