SELECT*
FROM tripdata_2022


-- Comparing avg ride time between casual and members

SELECT member_casual, day_of_week, AVG(ride_minutes) AS Avg_Min_Per_Day
FROM tripdata_2022
GROUP BY member_casual, day_of_week
ORDER BY CASE
	WHEN day_of_week = 'Sunday' THEN 1
    WHEN day_of_week = 'Monday' THEN 2
    WHEN day_of_week = 'Tuesday' THEN 3
    WHEN day_of_week = 'Wednesday' THEN 4
    WHEN day_of_week = 'Thursday' THEN 5
    WHEN day_of_week = 'Friday' THEN 6
    ELSE 7
	END, member_casual ASC


-- Seeing what type of bike is rented by casual vs members

SELECT member_casual, rideable_type, COUNT(rideable_type) AS bike_type_rented
FROM tripdata_2022
GROUP BY member_casual, rideable_type
ORDER BY member_casual ASC


-- Bikes rented per week

SELECT member_casual, day_of_week, COUNT(ride_id) AS rides_per_weekday
FROM tripdata_2022
GROUP BY member_casual, day_of_week
ORDER BY CASE
	WHEN day_of_week = 'Sunday' THEN 1
    WHEN day_of_week = 'Monday' THEN 2
    WHEN day_of_week = 'Tuesday' THEN 3
    WHEN day_of_week = 'Wednesday' THEN 4
    WHEN day_of_week = 'Thursday' THEN 5
    WHEN day_of_week = 'Friday' THEN 6
    ELSE 7
	END, member_casual ASC


-- Rides rented per month by members

SELECT MONTH(started_at) AS Month, COUNT(*) AS rides_count, member_casual
FROM tripdata_2022
GROUP BY MONTH(started_at), member_casual
ORDER BY MONTH(started_at) ASC


-- Count stations casual/members started at

SELECT* 
FROM
(
SELECT member_casual, COUNT(start_station_name) AS start_station, start_station_name, start_lat, start_lng,
       row_number() over (partition by member_casual order by start_station_name desc) as street_rank 
FROM tripdata_2022
WHERE member_casual = 'casual'
GROUP BY start_station_name, member_casual, start_lat, start_lng
) ranks
ORDER BY start_station DESC

SELECT* 
FROM
(
SELECT member_casual, COUNT(start_station_name) AS start_station, start_station_name, start_lat, start_lng,
       row_number() over (partition by member_casual order by start_station_name desc) as street_rank 
FROM tripdata_2022
WHERE member_casual = 'member'
GROUP BY start_station_name, member_casual, start_lat, start_lng
) ranks
ORDER BY start_station DESC


-- Count stations casual/members ended at

SELECT* 
FROM
(
SELECT member_casual, COUNT(end_station_name) AS end_station, end_station_name, end_lat, end_lng,
       row_number() over (partition by member_casual order by end_station_name desc) as street_rank 
FROM tripdata_2022
GROUP BY end_station_name, member_casual, end_lat, end_lng
) ranks
WHERE member_casual = 'casual'
ORDER BY end_station DESC

SELECT* 
FROM
(
SELECT member_casual, COUNT(end_station_name) AS end_station, end_station_name, end_lat, end_lng,
       row_number() over (partition by member_casual order by end_station_name desc) as street_rank 
FROM tripdata_2022
GROUP BY end_station_name, member_casual, end_lat, end_lng
) ranks
WHERE member_casual = 'member'
ORDER BY end_station DESC


-- Comparing how many members vs casuals start/end during which parts of the day

SELECT* 
FROM
(
SELECT member_casual, start_time_of_day, COUNT(start_time_of_day) AS part_started,
       row_number() over (partition by member_casual order by start_time_of_day desc) as start_rank 
FROM tripdata_2022
GROUP BY start_time_of_day, member_casual
) ranks


SELECT* 
FROM
(
SELECT member_casual, end_time_of_day, COUNT(end_time_of_day) AS part_ended,
       row_number() over (partition by member_casual order by end_time_of_day desc) as end_rank 
FROM tripdata_2022
GROUP BY end_time_of_day, member_casual
) ranks
