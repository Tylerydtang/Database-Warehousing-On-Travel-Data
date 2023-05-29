--CS779 A1 Spring 2023 Term Project
--Yuandi Tang U65674688

--Import weather and travel CSV files
CREATE TABLE project.full_data_flightdelay (
MONTH TEXT,
DAY_OF_WEEK TEXT,
DEP_DEL15 TEXT,
DEP_TIME_BLK TEXT,
DISTANCE_GROUP TEXT,
SEGMENT_NUMBER TEXT,
CONCURRENT_FLIGHTS TEXT,
NUMBER_OF_SEATS TEXT,
CARRIER_NAME TEXT,
AIRPORT_FLIGHTS_MONTH TEXT,
AIRLINE_FLIGHTS_MONTH TEXT,
AIRLINE_AIRPORT_FLIGHTS_MONTH TEXT,
AVG_MONTHLY_PASS_AIRPORT TEXT,
AVG_MONTHLY_PASS_AIRLINE TEXT,
FLT_ATTENDANTS_PER_PASS TEXT,
GROUND_SERV_PER_PASS TEXT,
PLANE_AGE TEXT,
DEPARTING_AIRPORT TEXT,
LATITUDE TEXT,
LONGITUDE TEXT,
PREVIOUS_AIRPORT TEXT,
PRCP TEXT,
SNOW TEXT,
SNWD TEXT,
TMAX TEXT,
AWND TEXT
)

CREATE TABLE project.flights (
planetokenno SERIAL CONSTRAINT fkplanetoken REFERENCES project.plane(planetokenno),
travelCode TEXT,
userCode TEXT,
locfrom TEXT,
locto TEXT,
flightType TEXT,
price TEXT,
time TEXT,
distance TEXT,
agency TEXT,
date TEXT
)

CREATE TABLE project.users (
code TEXT,
company TEXT,
name TEXT,
gender TEXT,
age TEXT
)

CREATE TABLE project.hotels (
travelCode TEXT,
userCode TEXT,
name TEXT,
place TEXT,
days TEXT,
price TEXT,
total TEXT,
date TEXT
)

--IMPORT INTO POSTGRESQL
--import data flight delay
COPY  project.full_data_flightdelay (
MONTH,
DAY_OF_WEEK,
DEP_DEL15,
DEP_TIME_BLK,
DISTANCE_GROUP,
SEGMENT_NUMBER,
CONCURRENT_FLIGHTS,
NUMBER_OF_SEATS,
CARRIER_NAME,
AIRPORT_FLIGHTS_MONTH,
AIRLINE_FLIGHTS_MONTH,
AIRLINE_AIRPORT_FLIGHTS_MONTH,
AVG_MONTHLY_PASS_AIRPORT,
AVG_MONTHLY_PASS_AIRLINE,
FLT_ATTENDANTS_PER_PASS,
GROUND_SERV_PER_PASS,
PLANE_AGE,
DEPARTING_AIRPORT,
LATITUDE,
LONGITUDE,
PREVIOUS_AIRPORT,
PRCP,
SNOW,
SNWD,
TMAX,
AWND
)
FROM 'D:\Download\Spring2023\779\TERM PROJECT\full_data_flightdelay.csv'
DELIMITER ','
CSV HEADER;

--import users data
COPY project.users (
code,
company,
name,
gender,
age
)

FROM 'D:\Download\Spring2023\779\TERM PROJECT\travel\users.csv'
DELIMITER ','
CSV HEADER;

--import hotels data
COPY  project.hotels (
travelCode,
userCode,
name,
place,
days,
price,
total,
date
)
FROM 'D:\Download\Spring2023\779\TERM PROJECT\travel\hotels.csv'
DELIMITER ','
CSV HEADER;

--import flights data
COPY  project.flights (
travelCode,
userCode,
locfrom,
locto,
flightType,
price,
time,
distance,
agency,
date
)
FROM 'D:\Download\Spring2023\779\TERM PROJECT\travel\flights.csv'
DELIMITER ','
CSV HEADER;

