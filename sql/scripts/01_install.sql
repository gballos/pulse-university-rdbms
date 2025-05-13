-- DATABASE CREATION

DROP DATABASE IF EXISTS pulse_uni_db;
CREATE DATABASE pulse_uni_db;
USE pulse_uni_db;

-- TABLES

DROP TABLE IF EXISTS LOCATIONS;
CREATE TABLE LOCATIONS (
	location_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    address VARCHAR(100),
    city VARCHAR(50),
    country VARCHAR(50),
    continent VARCHAR(50),
    longtitude NUMERIC(5, 2),
    latitude NUMERIC(5, 2),
    image VARCHAR(100), CHECK(image like 'https://%'),
    PRIMARY KEY(location_id)
);

DROP TABLE IF EXISTS FESTIVALS;
CREATE TABLE FESTIVALS (
    festival_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    date_starting DATE,
    date_ending DATE,
    duration INT,
    location_id INT UNSIGNED,
    image VARCHAR(100), CHECK(image like 'https://%'),
    festival_year INT GENERATED ALWAYS AS (YEAR(date_starting)) STORED,
    PRIMARY KEY(festival_id),
    FOREIGN KEY(location_id) REFERENCES LOCATIONS(location_id),
    UNIQUE (festival_year),
    CHECK (date_ending > date_starting) 
);

DROP TABLE IF EXISTS STAGES;
CREATE TABLE STAGES (
	stage_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    stage_name VARCHAR(50),
    stage_description VARCHAR(150),
    max_capacity INT,
    image VARCHAR(100), CHECK(image like 'https://%'),
    PRIMARY KEY(stage_id)
);

DROP TABLE IF EXISTS TECHNICAL_SUPPLY; 
CREATE TABLE TECHNICAL_SUPPLY(
	technical_supply_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	technical_supply_description VARCHAR(150),
    image VARCHAR(100), CHECK(image like 'https://%'),
	PRIMARY KEY(technical_supply_id)
);

DROP TABLE IF EXISTS STAGES_X_TECHNICAL_SUPPLY;
CREATE TABLE STAGES_X_TECHNICAL_SUPPLY(
	amount_of_supply INT UNSIGNED, 
	stage_id INT UNSIGNED,
	technical_supply_id INT UNSIGNED,
	PRIMARY KEY(stage_id, technical_supply_id),
	FOREIGN KEY(stage_id) REFERENCES STAGES(stage_id),
	FOREIGN KEY(technical_supply_id) REFERENCES TECHNICAL_SUPPLY(technical_supply_id)
);

DROP TABLE IF EXISTS FESTIVAL_EVENTS;
CREATE TABLE FESTIVAL_EVENTS (  
	event_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	festival_id INT UNSIGNED NOT NULL,
    stage_id INT UNSIGNED NOT NULL,
    event_date DATE,
    duration INT,  
    image VARCHAR(100), CHECK(image like 'https://%'),
    PRIMARY KEY(event_id),
    FOREIGN KEY(festival_id) REFERENCES FESTIVALS(festival_id),
    FOREIGN KEY(stage_id) REFERENCES STAGES(stage_id)
);

DROP TABLE IF EXISTS MUSIC_TYPES;
CREATE TABLE MUSIC_TYPES(
	music_type_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	music_type VARCHAR(20),
	PRIMARY KEY(music_type_id)
);

DROP TABLE IF EXISTS MUSIC_SUBTYPES;
CREATE TABLE MUSIC_SUBTYPES(
	music_subtype_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	music_subtype VARCHAR(20),
	PRIMARY KEY(music_subtype_id)
);
	
DROP TABLE IF EXISTS ARTISTS;
CREATE TABLE ARTISTS(
	artist_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	first_name VARCHAR(25),
	last_name VARCHAR(25),
	nickname VARCHAR(25),
	birthday DATE,
	website VARCHAR(100) CHECK(website LIKE 'https://%' OR website LIKE 'http://%'),
	instagram VARCHAR(50),
    image VARCHAR(100), CHECK(image like 'https://%'),
	PRIMARY KEY(artist_id)
);	

