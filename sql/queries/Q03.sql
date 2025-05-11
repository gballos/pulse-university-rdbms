USE pulse_uni_db;

SELECT
    a.artist_id,
    a.first_name,
    a.last_name,
    f.festival_id,
    COUNT(*) AS warmup_count
FROM (
    SELECT
        p.performer_id AS artist_id,
        fe.festival_id
    FROM PERFORMANCES p
    JOIN FESTIVAL_EVENTS fe ON fe.event_id = p.event_id
    JOIN PERFORMANCE_TYPES pt ON pt.performance_type_id = p.performance_type_id
    WHERE p.is_solo = 1 AND pt.performance_type = 'Warm Up'

    UNION ALL

    SELECT
        ab.artist_id,
        fe.festival_id
    FROM PERFORMANCES p
    JOIN FESTIVAL_EVENTS fe ON fe.event_id = p.event_id
    JOIN PERFORMANCE_TYPES pt ON pt.performance_type_id = p.performance_type_id
    JOIN ARTISTS_X_BANDS ab ON ab.band_id = p.performer_id
    WHERE p.is_solo = 0 AND pt.performance_type = 'Warm Up'
) AS artist_festival_warmups
JOIN ARTISTS a ON a.artist_id = artist_festival_warmups.artist_id
JOIN FESTIVALS f ON f.festival_id = artist_festival_warmups.festival_id
GROUP BY a.artist_id, f.festival_id
HAVING COUNT(*) > 2
ORDER BY warmup_count DESC;
