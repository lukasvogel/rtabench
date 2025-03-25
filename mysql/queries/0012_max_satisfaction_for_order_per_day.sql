SELECT DATE_FORMAT(event_created, '%Y-%m-%d %00:00:00') as day,
       max(satisfaction)
FROM order_events
WHERE order_id = 700
GROUP BY day
ORDER BY day desc;
