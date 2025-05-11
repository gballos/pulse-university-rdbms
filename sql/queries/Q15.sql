SELECT
    CONCAT(v.first_name, ' ', v.last_name) as visitor_name,
    CONCAT(a.first_name, ' ', a.last_name) as artist_name,
    SUM(r.interpretation_rating + r.overall_impression_rating) as total_score
FROM REVIEWS r
JOIN VISITORS v ON r.visitor_id = v.visitor_id
JOIN PERFORMANCES p ON r.performance_id = p.performance_id
JOIN ARTISTS a on p.performer_id = a.artist_id WHERE p.is_solo = 1
GROUP BY v.visitor_id, a.artist_id
ORDER BY total_score DESC
LIMIT 5;