DROP TABLE IF EXISTS BANDS;
CREATE TABLE BANDS(
	band_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	name VARCHAR(25),
	date_of_creation DATE,
	website VARCHAR(100) CHECK(website LIKE 'https://%' OR website LIKE 'http://%'),
	instagram VARCHAR(50),
    image VARCHAR(100), CHECK(website LIKE 'https://%' OR website LIKE 'http://%'),
	PRIMARY KEY(band_id)
);

DROP TABLE IF EXISTS ARTISTS_X_BANDS; 
CREATE TABLE ARTISTS_X_BANDS(
	artist_id INT UNSIGNED,
	band_id INT UNSIGNED,
	PRIMARY KEY(artist_id, band_id),
	FOREIGN KEY(artist_id) REFERENCES ARTISTS(artist_id),
	FOREIGN KEY(band_id) REFERENCES BANDS(band_id)
);

DROP TABLE IF EXISTS ARTISTS_X_MUSIC;
CREATE TABLE ARTISTS_X_MUSIC (
    artist_id INT UNSIGNED NOT NULL,
    music_type_id INT UNSIGNED,
    music_subtype_id INT UNSIGNED,
    PRIMARY KEY(artist_id, music_type_id, music_subtype_id),
    FOREIGN KEY (artist_id) REFERENCES ARTISTS(artist_id),
    FOREIGN KEY (music_type_id) REFERENCES MUSIC_TYPES(music_type_id),
    FOREIGN KEY (music_subtype_id) REFERENCES MUSIC_SUBTYPES(music_subtype_id)
);

DROP TABLE IF EXISTS BANDS_X_MUSIC;
CREATE TABLE BANDS_X_MUSIC (
    band_id INT UNSIGNED NOT NULL,
    music_type_id INT UNSIGNED,
    music_subtype_id INT UNSIGNED,
    PRIMARY KEY(band_id, music_type_id, music_subtype_id),
    FOREIGN KEY (band_id) REFERENCES BANDS(band_id),
    FOREIGN KEY (music_type_id) REFERENCES MUSIC_TYPES(music_type_id),
    FOREIGN KEY (music_subtype_id) REFERENCES MUSIC_SUBTYPES(music_subtype_id)
);

DROP TABLE IF EXISTS PERFORMANCE_TYPES;
CREATE TABLE PERFORMANCE_TYPES (
	performance_type_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    performance_type VARCHAR(50),
    PRIMARY KEY(performance_type_id)
);

DROP TABLE IF EXISTS PERFORMANCES;
CREATE TABLE PERFORMANCES (
	performance_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    performance_type_id INT UNSIGNED NOT NULL,
    event_id INT UNSIGNED NOT NULL,
    performance_time TIME,
    duration INT CHECK(duration <= 180),                           -- duration in minutes
    order_in_show INT,
    is_solo BOOLEAN,
    performer_id INT UNSIGNED,
    image VARCHAR(100), CHECK(image like 'https://%'),
    PRIMARY KEY(performance_id),
    FOREIGN KEY(performance_type_id)  REFERENCES PERFORMANCE_TYPES(performance_type_id),
    FOREIGN KEY(event_id) REFERENCES FESTIVAL_EVENTS(event_id)
);

DROP TABLE IF EXISTS TECHNICAL_ROLES;
CREATE TABLE TECHNICAL_ROLES(
	technical_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	technical_description VARCHAR(40),
	PRIMARY KEY(technical_id)
);

DROP TABLE IF EXISTS STAFF_CATEGORIES;
CREATE TABLE STAFF_CATEGORIES(
	staff_category_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	staff_category_desc VARCHAR(20),
	technical_id INT UNSIGNED DEFAULT NULL,                 -- NOT NULL for technical, NULL for security/assistance
	PRIMARY KEY(staff_category_id),
	FOREIGN KEY(technical_id) REFERENCES TECHNICAL_ROLES(technical_id)
);

