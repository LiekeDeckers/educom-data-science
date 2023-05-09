--opdracht 3.2.1
SELECT  * 
FROM    mhl_cities
WHERE   name='Amsterdam'

SELECT  name, 
        straat, 
        huisnr, 
        postcode 
FROM    mhl_suppliers
WHERE   city_ID=104


--opdracht 3.2.2
SELECT  * 
FROM    mhl_membertypes
WHERE   name='Gold' OR name='Silver' OR name='Bronze' OR name='GEEN INTERRESSE'

SELECT  name, 
        straat, 
        huisnr, 
        postcode 
FROM    mhl_suppliers
WHERE   membertype=1 OR membertype=2 OR membertype=3 OR membertype=8
--of
WHERE   membertype IN (1,2,3,8)


--opdracht 3.2.3
SELECT  name, 
        straat, 
        huisnr, 
        postcode 
FROM    mhl_suppliers
WHERE   city_ID=104 AND p_city_ID!=104
--of
WHERE   city_ID=104 AND NOT p_city_ID=104
--of
WHERE   city_ID=104 AND p_city_ID<>104


--opdracht 3.2.4
SELECT  * 
FROM    mhl_cities
WHERE   name='Amsterdam'

SELECT  * 
FROM    mhl_cities
WHERE   name='Den Haag'

SELECT  name, 
        straat, 
        huisnr, 
        postcode 
FROM    mhl_suppliers
WHERE   city_ID=104 OR p_city_ID=172


--opdracht 3.2.5
SELECT  name, 
        straat, 
        huisnr, 
        postcode 
FROM    mhl_suppliers
WHERE   huisnr BETWEEN 10 AND 20
--of
WHERE   huisnr>9 AND huisnr<21


--opdracht 3.2.6
SELECT  name, 
        straat, 
        huisnr, 
        postcode 
FROM    mhl_suppliers
WHERE   huisnr>100 OR huisnr BETWEEN 10 AND 20


--opdracht 3.2.7
SELECT  name, 
        straat, 
        huisnr, 
        postcode 
FROM    mhl_suppliers
WHERE   name LIKE "'t%"


--opdracht 3.2.8
SELECT  name, 
        straat, 
        huisnr, 
        postcode 
FROM    mhl_suppliers
WHERE   name LIKE "%handel"


--opdracht 3.2.9
SELECT  name, 
        straat, 
        huisnr, 
        postcode 
FROM    mhl_suppliers
WHERE   name LIKE "%groothandel%"

--opdracht 3.2.10
SELECT  name, 
        straat, 
        huisnr, 
        postcode 
FROM    mhl_suppliers
WHERE   name REGEXP '[&;-<>]' 


