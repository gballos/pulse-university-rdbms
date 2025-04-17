DROP DATABASE IF EXISTS pulse_uni_db;
CREATE DATABASE pulse_uni_db;
USE pulse_uni_db;

DROP TABLE IF EXISTS LOCATIONS;
CREATE TABLE LOCATIONS (
	location_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    address VARCHAR(50), CHECK(address like '%, %'),   -- formatted as Street, Number?
    city VARCHAR(50),
    country VARCHAR(50),
    continent VARCHAR(50),
    longtitude NUMERIC(5, 2),
    latitude NUMERIC(5, 2),
    PRIMARY KEY(location_id)
);

DROP TABLE IF EXISTS FESTIVALS;
CREATE TABLE FESTIVALS (
    festival_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    date_starting DATE,
    date_ending DATE,
    duration INT,
    location_id INT UNSIGNED,
    PRIMARY KEY(festival_id),
    FOREIGN KEY(location_id) REFERENCES LOCATIONS(location_id),
    CHECK (date_ending > date_starting) 
);

DROP TABLE IF EXISTS STAGES;
CREATE TABLE STAGES (
	stage_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    stage_name VARCHAR(50),
    stage_description VARCHAR(50),
    max_capacity INT,
    PRIMARY KEY(stage_id)
);

DROP TABLE IF EXISTS TECHNICAL_SUPPLY; 
CREATE TABLE TECHNICAL_SUPPLY(
	technical_supply_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	technical_supply_description VARCHAR(50),
	current_supply INT UNSIGNED NOT NULL,
	PRIMARY KEY(technical_supply_id)
);

DROP TABLE IF EXISTS STAGES_X_TECHNICAL_SUPPLY; --Many to many relationship
CREATE TABLE STAGES_X_TECHNICAL_SUPPLY(
	amount_of_supply INT UNSIGNED, 
	stage_id INT UNSIGNED,
	technical_supply_id INT UNSIGNED,
	PRIMARY KEY(stage_id, band_id),
	FOREIGN KEY(stage_id) REFERENCES STAGES(stage_id)
	FOREIGN KEY(technical_supply_id) REFERENCES TECHNICAL_SUPPLY(technical_supply_id)
);

DROP TABLE IF EXISTS FESTIVAL_EVENTS;
CREATE TABLE FESTIVAL_EVENTS (  -- events is reserved
	event_id INT USNIGNED NOT NULL AUTO_INCREMENT,
	festival_id INT UNSIGNED NOT NULL,
    stage_id INT  UNSIGNED NOT NULL,
    event_date DATE,
    duration INT,  -- again, in minutes?
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
	music_type_id INT UNSIGNED,
	music_subtype_id INT UNSIGNED,
	website VARCHAR(100) CHECK(website like 'https://%'),
	instagram VARCHAR(50),
	PRIMARY KEY(artist_id),
	FOREIGN KEY(music_type_id) REFERENCES MUSIC_TYPES(music_type_id),
	FOREIGN KEY(music_subtype_id) REFERENCES MUSIC_SUBTYPES(music_subtype_id)
);	


DROP TABLE IF EXISTS BANDS;
CREATE TABLE BANDS(
	band_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	name VARCHAR(25),
	date_of_creation DATE,
	music_type_id INT UNSIGNED,
	music_subtype_id INT UNSIGNED,
	website VARCHAR(100) CHECK(website like 'https://%'),
	instagram VARCHAR(50),
	PRIMARY KEY(band_id),
	FOREIGN KEY(music_type_id) REFERENCES MUSIC_TYPES(music_type_id),
	FOREIGN KEY(music_subtype_id) REFERENCES MUSIC_SUBTYPES(music_subtype_id)
);
	
DROP TABLE IF EXISTS ARTISTS_X_BANDS; --Many to many relationship
CREATE TABLE ARTISTS_X_BANDS(
	artist_id INT UNSIGNED,
	band_id INT UNSIGNED,
	PRIMARY KEY(artist_id, band_id),
	FOREIGN KEY(artist_id) REFERENCES ARTISTS(artist_id)
	FOREIGN KEY(band_id) REFERENCES BANDS(band_id)
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
    duration INT,
    order_in_show INT,
    is_solo BOOLEAN,
    performer_id INT UNSIGNED,
    PRIMARY KEY(performance_id),
    FOREIGN KEY(performance_type_id)  REFERENCES PERFORMANCE_TYPES(performance_type_id),
    FOREIGN KEY(event_id) REFERENCES FESTIVAL_EVENTS(event_id)
    -- Ensuring performer_id exists in the referenced table
    CONSTRAINT chk_performer CHECK (
        (is_solo = 0 AND performer_id IN (SELECT artist_id FROM ARTISTS)) OR
        (is_solo = 1 AND performer_id IN (SELECT band_id FROM BANDS)) --No literal reference to artists/bands - Delete trigger needed
    )
);

