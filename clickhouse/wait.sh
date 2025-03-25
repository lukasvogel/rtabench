while true
do
    clickhouse-client --query "SELECT 1" && break
    sleep 1
done
