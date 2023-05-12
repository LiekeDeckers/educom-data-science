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
CREATE VIEW fired_status AS
SELECT  employeeNumber, 
        f_fired(employeeNumber) AS status
FROM    employees



--6
DROP FUNCTION IF EXISTS f_give_raise;

DELIMITER $$

CREATE FUNCTION f_give_raise(
    employeeNumber INT(11)
) 
RETURNS INT(6)
DETERMINISTIC
BEGIN
    UPDATE  employees
    SET     salary = salary * 1.05;
    RETURN  1;
END$$

DELIMITER ;

--test
SELECT  f_give_raise(1002);


--7
DROP FUNCTION IF EXISTS f_remove_fired_employees;

DELIMITER $$

CREATE FUNCTION f_remove_fired_employees() 
RETURNS INT(6)
DETERMINISTIC
BEGIN
    DELETE FROM employees
    WHERE   date_fired IS NOT NULL;
    RETURN  1;
END$$

DELIMITER ;

--test
SELECT f_remove_fired_employees()



--8
--alter table
ALTER TABLE salaryarchives
ADD old_salary INT(6), ADD new_salary INT(6)

--create trigger
DROP TRIGGER IF EXISTS salaries_aur
DELIMITER $$

CREATE TRIGGER salaries_aur
AFTER UPDATE
ON employees FOR EACH ROW
BEGIN
    IF OLD.salary <> new.salary THEN
        INSERT INTO SalaryArchives(employeeNumber, old_salary, new_salary)
        VALUES(old.employeeNumber, old.salary, new.salary);
    END IF;
END$$

DELIMITER ;

--test
UPDATE employees 
SET     salary = 35000 
WHERE   employeeNumber = 1002;