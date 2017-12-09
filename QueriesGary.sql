delimiter $$
DROP PROCEDURE IF EXISTS ShowTickInfo $$
CREATE PROCEDURE ShowTickInfo(IN id VARCHAR(5))
    BEGIN 
        IF EXISTS (SELECT tick FROM Prices WHERE tick = id) THEN 
            SELECT * 
			FROM Prices JOIN Volume ON prices.tick = Volume.tick AND prices.date = Volume.date
				JOIN Misc ON prices.tick = Misc.tick AND prices.date = Misc.date
				JOIN AdjPrices ON prices.tick = AdjPrices.tick AND prices.date = AdjPrices.date;
        ELSE 
            SELECT 'ERROR: Tick NOT FOUND' AS 'Result'; 
        END IF; 
    END$$
delimiter;

delimiter $$
DROP PROCEDURE IF EXISTS FindTickerWithDate $$
CREATE procedure FindTickerWithDate(IN id VARCHAR(5), IN dt VARCHAR(10)) 
    BEGIN 
        IF EXISTS (SELECT tick FROM Prices WHERE tick = id) AND EXISTS (SELECT date FROM Prices WHERE dt = date) THEN 
            SELECT * 
			FROM Prices JOIN Volume ON prices.tick = Volume.tick AND prices.date = Volume.date
				JOIN Misc ON prices.tick = Misc.tick AND prices.date = Misc.date
				JOIN AdjPrices ON prices.tick = AdjPrices.tick AND prices.date = AdjPrices.date
			WHERE Prices.date = dt AND Prices.tick = id;
        ELSE
            SELECT 'ERROR: UPDATE FAILED INVALID Ticker OR Date' AS 'Result'; 
        END IF; 
    END$$
delimiter;

delimiter $$
DROP PROCEDURE IF EXISTS FindTickerWithDateRange $$
CREATE procedure FindTickerWithDate(IN id VARCHAR(5), IN dt1 VARCHAR(10), IN dt2 VARCHAR(10)) 
    BEGIN 
        IF EXISTS (SELECT tick FROM Prices WHERE tick = id) AND EXISTS (SELECT date FROM Prices WHERE dt1 >= date AND dt2 <= date) THEN 
            SELECT * 
			FROM Prices JOIN Volume ON prices.tick = Volume.tick AND prices.date = Volume.date
				JOIN Misc ON prices.tick = Misc.tick AND prices.date = Misc.date
				JOIN AdjPrices ON prices.tick = AdjPrices.tick AND prices.date = AdjPrices.date
			WHERE Prices.date = dt AND Prices.tick = id;
        ELSE
            SELECT 'ERROR: UPDATE FAILED INVALID Ticker OR Date' AS 'Result'; 
        END IF; 
    END$$
delimiter;


/*

#####################################################

*/

delimiter $$
DROP PROCEDURE IF EXISTS LocationOfCompany $$
CREATE procedure LocationOfCompany(IN id VARCHAR(5)) 
    BEGIN 
      IF EXISTS (SELECT tick FROM Prices WHERE tick = id) THEN 
        SELECT Location.city, Location.state, Location.country
        FROM Company JOIN Location ON Company.hqkey = Location.key;
      ELSE
        SELECT 'ERROR: UPDATE FAILED INVALID Ticker' AS 'Result'; 
      END IF; 
    END$$
delimiter;

delimiter $$
DROP PROCEDURE IF EXISTS CompaniesInSameCity $$
CREATE procedure CompaniesInSameCity(IN id VARCHAR(5)) 
    BEGIN 
      IF EXISTS (SELECT tick FROM Prices WHERE tick = id) THEN 
        SELECT c2.tick
        FROM Company c1 JOIN Company c2 ON c2.hqkey = c1.hqkey
          JOIN Location l ON c1.hqkey = l.key
        WHERE c1.tick = id AND c2.tick != id;
      ELSE
        SELECT 'ERROR: UPDATE FAILED INVALID Ticker' AS 'Result'; 
      END IF; 
    END$$
