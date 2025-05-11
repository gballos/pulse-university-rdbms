USE pulse_uni_db;

SET @visitor_id = 42;

-- simple query
-- EXPLAIN ANALYZE
SELECT
    r.visitor_id,
    r.performance_id,
    p.event_id,
    p.is_solo,
    ROUND(AVG(
        r.interpretation_rating +
        r.sound_lighting_rating +
        r.stage_presence_rating +
        r.organization_rating +
        r.overall_impression_rating
    ) / 5, 2) AS avg_rating
FROM REVIEWS r
JOIN PERFORMANCES p ON r.performance_id = p.performance_id
WHERE r.visitor_id = @visitor_id
GROUP BY r.visitor_id, r.performance_id, p.event_id, p.is_solo;

-- query with FORCE INDEX
SELECT
    r.visitor_id,
    r.performance_id,
    p.event_id,
    p.is_solo,
    ROUND(AVG(
        r.interpretation_rating +
        r.sound_lighting_rating +
        r.stage_presence_rating +
        r.organization_rating +
        r.overall_impression_rating
    ) / 5, 2) AS avg_rating
FROM REVIEWS r FORCE INDEX (idx_reviews_visitors_performances)
WHERE r.visitor_id = @visitor_id
GROUP BY r.visitor_id, r.performance_id;
