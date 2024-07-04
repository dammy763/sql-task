# US Household Income Data Cleaning

SELECT * 
FROM us_project.us_household_income;

SELECT * 
FROM us_project.us_household_income_statistics;


ALTER TABLE us_project.us_household_income_statistics RENAME COLUMN `ï»¿id` TO `id`;

# Check for counts

SELECT COUNT(id)
FROM us_project.us_household_income;

SELECT COUNT(id)
FROM us_project.us_household_income_statistics;

#identify duplicates
SELECT id, COUNT(id)
FROM us_project.us_household_income
GROUP BY id
HAVING COUNT(id) > 1
;

SELECT *
FROM (
SELECT row_id, id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
FROM us_project.us_household_income
) duplicates
WHERE row_num > 1
;

#delete duplicates

DELETE FROM us_project.us_household_income
WHERE row_id IN (
	  SELECT row_id
      FROM (
	      SELECT row_id, id,
          ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
		  FROM us_project.us_household_income
          ) duplicates
	  WHERE row_num > 1)
;


SELECT id, COUNT(id)
FROM us_project.us_household_income_statistics
GROUP BY id
HAVING COUNT(id) > 1
;

#check spelling mistakes

SELECT State_Name, COUNT(State_Name)
FROM us_project.us_household_income
GROUP BY State_Name
;

UPDATE us_project.us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georgia'; 

UPDATE us_project.us_household_income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama'; 

#checking state abbreviation

SELECT DISTINCT State_ab
FROM us_project.us_household_income
ORDER BY 1
;


SELECT *
FROM us_project.us_household_income
WHERE County = 'Autauga County'
ORDER BY 1;


UPDATE us_project.us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont';


#Type

SELECT Type, COUNT(Type)
FROM us_project.us_household_income
GROUP BY Type
;


UPDATE us_project.us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs'
;


SELECT ALand, AWater
FROM us_project.us_household_income
WHERE (ALand = 0 OR  ALand = '' OR  ALand is NULL)
;