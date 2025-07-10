LOAD DATA LOCAL INFILE './dataset/customers.csv' INTO TABLE customers COLUMNS TERMINATED BY ','PROPERTIES ("enclose" = "\"","escape" = "\\" );

LOAD DATA LOCAL INFILE './dataset/products.csv' INTO TABLE products COLUMNS TERMINATED BY ','PROPERTIES ("enclose" = "\"","escape" = "\\" );

LOAD DATA LOCAL INFILE './dataset/orders.csv' INTO TABLE orders COLUMNS TERMINATED BY ','PROPERTIES ("enclose" = "\"","escape" = "\\" );

LOAD DATA LOCAL INFILE './dataset/order_items.csv' INTO TABLE order_items COLUMNS TERMINATED BY ','PROPERTIES ("enclose" = "\"","escape" = "\\" );

LOAD DATA LOCAL INFILE './dataset/order_events2.csv' INTO TABLE order_events COLUMNS TERMINATED BY ',' (order_id,counter,event_created,event_type,satisfaction,processor,backup_processor,event_payload) PROPERTIES ("enclose" = "\"", "escape" = "\\" , "trim_double_quotes"="true");

analyze table customers with sync;
analyze table products with sync;
analyze table orders with sync;
analyze table order_items with sync;
analyze table order_events with sync;