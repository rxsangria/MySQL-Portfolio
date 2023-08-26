DELETE FROM `cyclistic-case-study-374601.trip_data_2022.trip_data_012022` 
WHERE start_station_name IS NULL AND end_station_name IS NULL 


/* further trim trips with no start station (but have ending station) */
DELETE
FROM `cyclistic-case-study-374601.trip_data_2022.trip_data_012022` 
WHERE start_station_name IS NULL

SELECT start_station_name, ROUND(AVG(start_lat),4) as avg_lat, ROUND(AVG(start_lng),4) as avg_lng
FROM `cyclistic-case-study-374601.trip_data_2022.trip_data_012022_v3`
WHERE start_station_name IS NOT NULL
GROUP BY start_station_name

SELECT end_station_name, ROUND(AVG(end_lat),4) as avg_lat, ROUND(AVG(end_lng),4) as avg_lng
FROM `cyclistic-case-study-374601.trip_data_2022.trip_data_012022_v3`
WHERE end_station_name IS NOT NULL
GROUP BY end_station_name

/* Updated start_station_name start_lat and start_lng with the start_station_geo avg_lat and avg_lng */

	UPDATE `cyclistic-case-study-374601.trip_data_2022.trip_data_012022_v3` AS td 
SET td.start_lat = sgeo.avg_lat, td.start_lng = sgeo.avg_lng
FROM `cyclistic-case-study-374601.trip_data_2022.start_station_geo` AS sgeo
WHERE td.start_station_name = sgeo.start_station_name
	
/* Updated end_station_name end_lat and end_lng with end_station_geo avg_lat and avg_lng */
UPDATE `cyclistic-case-study-374601.trip_data_2022.trip_data_012022_v3` AS td 
SET td.end_lat = egeo.avg_lat, td.end_lng = egeo.avg_lng
FROM `cyclistic-case-study-374601.trip_data_2022.end_station_geo` AS egeo
WHERE td.end_station_name = egeo.end_station_name