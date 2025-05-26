SELECT * FROM taxi_fare LIMIT 5

SELECT SUM(total_amount) as total_amount
FROM taxi_fare

-- Total revenue = 370256.72

SELECT AVG(fare_amount) 
FROM taxi_fare

-- Average fare_amount = 13

SELECT SUM(tip_amount) as total_tip_amount, AVG(tip_amount) as avg_tip_amount
FROM taxi_fare

-- Total Tip amount = 41670.37
-- Average Tip amount = 1.90

SELECT COUNT(tip_amount) as total_tip_count
FROM taxi_fare
WHERE tip_amount > 0

-- Total tip = 14642 times

SELECT COUNT(*) as total_rides
FROM taxi_fare

-- Total rides = 22699

SELECT SUM(taxi_fare.passenger_count) as total_passengers,AVG(taxi_fare.passenger_count) as avg_passengers
FROM taxi_fare

-- Total passengers = 37279
-- Average passenger = 2

SELECT SUM(taxi_fare.trip_distance) as total_distance_coverd,AVG(taxi_fare.trip_distance) as avg_distance_coverd
FROM taxi_fare

-- Total distance coverd = 66129.13
-- Average distance coverd = 3 miles

SELECT SUM(total_amount)/SUM(trip_distance) FROM taxi_fare
WHERE trip_distance > 0

-- Average Total Fare per Mile = 5.56

CREATE TABLE taxi_data AS
SELECT 
    tf.*,  -- all columns from taxi_fare
    pu."Zone" AS pickup_zone,
    pu."Borough" AS pickup_borough,
    dz."Zone" AS dropoff_zone,
    dz."Borough" AS dropoff_borough
FROM 
    taxi_fare tf
LEFT JOIN 
    time_zone pu ON tf."PULocationID" = pu."LocationID"
LEFT JOIN 
    time_zone dz ON tf."DOLocationID" = dz."LocationID";


SELECT * FROM taxi_data limit 5


SELECT pickup_zone, COUNT(*) AS pickup_count
FROM taxi_data
GROUP BY pickup_zone
ORDER BY pickup_count DESC
LIMIT 1;

-- Most common pickup zones = "Upper East Side South"	890

SELECT dropoff_zone, COUNT(*) AS dropoff_count
FROM taxi_data
GROUP BY dropoff_zone
ORDER BY dropoff_count DESC
LIMIT 1;

-- Most common dropoff zones = "Midtown Center"	858

SELECT payment_type, COUNT(*) 
FROM taxi_data 
GROUP BY payment_type 
ORDER BY COUNT(*) DESC 
LIMIT 1;

-- most comman payment_type = Credit card

SELECT pickup_zone, SUM(total_amount) as revenue 
FROM taxi_data 
GROUP BY pickup_zone 
ORDER BY revenue DESC 
LIMIT 1;

-- most profitable zone = "JFK Airport"	29257.82

SELECT 
    column_name, 
    data_type
FROM 
    information_schema.columns
WHERE 
    table_name = 'taxi_data'
  AND table_schema = 'public';

-- Convert pickup datetime from text to timestamp
ALTER TABLE taxi_data
ALTER COLUMN tpep_pickup_datetime 
TYPE timestamp 
USING tpep_pickup_datetime::timestamp;

-- Convert dropoff datetime from text to timestamp
ALTER TABLE taxi_data
ALTER COLUMN tpep_dropoff_datetime 
TYPE timestamp 
USING tpep_dropoff_datetime::timestamp;


SELECT AVG(EXTRACT(EPOCH FROM (tpep_dropoff_datetime - tpep_pickup_datetime))/60) AS avg_trip_duration_mins
FROM taxi_data;

-- Average drip duration = 17 min

-- checking how passengers and fare amount vary in each hour
SELECT 
  EXTRACT(HOUR FROM tpep_pickup_datetime) AS hour_of_day,
  COUNT(*) AS total_rides,
  SUM(passenger_count) as total_passenger,
  AVG(fare_amount) AS avg_fare
FROM 
  taxi_data
GROUP BY 
  hour_of_day
ORDER BY 
  hour_of_day

-- checking how passengers and fare amount vary in each day
SELECT 
  TO_CHAR(tpep_pickup_datetime, 'Day') AS day_name,
  COUNT(*) AS total_rides,
  SUM(passenger_count) AS total_passenger,
  AVG(fare_amount) AS avg_fare
FROM 
  taxi_data
GROUP BY 
  day_name
ORDER BY 
  MIN(tpep_pickup_datetime)

-- cheking about pickup zone with fare
SELECT 
  pickup_zone,
  AVG(fare_amount) AS avg_fare,
  COUNT(*) AS total_rides,
  AVG(trip_distance) as avg_trip_distance
FROM 
  taxi_data
GROUP BY 
  pickup_zone
ORDER BY 
  avg_fare
LIMIT 10;


SELECT SUM(total_amount) as revenue,pickup_zone
FROM taxi_data
GROUP BY pickup_zone
ORDER BY revenue DESC
LIMIT 10


SELECT 
    TO_CHAR(tpep_pickup_datetime::timestamp, 'Month') AS month_name,
    EXTRACT(MONTH FROM tpep_pickup_datetime::timestamp) AS month_number,
    AVG(fare_amount) AS avg_fare,
    SUM(passenger_count) AS total_passengers,
    SUM(total_amount) AS total_revenue,
    COUNT(*) AS total_rides
FROM 
    taxi_data
GROUP BY 
    month_name, month_number
ORDER BY 
    month_number;


SELECT pickup_zone, AVG(tip_amount) as avg_tip
FROM taxi_data
GROUP BY pickup_zone
ORDER BY avg_tip 









