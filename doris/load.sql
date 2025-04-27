LOAD DATA LOCAL INFILE './dataset/customers.csv' INTO TABLE customers COLUMNS TERMINATED BY ','PROPERTIES ("enclose" = "\"","escape" = "\\" );

LOAD DATA LOCAL INFILE './dataset/products.csv' INTO TABLE products COLUMNS TERMINATED BY ','PROPERTIES ("enclose" = "\"","escape" = "\\" );

LOAD DATA LOCAL INFILE './dataset/orders.csv' INTO TABLE orders COLUMNS TERMINATED BY ','PROPERTIES ("enclose" = "\"","escape" = "\\" );

LOAD DATA LOCAL INFILE './dataset/order_items.csv' INTO TABLE order_items COLUMNS TERMINATED BY ','PROPERTIES ("enclose" = "\"","escape" = "\\" );

LOAD DATA LOCAL INFILE './dataset/order_events2.csv' INTO TABLE order_events COLUMNS TERMINATED BY ',' (order_id,counter,event_created,event_type,satisfaction,processor,backup_processor,event_payload) PROPERTIES ("enclose" = "\"", "escape" = "\\" , "trim_double_quotes"="true");
