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

DELIMITER //
CREATE TRIGGER resale_queue
AFTER INSERT ON TICKETS_FOR_RESALE -- nope
FOR EACH ROW
BEGIN
  DECLARE buyer_id INT;
  SELECT buyer_id INTO buyer_id
  FROM BUYERS
  WHERE ticket_id = (SELECT ticket_id FROM TICKETS WHERE ticket_id = NEW.ticket_id) 
    OR (ticket_category = (SELECT ticket_category FROM TICKETS WHERE ticket_category = NEW.ticket_category) 
    AND event_id = (SELECT event_id FROM FESTIVAL_EVENTS WHERE event_id = NEW.event_id))
  ORDER BY buyer_id ASC 
  LIMIT 1;

  DECLARE ticket_for_resale_id INT;
  SELECT ticket_for_resale_id INTO ticket_for_resale_id
  FROM TICKETS_FOR_RESALE
  WHERE ticket_id = (SELECT ticket_id FROM TICKETS WHERE ticket_id = ticket_id) 
    OR (ticket_category = (SELECT ticket_category FROM TICKETS WHERE ticket_category = NEW.ticket_category) 
    AND event_id = (SELECT event_id FROM FESTIVAL_EVENTS WHERE event_id = NEW.event_id))
  ORDER BY ticket_for_resale ASC
  LIMIT 1;

  IF buyer_id IS NOT NULL AND ticket_for_resale_id IS NOT NULL THEN 
    DELETE FROM BUYERS WHERE buyer_id = buyer_id LIMIT 1;
    DELETE FROM TICKETS_FOR_RESALE WHERE tickets_for_resale_id = tickets_for_resale_id LIMIT 1;
  END IF;
END; 
//
