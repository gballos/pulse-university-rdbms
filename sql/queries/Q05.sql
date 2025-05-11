USE pulse_uni_db;

SELECT
    a.artist_id,
    a.first_name,
    a.last_name,
    a.birthday,
    COUNT(DISTINCT artist_festivals.festival_id) AS festival_count
FROM ARTISTS a
LEFT JOIN (
    SELECT p.performer_id AS artist_id, fe.festival_id
    FROM PERFORMANCES p
    JOIN FESTIVAL_EVENTS fe ON fe.event_id = p.event_id
    JOIN FESTIVALS f on fe.festival_id = f.festival_id
    WHERE p.is_solo = 1

    UNION ALL

    SELECT ab.artist_id as artist_id, fe.festival_id
    FROM PERFORMANCES p
    JOIN FESTIVAL_EVENTS fe ON fe.event_id = p.event_id
    JOIN ARTISTS_X_BANDS ab ON ab.band_id = p.performer_id
    JOIN FESTIVALS f on fe.festival_id = f.festival_id
    WHERE p.is_solo = 0
) AS artist_festivals ON artist_festivals.artist_id = a.artist_id
WHERE TIMESTAMPDIFF(YEAR, a.birthday, CURDATE()) < 30
GROUP BY a.artist_id
ORDER BY festival_count DESC;


