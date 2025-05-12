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
     OR (BUYERS.ticket_type_id = NEW.ticket_type_id AND BUYERS.event_id = NEW.event_id)
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

DROP TRIGGER IF EXISTS check_4th_year;
CREATE TRIGGER check_4th_year
BEFORE INSERT ON PERFORMANCES
FOR EACH ROW
BEGIN
    DECLARE performer_year INT;
    DECLARE prev_years INT;

    -- Get the year of the current performance
    SELECT YEAR(event_date) INTO performer_year
    FROM FESTIVAL_EVENTS
    WHERE event_id = NEW.event_id;

    -- Count how many times this performer performed in the 3 years before this one
    IF NEW.is_solo = TRUE THEN
        SELECT COUNT(DISTINCT YEAR(fe.event_date)) INTO prev_years
        FROM PERFORMANCES p
        JOIN FESTIVAL_EVENTS fe ON p.event_id = fe.event_id
        WHERE p.performer_id = NEW.performer_id
          AND p.is_solo = 1
          AND YEAR(fe.event_date) BETWEEN performer_year - 3 AND performer_year - 1;
    ELSE
        SELECT COUNT(DISTINCT YEAR(fe.event_date)) INTO prev_years
        FROM PERFORMANCES p
        JOIN FESTIVAL_EVENTS fe ON p.event_id = fe.event_id
        WHERE p.performer_id = NEW.performer_id
          AND p.is_solo = 0
          AND YEAR(fe.event_date) BETWEEN performer_year - 3 AND performer_year - 1;
    END IF;

    IF prev_years = 3 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Performer cannot take part in the festival for more than 3 consecutive years.';
    END IF;
END//

DROP TRIGGER IF EXISTS check_stage_capacity;
CREATE TRIGGER check_stage_capacity
BEFORE INSERT ON TICKETS
FOR EACH ROW
BEGIN
    DECLARE cap INT;
    DECLARE ticket_count INT;
    DECLARE vip_count INT;
    DECLARE ticket_type_name VARCHAR(20);

    SELECT ticket_type INTO ticket_type_name
    FROM TICKET_TYPES
    WHERE ticket_type_id = NEW.ticket_type_id;

    SELECT s.max_capacity INTO cap
    FROM FESTIVAL_EVENTS fe
    JOIN STAGES s ON s.stage_id = fe.event_id
    WHERE NEW.event_id = fe.event_id;

    SELECT COUNT(*) INTO ticket_count
    FROM TICKETS
    WHERE event_id = NEW.event_id;

    SELECT COUNT(*) INTO vip_count
    FROM TICKETS
    WHERE event_id = NEW.event_id AND ticket_type_name = 'VIP';

    IF ticket_count >= cap THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Exceeded stage capacity. No more tickets available.';
    END IF;

    IF vip_count >= 0.1*cap THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No more VIP tickets available';
    END IF;
END //
DROP VIEW IF EXISTS staff_coverage_view;
CREATE VIEW staff_coverage_view AS

SELECT
  fe.event_id,
  fe.stage_id,
  s.max_capacity,

  SUM(IF(sc.technical_id IS NOT NULL, 1, 0)) AS technical_assigned,
  SUM(IF(sc.staff_category_desc = 'Security', 1, 0))  AS security_assigned,
  SUM(IF(sc.staff_category_desc = 'Assistant', 1, 0)) AS general_assigned,


  CEIL(s.max_capacity * 0.05)                         AS security_required,
  CEIL(s.max_capacity * 0.02)                         AS general_required

FROM FESTIVAL_EVENTS fe
JOIN STAGES s ON fe.stage_id = s.stage_id
LEFT JOIN STAFF st ON st.event_id = fe.event_id  -- Left join because we need to see the event even if it has no staff
LEFT JOIN STAFF_CATEGORIES sc ON st.category_id = sc.staff_category_id

GROUP BY fe.event_id, fe.stage_id, s.max_capacity; //

DELIMITER ;



