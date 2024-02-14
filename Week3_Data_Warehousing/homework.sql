--Create table
CREATE OR REPLACE EXTERNAL TABLE `Green_taxi_2022.green_taxi_tables_2022`
OPTIONS (
  format = 'CSV',
  uris = ['gs://green_taxi_2134/green_tripdata_2022-*.parquet']
);

CREATE OR REPLACE TABLE Green_taxi_2022.green_taxi_tables_2022_non_partitoned AS
SELECT * FROM Green_taxi_2022.green_taxi_tables_2022;


--Question 1: What is count of records for the 2022 Green Taxi Data??
SELECT count(*) FROM `Green_taxi_2022.green_taxi_tables_2022`
840402

-- Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.
--What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?
---- Query scans 0 MB
select count(distinct PULocationID) from `Green_taxi_2022.green_taxi_tables_2022`
---- Query scans 6.41 MB
select count(distinct PULocationID) from `Green_taxi_2022.green_taxi_tables_2022_non_partitoned`

--Write a query to retrieve the distinct PULocationID between lpep_pickup_datetime 06/01/2022 and 06/30/2022 (inclusive)

--Use the materialized table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 4 and note the estimated bytes processed. What are these values?

select count(distinct PULocationID) from `seventh-sensor-412710.Green_taxi_2022.green_taxi_tables_2022_non_partitoned`
select count(distinct PULocationID) from `seventh-sensor-412710.Green_taxi_2022.green_taxi_tables_2022`

-- Creating a partitioned and clustered table
CREATE OR REPLACE TABLE `Green_taxi_2022.partitioned_green_taxi`
PARTITION BY DATE(lpep_pickup_datetime)
CLUSTER BY PULocationID AS
SELECT * FROM Green_taxi_2022.green_taxi_tables_2022;

--Write a query to retrieve the distinct PULocationID between lpep_pickup_datetime 06/01/2022 and 06/30/2022 (inclusive)
--Use the materialized table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 4 and note the estimated bytes processed. What are these values?

12.82Mb and 1.16mb
-- Query scans 12.82 MB
SELECT count(distinct PULocationID) as trips
FROM Green_taxi_2022.green_taxi_tables_2022_non_partitoned
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' AND '2022-07-01';

---- Query scans 1.16 MB
SELECT count(distinct PULocationID) as trips
FROM Green_taxi_2022.partitioned_green_taxi
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' AND '2022-07-01';
