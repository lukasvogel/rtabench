SELECT
    DATE_FORMAT(event_created, '%Y-%m-%d %00:00:00') as day,
    COUNT(*) as count
FROM
    order_events
WHERE
    event_created >= '2024-04-01' and event_created < '2024-05-01'
    AND event_type = 'Departed'
    AND event_payload->"$.terminal" = 'Berlin'
GROUP BY
    day
ORDER BY count desc, day
limit 10;