--drop users data
DROP TABLE project.users

--alter and clean
ALTER TABLE Project.flights
ALTER COLUMN date TYPE date USING date::date,

ALTER TABLE Project.hotels
ALTER COLUMN date TYPE date USING date::date;




--ERD tables

--change raw data names
ALTER TABLE project.hotels RENAME TO h;
ALTER TABLE project.flights RENAME TO f;
ALTER TABLE project.full_data_flightdelay RENAME TO f1;


--building new data
CREATE TABLE project.type (
    TypeNo SERIAL PRIMARY KEY,
    TypePrevious varchar(25),
	TypeCurrent varchar(25)
);

INSERT INTO project.type (TypeCurrent)
SELECT DISTINCT project.f.flightType
FROM project.f

SELECT* FROM TYPE

CREATE TABLE project.AIRLINE (
    CarrierNo SERIAL PRIMARY KEY,
    Airline varchar(50),
	AIRLINE_FLIGHTS_MONTH TEXT,
	AVG_MONTHLY_PASS_AIRLINE TEXT,
	FLT_ATTENDANTS_PER_PASS TEXT,
	GROUND_SERV_PER_PASS TEXT
);

INSERT INTO project.AIRLINE(Airline,AIRLINE_FLIGHTS_MONTH,AVG_MONTHLY_PASS_AIRLINE,FLT_ATTENDANTS_PER_PASS,GROUND_SERV_PER_PASS)
SELECT CARRIER_NAME,AIRLINE_FLIGHTS_MONTH,AVG_MONTHLY_PASS_AIRLINE,FLT_ATTENDANTS_PER_PASS,GROUND_SERV_PER_PASS
FROM project.f1;

--hotel name
CREATE TABLE project.HotelName(
 HotelNameNo SERIAL PRIMARY KEY,
    HotelNamePrevious varchar(25),
	HotelNameCurrent varchar(25)

);

INSERT INTO project.HotelName(HotelNameCurrent)
SELECT distinct name
FROM project.h;

--location 
CREATE TABLE project.Location(
LocationNo SERIAL PRIMARY KEY,
LocationPrevious varchar(25),
Locationcurrent varchar(25),
Country varchar(25),
City varchar(25),
State varchar(25)
);

INSERT INTO project.Location(Locationcurrent)
SELECT distinct place
FROM project.h;

select * from project.f1

--PLANE
CREATE TABLE project.plane(
PlaneTokenNo SERIAL PRIMARY KEY,
PlaneNo SERIAL,
PlaneAge varchar(25),
Carrier varchar(50)
);

INSERT INTO project.Plane(PlaneAge,carrier)
SELECT PLANE_AGE,CARRIER_NAME
FROM project.f1;



--TABLES WITH FKS
create TABLE project.airports (
AirportNo SERIAL PRIMARY KEY,
AirportNameCurrent varchar(50),
AirportNamePrevious varchar(50),
--LocationNo SERIAL CONSTRAINT fklocation REFERENCES project.location(LocationNo),
AirportFlightMonth 	TEXT
);

INSERT INTO project.Airports(AirportNameCurrent,AirportFlightMonth)
SELECT DISTINCT departing_airport,airport_flights_month
FROM project.f1

--weather
CREATE TABLE project.weather (
WeatherNo SERIAL PRIMARY KEY,
AirportNo SERIAL CONSTRAINT fkairports REFERENCES project.airports(AirportNo),
Airport TEXT,
date TEXT,
Precipitation NUMERIC,
Snowfall NUMERIC,
SnowonGround NUMERIC,
Temperature NUMERIC,
WindSpeed TEXT,
Airquality TEXT,
Airpressure TEXT
);

