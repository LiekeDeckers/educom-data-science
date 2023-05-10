--opdracht 6.2.1
SELECT  DATE_FORMAT(joindate, GET_FORMAT(DATE,'EUR')) AS joindate,
        ID
FROM    mhl_suppliers
WHERE   DAYOFMONTH(LAST_DAY(joindate))-DAYOFMONTH(joindate) <= 7


--opdracht 6.2.2
SELECT  ID,
        joindate,
        DATEDIFF(CURDATE(), joindate) AS dagen_lid
FROM    mhl_suppliers
ORDER BY dagen_lid ASC

--of
TO_DAYS(CURDATE())-TO_DAYS(joindate) AS dagen_lid


--opdracht 6.2.3
SELECT  DAYNAME(joindate) AS 'Dag van de week',
        COUNT(ID) AS 'Aantal aanmeldingen'
FROM    mhl_suppliers
GROUP BY DAYNAME(joindate)
ORDER BY DAYOFWEEK(joindate)


--opdracht 6.2.4
SELECT  EXTRACT(YEAR FROM joindate) AS jaar,
        MONTHNAME(joindate) AS maand,
        COUNT(ID) AS aantal
FROM    mhl_suppliers
GROUP BY jaar, maand, MONTH(joindate)
ORDER BY jaar, MONTH(joindate)