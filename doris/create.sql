DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS order_events;

CREATE TABLE customers
(
    customer_id integer not null,
    name text,
    birthday DateTime,
    email text,
    address text,
    city text,
    zip text,
    state text,
    country text,
) duplicate key (customer_id)
distributed BY hash(customer_id) buckets 16
properties("replication_num" = "1");

CREATE TABLE products
(
    product_id integer not null,
    name text,
    description text,
    category text,
    price decimal(10,2),
    stock int,
) duplicate key (product_id)
distributed BY hash(product_id) buckets 16
properties("replication_num" = "1");

CREATE TABLE orders
(
    order_id     integer not null,
    customer_id integer not null,
    created_at datetime not null,
) duplicate key (order_id, customer_id, created_at)
distributed BY hash(order_id, customer_id, created_at) buckets 16
properties("replication_num" = "1");

CREATE TABLE order_items
(
    order_id integer not null,
    product_id integer not null,
    amount integer not null,
) duplicate key (order_id, product_id)
distributed BY hash(order_id, product_id) buckets 16
properties("replication_num" = "1");

CREATE TABLE order_events
(
    event_created    datetime not null,
    order_id         integer   not null,
    counter          integer,
    event_type       text      not null,
    satisfaction     Float      not null,
    processor        text      not null,
    backup_processor text,
    event_payload    variant not null,
    INDEX idx_var (`event_payload`) USING INVERTED,
    INDEX idx_order_id (`order_id`) USING INVERTED,
    INDEX idx_event_type (`event_type`) USING INVERTED
) duplicate key (event_created, order_id)
distributed BY hash(order_id) buckets 16
properties("replication_num" = "1");
