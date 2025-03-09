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
