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

--opdracht 5.3.3