USE pulse_uni_db;

DROP TRIGGER IF EXISTS delete_performance_after_artist;
DELIMITER //
CREATE TRIGGER delete_performance_after_artist
AFTER DELETE ON ARTISTS
FOR EACH ROW
DELETE FROM PERFORMANCES WHERE performer_id = OLD.artist_id AND is_solo = 1;
//

DROP TRIGGER IF EXISTS delete_performance_after_band;
DELIMITER //
CREATE TRIGGER delete_performance_after_band
AFTER DELETE ON BANDS
FOR EACH ROW
DELETE FROM PERFORMANCES WHERE performer_id = OLD.band_id AND is_solo = 0;
//

