Jan 11, 2023
* Downloaded 12 zip files for 2022 trip data
* Unzipped 12 files containing one month of data in each and added to a single folder labeled 2022_divvy_tripdata
* Renamed file “202209-divvy-publictripdata” to “202209-divvy-tripdata” for consistency
* Uploaded all to new dataset in BigQuery named trip_data_2022
* Notable finds during cleaning and examining data: 
   * Where bikes were checked out and returned to the same station, the start station name and end station name are both the same. 
   * Trips where started_at and ended_at are different, but start_lat/start_lng and end_lat/end_lng are the same should be included (trip was a circle)
      * maybe determine how many of these were less than 5 minutes? 2 minutes?: Took it out then changed mind and returned it? 
   * NULL entries are present for some rides for ending station name, ending lat and ending long, indicating that the bike was not checked back in. 
      * Maybe they were stolen? Find these rides and determine if any had a very long ride time indicating they may have been stolen or abandoned. 
   * Some trips were to/from vaccination sites 
                                
* 012022 trip data
   * SCHEMA: PROPER
   * DUPLICATES; NONE
   * With length() function, found ride_id that are expressed as exponential numbers. Since there are no duplicates, will leave them in their current format. 
   * NO NULL ENTRIES: for primary key (ride_id), rideable_type, started_at, ended_at, start_lat, start_lng, member_casual
   * NULL ENTRIES: present for starting_station_name - is not relevant at this time due to presence of start_lat, start_lng 
   * Many NULL entries present >1000 for end_station_name, not relevant as most have end_lat and end_lng
   * MISFILLED DATA: NONE
   * OUTLIERS: NONE
* 022022 trip data
   * SCHEMA: PROPER
   * DUPLICATES: none
   * NULL ENTRIES: start_station_name, start_station_id, end_station_name, end_station_id, end_lat, end_lng
   * NO NULL ENTRIES: ride_id, rideable_type, started_at, ended_at, start_lat, start_lng, member_casual
   * MISFILLED DATA: none
   * OUTLIERS: NONE
* 032022 trip data
   * SCHEMA: PROPER
   * DUPLICATES: none
   * NULL ENTRIES: start_station_name, start_station_id, end_station_name, end_station_id, end_lat, end_lng 
   * NO NULL ENTRIES: ride_id, rideable_type, started_at, ended_at, start_lat, start_lng, member_casual
   * MISFILLED DATA - using length(cast x as string): start_station_id: Hastings WH2
   * OUTLIERS: NONE
* 042022 trip data
   * SCHEMA: PROPER
   * DUPLICATES: NONE
   * NULL ENTRIES: 
   * NO NULL ENTRIES:  ride_id, rideable_type, started_at, ended_at, start_lat, start_lng, member_casual
   * MISFILLED DATA: 
   * OUTLIERS: NONE
* 052022 trip data
   * SCHEMA: PROPER
   * DUPLICATES: NONE
   * NULL ENTRIES: 
   * NO NULL ENTRIES:  ride_id, rideable_type, started_at, ended_at, start_lat, start_lng, member_casual
   * MISFILLED DATA: 
   * OUTLIERS: max(ended_at) = 2022-06-02 11:35:01, MIN(end_lng) = -88.14
* 062022 trip data
   * SCHEMA: PROPER
   * DUPLICATES: NONE
   * NULL ENTRIES: 
   * NO NULL ENTRIES:  ride_id, rideable_type, started_at, ended_at, start_lat, start_lng, member_casual
   * MISFILLED DATA: 
   * OUTLIERS: max(ended_at) = 2022-07-13 04:21:06
________________


* 072022 trip data
   * SCHEMA: PROPER
   * DUPLICATES: NONE
   * NULL ENTRIES: 
   * NO NULL ENTRIES:  ride_id, rideable_type, started_at, ended_at, start_lat, start_lng, member_casual
   * MISFILLED DATA: 
   * OUTLIERS: max(ended_at) = 2022-08-04 13:53:01
