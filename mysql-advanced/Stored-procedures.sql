--VARIABLES AND ARGUMENTS
--assignement
DELIMITER $$

CREATE PROCEDURE p_get_office_by_country(IN countryName VARCHAR(255))
BEGIN
    
    SELECT  world.country.Name,
            sales.offices.officeCode
    FROM    world.country
    JOIN    sales.offices ON world.country.Name = sales.offices.country
END

DELIMITER


--CONDITIONS
--example
# First we drop so we can recreate!
DROP PROCEDURE p_get_customer_level;

DELIMITER $$

CREATE PROCEDURE p_get_customer_level(
    IN  pCustomerNumber INT, 
    OUT pCustomerLevel  VARCHAR(20))
BEGIN
    DECLARE credit DECIMAL DEFAULT 0;

    SELECT creditLimit 
    INTO credit
    FROM customers
    WHERE customerNumber = pCustomerNumber;

    IF credit > 50000 THEN
        SET pCustomerLevel = 'PLATINUM';
    ELSEIF credit <= 50000 AND credit > 10000 THEN
        SET pCustomerLevel = 'GOLD';
    ELSE
        SET pCustomerLevel = 'SILVER';
    END IF;
END $$

DELIMITER ;

--calling
CALL p_get_customer_level(447, @level);
SELECT @level;            


--CASE
--example

DELIMITER $$

CREATE PROCEDURE p_get_customer_shipping(
    IN pCustomerNUmber INT
)

BEGIN
    
    DECLARE customerCountry VARCHAR(100);
    DECLARE pShipping VARCHAR(50);

    SELECT  country
      INTO customerCountry 
      FROM customers
     WHERE customerNumber = pCustomerNUmber;

    CASE customerCountry
        WHEN 'USA' THEN SET pShipping = '2-day Shipping';
        WHEN 'Canada' THEN SET pShipping = '3-day Shipping';
        ELSE SET pShipping = '5-day Shipping';
    END CASE;
    
    SELECT pShipping;
    
END$$

DELIMITER ;
 
--calling
CALL p_get_customer_shipping(112);


--IRERATIONS
--example
DELIMITER $$
CREATE PROCEDURE p_while_demo()
BEGIN
    DECLARE x  INT;
    DECLARE str  VARCHAR(255);
        
    SET x = 1;
    SET str =  '';
        
    loop_label:  WHILE X <= 10 DO             
        IF NOT (x mod 2) THEN
            SET  str = CONCAT(str,x,',');
        END  IF;
        SET  x = x + 1;
    END WHILE;
    SELECT str;
END$$

DELIMITER;


--CURSORS
--example
DROP PROCEDURE IF EXISTS p_create_emaillist;

DELIMITER $$
CREATE PROCEDURE p_create_emaillist (
    INOUT emailList varchar(4000)
)
BEGIN
    DECLARE finished INTEGER DEFAULT 0;
    DECLARE emailAddress varchar(100) DEFAULT "";

    -- declare cursor for employee email
    DEClARE curEmail 
        CURSOR FOR 
            SELECT email FROM employees;

    -- declare NOT FOUND handler
    DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finished = 1;

    OPEN curEmail;

    getEmail: LOOP
        FETCH curEmail INTO emailAddress;
        IF finished = 1 THEN 
            LEAVE getEmail;
        END IF;
        -- build email list
        SET emailList = CONCAT(emailAddress,";",emailList);
    END LOOP getEmail;
    CLOSE curEmail;

END$$
DELIMITER;

--calling
SET @emailList = ""; 
CALL p_create_emaillist(@emailList); 
SELECT @emailList;


--assignment
DROP PROCEDURE IF EXISTS p_get_customer_order_amount;

DELIMITER $$
CREATE PROCEDURE p_get_customer_order_amount (
    INOUT customer_reporting INT(6)
)

BEGIN
    DECLARE finished INTEGER DEFAULT 0;
    DECLARE customerNumber varchar(100) DEFAULT "";

    -- declare cursor for customerNumber
    DEClARE curCustomerNumber 
        CURSOR FOR 
            SELECT customerNumber FROM orders;

    -- declare NOT FOUND handler
    DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finished = 1;

    OPEN curCustomerNumber;

    getOrders: LOOP
        FETCH curCustomerNumber INTO customerNumber;
        IF finished = 1 THEN 
            LEAVE getOrders;
        END IF;
        -- build orders list
        SET customer_reporting = SUM(curCustomerNumber);
    END LOOP getOrders;
    CLOSE curCustomerNumber;

END$$
DELIMITER;


--CALLING FROM PHP
--example on e-learning website


--STORED FUNCTIONS
DROP FUNCTION IF EXISTS f_customer_level;

DELIMITER $$

CREATE FUNCTION f_customer_level(
    credit DECIMAL(10,2)
) 
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE customerLevel VARCHAR(20);

    IF credit > 50000 THEN
        SET customerLevel = 'PLATINUM';
    ELSEIF (credit >= 50000 AND 
            credit <= 10000) THEN
        SET customerLevel = 'GOLD';
    ELSEIF credit < 10000 THEN
        SET customerLevel = 'SILVER';
    END IF;
    -- return the customer level
    RETURN (customerLevel);
END$$

DELIMITER;

--calling
SELECT customerName, f_customer_level(creditLimit) status
FROM customers
ORDER BY customerName



