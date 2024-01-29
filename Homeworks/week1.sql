--Count records
SELECT COUNT(*)
FROM green_taxi_trips
WHERE 
    DATE(lpep_pickup_datetime) = '2019-09-18' AND
    DATE(lpep_dropoff_datetime) = '2019-09-18';

--Which was the pick up day with the largest trip distance. Use the pick up time for your calculations.
select max(trip_distance) as dist, date(lpep_pickup_datetime)
from green_taxi_trips
group by date(lpep_pickup_datetime)
order by dist desc

--Consider lpep_pickup_datetime in '2019-09-18' and ignoring Borough has Unknown
--Which were the 3 pick up Boroughs that had a sum of total_amount superior to 50000?
SELECT t2."Borough", SUM(t1.total_amount) AS total_amount
FROM green_taxi_trips t1
JOIN zones_lookup t2 ON t1."PULocationID" = t2."LocationID"
WHERE DATE(t1.lpep_pickup_datetime) = '2019-09-18'
  AND t2."Borough" != 'Unknown'
GROUP BY t2."Borough"
HAVING SUM(t1.total_amount) > 50000
ORDER BY total_amount DESC
LIMIT 3;

--For the passengers picked up in September 2019 in the zone name Astoria which was the drop off zone that had the largest tip? 
--We want the name of the zone, not the id.
WITH SeptemberTrips AS (
    SELECT
        gtr.*,
        zl_dropoff."Zone" AS dropoff_zone_name
    FROM
        green_taxi_trips gtr
    JOIN
        zones_lookup zl_pickup ON gtr."PULocationID" = zl_pickup."LocationID"
    JOIN
        zones_lookup zl_dropoff ON gtr."DOLocationID" = zl_dropoff."LocationID"
    WHERE
        zl_pickup."Zone" = 'Astoria'
        AND DATE(gtr.lpep_pickup_datetime) BETWEEN '2019-09-01' AND '2019-09-30'
)
SELECT
    dropoff_zone_name,
    MAX(tip_amount) AS max_tip_amount
FROM
    SeptemberTrips
GROUP BY
    dropoff_zone_name
ORDER BY
    max_tip_amount DESC
LIMIT 1;