DROP TABLE IF EXISTS LEVELS_OF_EXPERTISE;
CREATE TABLE LEVELS_OF_EXPERTISE(
	level_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	level_description VARCHAR(20),
	PRIMARY KEY(level_id)
);

DROP TABLE IF EXISTS STAFF;
CREATE TABLE STAFF (
	staff_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    category_id INT UNSIGNED,
    level_id INT UNSIGNED,
    event_id INT UNSIGNED NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    image VARCHAR(100), CHECK(image like 'https://%'),
    PRIMARY KEY(staff_id),
    FOREIGN KEY(event_id) REFERENCES FESTIVAL_EVENTS(event_id),
	FOREIGN KEY(category_id) REFERENCES STAFF_CATEGORIES(staff_category_id),
	FOREIGN KEY(level_id) REFERENCES LEVELS_OF_EXPERTISE(level_id)
); 

DROP TABLE IF EXISTS VISITORS;
CREATE TABLE VISITORS(
	visitor_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	first_name VARCHAR(20),
	last_name VARCHAR(20),
	phone_number VARCHAR(40),
	email VARCHAR(20),
	age INT,
	PRIMARY KEY(visitor_id)
);

DROP TABLE IF EXISTS TICKET_TYPES;
CREATE TABLE TICKET_TYPES(
	ticket_type_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	ticket_type VARCHAR(25),
	PRIMARY KEY(ticket_type_id)
);

DROP TABLE IF EXISTS PAYMENT_METHODS;
CREATE TABLE PAYMENT_METHODS(
	payment_method_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	payment_method VARCHAR(50),
	PRIMARY KEY(payment_method_id)
);

DROP TABLE IF EXISTS TICKETS;
CREATE TABLE TICKETS(
	ticket_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	event_id INT UNSIGNED,
	visitor_id INT UNSIGNED,
	ticket_type_id INT UNSIGNED,
	payment_method_id INT UNSIGNED,
	ean_code CHAR(13),
	is_scanned BOOLEAN,
	date_bought DATE,
	cost INT,
	PRIMARY KEY(ticket_id),
    FOREIGN KEY(event_id) REFERENCES FESTIVAL_EVENTS(event_id),
	FOREIGN KEY(ticket_type_id) REFERENCES TICKET_TYPES(ticket_type_id),
	FOREIGN KEY(visitor_id) REFERENCES VISITORS(visitor_id),
	FOREIGN KEY(payment_method_id) REFERENCES PAYMENT_METHODS(payment_method_id)
);

DROP TABLE IF EXISTS LIKERT_RATINGS;
CREATE TABLE LIKERT_RATINGS(
	rating_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	rating_number INT UNSIGNED CHECK (rating_number BETWEEN 1 AND 5),
	rating_description VARCHAR(25),
	PRIMARY KEY(rating_id)
);

DROP TABLE IF EXISTS REVIEWS;
CREATE TABLE REVIEWS( 
	review_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	visitor_id INT UNSIGNED NOT NULL,
	performance_id INT UNSIGNED NOT NULL,
	interpretation_rating INT UNSIGNED,
	sound_lighting_rating INT UNSIGNED,
	stage_presence_rating INT UNSIGNED,
	organization_rating INT UNSIGNED,
	overall_impression_rating INT UNSIGNED,
	PRIMARY KEY(review_id),
	FOREIGN KEY(visitor_id) REFERENCES VISITORS(visitor_id),
	FOREIGN KEY(performance_id) REFERENCES PERFORMANCES(performance_id),
	FOREIGN KEY(interpretation_rating) REFERENCES LIKERT_RATINGS(rating_id),
	FOREIGN KEY(sound_lighting_rating) REFERENCES LIKERT_RATINGS(rating_id),
	FOREIGN KEY(stage_presence_rating) REFERENCES LIKERT_RATINGS(rating_id),
	FOREIGN KEY(organization_rating) REFERENCES LIKERT_RATINGS(rating_id),	
	FOREIGN KEY(overall_impression_rating) REFERENCES LIKERT_RATINGS(rating_id)
);

