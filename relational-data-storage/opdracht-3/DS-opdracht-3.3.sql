--opdracht 3.3.1
SELECT DISTINCT name
FROM    mhl_cities
ORDER BY name ASC


--opdracht 3.3.2
SELECT  *
FROM    mhl_suppliers
ORDER BY membertype, city_ID, postcode 


--opdracht 3.3.3
SELECT  *
FROM    mhl_hitcount
ORDER BY year, month, hitcount DESC
