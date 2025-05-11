USE pulse_uni_db;

WITH appearances_per_year AS (
    SELECT
        mt.music_type_id,
        mt.music_type,
        YEAR(f.date_starting) AS year,
        COUNT(*) AS appearance_count
    FROM PERFORMANCES p
    JOIN ARTISTS a ON p.performer_id = a.artist_id AND p.is_solo = 1
    JOIN FESTIVAL_EVENTS fe ON p.event_id = fe.event_id
    JOIN FESTIVALS f ON fe.festival_id = f.festival_id
    JOIN MUSIC_TYPES mt ON a.music_type_id = mt.music_type_id
    GROUP BY mt.music_type_id, mt.music_type, YEAR(f.date_starting)
    HAVING COUNT(*) >= 3
),
consecutive_years AS (
    SELECT
        a1.music_type,
        a1.year AS year1,
        a2.year AS year2,
        a1.appearance_count
    FROM appearances_per_year a1
    JOIN appearances_per_year a2
      ON a1.music_type_id = a2.music_type_id
     AND a2.year = a1.year + 1
     AND a1.appearance_count = a2.appearance_count
)
SELECT
    music_type,
    year1,
    year2,
    appearance_count
FROM consecutive_years
ORDER BY music_type, year1;
