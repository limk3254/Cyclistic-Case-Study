-- Had trouble with merging all the tables into one because of mismiatched data types. I changed them to the same data type so that the tables cam be unioned

SELECT* 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'jan_tripdata'

SELECT* 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'dec_tripdata'


-- I do not have the all the code for which tables were altered since I did not save them. However below is the code that I had used to change the data type

ALTER TABLE dec_tripdata
ALTER COLUMN end_station_id nvarchar(255)


-- A new table created with the datasets from each month

SELECT* INTO tripdata_2022 FROM jan_tripdata UNION ALL
SELECT* FROM feb_tripdata UNION ALL
SELECT* FROM mar_tripdata UNION ALL
SELECT* FROM apr_tripdata UNION ALL
SELECT* FROM may_tripdata UNION ALL
SELECT* FROM jun_tripdata UNION ALL
SELECT* FROM jul_tripdata UNION ALL
SELECT* FROM aug_tripdata UNION ALL
SELECT* FROM sep_tripdata UNION ALL
SELECT* FROM oct_tripdata UNION ALL
SELECT* FROM nov_tripdata UNION ALL
SELECT* FROM dec_tripdata 


-- Checking for duplicates

SELECT ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual, COUNT(*)
FROM tripdata_2022
GROUP BY ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual
HAVING COUNT(*) > 1


-- Noticed columns with null values. Replaced them with station_name nulls with 'N/A' and station_id with 0

-- Check for nulls

SELECT* 
FROM tripdata_2022

SELECT start_station_name
FROM tripdata_2022
WHERE start_station_name IS NULL

SELECT start_station_id
FROM tripdata_2022
WHERE start_station_id IS NULL

SELECT end_station_name
FROM tripdata_2022
WHERE end_station_name IS NULL


-- Replacing the nulls

UPDATE tripdata_2022
SET start_station_name = 'N/A'
WHERE start_station_name = 0

UPDATE tripdata_2022
SET start_station_id = 0
WHERE start_station_id IS NULL

UPDATE tripdata_2022
SET end_station_name = 'N/A'
WHERE end_station_name IS NULL

UPDATE tripdata_2022
SET end_station_id = 0
WHERE end_station_id IS NULL


-- Created a ride_length column that gets the difference between started_at and ended_at in minutes

ALTER TABLE tripdata_2022
ADD ride_length datetime

SELECT DATEDIFF(MINUTE, started_at, ended_at) 
FROM tripdata_2022

UPDATE tripdata_2022
SET ride_length = CONVERT(int, DATEDIFF(MINUTE, started_at, ended_at))

ALTER TABLE tripdata_2022
ADD ride_minutes int

UPDATE tripdata_2022
SET ride_minutes = CONVERT(int, DATEDIFF(MINUTE, started_at, ended_at))


-- Get date only from started_at for date rented

ALTER TABLE tripdata_2022
ADD date_rented datetime

UPDATE tripdata_2022
SET date_rented = CONVERT(DATE, started_at)


-- Add weekday column 

ALTER TABLE tripdata_2022
ADD day_of_week nvarchar(255)

SELECT started_at, DATEPART(dw, started_at) AS Weekday
FROM tripdata_2022

UPDATE tripdata_2022
SET day_of_week = CASE
	WHEN DATEPART(dw, started_at) = 1 THEN 'Sunday'
	WHEN DATEPART(dw, started_at) = 2 THEN 'Monday'
	WHEN DATEPART(dw, started_at) = 3 THEN 'Tuesday'
	WHEN DATEPART(dw, started_at) = 4 THEN 'Wednesday'
	WHEN DATEPART(dw, started_at) = 5 THEN 'Thursday'
	WHEN DATEPART(dw, started_at) = 6 THEN 'Friday'
	ELSE 'Saturday'
	END


-- Isolating time for starting and ending

-- Start

ALTER TABLE tripdata_2022
ADD start_time char(5)

UPDATE tripdata_2022
SET start_time = CONVERT(char(5), started_at, 108)


-- End

ALTER TABLE tripdata_2022
ADD end_time char(5)

UPDATE tripdata_2022
SET end_time = CONVERT(char(5), ended_at, 108)


-- Time of day when customers start and end their rides

--Start

ALTER TABLE tripdata_2022
ADD start_time_of_day char(100)

UPDATE tripdata_2022
SET start_time_of_day = CASE
	WHEN start_time between '05:00' AND '11:59' THEN 'Morning'
    WHEN start_time between '12:00' AND '16:59' THEN 'Noon'
    WHEN start_time between '17:00' AND '20:59' THEN 'Evening'
	ELSE 'Night'
	END 


-- End

ALTER TABLE tripdata_2022
ADD end_time_of_day char(100)

UPDATE tripdata_2022
SET end_time_of_day = CASE
	WHEN end_time between '05:00' AND '11:59' THEN 'Morning'
    WHEN end_time between '12:00' AND '16:59' THEN 'Noon'
    WHEN end_time between '17:00' AND '21:00' THEN 'Evening'
	ELSE 'Night'
	END


-- Creating a month column

ALTER TABLE tripdata_2022
ADD m0nth nvarchar (255)
 
UPDATE tripdata_2022
SET m0nth = CONVERT(nvarchar, DATEPART(MONTH, started_at))
 
UPDATE tripdata_2022
SET m0nth = CASE
	WHEN m0nth = 1 THEN 'JAN'
	WHEN m0nth = 2 THEN 'FEB'
	WHEN m0nth = 3 THEN 'MAR'
	WHEN m0nth = 4 THEN 'APR'
	WHEN m0nth = 5 THEN 'MAY'
	WHEN m0nth = 6 THEN 'JUN'
	WHEN m0nth = 7 THEN 'JUL'
	WHEN m0nth = 8 THEN 'AUG'
	WHEN m0nth = 9 THEN 'SEP'
	WHEN m0nth = 10 THEN 'OCT'
	WHEN m0nth = 11 THEN 'NOV'
	ELSE 'DEC'
	END

