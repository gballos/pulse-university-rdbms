USE pulse_uni_db;

SELECT
    f.festival_id,
    SUM(t.cost) as total_income,
    YEAR(f.date_starting) as fest_year
FROM FESTIVALS f
JOIN FESTIVAL_EVENTS fe ON fe.festival_id = f.festival_id
JOIN TICKETS t ON fe.event_id = t.event_id

GROUP BY f.festival_id, YEAR(f.date_starting)
