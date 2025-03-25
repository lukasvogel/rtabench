#!/bin/bash
set -xeu

# Download the dataset
mkdir -p dataset
wget --no-verbose --directory-prefix=dataset --continue 'https://rtadatasets.timescale.com/customers.csv.gz'
wget --no-verbose --directory-prefix=dataset --continue 'https://rtadatasets.timescale.com/products.csv.gz'
wget --no-verbose --directory-prefix=dataset --continue 'https://rtadatasets.timescale.com/orders.csv.gz'
wget --no-verbose --directory-prefix=dataset --continue 'https://rtadatasets.timescale.com/order_items.csv.gz'
wget --no-verbose --directory-prefix=dataset --continue 'https://rtadatasets.timescale.com/order_events.csv.gz'

# Install
curl https://clickhouse.com/ | sh
sudo ./clickhouse install --noninteractive

sudo clickhouse start

./wait.sh

# Load the data
clickhouse client < create.sql #import

# using incremental MVs
clickhouse client < mat_views.sql

clickhouse client --time --query "INSERT INTO customers FROM INFILE 'dataset/customers.csv.gz'" #import
clickhouse client --time --query "INSERT INTO products FROM INFILE 'dataset/products.csv.gz'" #import
clickhouse client --time --query "INSERT INTO orders FROM INFILE 'dataset/orders.csv.gz'" #import
clickhouse client --time --query "INSERT INTO order_items FROM INFILE 'dataset/order_items.csv.gz'" #import
clickhouse client --time --query "INSERT INTO order_events FROM INFILE 'dataset/order_events.csv.gz'" #import

# Run the queries

./run.sh "$@" #results

clickhouse client --query "SELECT sum(total_bytes) FROM system.tables WHERE (name = 'orders' OR name = 'order_events' OR name = 'order_items' OR name = 'products' OR name = 'customers') and database = 'default'" #datasize

echo "Real-time Analytics" #tag
echo "Batch Analytics" #tag 
echo "ClickHouse" #name
echo "Insert" #mv_supported_capability