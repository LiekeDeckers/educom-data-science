--opdracht 4.2.1
SELECT  P.name,
        P.commune_ID
FROM    mhl_cities AS P
LEFT JOIN mhl_communes AS G ON P.commune_ID=G.id
WHERE   ISNULL(G.name)


--opdracht 4.2.2
SELECT  P.name AS plaatsnaam,
        IFNULL(G.name, "INVALID") AS gemeente_invalid
FROM    mhl_cities AS P
JOIN    mhl_communes AS G ON P.commune_ID=G.id

 
--opdracht 4.2.3
SELECT  SR.id,
        IFNULL(R.name, SR.name) AS hoofdrubriek,
        IF(ISNULL(R.name), '', SR.name) AS subrubriek
FROM    mhl_rubrieken R
RIGHT JOIN mhl_rubrieken SR ON SR.parent = R.id
ORDER BY hoofdrubriek, subrubriek


--opdracht 4.2.4
SELECT  S.name,
        PT.name,
        IFNULL(YN.content, "NOT SET") AS value
FROM    mhl_yn_properties AS YN
JOIN    mhl_propertytypes AS PT ON YN.propertytype_ID=PT.id
JOIN    mhl_suppliers AS S ON YN.supplier_ID=S.ID
JOIN    mhl_cities AS C ON S.city_ID=C.id
WHERE   C.name="Amsterdam"