* 082022 trip data
   * SCHEMA: PROPER
   * DUPLICATES: NONE
   * NULL ENTRIES: 
   * NO NULL ENTRIES:  ride_id, rideable_type, started_at, ended_at, start_lat, start_lng, member_casual
   * MISFILLED DATA: 
   * OUTLIERS: max(ended_at) = 2022-09-06 21:49:04, min(end_lng) = -88.05
* 092022 trip data
   * SCHEMA: PROPER
   * DUPLICATES: NONE
   * NULL ENTRIES: 
   * NO NULL ENTRIES:  ride_id, rideable_type, started_at, ended_at, start_lat, start_lng, member_casual
   * MISFILLED DATA: 
   * OUTLIERS: max(ended_at)= 2022-10-05 19:53:11
* 102022 trip data
   * SCHEMA: PROPER
   * DUPLICATES: NONE
   * NULL ENTRIES: 
   * NO NULL ENTRIES:  ride_id, rideable_type, started_at, ended_at, start_lat, start_lng, member_casual
   * MISFILLED DATA: 
   * OUTLIERS: max(ended_at)= 2022-11-07 04:53:58
   * * 112022 trip data
   * SCHEMA: PROPER
   * DUPLICATES: NONE
   * NULL ENTRIES: 
   * NO NULL ENTRIES:  ride_id, rideable_type, started_at, ended_at, start_lat, start_lng, member_casual
   * MISFILLED DATA: 
   * OUTLIERS: MIN(end_lat) = 0, Max(end_lng) = 0 
* 122022 trip data
   * SCHEMA: PROPER
   * DUPLICATES: NONE
   * NULL ENTRIES: 
   * NO NULL ENTRIES: 
   * MISFILLED DATA: 
   * OUTLIERS: none


Combined 12 tables into one using INSERT INTO table SELECT * from table for each table for a total of 5,667,716 rows named trip_data_012022


Dropped columns start_station_id and end_station_id as not necessary for analysis and to reduce table size


Deleted rows that have the same time for started_at and ended_at times, and saved as new table canceled_trips_2022


**Outliers: sorted by end_lat ASC and DESC and found some trips ending at Green St & Madison Ave* station had end_lat and end_lng = 0.0. Updated table to add appropriate end_lat and end_lng for these entries.


**Missing data: rows that have NULL values for end_lat and end_lng also are missing end_station_name, therefore cannot be used for trip distance data. These trips do have start and end times, so can be used for trip length data. ALTHOUGH there is a question as to if these bikes were stolen or lost or abandoned. There are 5858 of these trips ranging from a trip time of 35 seconds to a max of 689 hours, 47 minutes, 15 seconds (saved in google drive as tripdata_missing_ending_location.csv)


**Missing data where start_station_name and end_station_name are both NULL are all found to be electric bikes and are considered to be ‘charging times’ and are deleted, as this does not reflect member or casual activity. 


DELETE FROM `cyclistic-case-study-374601.trip_data_2022.trip_data_012022` 
WHERE start_station_name IS NULL AND end_station_name IS NULL 
This statement removed 427,005 rows from trip_data_012022


/* further trim trips with no start station (but have ending station) */
DELETE
FROM `cyclistic-case-study-374601.trip_data_2022.trip_data_012022` 
WHERE start_station_name IS NULL


 
Typos: I have not found any during cleaning, I may be able to find during visualization
Misfields: Possible misfield in started_at and ended_at for several entries. Found when sorting for length of trip. Several trips calculate to negative trip times. 
Format errors: none
Data consistency:
*  latitude and longitude entries are not consistent length. Applied UPDATE and ROUND function to start_lat, start_lng, end_lat, end_lng to round to 4 decimal places where field IS  NOT NULL
* Station names do not have consistent latitude and longitude values. Each station name should have a fixed lat/long.  Will update each station to have the AVERAGE() latitude /longitude for that specific station to stardardize the lat/long to better be able to visualize the location on a map. 
* Utilized chatGPT to get some ideas on how to proceed with the update. Recommended code suggests to use a cte and an update/join
* MYSQL is not happy with using a cte with the UPDATE function. 
* Further queries with chatGPT suggested creating a temporary table, then joining the table and updating. 
* Needed to google search for the correct syntax for BigQuery. 


