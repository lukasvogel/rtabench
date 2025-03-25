SELECT count(*)
FROM order_events
WHERE event_created >= '2024-05-01' and event_created < '2024-06-01'
  AND event_type = 'Departed' AND order_id = 27;
