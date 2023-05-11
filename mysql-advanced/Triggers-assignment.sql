--1
ALTER TABLE employees
ADD salary INT(6), ADD date_hired DATE, ADD date_fired DATE

--2
UPDATE  employees
SET     salary = 30000, date_hired = '2023-01-01'
WHERE   employeeNumber=1002

UPDATE  employees
SET     salary = 35000, date_hired = '2023-03-01'
WHERE   employeeNumber=1056

UPDATE  employees
SET     salary = 37000, date_hired = '2023-05-01'
WHERE   employeeNumber=1076

UPDATE  employees
SET     salary = 50000, date_hired = '2023-01-01'
WHERE   employeeNumber=1088

--3
-- create employeeArchive table
CREATE TABLE employeeArchive (
    employeeNumber INT(11),
    lastName VARCHAR(50),
    firstName VARCHAR(50),
    extension VARCHAR(10),
    email VARCHAR(100),
    date_hired DATE,
    date_fired DATE
)

-- create trigger after update row
DROP TRIGGER IF EXISTS fired_aur
DELIMITER $$

CREATE TRIGGER fired_aur
AFTER UPDATE 
ON employees FOR EACH ROW
BEGIN
    IF OLD.date_fired != NEW.date_fired THEN
        INSERT INTO employeeArchive (employeeNumber, lastName, firstName, extension, email, date_hired, date_fired) 
        VALUES (old.employeeNumber, old.lastName, old.firstName, old.extension, old.email, old.date_hired, new.date_fired);
    END IF;
END$$

DELIMITER ;

--test
UPDATE  employees
SET     date_fired = '2023-05-01'
WHERE   employeeNumber=1002

UPDATE  employees
SET     date_fired = '2023-04-01'
WHERE   employeeNumber=1056

UPDATE  employees
SET     date_fired = '2023-05-05'
WHERE   employeeNumber=1076


--4
DROP FUNCTION IF EXISTS f_fired;

DELIMITER $$

CREATE FUNCTION f_fired(
    employeeNumber INT(11)
) 
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE date_fired VARCHAR(20);

    IF date_fired = NULL THEN
        SET date_fired = ' ';
    ELSE SET date_fired = 'FIRED';
    END IF;

    RETURN (date_fired);  
END$$

DELIMITER ;

--test
SELECT  employeeNumber, f_fired(1002) AS status
FROM    employees
WHERE   employeeNumber=1002

SELECT  employeeNumber, f_fired(employeeNumber) AS status
FROM    employees



--5
CREATE VIEW



