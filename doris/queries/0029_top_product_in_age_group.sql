SELECT
    p.product_id,
    p.name,
    SUM(oi.amount * p.price) AS total_revenue
FROM
    products p
    INNER JOIN order_items oi USING (product_id)
    INNER JOIN orders o ON o.order_id = oi.order_id
    INNER JOIN customers c ON c.customer_id = o.customer_id
WHERE 
    o.created_at >= '2024-12-24' 
    AND o.created_at < '2025-01-01'
    AND TIMESTAMPDIFF(YEAR, c.birthday, CURDATE()) BETWEEN 18 AND 25
GROUP BY
    p.product_id, p.name
ORDER BY
    total_revenue DESC
LIMIT 10;