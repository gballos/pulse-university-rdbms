USE pulse_uni_db;

SELECT
    t.visitor_id,
    YEAR(fe.event_date) AS year,
    COUNT(*) AS num_performances
FROM TICKETS t
JOIN FESTIVAL_EVENTS fe ON t.event_id = fe.event_id
GROUP BY t.visitor_id, YEAR(fe.event_date)
HAVING COUNT(*) > 3
ORDER BY num_performances DESC, visitor_id;
