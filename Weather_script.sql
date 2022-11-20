DROP TABLE IF EXISTS weather;
DROP TABLE IF EXISTS stations;

DELETE  FROM weather ;
--
-- Name: categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--
---- Operacje przeprowadzone na danych z bazy: https://www.kaggle.com/smid80/weatherww2


CREATE TABLE stations (
station_id int PRIMARY key,
"name" varchar(50) null,
state varchar(50) NULL ,
lat varchar(50) NULL ,
lon varchar(50) null,
ELEV int,
Latitude_c real,
Longitude_c real
);


CREATE TABLE weather (
    station_id int,
    dates date,
    PRIMARY KEY (station_id, dates),
    precip varchar(10),
    windGustSpd real,
    MaxTemp real,
    MinTemp real,
    MeanTemp real,
    Snowfall real,
    PoorWeather real,
    YR smallint,
    MO  smallint,
    DA smallint,
    PRCP varchar(10),
    DR real,
    SPD real,
    MAX_v  real,
    MIN_v real,
    MEA real,
    SNF real,
    SND real,
    FT real,
    FB real,
    FTI real,
    ITH real,
    PGT real,
    TSHDSBRSGF real,
    SD3 real,
    RHX real,
    RHN real,
    RVG real,
    WTE real
);

ALTER TABLE weather
ADD FOREIGN KEY (station_id ) REFERENCES stations(station_id);



ALTER TABLE weather
ADD PRIMARY KEY (station_id, dates);

--zad1 Jaka była i w jakim kraju miała miejsce najwyższa dzienna amplituda temperatury?
WITH cte AS (
SELECT MAX(MaxTemp - MinTemp) AS ampl, station_id FROM weather
GROUP BY weather.station_id 
ORDER BY ampl DESC
LIMIT 1
)
SELECT * FROM stations s
INNER JOIN cte 
ON s.station_id =cte.station_id

--ODP: Najwyższa amplituda wynosiła 51,11 stopni i była w LAE/AAF w NG

--zad 2 Z czym silniej skorelowana jest średnia dzienna temperatura dla stacji – szerokością 
-- (lattitude) czy długością (longtitude) geograficzną?
WITH cte as(
SELECT w.station_id , w.meantemp AS meanT, s.latitude_c AS lat, s.longitude_c AS lon FROM weather w 
JOIN stations s 
ON w.station_id = s.station_id 
)
SELECT corr(meanT, lat) AS cor_lat, corr(meanT, lon) AS cor_lon FROM cte
-- ODP: Średnia dzienna temperatura dla stacji skierowana jest z szerokością geograficzną latitude.
-- -0.5613318243696348	 jest silniejszą korelacją niż 	-0.011839978181757341
-- Liczyłem korelację na podstawie wszystkich średnich dziennych temperatur dla stacji, nie liczyłem średniej temperatury na stacji

--zad 3 Pokaż obserwacje, w których suma opadów atmosferycznych (precipitation) przekroczyła 
--sumę opadów z ostatnich 5 obserwacji na danej stacji. (25%)
DROP VIEW wybrane_obserwacje;
DROP VIEW cte;
CREATE VIEW cte as(
SELECT
case WHEN precip = 'T' THEN 0.0 ELSE CAST(precip AS REAL) end AS prep_act,
ROW_NUMBER () OVER ( PARTITION BY station_id ORDER BY dates asc) AS number, station_id, dates
FROM weather
)

CREATE VIEW wybrane_obserwacje AS 
SELECT cte.*, cte1.prep_act AS prep_1, cte2.prep_act AS prep_2, cte3.prep_act AS prep_3, cte4.prep_act AS prep_4, cte5.prep_act AS prep_5  FROM cte 
LEFT join cte cte1
ON cte.station_id = cte1. station_id AND cte.number = cte1.number+1
LEFT join cte cte2
ON cte.station_id = cte2. station_id AND cte.number = cte2.number+2
LEFT join cte cte3
ON cte.station_id = cte3. station_id AND cte.number = cte3.number+3
LEFT join cte cte4
ON cte.station_id = cte4. station_id AND cte.number = cte4.number+4
LEFT join cte cte5
ON cte.station_id = cte5. station_id AND cte.number = cte5.number+5
WHERE cte.prep_act >  cte1.prep_act + cte2.prep_act+ cte3.prep_act  + cte4.prep_act + cte5.prep_act  -- aktualne opady większe od sumy sprzed 5 dni

SELECT DISTINCT w.* FROM weather w
INNER JOIN wybrane_obserwacje 
ON w.station_id =wybrane_obserwacje.station_id  AND w.dates = wybrane_obserwacje.dates
-- ODP: lista obserwacji w których opady przekraczają sumę opadów sprzed 5 dni

--zad 4. Uszereguj stany/państwa według od najniższej temperatury zanotowanej tam w okresie 
-- obserwacji używając do tego funkcji okna 

WITH cte AS (
SELECT state, min (mintemp) AS min_tmp FROM weather w 
JOIN stations s 
ON s.station_id = w.station_id 
GROUP BY state
)
SELECT ROW_NUMBER () OVER (ORDER BY min_tmp asc ), min_tmp, state FROM cte;

-- ODP. Uszeregenowane powyżej

-- EXTRA


SELECT * FROM stations s 
JOIN weather w 
ON s.station_id =w.station_id 
WHERE EXTRACT (MONTH FROM dates) ='07' AND snowfall>0;

-- Opady śniegu wielkości 2 były w ClonCurry w AU w 16 lipca 1944 roku

-- Name: customer_customer_demo; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE customer_customer_demo (
    customer_id bpchar NOT NULL,
    customer_type_id bpchar NOT NULL
);