# SQL Join exercise
#

USE world;
-- DESCRIBE city;
-- DESCRIBE country;
-- DESCRIBE countrylanguage;

#
# 1: Get the cities with a name starting with ping sorted by their population with the least populated cities first
#

SELECT * FROM city  WHERE `Name` LIKE 'ping%' ORDER BY population ASC;

#
# 2: Get the cities with a name starting with ran sorted by their population with the most populated cities first
#

SELECT * FROM city  WHERE `Name` LIKE 'ran%' ORDER BY population DESC;

#
# 3: Count all cities
#

SELECT COUNT(ID) AS Total FROM city;

#
# 4: Get the average population of all cities
#

SELECT AVG(Population) AS Average FROM city;

#
# 5: Get the biggest population found in any of the cities
#

SELECT MAX(Population) AS Biggest_population FROM city;

#
# 6: Get the smallest population found in any of the cities
#

SELECT MIN(Population) AS Smallest_population FROM city;

#
# 7: Sum the population of all cities with a population below 10000
#

SELECT SUM(Population) FROM city WHERE Population < 1000;

#
# 8: Count the cities with the countrycodes MOZ and VNM
#

SELECT COUNT(ID) AS Total FROM city WHERE CountryCode = "MOZ" OR CountryCode = "VNM";

#
# 9: Get individual count of cities for the countrycodes MOZ and VNM
#

SELECT ( 
	SELECT COUNT(ID) AS MOZ 
    FROM city WHERE CountryCode = "MOZ"
    ) AS MOZ,
	(SELECT COUNT(ID) 
    FROM city WHERE CountryCode = "VNM"
) AS VNM;

#
# 10: Get average population of cities in MOZ and VNM
#

SELECT ( 
	SELECT AVG(Population) AS MOZ 
    FROM city WHERE CountryCode = "MOZ"
    ) AS Avg_MOZ,
	(SELECT AVG(Population) 
    FROM city WHERE CountryCode = "VNM"
) AS Avg_VNM;

#
# 11: Get the countrycodes with more than 200 cities
#

SELECT `Code` FROM country WHERE Capital > 200;

#
# 12: Get the countrycodes with more than 200 cities ordered by city count
#

SELECT `Code` FROM country WHERE Capital > 200 ORDER BY Capital;

#
# 13: What language(s) is spoken in the city with a population between 400 and 500 ?
#

SELECT A.`Language` AS "Spoken Language"
FROM countrylanguage A 
WHERE A.CountryCode 
IN (
	SELECT B.CountryCode 
    FROM city B 
    WHERE B.Population > 399 
    AND B.Population < 501
);

#
# 14: What are the name(s) of the cities with a population between 500 and 600 people and the language(s) spoken in them
#

SELECT B.`Name`, C.`Language`
FROM countrylanguage C, city B 
WHERE C.CountryCode 
IN (
	SELECT B.CountryCode 
    FROM city B 
    WHERE B.Population > 499 
    AND B.Population < 601
);

#
# 15: What names of the cities are in the same country as the city with a population of 122199 (including the that city itself)
#

SELECT A.`Name` 
FROM city A, city B 
WHERE A.CountryCode = B.CountryCode 
AND B.Population = 122199;

#
# 16: What names of the cities are in the same country as the city with a population of 122199 (excluding the that city itself)
#

SELECT A.`Name` 
FROM city A, city B
WHERE A.CountryCode = B.CountryCode 
AND B.Population=122199 
AND A.`Name` != ANY(
	SELECT C.`Name` 
    FROM city C 
    WHERE Population = 122199
);

#
# 17: What are the city names in the country where Luanda is capital?
#

SELECT A.`Name` AS "City names"
FROM city A
JOIN country B ON A.CountryCode = B.`Code`
WHERE B.Capital = ANY(
	SELECT C.ID 
    FROM city C 
    WHERE C.`Name` = "Luanda"
);

#
# 18: What are the names of the capital cities in countries in the same region as the city named Yaren
#

SELECT A.`Name` AS "City Names" 
FROM city A 
JOIN country B ON A.CountryCode = B.`Code` 
WHERE B.Region = ANY(
	SELECT C.Region FROM country C 
    JOIN city D ON C.`Code` = D.CountryCode 
    WHERE C.Capital = ANY(
		SELECT F.ID FROM city F 
		WHERE F.`Name` = "Yaren"
	)
);

#
# 19: What unique languages are spoken in the countries in the same region as the city named Riga
#

SELECT A.`Language`
FROM countrylanguage A 
JOIN country B ON A.CountryCode = B.`Code` 
AND B.Region = ANY(
	SELECT C.Region 
    FROM country C 
    JOIN city D ON C.`Code` = D.CountryCode 
    WHERE C.Capital = ANY(
		SELECT E.ID 
        FROM city E 
        WHERE E.`Name` = "Riga"
	)
);

#
# 20: Get the name of the most populous city
#

SELECT `Name` FROM city ORDER BY Population DESC LIMIT 1;
