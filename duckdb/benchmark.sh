#!/bin/bash

sudo apt-get update

#Download the dataset
wget --no-verbose --continue 'https://rtadatasets.timescale.com/customers.csv.gz'
wget --no-verbose --continue 'https://rtadatasets.timescale.com/products.csv.gz'
wget --no-verbose --continue 'https://rtadatasets.timescale.com/orders.csv.gz'
wget --no-verbose --continue 'https://rtadatasets.timescale.com/order_items.csv.gz'
wget --no-verbose --continue 'https://rtadatasets.timescale.com/order_events.csv.gz'
gzip -d customers.csv.gz products.csv.gz orders.csv.gz order_items.csv.gz order_events.csv.gz
sudo chmod og+rX ~
chmod 777 customers.csv products.csv orders.csv order_items.csv order_events.csv
mkdir -p dataset
mv *.csv dataset/

# Install
sudo apt-get update
sudo apt-get install -y unzip

curl --fail --location --output duckdb_cli-linux-amd64.zip https://github.com/duckdb/duckdb/releases/download/v1.2.0/duckdb_cli-linux-amd64.zip && unzip duckdb_cli-linux-amd64.zip
sudo cp duckdb /usr/local/bin

duckdb rtabench.db -f create.sql
duckdb rtabench.db -c "copy customers from 'dataset/customers.csv'" #import
duckdb rtabench.db -c "copy products from 'dataset/products.csv'" #import
duckdb rtabench.db -c "copy orders from 'dataset/orders.csv'" #import
duckdb rtabench.db -c "copy order_items from 'dataset/order_items.csv'" #import
duckdb rtabench.db -c "copy order_events from 'dataset/order_events.csv'" #import

./run.sh | tee log.txt

wc -c rtabench.db #datasize

cat log.txt |
  grep -P '^\d|Killed|Segmentation|^Run Time \(s\): real' |
  sed -r -e 's/^.*(Killed|Segmentation).*$/null\nnull\nnull/; s/^Run Time \(s\): real\s*([0-9.]+).*$/\1/' |
  awk '{ if (i % 3 == 0) { printf "[" }; printf $1; if (i % 3 != 2) { printf "," } else { print "]," }; ++i; }' #results

echo "Batch Analytics" #tag
echo "DuckDB" #name
