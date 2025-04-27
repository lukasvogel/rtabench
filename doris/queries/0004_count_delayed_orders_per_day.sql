SELECT DATE_FORMAT(event_created, '%Y-%m-%d %00:00:00') as day,
       COUNT(*) as count
FROM order_events
WHERE event_created >= '2024-05-01' and event_created < '2024-06-01'
  AND ARRAY_SIZE(ARRAY_EXCEPT(["Delayed", "Priority"], cast(event_payload['status'] as array<text>)))==0
GROUP BY day
ORDER BY count desc, day
limit 20;
