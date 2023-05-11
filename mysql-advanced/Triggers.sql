--BEFORE INSERT ROW (BIR)
--example
DROP TRIGGER IF EXISTS workcenters_bir;

DELIMITER $$

CREATE TRIGGER workcenters_bir
BEFORE INSERT
ON WorkCenters FOR EACH ROW
BEGIN
    DECLARE rowcount INT;
    
    SELECT COUNT(*) 
    INTO rowcount
    FROM WorkCenterStats;
    
    IF rowcount > 0 THEN
        UPDATE WorkCenterStats
        SET totalCapacity = totalCapacity + new.capacity;
    ELSE
        INSERT INTO WorkCenterStats(totalCapacity)
        VALUES(new.capacity);
    END IF; 

END $$

DELIMITER;

--test
INSERT INTO WorkCenters(name, capacity) VALUES('Mold 
Machine',100);




--AFTER INSERT ROW (AIR)
--example
DROP TRIGGER IF EXISTS members_air;
DELIMITER $$

CREATE TRIGGER members_air
AFTER INSERT
ON members FOR EACH ROW
BEGIN
    IF NEW.birthDate IS NULL THEN
        INSERT INTO reminders(memberId, message)
        VALUES(new.id,CONCAT('Hi ', NEW.name, ', please update your date of birth.'));
    END IF;
END$$

DELIMITER ;

--test
INSERT INTO members(name, email, birthDate)
VALUES
    ('John Doe', 'john.doe@example.com', NULL),
    ('Jane Doe', 'jane.doe@example.com','2000-01-01');




--BEFORE UPDATE ROW (BUR)
--example
DROP TRIGGER IF EXISTS sales_bur
DELIMITER $$

CREATE TRIGGER sales_bur
BEFORE UPDATE
ON sales FOR EACH ROW
BEGIN
    DECLARE errorMessage VARCHAR(255);
    SET errorMessage = CONCAT('The new quantity ',
                        NEW.quantity,
                        ' cannot be 3 times greater than the current quantity ',
                        OLD.quantity);
                        
    IF new.quantity > old.quantity * 3 THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = errorMessage;
    END IF;
END $$

DELIMITER ;

--test
UPDATE sales SET quantity = 150 WHERE id = 1;
--
UPDATE sales SET quantity = 500 WHERE id = 1;




--AFTER UPDATE ROW
--example
DROP TRIGGER IF EXISTS sales_aur
DELIMITER $$

CREATE TRIGGER sales_aur
AFTER UPDATE
ON sales FOR EACH ROW
BEGIN
    IF OLD.quantity <> new.quantity THEN
        INSERT INTO SalesChanges(salesId,beforeQuantity, afterQuantity)
        VALUES(old.id, old.quantity, new.quantity);
    END IF;
END$$

DELIMITER ;

--test
UPDATE Sales SET quantity = 350 WHERE id = 1;
UPDATE Sales SET quantity = CAST(quantity * 1.1 AS UNSIGNED);



--BEFORE DELETE ROW (BDR)
--example
DROP TRIGGER IF EXISTS salaries_bdr;

DELIMITER $$

CREATE TRIGGER salaries_bdr
BEFORE DELETE
ON salaries FOR EACH ROW
BEGIN
    INSERT INTO SalaryArchives(employeeNumber,validFrom,amount)
    VALUES(OLD.employeeNumber,OLD.validFrom,OLD.amount);
END$$    

DELIMITER ;

--test
DELETE FROM salaries WHERE employeeNumber = 1002;



--AFTER DELETE ROW (ADR)
--example
DROP TRIGGER IF EXISTS salaries_adr;

DELIMITER $$

CREATE TRIGGER salaries_adr
    AFTER DELETE
    ON Salaries FOR EACH ROW
BEGIN
   UPDATE SalaryBudgets 
      SET total = total - old.salary;
END$$    

DELIMITER ;

--test
DELETE FROM salaries WHERE employeeNumber = 1002;
