SELECT
    SUM(CASE 
        WHEN TIMESTAMPDIFF(YEAR, c.birthday, CURDATE()) BETWEEN 18 AND 25 
        THEN p.price * oi.amount ELSE 0 END) AS "18-25",
    SUM(CASE 
        WHEN TIMESTAMPDIFF(YEAR, c.birthday, CURDATE()) BETWEEN 26 AND 35 
        THEN p.price * oi.amount ELSE 0 END) AS "26-35",
    SUM(CASE 
        WHEN TIMESTAMPDIFF(YEAR, c.birthday, CURDATE()) BETWEEN 36 AND 50 
        THEN p.price * oi.amount ELSE 0 END) AS "36-50",
    SUM(CASE 
        WHEN TIMESTAMPDIFF(YEAR, c.birthday, CURDATE()) BETWEEN 51 AND 65 
        THEN p.price * oi.amount ELSE 0 END) AS "51-65",
    SUM(CASE 
        WHEN TIMESTAMPDIFF(YEAR, c.birthday, CURDATE()) >= 66 
        THEN p.price * oi.amount ELSE 0 END) AS "66+"
FROM
    products p
    INNER JOIN order_items oi USING (product_id)
    INNER JOIN orders o ON o.order_id = oi.order_id
    INNER JOIN customers c ON c.customer_id = o.customer_id
WHERE 
    o.created_at >= '2024-01-01' 
    AND o.created_at < '2024-01-07';