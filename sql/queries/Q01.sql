USE pulse_uni_db;

SELECT
    f.festival_id,
    pm.payment_method as method,
    YEAR(f.date_starting) as fest_year,
    SUM(t.cost) as total_income
FROM FESTIVALS f
JOIN FESTIVAL_EVENTS fe ON fe.festival_id = f.festival_id
JOIN TICKETS t ON fe.event_id = t.event_id
JOIN PAYMENT_METHODS pm ON t.payment_method_id = pm.payment_method_id

GROUP BY f.festival_id, YEAR(f.date_starting), method
ORDER BY fest_year DESC;