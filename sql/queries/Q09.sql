USE pulse_uni_db;

SELECT
    t.visitor_id,
    v.first_name,
    v.last_name,
    YEAR(fe.event_date) AS year,
    COUNT(*) AS num_performances
FROM TICKETS t
JOIN VISITORS v on t.visitor_id = v.visitor_id
JOIN FESTIVAL_EVENTS fe ON t.event_id = fe.event_id
WHERE t.is_scanned = 1
GROUP BY t.visitor_id, YEAR(fe.event_date)
HAVING COUNT(*) > 0
ORDER BY num_performances DESC;
