SELECT DATE_FORMAT(event_created, '%Y-%m-%d %00:00:00') as day,
       COUNT(*) as count
FROM order_events
WHERE event_created >= '2024-05-01' and event_created < '2024-06-01'
  AND JSON_CONTAINS(JSON_EXTRACT(event_payload, '$.status'), '["Delayed", "Priority"]')
GROUP BY day
ORDER BY count desc, day
limit 20;
