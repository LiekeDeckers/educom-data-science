--opdracht 5.3.1
CREATE VIEW directie AS
SELECT  D.id,
        C.name,
        C.contacttype AS functie,
        D.name AS department
FROM    mhl_departments AS D
JOIN    mhl_contacts AS C ON C.department = D.id
WHERE IF(D.name="directie", TRUE, C.contacttype LIKE '%directeur%')


--opdracht 5.3.2
CREATE VIEW verzendlijst AS
SELECT  S.ID,
        IF(ISNULL(S.p_address), S.p_address, CONCAT(S.straat, ' ', S.huisnr)) AS adres,
        IF(ISNULL(S.p_address), S.p_postcode, S.postcode) AS postcode,
        IF(ISNULL(S.p_address), PC.name, C.name) AS stad
FROM    mhl_suppliers AS S
JOIN    mhl_cities AS C ON S.city_id=C.id
JOIN    mhl_cities AS PC ON S.p_city_id=PC.id


--opdracht 5.3.3
SELECT  S.name,
        IFNULL(D.name, 'tav de directie') AS contact,
        V.adres,
        V.postcode,
        V.stad
FROM    mhl_suppliers AS S
JOIN    directie AS D ON D.ID=S.ID
JOIN    verzendlijst AS V ON V.ID=S.ID