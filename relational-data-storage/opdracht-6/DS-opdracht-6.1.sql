--opdracht 6.1.1
SELECT  year,
        month,
        COUNT(supplier_ID) AS 'aantal leveranciers',
        SUM(hitcount) AS 'totaal aantal hits'
FROM    mhl_hitcount
GROUP BY year, month

--of

CREATE VIEW months (id, name) AS 
  SELECT 1,'Januari'
  UNION SELECT 2,'Februari'
  UNION SELECT 3,'Maart'
  UNION SELECT 4,'April'
  UNION SELECT 5,'Mei'
  UNION SELECT 6,'Juni'
  UNION SELECT 7,'Juli'
  UNION SELECT 8,'Augustus'
  UNION SELECT 9,'September'
  UNION SELECT 10, 'Oktober'
  UNION SELECT 11,'November'
  UNION SELECT 12,'December'

SELECT
    year as jaar,
    months.name as maand,
    num_sup as 'aantal leveranciers',
    total_hit as 'totaal aantal hits'
FROM (
    SELECT year, month, COUNT(supplier_ID) as num_sup, SUM(hitcount) AS total_hit 
    FROM mhl_hitcount 
    GROUP BY year, month 
    ORDER BY year, month 
) AS totals
JOIN months ON month=months.id
ORDER BY year DESC, months.name ASC


--opdracht 6.2.1
CREATE VIEW hitcount_per_gemeente AS
SELECT  G.id AS gemeente_id,
        G.name AS gemeente,
        AVG(H.hitcount) AS average_hitcount
FROM    mhl_hitcount AS H
JOIN    mhl_suppliers AS S ON S.ID=H.supplier_ID
JOIN    mhl_cities AS C ON C.ID= S.city_ID
JOIN    mhl_communes AS G ON G.id=C.commune_ID
GROUP BY gemeente


SELECT  G.name AS gemeente, 
        S.name AS leverancier, 
        SUM(H.hitcount) AS total_hitcount,
        HG.average_hitcount
FROM    mhl_suppliers S    
INNER JOIN mhl_cities C ON S.city_ID=C.id
INNER JOIN mhl_communes G ON C.commune_ID=G.id
INNER JOIN mhl_districts D ON G.district_ID=D.id
INNER JOIN mhl_countries L ON D.country_ID=L.id
INNER JOIN mhl_hitcount H ON H.supplier_ID=S.id
INNER JOIN hitcount_per_gemeente AS HG ON HG.gemeente_id=G.id
WHERE   L.name="Nederland"
GROUP BY leverancier
ORDER BY gemeente, total_hitcount DESC

--of

SELECT a.gemeente, b.leverancier, b.total_hitcount, a.average_hitcount
FROM (
    SELECT g.id, l.name AS leverancier, SUM(h.hitcount) AS total_hitcount
  FROM mhl_suppliers l
  INNER JOIN mhl_cities p ON l.city_ID=p.id
  INNER JOIN mhl_communes g ON p.commune_ID=g.id
  INNER JOIN mhl_districts d ON g.district_ID=d.id
  INNER JOIN mhl_hitcount h ON h.supplier_ID=l.id
  WHERE d.country_ID= (
        SELECT id
        FROM mhl_countries
        WHERE name='Nederland')
        GROUP BY g.id, l.name 
    ) AS b
INNER JOIN (
    SELECT g.id, AVG(h.hitcount) AS average_hitcount, g.name AS gemeente
    FROM mhl_hitcount h
    INNER JOIN mhl_suppliers l ON h.supplier_ID=l.id
    INNER JOIN mhl_cities p ON l.city_ID=p.id
    INNER JOIN mhl_communes g ON p.commune_ID=g.id
    INNER JOIN mhl_districts d ON g.district_ID=d.id
    WHERE d.country_ID = (
        SELECT id
        FROM mhl_countries
        WHERE name='Nederland'
    ) 
    GROUP BY g.id
    ) AS a ON a.id=b.id
GROUP BY a.id, b.leverancier
HAVING b.total_hitcount > a.average_hitcount
ORDER BY a.gemeente, (b.total_hitcount-a.average_hitcount) DESC


--opdracht 6.1.3
CREATE VIEW rubrieken AS
SELECT  IFNULL(SR.id, PR.id) AS id,
        IF(ISNULL(PR.name), SR.name, CONCAT(PR.name, ' - ', SR.name)) AS rubriek,
        IFNULL(PR.name, SR.name) AS hoofdrubriek,
        IF(ISNULL(PR.name), ' ', SR.name) AS subrubriek
FROM mhl_rubrieken AS PR
JOIN mhl_rubrieken AS SR ON SR.parent = PR.id
ORDER BY rubriek

SELECT  rubrieken.rubriek,
        COUNT(mhl_suppliers_ID) AS 'aantal leveranciers'
FROM    rubrieken
JOIN    mhl_suppliers_mhl_rubriek_view AS SRV ON SRV.mhl_rubriek_view_ID=rubrieken.ID
JOIN    mhl_suppliers ON SRV.mhl_suppliers_ID=mhl_suppliers.ID
GROUP BY rubriek


--opdracht 6.1.4
SELECT  rubrieken.rubriek,
        IFNULL(SUM(H.hitcount), 'Geen hits') AS 'total hitcount'
FROM    rubrieken
JOIN    mhl_suppliers_mhl_rubriek_view AS SRV ON SRV.mhl_rubriek_view_ID=rubrieken.ID
JOIN    mhl_suppliers AS S ON SRV.mhl_suppliers_ID=S.ID
JOIN    mhl_hitcount AS H ON H.supplier_ID=S.ID
GROUP BY rubriek