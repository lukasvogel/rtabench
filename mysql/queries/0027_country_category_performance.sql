SELECT
    c.country,
    p.category,
    SUM(p.price * oi.amount) AS total_revenue
FROM
    products p
    INNER JOIN order_items oi USING (product_id)
    INNER JOIN orders o ON o.order_id = oi.order_id
    INNER JOIN customers c ON c.customer_id = o.customer_id
    INNER JOIN order_events oe ON oe.order_id = o.order_id
WHERE 
    oe.event_type = 'Delivered'
    AND oe.event_created >= '2024-01-01' 
    AND oe.event_created < '2024-02-01'
    AND c.country = 'Switzerland'
GROUP BY
    c.country, p.category
ORDER BY 
    c.country, p.category;