DROP TABLE IF EXISTS STAFF;
CREATE TABLE STAFF (
	staff_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    staff_category VARCHAR(15) CHECK(staff_category in ('technical', 'security', 'general')).
    level_of_expertise VARCHAR(10) CHECK(level_of_expertise in ('trainee', 'junior', 'mid', 'senior', 'manager')),
    event_id INT UNSIGNED NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    PRIMARY KEY(staff_id),
    FOREIGN KEY(event_id) REFERENCES FESTIVAL_EVENTS(event_id)
); 

DROP TABLE IF EXISTS VISITORS;
CREATE TABLE VISITORS(
	visitor_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	first_name VARCHAR(20),
	last_name VARCHAR(20),
	phone_number VARCHAR(20),
	email VARCHAR(20),
	age INT,
	PRIMARY KEY(visitor_id)
);

DROP TABLE IF EXISTS TICKETS;
CREATE TABLE TICKETS(
	ticket_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	event_id INT UNSIGNED,
	vistor_id INT UNSIGNED,
	ticket_type VARCHAR(15) CHECK(ticket_type in ('regular', 'VIP', 'backstage')),
	payment_method VARCHAR(15) CHECK(payment_method in ('credit card', 'debit card', 'bank transfer')),
	ean_code CHAR(13),
	is_scanned BOOLEAN,
	date_bought DATE,
	cost INT,
	PRIMARY KEY(ticket_id),
    FOREIGN KEY(event_id) REFERENCES FESTIVAL_EVENTS(event_id),
	FOREIGN KEY(visitor_id) REFERENCES VISTORS(visitor_id)
);

DROP TABLE IF EXISTS REVIEWS;
CREATE TABLE REVIEWS( 
	review_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	visitor_id INT UNSIGNED NOT NULL,
	performance_id INT UNSIGNED NOT NULL,
	interpretation_rating INT CHECK(interpretation_rating BETWEEN 1 AND 5),
	sound_lighting_rating INT CHECK(soun_lighting_rating BETWEEN 1 AND 5),
    	stage_presence_rating INT CHECK(stage_presence_rating BETWEEN 1 AND 5),
    	organization_rating INT CHECK(organization)rating BETWEEN 1 AND 5),
    	overall_impression_rating INT CHECK(overall_impression_rating BETWEEN 1 AND 5),
	PRIMARY KEY(review_id),
	FOREIGN KEY(visitor_id) REFERENCES VISITORS(visitor_id),
	FOREIGN KEY(performance_id) REFERENCES PERFORMANCES(performance_id)
	CHECK( -- check ticket is scanned
        	ticket_id IN (SELECT ticket_id FROM TICKETS WHERE is_scanned = TRUE)
    	)
);

DROP TABLE IF EXISTS BUYERS;
CREATE TABLE BUYERS( 
	buyer_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	event_id INT UNSIGNED,
	ticket_type VARCHAR(15) CHECK(ticket_type in ('regular', 'VIP', 'backstage')),
	ticket_id INT UNSIGNED,
	PRIMARY KEY(buyer_id),
	FOREIGN KEY(event_id) REFERENCES FESTIVAL_EVENTS(event_id),
	FOREIGN KEY(ticket_type) REFERENCES TICKETS(ticket_type),
	FOREIGN KEY(ticket_id) REFERENCES TICKETS(ticket_id)
	CHECK( -- check ticket is not scanned
        	ticket_id IN (SELECT ticket_id FROM TICKETS WHERE is_scanned = FALSE)
    	)
);

DROP TABLE IF EXISTS TICKETS_FOR_RESALE;
CREATE TABLE TICKETS_FOR_RESALE(
	ticket_for_resale_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	ticket_id INT UNSIGNED,
	event_id INT UNSIGNED,
	ticket_type VARCHAR(15) CHECK(ticket_type in ('regular', 'VIP', 'backstage')),
	PRIMARY KEY(ticket_for_resale_id),
	FOREIGN KEY(ticket_id) REFERENCES TICKETS(ticket_id),
	FOREIGN KEY(event_id) REFERENCES FESTIVAL_EVENTS(event_id),
	FOREIGN KEY(ticket_type) REFERENCES TICKETS(ticket_type)
	CHECK( -- check that seller has expressed "valid" interest
        	ticket_id IS NOT NULL 
        	OR (ticket_type IS NOT NULL AND event_id IS NOT NULL)
    	)
);