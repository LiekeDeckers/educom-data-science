--opdracht 5.2.1
SELECT  S.name AS leverancier,

        CASE
            WHEN ISNULL(CNT.name) THEN ('tav de directie')
            ELSE CONCAT('tav ', CNT.name)
        END AS aanhef,
        
        CASE
            WHEN ISNULL(S.p_address) THEN CONCAT(S.straat, ' ', S.huisnr)
            ELSE S.p_address
        END AS adres,

        CASE
            WHEN ISNULL(S.p_address) THEN S.postcode
            ELSE S.p_postcode
        END AS postcode,

        C.name AS stad
FROM    mhl_suppliers AS S
JOIN    mhl_contacts AS CNT ON  CNT.supplier_ID = S.ID
JOIN    mhl_cities AS C ON S.city_id=C.id
JOIN    mhl_communes AS G ON C.commune_id=G.id
JOIN    mhl_districts AS D ON G.district_id=D.id
ORDER BY D.id, C.name, S.name

--of 

SELECT DISTINCT S.name AS leverancier,
        IF(ISNULL(CNT.name), CNT.name, 'tav de directie') AS aanhef,
        IF(ISNULL(S.p_address), S.p_address, CONCAT(S.straat, ' ', S.huisnr)) AS adres,
        IF(ISNULL(S.p_address), S.p_postcode, S.postcode) AS postcode,
        C.name AS stad
FROM    mhl_suppliers AS S
JOIN    mhl_contacts AS CNT ON  CNT.supplier_ID = S.ID
JOIN    mhl_cities AS C ON S.city_id=C.id
JOIN    mhl_communes AS G ON C.commune_id=G.id
JOIN    mhl_districts AS D ON G.district_id=D.id
ORDER BY D.id, C.name, S.name

--of

SELECT
    S.name AS leverancier,
    IFNULL(C.name, 'tav de directie') AS aanhef,
    IF (p_address<>'', p_address, CONCAT(straat, ' ', huisnr)) AS adres,
    IF (p_address<>'', p_postcode, postcode) AS postcode,
    IF (p_address<>'', P.name, V.name) AS stad,
    IF (p_address<>'', PP.name, VP.name) AS provincie
FROM mhl_suppliers AS S
LEFT JOIN mhl_contacts AS C ON S.ID=C.supplier_ID AND C.department=3
LEFT JOIN mhl_cities AS P ON P.ID=S.p_city_ID
LEFT JOIN mhl_communes AS PC ON PC.ID=P.commune_ID
LEFT JOIN mhl_districts AS PP ON PP.ID=PC.district_ID
LEFT JOIN mhl_cities AS V ON V.ID=S.city_ID
LEFT JOIN mhl_communes AS VC ON VC.ID=V.commune_ID
LEFT JOIN mhl_districts AS VP ON VP.ID=VC.district_ID
/* optioneel filteren */
WHERE postcode <> ''
ORDER BY provincie, stad, leverancier


--opdracht 5.2.2
SELECT  C.name AS stad,
        COUNT(IF(MT.name="Gold", 1, NULL)) AS gold,
        COUNT(IF(MT.name="Silver", 1, NULL)) AS silver,
        COUNT(IF(MT.name="Bronze", 1, NULL)) AS bronze,
        COUNT(IF(MT.name NOT IN ('gold', 'silver', 'bronze'), 1, NULL)) AS other
FROM    mhl_suppliers AS S
JOIN    mhl_cities AS C ON S.city_ID=C.ID
JOIN    mhl_membertypes AS MT ON MT.ID=S.membertype
GROUP BY stad
ORDER BY gold DESC,silver DESC, bronze DESC, other DESC


--opdracht 5.2.3
SELECT  year AS jaar,
        SUM(IF(month IN (1,2,3), hitcount, 0)) AS eerste_kwartaal,
        SUM(IF(month IN (4,5,6), hitcount, 0)) AS tweede_kwartaal,
        SUM(IF(month IN (7,8,9), hitcount, 0)) AS derde_kwartaal,
        SUM(IF(month IN (10, 11, 12), hitcount, 0))AS vierde_kwartaal,
        SUM(hitcount) AS totaal
FROM    mhl_hitcount
GROUP BY jaar


