USE pulse_uni_db;

WITH artist_types AS(
    SELECT DISTINCT am.artist_id, mt.music_type
    FROM ARTISTS_X_MUSIC am
    JOIN MUSIC_TYPES mt ON am.music_type_id = mt.music_type_id
),
festival_artists AS(
    SELECT DISTINCT
        CASE
            WHEN p.is_solo = 1 THEN p.performer_id
            ELSE ab.artist_id
        END AS artist_id,
        fe.festival_id as festival_id
    FROM PERFORMANCES p
    JOIN FESTIVAL_EVENTS fe on p.event_id = fe.event_id
    LEFT JOIN ARTISTS_X_BANDS ab on ab.band_id = p.performer_id
)

SELECT
    fa.festival_id,
    LEAST(at2.music_type,at1.music_type) AS type1,
    GREATEST(at2.music_type,at1.music_type) AS type2,
    COUNT(*) AS pair_count
FROM artist_types at1
JOIN artist_types at2 ON at2.artist_id = at1.artist_id AND at1.music_type < at2.music_type
JOIN festival_artists fa on at1.artist_id = fa.artist_id
GROUP BY fa.festival_id, type1, type2
ORDER BY pair_count DESC
LIMIT 3