INSERT INTO project.weather(Airport,date,Precipitation,snowfall,snowonground,temperature,windspeed)
SELECT DEPARTING_AIRPORT,CONCAT(MONTH,DAY_OF_WEEK),CAST(PRCP AS NUMERIC),CAST(SNOW AS NUMERIC),CAST(SNWD AS NUMERIC),CAST(TMAX AS NUMERIC),CAST(AWND AS NUMERIC)
FROM project.f1


--hotels
create TABLE project.hotels (
HotelNo SERIAL PRIMARY KEY,
HotelNameNo SERIAL CONSTRAINT fkhotelnames REFERENCES project.hotelname(HotelNameNo),
LocationNameNo SERIAL CONSTRAINT fklocation REFERENCES project.location(locationNo),
location TEXT,
Hoteldays TEXT,
Hotelprice NUMERIC,
Hoteldate DATE
);

INSERT INTO project.hotels(location,hoteldays,hotelprice,hoteldate)
SELECT place,days,CAST(price AS NUMERIC),CAST(date AS DATE)
FROM project.h


--flights
CREATE TABLE project.flights (
Flightsno SERIAL PRIMARY KEY,
AirportNoF SERIAL CONSTRAINT fkairport REFERENCES project.airports(AirportNo),
AirportNoT SERIAL CONSTRAINT fkairport REFERENCES project.airports(AirportNo),
TypeNo SERIAL CONSTRAINT fktype REFERENCES project.type(typeNo),
CarrierNo SERIAL CONSTRAINT fkcarrier REFERENCES project.airline(CarrierNo),
PlaneNo SERIAL CONSTRAINT fkplane REFERENCES project.airports(AirportNo),
Price NUMERIC,
FlightHours NUMERIC,
Distance NUMERIC,
Date TEXT
);

INSERT INTO project.flights(Price,FlightHours,Distance,Date)
SELECT CAST(price as NUMERIC),CAST(time as NUMERIC),CAST(distance as NUMERIC),date
FROM project.f

--Tuning
--explain a query before indexing
EXPLAIN SELECT * FROM project.weather
WHERE Precipitation >2 AND SNOWFALL<5
ORDER BY precipitation DESC;
--create indexes
CREATE INDEX idx_weather1_hash ON project.weather USING btree(Precipitation);
CREATE INDEX idx_weather2_hash ON project.weather USING btree(Snowfall);
CREATE INDEX idx_weather3_hash ON project.weather USING btree(SnowonGround);
CREATE INDEX idx_weather4_hash ON project.weather USING btree(Temperature);
CREATE INDEX idx_weather5_hash ON project.weather USING btree(WindSpeed);
--explain on it after indexing 
EXPLAIN SELECT * FROM project.weather
WHERE Precipitation >2 AND SNOWFALL<5
ORDER BY precipitation DESC;

--trigger prevent deletion
CREATE OR REPLACE FUNCTION prevent_airline_deletion()
RETURNS trigger AS
$$
BEGIN
  RAISE EXCEPTION 'Deletion of records in the airline table is not allowed';
  RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER prevent_airline_deletion_trigger
BEFORE DELETE ON project.airline
FOR EACH ROW
EXECUTE FUNCTION prevent_airline_deletion();

delete from project.airline
where carrierno =1

--a example of a stored procedure
CREATE OR REPLACE PROCEDURE update_airport_name(
    airport_no integer,
    new_name text
)
LANGUAGE plpgsql
AS $$
DECLARE
    old_name text;
BEGIN
    -- Get the current value of the "AirportNameCurrent" attribute
    SELECT AirportNameCurrent INTO old_name FROM project.airports WHERE AirportNo = airport_no;

    -- If the new value is the same as the old value, do nothing
    IF old_name = new_name THEN
        RETURN;
    END IF;

    -- Otherwise, update the "AirportNamePrevious" attribute with the old value
    UPDATE project.airports SET AirportNamePrevious = old_name WHERE AirportNo = airport_no;

    -- Update the "AirportNameCurrent" attribute with the new value
    UPDATE project.airports SET AirportNameCurrent = new_name WHERE AirportNo = airport_no;