My ultimate solution: 
* Copied table to a new trip_data_012022_v3
* Created 2 new tables named start_station_geo and end_station_geo that contain the station names and the average latitude and longitude for each start station and end station, rounded to 4 decimal places (saved in BigQuery Google Cloud server under trip_data_2022 dataset)
Note: I probably could have made it just one table, but wanted to keep the statements shorter to avoid typos and make it easier to read. I recognize that many start_station_names and end_station_names are the same, but would not be assigned the same average lat and lng using this method. I am okay with this. 


SELECT start_station_name, ROUND(AVG(start_lat),4) as avg_lat, ROUND(AVG(start_lng),4) as avg_lng
FROM `cyclistic-case-study-374601.trip_data_2022.trip_data_012022_v3`
WHERE start_station_name IS NOT NULL
GROUP BY start_station_name


SELECT end_station_name, ROUND(AVG(end_lat),4) as avg_lat, ROUND(AVG(end_lng),4) as avg_lng
FROM `cyclistic-case-study-374601.trip_data_2022.trip_data_012022_v3`
WHERE end_station_name IS NOT NULL
GROUP BY end_station_name


* Updated start_station_name start_lat and start_lng with the start_station_geo avg_lat and avg_lng


        UPDATE `cyclistic-case-study-374601.trip_data_2022.trip_data_012022_v3` AS td 
SET td.start_lat = sgeo.avg_lat, td.start_lng = sgeo.avg_lng
FROM `cyclistic-case-study-374601.trip_data_2022.start_station_geo` AS sgeo
WHERE td.start_station_name = sgeo.start_station_name
        
* Updated end_station_name end_lat and end_lng with end_station_geo avg_lat and avg_lng
UPDATE `cyclistic-case-study-374601.trip_data_2022.trip_data_012022_v3` AS td 
SET td.end_lat = egeo.avg_lat, td.end_lng = egeo.avg_lng
FROM `cyclistic-case-study-374601.trip_data_2022.end_station_geo` AS egeo
WHERE td.end_station_name = egeo.end_station_name






VERIFICATION: 
* checked max/min end_lat, end_lng where end_station_name is present
* Checked for zero length trips (started_at and ended_at are same date/time) - found several trips that are negative trip times
* Verified appropriate columns are present and schema is correct


Further cleaning: 
* Delete negative trip times (found exactly 100 trips), due to very small number of trips relative to total number of trips and insignificant to analysis. 
DELETE
FROM `cyclistic-case-study-374601.trip_data_2022.trip_data_012022`
WHERE UNIX_SECONDS(ended_at)-UNIX_SECONDS(started_at) < 0
This statement removed 100 rows from trip_data_012022.






VERIFICATION: 
        Check for negative trip times: 


                SELECT ride_id
FROM `cyclistic-case-study-374601.trip_data_2022.trip_data_012022_v3`
WHERE UNIX_SECONDS(ended_at)-UNIX_SECONDS(started_at) <0




Check for NULL starting AND ending stations:


SELECT * 
FROM `cyclistic-case-study-374601.trip_data_2022.trip_data_012022_v3` 
WHERE start_station_name IS NULL AND end_station_name IS NULL 


Check for standardized start_lat, start_lng, end_lat, end_lng
/* get number of start_station_names */
SELECT COUNT(DISTINCT start_station_name) AS start_station_count
FROM `cyclistic-case-study-374601.trip_data_2022.trip_data_012022_v3`
WHERE start_station_name IS NOT NULL