DROP TABLE IF EXISTS BUYERS;
CREATE TABLE BUYERS( 
	buyer_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	event_id INT UNSIGNED,
	ticket_type_id INT UNSIGNED,
	ticket_id INT UNSIGNED,
    requested_at DATETIME,
	PRIMARY KEY(buyer_id),
	FOREIGN KEY(event_id) REFERENCES FESTIVAL_EVENTS(event_id),
	FOREIGN KEY(ticket_id) REFERENCES TICKETS(ticket_id),
	FOREIGN KEY(ticket_type_id) REFERENCES TICKET_TYPES(ticket_type_id)
);

DROP TABLE IF EXISTS TICKETS_FOR_RESALE;
CREATE TABLE TICKETS_FOR_RESALE(
	ticket_for_resale_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	ticket_id INT UNSIGNED,
	event_id INT UNSIGNED,
	ticket_type_id INT UNSIGNED,
    listed_at DATETIME,
	PRIMARY KEY(ticket_for_resale_id),
	FOREIGN KEY(ticket_id) REFERENCES TICKETS(ticket_id),
	FOREIGN KEY(ticket_type_id) REFERENCES TICKET_TYPES(ticket_type_id),
	FOREIGN KEY(event_id) REFERENCES FESTIVAL_EVENTS(event_id)
);

-- TRIGGERS 

-- Delete trigger for performances
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
END

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
END

//

-- Check 3 consecutive years
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
END

//

-- Check stage capacity
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
        INSERT INTO BUYERS (event_id, ticket_type_id, ticket_id, requested_at)
        VALUES (NEW.event_id, NEW.ticket_type_id, NULL, NOW());
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Exceeded stage capacity. No more tickets available. Added buyer to queue';
    END IF;

    IF vip_count >= 0.1*cap THEN
        INSERT INTO BUYERS (event_id, ticket_type_id, ticket_id, requested_at)
        VALUES (NEW.event_id, NEW.ticket_type_id, NULL, NOW());
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No more VIP tickets available. Added buyer to queue';
    END IF;
END

-- Resale Queue | Matching
//
DROP PROCEDURE IF EXISTS match_resale_queue;
CREATE PROCEDURE match_resale_queue()
BEGIN
    DECLARE b_id INT;
    DECLARE b_event INT;
    DECLARE b_ticket INT;
    DECLARE b_ticket_type INT;
    DECLARE r_id INT;
    DECLARE r_ticket INT;

    match_loop: LOOP
        SELECT buyer_id, event_id, ticket_type_id, ticket_id
        INTO b_id, b_event, b_ticket_type, b_ticket
        FROM BUYERS
        ORDER BY requested_at
        LIMIT 1;

        -- No buyers left
        IF b_id IS NULL THEN
            LEAVE match_loop;
        END IF;

        -- Check if requested by id:
        IF b_ticket IS NOT NULL THEN
            SELECT ticket_for_resale_id
            INTO r_id
            FROM TICKETS_FOR_RESALE
            WHERE ticket_id = b_ticket
            ORDER BY listed_at
            LIMIT 1;

            IF r_id IS NOT NULL THEN
                DELETE FROM TICKETS_FOR_RESALE WHERE ticket_for_resale_id = r_id;
                DELETE FROM BUYERS WHERE buyer_id = b_id;
                ITERATE match_loop;
            END IF;
        END IF;

        -- Otherwise match by event + type
        SELECT ticket_for_resale_id, ticket_id
        INTO r_id, r_ticket
        FROM TICKETS_FOR_RESALE
        WHERE event_id = b_event AND ticket_type_id = b_ticket_type
        ORDER BY listed_at
        LIMIT 1;

        IF r_id IS NOT NULL THEN
          DELETE FROM TICKETS_FOR_RESALE WHERE ticket_for_resale_id = r_id;
          DELETE FROM BUYERS WHERE buyer_id = b_id;
          ITERATE match_loop;
        END IF;

        -- If here no match found
        LEAVE match_loop;
    END LOOP match_loop;
END //

