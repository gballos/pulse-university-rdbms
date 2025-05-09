USE pulse_uni_db;

SELECT
    s.staff_id,
    s.first_name,
    s.last_name
FROM STAFF s
JOIN STAFF_CATEGORIES sc ON s.category_id = sc.staff_category_id
WHERE sc.technical_id IS NULL
  AND s.staff_id NOT IN (
    SELECT s2.staff_id
    FROM STAFF s2
    JOIN FESTIVAL_EVENTS fe ON s2.event_id = fe.event_id
    WHERE fe.event_date = '2022-07-29'
)
ORDER BY s.last_name;
