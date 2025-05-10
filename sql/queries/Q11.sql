USE pulse_uni_db;

WITH artist_participations AS (
    SELECT p.performer_id AS artist_id, COUNT(DISTINCT fe.festival_id) AS festivals_count
    FROM PERFORMANCES p
    JOIN FESTIVAL_EVENTS fe ON fe.event_id = p.event_id
    WHERE p.is_solo = 1
    GROUP BY p.performer_id

    UNION ALL

    SELECT ab.artist_id, COUNT(DISTINCT fe.festival_id) AS festivals_count
    FROM PERFORMANCES p
    JOIN FESTIVAL_EVENTS fe ON fe.event_id = p.event_id
    JOIN ARTISTS_X_BANDS ab ON ab.band_id = p.performer_id
    WHERE p.is_solo = 0
    GROUP BY ab.artist_id
),
total_counts AS (
    SELECT artist_id, SUM(festivals_count) AS total_participations
    FROM artist_participations
    GROUP BY artist_id
)

SELECT
    a.artist_id,
    a.first_name,
    a.last_name,
    tc.total_participations
FROM total_counts tc
JOIN ARTISTS a ON a.artist_id = tc.artist_id
WHERE tc.total_participations <= (
    SELECT MAX(total_participations) FROM total_counts
) - 5
ORDER BY tc.total_participations DESC;
