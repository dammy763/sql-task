# World life Expectancy (Data Cleaning)


SELECT * 
FROM world_life_expectancy
;

#Identifying duplicates using country & Year

SELECT country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM world_life_expectancy
GROUP BY Country, Year,  CONCAT(Country, Year)
HAVING  COUNT(CONCAT(Country, Year)) > 1
;
# Identified 3 duplicates (Ireland,Senegal,Zimbabwe)

#using row_id to identify duplicates and removing them


SELECT *
FROM (
    SELECT Row_ID, 
    CONCAT(Country, Year),
    ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) as Row_Num
    FROM world_life_expectancy
    ) AS Row_table
WHERE Row_Num > 1
;

# Delete duplicates

DELETE FROM world_life_expectancy
WHERE 
    Row_ID IN (
	SELECT Row_ID
FROM (
    SELECT Row_ID, 
    CONCAT(Country, Year),
    ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) as Row_Num
    FROM world_life_expectancy
    ) AS Row_table
WHERE Row_Num > 1
)
;


# Identifying missing data in the status table so check NULL or ''

SELECT *
FROM world_life_expectancy
WHERE Status = ''
;

# check if they are all blank or not

SELECT DISTINCT(Status)
FROM world_life_expectancy
WHERE Status <> ''
;

# check countries that are developing

SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing';

# populate if its a developing country


UPDATE world_life_expectancy
SET Status = 'Developing'
WHERE Country IN (SELECT DISTINCT(Country)
                FROM world_life_expectancy
                WHERE Status = 'Developing');

#Join in a update statement 

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
    ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing'
;

#Check for update for developing countries
SELECT *
FROM world_life_expectancy
WHERE Country = 'United States of America'
;

#Update developed countries as well

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
    ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed'
;

#Check again running this to check for blanks
SELECT *
FROM world_life_expectancy
WHERE Status IS NULL
;

#check for blanks in other columns

SELECT *
FROM world_life_expectancy
WHERE `Life expectancy` = ''
;

# Populate
SELECT Country, Year, `Life expectancy`
FROM world_life_expectancy
WHERE `Life expectancy` = ''
;


SELECT t1.Country, t1.Year, t1. `Life expectancy`, 
t2.Country, t2.Year, t2.`Life expectancy`,
t3.Country, t3.Year, t3.`Life expectancy`,
ROUND((t2.`Life expectancy` + t3. `Life expectancy` )/2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
    ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
    ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1. `Life expectancy` = '' 
;


UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
    ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
    ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
SET t1. `Life expectancy` = ROUND((t2.`Life expectancy` + t3. `Life expectancy` )/2,1)
WHERE t1. `Life expectancy` = ''
;


