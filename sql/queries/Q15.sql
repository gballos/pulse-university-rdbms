USE pulse_uni_db;

WITH solo_scores AS(
    SELECT
        r.visitor_id AS visitor_id,
        p.performer_id AS artist_id,
        SUM(r.interpretation_rating+r.overall_impression_rating) AS score
    FROM REVIEWS r
    JOIN PERFORMANCES p on r.performance_id = p.performance_id
    WHERE p.is_solo = 1
    GROUP BY visitor_id, artist_id
),
band_scores AS(
    SELECT
        r.visitor_id AS visitor_id,
        ab.artist_id AS artist_id,
        SUM(r.interpretation_rating+r.overall_impression_rating) AS score
    FROM REVIEWS r
    JOIN PERFORMANCES p on r.performance_id = p.performance_id
    JOIN ARTISTS_X_BANDS ab on ab.band_id = p.performer_id
    WHERE p.is_solo = 0
    GROUP BY visitor_id, ab.artist_id
),
all_scores AS(
    SELECT * FROM band_scores
    UNION ALL
    SELECT * FROM solo_scores
)
SELECT
    CONCAT(v.first_name, ' ', v.last_name) as visitor_name,
    CONCAT(a.first_name, ' ', a.last_name) as artist_name,
    SUM(score) as total_score
FROM all_scores s
JOIN VISITORS v ON s.visitor_id = v.visitor_id
JOIN ARTISTS a ON s.artist_id = a.artist_id
GROUP BY s.visitor_id, s.artist_id
ORDER BY total_score DESC
LIMIT 5