Row
	start_station_count
	

	1
	1673
	

	



/* get DISTINCT start_station_name with start_lat, start_lng, get number of rows, compare to above */


SELECT DISTINCT start_station_name, start_lat, start_lng
FROM `cyclistic-case-study-374601.trip_data_2022.trip_data_012022_v3`
WHERE start_station_name IS NOT NULL


Results: 
Varied start_lat, start_lng values, displaying “1 – 50 of 1673”




Updates/additions for analysis:


* Created a table listing the top 10 starting stations for casual riders, added a new column named “attraction”, cross referenced the start_lat, start_lng for each station and updated the table to include the closest attraction to the starting station. Table name casual_top_10_stations


* Created a table listing the top 10 starting stations for members, added a new column named “attraction”, cross referenced the start_lat, start_lng for each station and updated the table to include the closest attraction to the starting station. Table name member_top_10_stations


Aug 14, 2023
Revisited this project. I found that the Google Cloud/BigQuery storage was updated and several of the tables that I had created and saved on the server were deleted/lost :(  I have a version of the mostly cleaned original dataset, but the individual entries for latitude and longitude are not correct (this was a version that I had an error updating). The rest of the data appears intact. I don’t have access to the original complete dataset to download again, but I do have a few months that I can reference. 


The plan is to use the lat/long data from a couple of months of the original data as a reference to update the most recent table with accurate lat/long data for each station name.  Since each station doesn’t ‘move’, they should each have their own static lat/long.


1.  I will attempt to find all the stations from the original tables that I do have, and make sure that I have 1673 distinct station names. 
2. If I can find all station names, I will then find the average lat/long listed for each station and create a table including the distinct station name, average lat and average long for each station. 
3. I will use this table to join/update the most accurate version of the dataset that I have to regulate the lat/long for each station so they can be grouped accurately. 




0522 has 1086
0622 has 1233
0722 has 1199
0822 has 1246
0922 has 1242


0522 and 0822 (end of school and mid summer) , selecting just station name, lat and long from both tables: 


SELECT
  ride_id, start_station_name,start_lat, start_lng, end_station_name, end_lat, end_lng
FROM
  `cyclistic-case-study-374601.trip_data_2022.tripdata_052022`
UNION ALL
select
  ride_id, start_station_name,start_lat, start_lng, end_station_name, end_lat, end_lng
FROM
  `cyclistic-case-study-374601.trip_data_2022.tripdata_082022`


Saving as new table start_end_stations_may_aug in BigQuery dataset.
New query to check number of distinct station names:


SELECT DISTINCT start_station_name
FROM `cyclistic-case-study-374601.trip_data_2022.start_end_stations_may_aug` WHERE start_station_name IS NOT NULL


Results: 1369 Rows.


Not enough, so I will add another “month” to the query and continue adding months until I find them all. Looking for 1673 Rows. 


Adding 0622: Result 1407 Rows.
Adding 0722: Result 1441 Rows
Adding 0922: Result 1599 Rows
Adding 1022: Result 1653 Rows
Adding 1222: Result 1671 Rows


I don’t have any more “months” to find the last 2 stations. I am assuming since the last 2 stations didn’t show up in any of the “months” I have added, that they are most likely rarely used stations and are not relevant. I will probably find them when I update the long/lat data. 
Copied the most current version of the trip_data table and renamed it trip_data_2022_v2


New query: start_end_station_geo with Rounded average lat/long using code from above. 
Save it in BigQuery as station_geo_rounded


UPDATE trip_data_2022_v2 with info from station_geo_rounded lat/long reference according to station name: 


UPDATE `cyclistic-case-study-374601.trip_data_2022.trip_data_2022_v2` AS td
SET td.start_lat = sgeo.avg_lat, td.start_lng = sgeo.avg_lng
FROM `cyclistic-case-study-374601.trip_data_2022.station_geo_rounded` AS sgeo
WHERE td.start_station_name = sgeo.station


UPDATE `cyclistic-case-study-374601.trip_data_2022.trip_data_2022_v2` AS td
SET td.end_lat = sgeo.avg_lat, td.end_lng = sgeo.avg_lng
FROM `cyclistic-case-study-374601.trip_data_2022.station_geo_rounded` AS sgeo
WHERE td.end_station_name = sgeo.station


Verification: 
Running a COUNT DISTINCT of the start_lat and end_lat values shows that a couple of entries did not update. Will look to update these manually. 


Did not update (: 
Start lat 41.902355524950814
End lat 41.902340120894308


Updated/deleted: (delete rows I cannot find lat/lng for)  total rows deleted = 9  
Bissell st Armitage lat 41.918  Lng -87.6522
Wilton Ave & Diversey Pkwy - Charging lat 41.9324  lng -87.6527
Kedzie ave & 58th St - Charging lat 41.79 lng -87.7
Lincoln Ave & Roscoe St - Charging lat 41.9438  lng -87.6713
Public Rack - Western Ave & 79th St lat 41.75 lng -87.68
Public Rack - Garfield Park Conservatory - not updated - delete
Public Rack - Kostner Ave & Lake St lat 41.8863 lng -87.7359
Public Rack - 63rd & Western Ave N lat 41.78 lng -87.68
Public Rack - Baltimore Ave & 132nd St   lat 41.66 kng -87.55
Public Rack - Jeffery Blvd & 83rd St - delete
Public Rack - Kedzie Ave & 64th St - SE lat 41.78 lng -87.7
Hastings WH 2 : not updated - delete
Public Rack - Ewing Ave & 106th St NW lat 41.7 lng -87.54
Public Rack - Ada St & 79th St  lat 41.75 lng -87.66
Public Rack - Christiana Ave & 55th St lat 41.79 lng -87.71
Public Rack - Loomis Blvd & 47th St lat delete
Public Rack - Michigan Ave & 119th St lat 41.68 lng -87.62
Public Rack - Newcastle Ave & Belmont Ave 41.94 lng -87.8




ANALYSIS: 
Total rides by member status: 




Average ride time by member status: 
SELECT  
  AVG(ended_at-started_at) as avg_ride_time,
  member_casual AS member_status
FROM `cyclistic-case-study-374601.trip_data_2022.trip_data_2022_v2`
GROUP BY member_casual


Number of rides per starting station by member status: 
SELECT  
  start_station_name,
  COUNT(ride_id) as number_of_rides,
  member_casual AS member_status
FROM `cyclistic-case-study-374601.trip_data_2022.trip_data_2022_v2`
GROUP BY member_casual, start_station_name
ORDER BY number_of_rides DESC


Most popular stations: 
SELECT  
  start_station_name,
  COUNT(ride_id) as number_of_rides
FROM `cyclistic-case-study-374601.trip_data_2022.trip_data_2022_v2`
GROUP BY start_station_name
ORDER BY number_of_rides DESC


















Popular stations by member status with lat/long: 
SELECT  
  start_station_name,
  COUNT(ride_id) as number_of_rides,
  member_casual AS member_status,
  start_lat,
  start_lng
FROM `cyclistic-case-study-374601.trip_data_2022.trip_data_2022_v2`
GROUP BY member_casual, start_station_name, start_lat, start_lng
ORDER BY number_of_rides DESC


Popular trips by member status: 
SELECT  
  CONCAT(start_station_name," to ", end_station_name) as trip,
  COUNT(ride_id) as number_of_rides,
  member_casual AS member_status,
FROM `cyclistic-case-study-374601.trip_data_2022.trip_data_2022_v2`
WHERE end_station_name IS NOT NULL
GROUP BY member_casual, trip
ORDER BY number_of_rides DESC