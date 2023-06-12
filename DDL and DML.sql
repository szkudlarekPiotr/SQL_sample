INSERT INTO legal_description (law_code) 

SELECT DISTINCT law_code 

FROM crimes; 

  

UPDATE legal_description  

SET ofns_desc = c.ofns_desc, 

    law_cat_cd = c.law_cat_cd 

FROM crimes c 

WHERE legal_description.law_code = c.law_code; 

  

----- 

INSERT INTO crime (arrest_key) 

SELECT DISTINCT arrest_key  

FROM crimes ; 

 

UPDATE crime 

SET arrest_date = TO_DATE(c.arrest_date, 'MM/DD/YYYY') 

FROM crimes c WHERE crime.arrest_key = c.arrest_key; 

  

UPDATE  crime 

SET personal_data_id = p.personal_data_id  

FROM personal_data p JOIN crimes c ON (p.age_group = c.age_group  AND p.perp_sex  = c.perp_sex AND p.perp_race = p.perp_race) 

WHERE crime.arrest_key = c.arrest_key; 

  

UPDATE  crime 

SET law_code = l.law_code  

FROM legal_description l JOIN crimes c ON l.law_code = c.law_code  

WHERE crime.arrest_key = c.arrest_key; 

  

UPDATE crime 

SET location_id = l.location_id 

FROM locations l 

JOIN crimes c ON CAST(c.latitude AS numeric(10, 3)) = l.latitude AND CAST(c.longitude AS numeric(10, 3)) = l.longitude 

WHERE crime.arrest_key = c.arrest_key; 

  

----------- 

INSERT INTO airbnb (airbnb_id) 

SELECT DISTINCT id 

FROM airbnbb ; 

  

UPDATE airbnb  

SET airbnb_name = a."NAME"  

FROM airbnbb a 

WHERE a.id = airbnb_id; 

  

UPDATE airbnb  

SET price = a.price::MONEY, 

room_type = a."room type", 

minimum_nights = a."minimum nights" , 

review_per_month = a."reviews per month" , 

number_of_reviews = a."number of reviews"  

FROM airbnbb a 

WHERE a.id = airbnb_id; 

  

UPDATE airbnb  

SET host_id = ah.host_id  

FROM airbnb_host ah JOIN airbnbb a ON ah.host_id = a."host id"  

WHERE a.id = airbnb_id ; 

  

UPDATE airbnb 

SET location_id = l.location_id 

FROM locations l JOIN airbnbb a ON round(a.lat, 3) = l.latitude AND round(a.long, 3) = l.longitude 

WHERE airbnb.airbnb_id  = a.id; 

  

UPDATE airbnb  

SET last_review = a."last review"::DATE 

FROM airbnbb a 

WHERE airbnb_id = a.id; 

 

 --------- 

CREATE VIEW cr 

AS 

(SELECT DISTINCT latitude, longitude 

FROM ( 

SELECT ROUND(latitude::NUMERIC, 3)"latitude",  

ROUND(longitude::NUMERIC, 3) "longitude" 

FROM crimes) AS c); 

 

CREATE VIEW x 

AS 

(SELECT DISTINCT latitude, longitude 

FROM ( 

SELECT ROUND(lat::NUMERIC, 3)"latitude", 

 ROUND(long::NUMERIC, 3) "longitude" 

FROM airbnbb) AS a); 

 

CREATE VIEW merged_view  

AS 

SELECT latitude, longitude FROM cr 

UNION 

SELECT latitude, longitude FROM x; 

 

INSERT INTO locations (latitude, longitude) 

SELECT a.latitude, a.longitude 

FROM merged_view a; 

 

UPDATE locations 

SET neighbourhood_name = a.neighbourhood  

FROM airbnbb a 

WHERE locations.latitude = round(a.lat,3) AND locations.longitude = round(a.long,3); 

----

UPDATE locations 

SET neighbourhood_group = CASE 

    WHEN a."neighbourhood group" = 'Brooklin' THEN 'K' 

    WHEN a."neighbourhood group" = 'Bronx' THEN 'B' 

    WHEN a."neighbourhood group" = 'manhattan' THEN 'M' 

    WHEN a."neighbourhood group" = 'brookln' THEN 'K' 

    ELSE SUBSTRING(a."neighbourhood group", 1, 1) 

END 

FROM airbnbb a 

WHERE locations.latitude = round(a.lat, 3) AND locations.longitude = round(a.long, 3);  
  

 --dodanie danych + transformacja danych do zaokrąglonej wartości 

UPDATE locations 

SET neighbourhood_group = c.arrest_boro 

FROM crimes c 

WHERE locations.latitude = round(CAST(c.latitude AS NUMERIC),3) AND locations.longitude = round(CAST(c.longitude AS NUMERIC),3); 
 

------- 

INSERT INTO airbnb_host(host_id, host_identity_verified) 

SELECT DISTINCT "host id", host_identity_verified 

FROM airbnbb 

WHERE "host id" IS NOT NULL 

 