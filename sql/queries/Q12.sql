USE pulse_uni_db;

SELECT
    fe.event_date,
    CASE
        WHEN sc.technical_id IS NOT NULL THEN 'Technical'
        WHEN sc.staff_category_desc = 'Security' THEN 'Security'
        ELSE 'Support'
    END AS staff_group,
    COUNT(*) AS staff_count
FROM STAFF s
JOIN STAFF_CATEGORIES sc ON s.category_id = sc.staff_category_id
JOIN FESTIVAL_EVENTS fe ON s.event_id = fe.event_id
  
GROUP BY fe.event_date, staff_group
ORDER BY fe.event_date DESC;
