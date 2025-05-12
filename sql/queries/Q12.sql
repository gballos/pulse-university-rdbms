USE pulse_uni_db;

SET @tech_req = 5;

SELECT
    fe.event_date,
    SUM(@tech_req) AS technical_count,
    SUM(CEIL(st.max_capacity * 0.05)) AS security_count,
    SUM(CEIL(st.max_capacity * 0.02)) AS assistant_count,
    SUM(@tech_req+CEIL(st.max_capacity * 0.05)+CEIL(st.max_capacity * 0.02)) as total_count
FROM FESTIVAL_EVENTS fe
JOIN STAGES st ON st.stage_id = fe.stage_id

GROUP BY fe.event_date
ORDER BY fe.event_date DESC;
