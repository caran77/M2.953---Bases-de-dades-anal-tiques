--
-- Create the view
--
CREATE OR REPLACE VIEW sale_stg.vw_city_distance as
	WITH RECURSIVE near_city (
		city_name, 
		latitude_num, 
		longitude_num,
		depth,
		path,
		distance,
		destination
	) AS (
		SELECT	city_end.city_name, 
				city_end.latitude_num, 
				city_end.longitude_num, 
				1, 
				city_end.city_name, 
				CAST (0 AS NUMERIC) distance,
				city_end.city_name
		FROM	sale.tb_city 	city_end
		UNION
		SELECT	city.city_name, 
				city.latitude_num, 
				city.longitude_num, 
				depth + 1, 
				city.city_name ||' -> '||path,
				sale.distance_km(city.latitude_num, city.longitude_num, nc.latitude_num, nc.longitude_num) + distance,
				destination
		FROM	sale.tb_city 	city
		JOIN	near_city 		nc on (
				city.city_name != nc.city_name
			AND position(CITY.city_name in path) < 1
		)
	) 	
		SELECT	nc.city_name	from_city,
				nc.destination	to_city,
				nc.path			path,
				nc.distance		total_distance,
				nc.depth 		num_places
		FROM	near_city	nc
		WHERE 	nc.depth = (
			SELECT	COUNT(city_in.*)
			FROM	sale.tb_city city_in
		) 
		 ORDER BY nc.distance ASC;
--
-- Retrieve the data
--
SELECT 	*
FROM 	sale_stg.vw_city_distance
WHERE 	to_city = 'Madrid'
 AND	from_city = 'Barcelona'
LIMIT 1;