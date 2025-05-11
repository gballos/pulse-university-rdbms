USE pulse_uni_db;

WITH artist_continents AS (
    SELECT DISTINCT
        p.performer_id AS artist_id,
        l.continent
    FROM PERFORMANCES p
    JOIN FESTIVAL_EVENTS fe ON p.event_id = fe.event_id
    JOIN FESTIVALS f ON fe.festival_id = f.festival_id
    JOIN LOCATIONS l ON f.location_id = l.location_id
    WHERE p.is_solo = 1

    UNION

    SELECT DISTINCT
        ab.artist_id,
        l.continent
    FROM PERFORMANCES p
    JOIN ARTISTS_X_BANDS ab ON ab.band_id = p.performer_id
    JOIN FESTIVAL_EVENTS fe ON p.event_id = fe.event_id
    JOIN FESTIVALS f ON fe.festival_id = f.festival_id
    JOIN LOCATIONS l ON f.location_id = l.location_id
    WHERE p.is_solo = 0
)
SELECT
    a.artist_id,
    a.first_name,
    a.last_name,
    COUNT(DISTINCT ac.continent) AS continent_count
FROM artist_continents ac
JOIN ARTISTS a ON a.artist_id = ac.artist_id
GROUP BY a.artist_id
HAVING COUNT(DISTINCT ac.continent) >= 3
ORDER BY continent_count DESC;
