USE pulse_uni_db;

-- Delete triggers for performances.
DROP TRIGGER IF EXISTS delete_performance_after_artist;
DELIMITER //
CREATE TRIGGER delete_performance_after_artist
AFTER DELETE ON ARTISTS
FOR EACH ROW
BEGIN
    DELETE FROM PERFORMANCES
    WHERE performer_id = OLD.artist_id AND is_solo = 1;
END;
//

DROP TRIGGER IF EXISTS delete_performance_after_band;
CREATE TRIGGER delete_performance_after_band
AFTER DELETE ON BANDS
FOR EACH ROW
BEGIN
    DELETE FROM PERFORMANCES
    WHERE performer_id = OLD.band_id AND is_solo = 0;
END;
//

-- Resale queue
DROP TRIGGER IF EXISTS resale_queue;
CREATE TRIGGER resale_queue
AFTER INSERT ON TICKETS_FOR_RESALE
FOR EACH ROW
BEGIN
  DECLARE matched_buyer_id INT;
  DECLARE matched_resale_id INT;

  -- Find first buyer requesting this ticket or a matching one
  SELECT buyer_id INTO matched_buyer_id
  FROM BUYERS
  WHERE ticket_id = NEW.ticket_id
     OR (BUYERS.ticket_type = NEW.ticket_type AND BUYERS.event_id = NEW.event_id)
  ORDER BY buyer_id
  LIMIT 1;

  SET matched_resale_id = NEW.ticket_for_resale_id;

  IF matched_buyer_id IS NOT NULL THEN
    DELETE FROM BUYERS WHERE buyer_id = matched_buyer_id;
    DELETE FROM TICKETS_FOR_RESALE WHERE ticket_for_resale_id = matched_resale_id;
  END IF;
END;
//

-- Check review eligibility
DROP TRIGGER IF EXISTS check_review_ticket_scanned;

CREATE TRIGGER check_review_ticket_scanned
BEFORE INSERT ON REVIEWS
FOR EACH ROW
BEGIN
    DECLARE event_of_perf INT;
    DECLARE ticket_scanned BOOL;

    -- Get the event for the performance being reviewed
    SELECT event_id INTO event_of_perf
    FROM PERFORMANCES
    WHERE performance_id = NEW.performance_id;

    -- Check if visitor has a scanned ticket for that event
    SELECT COUNT(*) > 0 INTO ticket_scanned
    FROM TICKETS
    WHERE visitor_id = NEW.visitor_id
      AND event_id = event_of_perf
      AND is_scanned = TRUE;

    -- If not, block the review
    IF NOT ticket_scanned THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'You can only review performances you attended (ticket must be scanned).';
    END IF;
END;
//
-- Performer ID Trigger
DROP TRIGGER IF EXISTS check_performer;
CREATE TRIGGER check_performer
BEFORE INSERT ON PERFORMANCES
FOR EACH ROW
BEGIN
   DECLARE artist_count INT;
   DECLARE band_count INT;

   IF NEW.is_solo = TRUE THEN
       SELECT COUNT(*) INTO artist_count FROM ARTISTS WHERE artist_id = NEW.performer_id;
       IF artist_count = 0 THEN
           SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No matching artist for solo performance.';
       END IF;
   ELSE
       SELECT COUNT(*) INTO band_count FROM BANDS WHERE band_id = NEW.performer_id;
       IF band_count = 0 THEN
           SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No matching band for ensemble performance.';
       END IF;
   END IF;
END //



DELIMITER ;



