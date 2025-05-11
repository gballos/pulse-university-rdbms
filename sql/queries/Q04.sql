USE pulse_uni_db;

SET @artist_id = 42;

-- simple query 
SELECT
    a.artist_id,
    a.first_name,
    a.last_name,
    ROUND(AVG(r.interpretation_rating), 2) AS avg_interpretation,
    ROUND(AVG(r.overall_impression_rating), 2) AS avg_impression
FROM REVIEWS r
JOIN PERFORMANCES p ON r.performance_id = p.performance_id
JOIN ARTISTS a ON p.performer_id = a.artist_id AND p.is_solo = 1
WHERE a.artist_id = @artist_id
GROUP BY a.artist_id;
