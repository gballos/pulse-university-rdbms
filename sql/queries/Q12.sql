USE pulse_uni_db;

SELECT
    fe.event_date,
    SUM(CASE WHEN sc.technical_id IS NOT NULL THEN 1 ELSE 0 END) AS technical_count,
    SUM(CASE WHEN sc.staff_category_desc = 'Security' THEN 1 ELSE 0 END) AS security_count,
    SUM(CASE WHEN sc.staff_category_desc = 'Assistant' THEN 1 ELSE 0 END) AS assistant_count,
    COUNT(*) AS total_count
FROM STAFF s
JOIN STAFF_CATEGORIES sc ON s.category_id = sc.staff_category_id
JOIN FESTIVAL_EVENTS fe ON s.event_id = fe.event_id
  
GROUP BY fe.event_date, staff_group
ORDER BY fe.event_date DESC;