END;
$$;
--test the stored procedures
--show the original value
SELECT * FROM PROJECT.airports
WHERE AIRPORTNO =3;
--execute the new value
DO $$
BEGIN
    CALL update_airport_name(3,'Boston Logan');
END;
$$;
--see changes
SELECT * FROM PROJECT.airports
WHERE airportno = 3
--execute the same value
DO $$
BEGIN
    CALL update_airport_name(3,'Boston Logan');
END;
$$;
--see changes
SELECT * FROM PROJECT.airports
WHERE airportno = 3


--stored procedure to renew the hotel data
CREATE OR REPLACE PROCEDURE update_hotel_name(
    hotelno integer,
    new_name varchar(25)
)
LANGUAGE plpgsql
AS $$
DECLARE
    old_name varchar(25);
BEGIN
    -- Get the current value of the "HotelNameCurrent" attribute
    SELECT HotelNameCurrent INTO old_name FROM project.HotelName WHERE HotelNameNo = hotelno;

    -- If the new value is the same as the old value, do nothing
    IF old_name = new_name THEN
        RETURN;
    END IF;

    -- Otherwise, update the "HotelNamePrevious" attribute with the old value
    UPDATE project.HotelName SET HotelNamePrevious = old_name WHERE HotelNameNo = hotelno;

    -- Update the "HotelNameCurrent" attribute with the new value
    UPDATE project.HotelName SET HotelNameCurrent = new_name WHERE HotelNameNo = hotelno;
END;
$$;
--test the stored procedures
--show the original value
SELECT * FROM PROJECT.hotelname
WHERE hotelnameno =2;
--execute the new value
DO $$
BEGIN
    CALL update_hotel_name(2,'Marriot');
END;
$$;
--see changes
SELECT * FROM PROJECT.hotelname
WHERE hotelnameno = 2
--execute the same value
DO $$
BEGIN
    CALL update_hotel_name(2,'Marriot');
END;
$$;
--see changes
SELECT * FROM PROJECT.hotelname
WHERE hotelnameno = 2

--Dimensional&creation
CREATE TABLE project.time (
TIME TIMESTAMP,
YEAR DATE,	
MONTH DATE,
DAY DATE
);

WITH time_cte AS (
  SELECT time, airportno
  FROM project.time
), hotel_cte AS (
  SELECT hotelno, hotelprices, airportno
  FROM project.hotel
), weather_cte AS (
  SELECT weatherno, windspeed, temperature, airportno
  FROM project.weather
), flight_cte AS (
  SELECT flightno
  FROM project.flight --not working
), airport_cte AS (
  SELECT DISTINCT airportno
  FROM time_cte
  JOIN hotel_cte USING (airportno)
  JOIN weather_cte USING (airportno)
  JOIN flight_cte USING (airportno)
)
SELECT t.time, h.hotelno, w.weatherno, f.flightno, h.hotelprices, wa.windspeed, wa.temperature
FROM airport_cte a
JOIN time_cte t ON a.airportno = t.airportno
JOIN hotel_cte h ON a.airportno = h.airportno
JOIN weather_cte wa ON a.airportno = wa.airportno
JOIN flight_cte f ON a.airportno = f.airportno
WHERE h.hotelprices >= (
  SELECT AVG(hotelprices)
  FROM hotel_cte
  WHERE airportno = a.airportno
)
ORDER BY h.hotelprices DESC;

--create a visual of a sample query
ALTER TABLE project.hotels ALTER COLUMN hotelprice TYPE numeric USING hotelprice::numeric;
SELECT DISTINCT LOCATION, AVG(hotelprice)
FROM project.hotels
GROUP BY project.hotels.LOCATION

COPY (SELECT DISTINCT LOCATION, AVG(hotelprice)
FROM project.hotels
GROUP BY project.hotels.LOCATION) TO 'TO '/users/yuanditang/downloads/avg.csv';