delimiter;

delimiter $$
DROP PROCEDURE IF EXISTS CompaniesInSameState $$
CREATE procedure CompaniesInSameState(IN id VARCHAR(5)) 
    BEGIN 
      IF EXISTS (SELECT tick FROM Prices WHERE tick = id) THEN 
        SELECT c2.tick, l2.city, l2.state, l2.country
        FROM Company c1 JOIN Location l1 ON c1.hqkey = l1.key
          JOIN Location l2 ON l1.state = l2.state
          JOIN Company c2 ON c2.hqkey = l2.key
        WHERE c1.tick = id AND c2.tick != id;
      ELSE
        SELECT 'ERROR: UPDATE FAILED INVALID Ticker' AS 'Result'; 
      END IF; 
    END$$
delimiter;

delimiter $$
DROP PROCEDURE IF EXISTS CompaniesInSameCountry $$
CREATE procedure CompaniesInSameCountry(IN id VARCHAR(5)) 
    BEGIN 
      IF EXISTS (SELECT tick FROM Prices WHERE tick = id) THEN 
        SELECT c2.tick, l2.city, l2.state, l2.country
        FROM Company c1 JOIN Location l1 ON c1.hqkey = l1.key
          JOIN Location l2 ON l1.country = l2.country
          JOIN Company c2 ON c2.hqkey = l2.key
        WHERE c1.tick = id AND c2.tick != id;
      ELSE
        SELECT 'ERROR: UPDATE FAILED INVALID Ticker' AS 'Result'; 
      END IF; 
    END$$
delimiter;


delimiter $$
DROP PROCEDURE IF EXISTS EmployeesOfCompany $$
CREATE procedure EmployeesOfCompany(IN id VARCHAR(5)) 
    BEGIN 
      IF EXISTS (SELECT tick FROM Prices WHERE tick = id) THEN 
        SELECT Company.employees
        FROM Company;
      ELSE
        SELECT 'ERROR: UPDATE FAILED INVALID Ticker' AS 'Result'; 
      END IF; 
    END$$
delimiter;


delimiter $$
DROP PROCEDURE IF EXISTS BiggestEmployerInState $$
CREATE procedure BiggestEmployerInState(IN s VARCHAR(5)) 
    BEGIN 
      IF EXISTS (SELECT state FROM Location WHERE state = s) THEN 
        SELECT Company.tick
        FROM Location JOIN Company ON Location.key = Company.hqkey
        WHERE Location.state = s
        ORDER BY Company.employees DESC
        LIMIT 1;
      ELSE
        SELECT 'ERROR: UPDATE FAILED INVALID state' AS 'Result'; 
      END IF; 
    END$$
delimiter;

delimiter $$
DROP PROCEDURE IF EXISTS BiggestEmployerInCountry $$
CREATE procedure BiggestEmployerInCountry(IN c VARCHAR(5)) 
    BEGIN 
      IF EXISTS (SELECT country FROM Location WHERE country = c) THEN 
        SELECT Company.tick
        FROM Location JOIN Company ON Location.key = Company.hqkey
        WHERE Location.country = c
        ORDER BY Company.employees DESC
        LIMIT 1;
      ELSE
        SELECT 'ERROR: UPDATE FAILED INVALID state' AS 'Result'; 
      END IF; 
    END$$
delimiter;


delimiter $$
DROP PROCEDURE IF EXISTS BiggestEmployerInCity $$
CREATE procedure BiggestEmployerInCity(IN c VARCHAR(5)) 
    BEGIN 
      IF EXISTS (SELECT city FROM Location WHERE city = c) THEN 
        SELECT Company.tick
        FROM Location JOIN Company ON Location.key = Company.hqkey
        WHERE Location.city = c
        ORDER BY Company.employees DESC
        LIMIT 1;
      ELSE
        SELECT 'ERROR: UPDATE FAILED INVALID state' AS 'Result'; 
      END IF; 
    END$$
delimiter;





