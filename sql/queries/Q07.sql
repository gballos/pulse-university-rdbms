USE pulse_uni_db;

SELECT 
    f.festival_id,
    AVG(l.level_id) AS avg_experience
FROM STAFF s
JOIN STAFF_CATEGORIES sc ON s.category_id = sc.staff_category_id
JOIN LEVELS_OF_EXPERTISE l ON s.level_id = l.level_id
JOIN FESTIVAL_EVENTS fe ON s.event_id = fe.event_id
JOIN FESTIVALS f ON fe.festival_id = f.festival_id
WHERE sc.technical_id IS NOT NULL
GROUP BY f.festival_id
ORDER BY avg_experience ASC