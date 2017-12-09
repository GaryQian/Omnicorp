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



