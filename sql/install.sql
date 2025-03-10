DROP SCHEMA IF EXISTS pulse_uni_db;
CREATE DATABASE pulse_uni_db;
USE pulse_uni_db;

-- Fixed column name in CHECK constraint and coordinate precision
DROP TABLE IF EXISTS LOCATIONS;
CREATE TABLE LOCATIONS (
    location_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    address VARCHAR(50) CHECK(address LIKE '%, %'), 
    city VARCHAR(50),
    country VARCHAR(50),
    continent VARCHAR(50),
    longitude NUMERIC(9, 6), 
    latitude NUMERIC(8, 6),   
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