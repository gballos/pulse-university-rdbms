DROP SCHEMA IF EXISTS 'pulse_uni_db';
CREATE SCHEMA 'pulse_uni_db';
USE 'pulse_uni_db';

DROP TABLE IF EXISTS LOCATIONS;
CREATE TABLE LOCATIONS (
	location_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    address VARCHAR(50) CHECK(adress like '%, %'),   -- formatted as Street, Number?
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
    duration INT,  -- having duration in minutes?
    location_id INT UNSIGNED,
    PRIMARY KEY(festival_id),
    FOREIGN KEY(location_id) REFERENCES LOCATIONS(location_id)
);

DROP TABLE IF EXISTS STAGES;
CREATE TABLE STAGES (
	stage_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    stage_name VARCHAR(50),
    stage_description VARCHAR(50),
    max_capacity INT,
    PRIMARY KEY(stage_id)
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

DROP TABLE IS EXISTS PERFORMANCE_TYPES;
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
    is_group_or_solo BOOLEAN,
    -- artist_or_group_id INT NOT NULL,
    PRIMARY KEY(performance_id),
    FOREIGN KEY(performance_type_id)  REFERENCES PERFORMANCE_TYPES(performance_type_id),
    FOREIGN KEY(event_id) REFERENCES FESTIVAL_EVENTS(event_id)
    -- FOREIGN KEY( ) artists/group id ?
);


CREATE TABLE STAFF_CATEGORIES (
	staff_category_id INT NOT NULL,
    staff_category_description VARCHAR(50),
    PRIMARY KEY(staff_category_id)
);

CREATE TABLE LEVELS_OF_EXPERTISE (
	level_id INT NOT NULL,
    level_description VARCHAR(50),
    PRIMARY KEY(level_id)
);

DROP TABLE IF EXISTS STAFF;
CREATE TABLE STAFF (
	staff_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    staff_category_id INT NOT NULL,
    level_id INT NOT NULL,
    event_id INT UNSIGNED NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    PRIMARY KEY(staff_id),
    FOREIGN KEY(staff_category_id) REFERENCES STAFF_CATEGORIES(staff_category_id),
    FOREIGN KEY(level_id) REFERENCES LEVELS_OF_EXPERTISE(level_id),
    FOREIGN KEY(event_id) REFERENCES FESTIVAL_EVENTS(event_id)
); 
