#!/bin/bash

#apt-get -y install sudo
sudo apt-get update

# Download the dataset
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

sudo apt-get install -y mysql-server-8.0
sudo bash -c "echo -e '[mysql]\nlocal-infile=1\n\n[mysqld]\nlocal-infile=1\nmax_allowed_packet=16M\n' > /etc/mysql/conf.d/local_infile.cnf"
sudo service mysql restart

# Create database and schema
sudo mysql -e "DROP DATABASE IF EXISTS test"
sudo mysql -e "CREATE DATABASE test"
sudo mysql test < create.sql

# Import dataset
sudo mysql --database "test" -e "LOAD DATA LOCAL INFILE 'dataset/customers.csv' INTO TABLE customers FIELDS terminated by ',' ENCLOSED BY '\"' LINES terminated by '\r\n' (@var_customer_id, name, birthday, email, @var_address, city, zip, state, country) SET customer_id = CAST(@var_customer_id AS UNSIGNED INTEGER), address = CONVERT(@var_address, CHAR(256))" #import
sudo mysql --database "test" -e "LOAD DATA LOCAL INFILE 'dataset/products.csv' INTO TABLE products  FIELDS terminated by ',' LINES terminated by '\r\n'"  #import
sudo mysql --database "test" -e "LOAD DATA LOCAL INFILE 'dataset/orders.csv' INTO TABLE orders FIELDS terminated by ',' LINES terminated by '\r\n' (order_id, @var_customer_id, created_at) SET customer_id = CAST(@var_customer_id AS UNSIGNED INTEGER)"  #import
sudo mysql --database "test" -e "LOAD DATA LOCAL INFILE 'dataset/order_items.csv' INTO TABLE order_items FIELDS terminated by ',' LINES terminated by '\r\n' (order_id, @var_product_id, @var_amount) SET product_id = CAST(@var_product_id AS UNSIGNED INTEGER), amount = CAST(@var_amount AS UNSIGNED INTEGER)"  #import
sudo mysql --database "test" -e "LOAD DATA LOCAL INFILE 'dataset/order_events.csv' INTO TABLE order_events FIELDS terminated by ',' OPTIONALLY ENCLOSED BY '\"' LINES terminated by '\n' (order_id, @var_counter, @var_event_created, event_type, satisfaction, processor, backup_processor, event_payload) SET counter = CAST(@var_counter AS UNSIGNED INTEGER), event_created = TIMESTAMP(@var_event_created)" #import

sudo mysql --database "test" -e "ALTER TABLE orders ADD INDEX orders_customer_id_index (customer_id);"
sudo mysql --database "test" -e "ALTER TABLE order_events ADD INDEX order_events_order_id_index (order_id);"
sudo mysql --database "test" -e "ALTER TABLE order_events ADD INDEX order_events_event_type_index (event_type);"

./run.sh 2>&1 | tee log.txt

sudo du -bcs /var/lib/mysql | grep total #datasize

cat log.txt |
  grep -P 'rows? in set|Empty set|^ERROR' |
  sed -r -e 's/^ERROR.*$/\-1/; s/^.*?\((([0-9.]+) min )?([0-9.]+) sec\).*?$/\2 \3/' |
  awk '{ if ($2) { print $1 * 60 + $2 } else { print $1 } }' |
  awk '{ if (i % 3 == 0) { printf "[" }; printf $1; if (i % 3 != 2) { printf "," } else { print "]," }; ++i; }' #results

echo "General Purpose" #tag
echo "MySQL" #name
