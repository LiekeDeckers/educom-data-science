--opdracht 6.3.1
SELECT  name,
        CASE
            WHEN name LIKE "\'%"
            THEN CONCAT(SUBSTRING(name, 1, 2), UPPER(SUBSTRING(name, 3, 2)), SUBSTRING(name, 5))
            ELSE CONCAT(UPPER(SUBSTRING(name, 1, 1)), SUBSTRING(name, 2))
        END AS nice_name
FROM    mhl_cities
ORDER BY name ASC


--opdracht 6.3.2
SELECT name,
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            REPLACE(name, '&iuml;','ï'),
                        name, '&egrave;', 'è'),
                    name, '&euml;', 'ë'),
                name, '&eacute;', 'é'),
            name, '&ouml;', 'ö'),
        name, '&Uuml;', 'Ü') AS nice_name
FROM    mhl_suppliers
WHERE   name REGEXP '&[^\s]*;'
LIMIT   25