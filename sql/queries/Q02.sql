USE pulse_uni_db;

SELECT
    a.artist_id,
    a.first_name,
    a.last_name,
    mt.music_type,
    CASE
        WHEN participation.artist_id IS NOT NULL THEN 'Yes'
        ELSE 'No'
    END AS participated_in_year
FROM ARTISTS a
JOIN ARTISTS_X_MUSIC am ON am.artist_id = a.artist_id
JOIN MUSIC_TYPES mt ON mt.music_type_id = am.music_type_id

LEFT JOIN (
    SELECT DISTINCT p.performer_id AS artist_id
    FROM PERFORMANCES p
    JOIN FESTIVAL_EVENTS fe ON fe.event_id = p.event_id
    JOIN FESTIVALS f ON f.festival_id = fe.festival_id
    WHERE p.is_solo = 1 AND YEAR(f.date_starting) = 2022

    UNION

    SELECT DISTINCT ab.artist_id
    FROM PERFORMANCES p
    JOIN FESTIVAL_EVENTS fe ON fe.event_id = p.event_id
    JOIN FESTIVALS f ON f.festival_id = fe.festival_id
    JOIN ARTISTS_X_BANDS ab ON ab.band_id = p.performer_id
    WHERE p.is_solo = 0 AND YEAR(f.date_starting) = 2022
) AS participation ON participation.artist_id = a.artist_id

WHERE mt.music_type = 'Rock'
ORDER BY participated_in_year DESC, a.last_name;
