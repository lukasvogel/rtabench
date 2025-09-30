#!/bin/bash

sudo apt-get update -y
sudo apt-get install -y docker.io postgresql-client gzip

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


# get and configure CedarDB image
echo "Starting CedarDB..."
docker run --rm -p 5432:5432 -v ./dataset:/dataset -v ./db:/var/lib/cedardb/data -e CEDAR_PASSWORD=test --name cedardb cedardb/cedardb:latest > /dev/null 2>&1 &

# wait for container to start
until pg_isready -h localhost --dbname postgres -U postgres > /dev/null 2>&1; do sleep 1; done


PGPASSWORD=test psql -h localhost -U postgres -c "CREATE DATABASE test"

# Import the data
PGPASSWORD=test psql -h localhost -U postgres --dbname=test < create.sql #import

PGPASSWORD=test psql -h localhost -U postgres --dbname=test -t -c '\timing' -c "\\COPY customers FROM 'dataset/customers.csv' WITH (FORMAT csv);" #import
PGPASSWORD=test psql -h localhost -U postgres --dbname=test -t -c '\timing' -c "\\COPY products FROM 'dataset/products.csv' WITH (FORMAT csv);" #import
PGPASSWORD=test psql -h localhost -U postgres --dbname=test -t -c '\timing' -c "\\COPY orders FROM 'dataset/orders.csv' WITH (FORMAT csv);" #import
PGPASSWORD=test psql -h localhost -U postgres --dbname=test -t -c '\timing' -c "\\COPY order_items FROM 'dataset/order_items.csv' WITH (FORMAT csv);" #import
PGPASSWORD=test psql -h localhost -U postgres --dbname=test -t -c '\timing' -c "\\COPY order_events FROM 'dataset/order_events.csv' WITH (FORMAT csv);" #import

PGPASSWORD=test psql -h localhost -U postgres --dbname=test -c "\t" -c "SELECT pg_total_relation_size('order_events') + pg_total_relation_size('orders') + pg_total_relation_size('order_items') + pg_total_relation_size('products') + pg_total_relation_size('customers');" #datasize

./run.sh 2>&1 | tee log.txt

cat log.txt | grep -oP 'Time: \d+\.\d+ ms' | sed -r -e 's/Time: ([0-9]+\.[0-9]+) ms/\1/' |
  awk '{ if (i % 3 == 0) { printf "[" }; printf $1 / 1000; if (i % 3 != 2) { printf "," } else { print "]," }; ++i; }'  #results

echo "General Purpose" #tag
echo "Real-time Analytics" #tag
echo "CedarDB" #name