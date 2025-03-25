SELECT order_id, count(*) as count
FROM order_events
WHERE event_created >= '2024-01-29' and event_created < '2024-02-05'
  AND JSON_CONTAINS(JSON_EXTRACT(event_payload, '$.status'), '["Delayed"]')
GROUP BY order_id
ORDER BY count, order_id desc
limit 1;
