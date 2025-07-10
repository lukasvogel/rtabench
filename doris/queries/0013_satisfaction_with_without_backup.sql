SELECT MONTH(event_created) as month,
       SUM(backup_processor <> '') as count_with_backup,
       SUM(backup_processor IS NULL) as count_without_backup,
       AVG(if(backup_processor <> '', satisfaction, 0.0)) as avg_satisfaction_with_backup,
       AVG(if(backup_processor IS NULL, satisfaction, 0.0)) as avg_satisfaction_without_backup
FROM order_events
WHERE order_id = 112
GROUP BY month
ORDER BY month desc;