-- Run match for new entries
//
DROP TRIGGER IF EXISTS after_ticket_resale_insert;
CREATE TRIGGER after_ticket_resale_insert
AFTER INSERT ON TICKETS_FOR_RESALE
FOR EACH ROW
BEGIN
    CALL match_resale_queue();
END;
//
DROP TRIGGER IF EXISTS after_buyer_insert;
CREATE TRIGGER after_buyer_insert
AFTER INSERT ON BUYERS
FOR EACH ROW
BEGIN
    CALL match_resale_queue();
END;
//

-- trigger to check if an event is within the date range of the festival
DROP TRIGGER IF EXISTS event_dates_in_festival;
CREATE TRIGGER event_dates_in_festival
BEFORE INSERT ON FESTIVAL_EVENTS
FOR EACH ROW
BEGIN
    DECLARE fest_start_date DATE;
    DECLARE fest_end_date DATE;
    
    SELECT date_starting, date_ending 
        INTO fest_start_date, fest_end_date
        FROM FESTIVALS 
    WHERE festival_id = NEW.festival_id;
    
    IF NEW.event_date < fest_start_date OR NEW.event_date > fest_end_date THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Event date must be between festival start and end dates';
    END IF;
END
//

-- create trigger to check that break is within range of 5-30 mins
DROP TRIGGER IF EXISTS check_break_range;
//
CREATE TRIGGER check_break_range
BEFORE INSERT ON PERFORMANCES
FOR EACH ROW
BEGIN
    DECLARE show_time INT;
    DECLARE prev_show_time TIME;
    DECLARE prev_duration_min INT;
    DECLARE prev_show_total INT;
    DECLARE time_difference INT;

    SET show_time = TIME_TO_SEC(NEW.performance_time);

    SELECT performance_time, duration INTO prev_show_time, prev_duration_min
    FROM PERFORMANCES 
    WHERE event_id = NEW.event_id 
        AND order_in_show = (NEW.order_in_show - 1);  
   
    IF prev_show_time IS NOT NULL THEN
        SET prev_show_total = TIME_TO_SEC(ADDTIME(prev_show_time, SEC_TO_TIME(prev_duration_min * 60)));

        SET time_difference = (show_time - prev_show_total) / 60;  -- convert to minutes

        IF time_difference < 5 OR time_difference > 30 THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Break between performances must be between 5 and 30 minutes';
        END IF;
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
LEFT JOIN STAFF st ON st.event_id = fe.event_id       -- Left join because we need to see the event even if it has no staff
LEFT JOIN STAFF_CATEGORIES sc ON st.category_id = sc.staff_category_id

GROUP BY fe.event_id, fe.stage_id, s.max_capacity;

//

DELIMITER ;

-- indexes for the most common joins / foreign keys

-- festival_events
CREATE INDEX idx_events_festivals ON FESTIVAL_EVENTS(festival_id);
CREATE INDEX idx_events_performances_events ON PERFORMANCES(event_id);
CREATE INDEX idx_events_tickets ON TICKETS(event_id);
CREATE INDEX idx_events_staff ON STAFF(event_id);

-- artist / band relationships
CREATE INDEX idx_ab_artist ON ARTISTS_X_BANDS(artist_id);
CREATE INDEX idx_ab_band ON ARTISTS_X_BANDS(band_id);

-- composite indexes 

-- for queries 2, 3, 4, 10, 15  /  require the connection both events and performers
CREATE INDEX idx_events_performers ON PERFORMANCES(event_id, performer_id);

-- for queries 6, 9, 15  /  require both visitors and events 
-- useful for the big number of tickets
CREATE INDEX idx_tickets_visitors_events ON TICKETS(visitor_id, event_id);

-- performance-review related queries 4, 15
CREATE INDEX idx_performances_performers ON PERFORMANCES(performance_id, performer_id);

-- review related queries 4, 6, 9, 15
CREATE INDEX idx_reviews_performance ON REVIEWS(performance_id);
CREATE INDEX idx_reviews_visitors_performances ON REVIEWS(visitor_id, performance_id);

-- staff queries 7, 12   /   filter event & categories
CREATE INDEX idx_staff_event_level ON STAFF(event_id, category_id);
