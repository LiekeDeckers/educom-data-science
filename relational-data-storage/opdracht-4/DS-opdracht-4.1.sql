--opdracht 4.1.1
SELECT  mhl_suppliers.name, 
        mhl_suppliers.straat, 
        mhl_suppliers.huisnr, 
        mhl_suppliers.postcode,
        mhl_cities.name 
FROM    mhl_suppliers 
JOIN    mhl_cities ON mhl_suppliers.city_ID=mhl_cities.ID 
WHERE   mhl_cities.name="Amsterdam"


--opdracht 4.1.2
SELECT  mhl_suppliers.name, 
        mhl_suppliers.straat, 
        mhl_suppliers.huisnr, 
        mhl_suppliers.postcode,
        mhl_cities.name AS plaatsnaam
FROM    mhl_suppliers 
JOIN    mhl_cities ON mhl_suppliers.city_ID=mhl_cities.ID
JOIN    mhl_communes ON mhl_cities.commune_ID=mhl_communes.ID 
WHERE   mhl_communes.name="Steenwijkerland"


--opdracht 4.1.3
SELECT  mhl_suppliers.name AS supplier, 
        mhl_suppliers.straat, 
        mhl_suppliers.huisnr, 
        mhl_suppliers.postcode,
        mhl_cities.name AS city,
        mhl_rubrieken.name AS rubriek
FROM    mhl_suppliers_mhl_rubriek_view 
JOIN    mhl_suppliers ON mhl_suppliers_mhl_rubriek_view.mhl_suppliers_ID=mhl_suppliers.ID
JOIN    mhl_rubrieken ON mhl_suppliers_mhl_rubriek_view.mhl_rubriek_view_ID=mhl_rubrieken.ID
JOIN    mhl_cities ON mhl_suppliers.city_ID=mhl_cities.ID 
WHERE   mhl_cities.name="Amsterdam" AND (mhl_rubrieken.name="drank" OR mhl_rubrieken.parent=235)
ORDER BY mhl_rubrieken.name, mhl_suppliers.name

--of

SELECT      S.name, S.straat, S.huisnr, S.postcode, R.name
FROM        mhl_suppliers_mhl_rubriek_view AS SR
INNER JOIN  mhl_suppliers AS S ON SR.mhl_suppliers_ID=S.ID
INNER JOIN  mhl_rubrieken AS R ON SR.mhl_rubriek_view_ID= R.ID
LEFT JOIN   mhl_rubrieken AS PR ON R.parent=PR.ID
INNER JOIN  mhl_cities AS C ON S.city_ID=C.ID
WHERE       C.name="Amsterdam" AND (R.name="drank" OR PR.name="drank")
ORDER BY    R.name, S.name


--opdracht 4.1.4
SELECT  mhl_suppliers.name AS supplier, 
        mhl_suppliers.straat, 
        mhl_suppliers.huisnr, 
        mhl_suppliers.postcode,
        mhl_propertytypes.name AS propertytype
FROM    mhl_yn_properties
JOIN    mhl_suppliers ON mhl_yn_properties.supplier_ID=mhl_suppliers.ID
JOIN    mhl_propertytypes ON mhl_yn_properties.propertytype_ID=mhl_propertytypes.ID
WHERE   mhl_propertytypes.name="specialistische leverancier" 
        OR mhl_propertytypes.name="ook voor particulieren"

--of

SELECT      S.name, S.straat, S.huisnr, S.postcode
FROM        mhl_yn_properties AS PS
INNER JOIN  mhl_suppliers AS S ON PS.supplier_ID=S.ID
INNER JOIN  mhl_propertytypes AS P ON PS.propertytype_ID=P.ID
WHERE       P.name="ook voor particulieren" OR P.name="specialistische leverancier"


--opdracht 4.1.5
SELECT  mhl_suppliers.name AS supplier, 
        mhl_suppliers.straat, 
        mhl_suppliers.huisnr, 
        mhl_suppliers.postcode,
        pc_lat_long.lat,
        pc_lat_long.lng
FROM    mhl_suppliers
JOIN    pc_lat_long ON pc_lat_long.pc6=mhl_suppliers.postcode
ORDER BY pc_lat_long.lat DESC
LIMIT   5

--of

SELECT  L.name, L.straat, L.huisnr, L.postcode, P.lat, P.lng
FROM    mhl_suppliers AS L, pc_lat_long AS P
WHERE   L.postcode=P.pc6
ORDER BY P.lat DESC
LIMIT   5


--opdracht 4.1.6
SELECT  H.hitcount,
        S.name AS leveranciernaam,
        C.name AS stad,
        G.name AS gemeente,
        D.name AS provincie
FROM    mhl_hitcount AS H
JOIN    mhl_suppliers AS S ON H.supplier_ID=S.ID
JOIN    mhl_cities AS C ON S.city_ID=C.ID
JOIN    mhl_communes AS G ON C.commune_ID=G.ID
JOIN    mhl_districts AS D ON G.district_ID=D.ID
WHERE   H.month=1 AND H.year=2014 AND 
        (D.name="Limburg" OR D.name="Noord-Brabant" OR D.name="Zeeland")


--opdracht 4.1.7
SELECT  P.name AS plaatsnaam,
        P.id AS plaatsnaam_id,
        G.name AS gemeente,
        G.id AS gemeente_id
FROM    mhl_cities AS P
JOIN    mhl_communes AS G ON P.commune_ID=G.ID
WHERE   P.name=G.name        
ORDER BY P.name       


--opdracht 4.1.8
SELECT  P1.name AS plaatsnaam,
        P1.id AS plaats_id1,
        P2.id AS plaats_id2,
        G1.name AS gemeente1,
        G1.id AS gemeente_id1,
        G2.name AS gemeente2,
        G2.id AS gemeente_id2
FROM    mhl_cities AS P1
JOIN    mhl_cities AS P2 ON P1.name=P2.name
JOIN    mhl_communes AS G1 ON P1.commune_id=G1.id
JOIN    mhl_communes AS G2 ON P2.commune_id=G2.id
WHERE   P1.id<P2.id
ORDER BY P1.name