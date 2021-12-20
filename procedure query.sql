DELIMITER $
CREATE OR REPLACE PROCEDURE menuChecker(paraCondition VARCHAR(50), paraMonth INT, paraYear INT)
BEGIN
	#declaring variable
	DECLARE rowCounter, rowCounterMenu, tempQuantity INT;
	DECLARE tempMenuName, tempMenuCode VARCHAR(100);
	DECLARE maxQuantityBought, minQuantityBought INT;
	DECLARE tempTop, tempWorst VARCHAR(100);
	DECLARE moreTop, moreWorst INT;
	DECLARE tempMoreTop, tempMoreWorst VARCHAR(50);
	DECLARE counterMoreTop, counterMoreWorst INT;
	DECLARE startMonths INT;
	DECLARE inputYear INT;
	DECLARE inputMonths INT;
	DECLARE inputCondition VARCHAR(10);	
	DECLARE totalMenu INT;
	DECLARE line VARCHAR(20);
	DECLARE mostBought, leastBought VARCHAR(100);
	DECLARE mostBoughtQuantity, leastBoughtQuantity INT;
	DECLARE moreMost, moreLeast INT;
	
	#declaring table output and additionTable
	CREATE OR REPLACE TEMPORARY TABLE output(
		menuNumber VARCHAR(100),
		menuName VARCHAR(100),
		quantityBought INT
	);

	CREATE OR REPLACE TEMPORARY TABLE additionTable(
		menuNumber VARCHAR(100),
		menuName VARCHAR(100),
		quantityBought INT
	);
	
	#setting all variable needed
	SET rowCounter = 1;
	SET rowCounterMenu = 0;
	SET startMonths = 1;
	SET inputYear = paraYear;
	SET inputMonths = paraMonth;
	SET inputCondition = paraCondition;
	SET totalMenu = (SELECT COUNT(menucode) FROM menu);
	SET line = '-------------------';
	
	#inserting menuName and rowCounter for table addition
	inserting_menu: LOOP
		IF rowCounter > totalmenu THEN
			LEAVE inserting_menu;
		END IF;
		
		SET tempMenuCode = (SELECT menuCode FROM menu LIMIT 1 OFFSET rowCounterMenu);
		SET tempMenuName = (SELECT menuName FROM menu WHERE menuCode = tempMenuCode);
			
		INSERT INTO additionTable VALUES 
		(rowCounter, tempMenuName, 0);		
		
		SET rowCounter = rowCounter + 1;
		SET rowCounterMenu = rowCounterMenu + 1;
	END LOOP;	
	
	#loop for different months
	per_Months: LOOP
		DROP TABLE IF EXISTS secondary;
		
		CREATE OR REPLACE TEMPORARY TABLE secondary(
			menuNumber VARCHAR(100),
			menuName VARCHAR(100),
			quantityBought INT
		);
		
		#reset variable after use
		SET rowCounter = 1;
		SET rowCounterMenu = 0;
		SET counterMoreTop = 0;
		SET counterMoreWorst = 0;
		
		IF startMonths > inputMonths THEN
			LEAVE per_Months;
					
		ELSE 
			#show months name from 1-12
			IF startMonths = 1 THEN
				INSERT INTO output VALUES 
				(line , CONCAT(line, line,CONCAT(inputCondition," (", "JANUARY ", inputYear,")") ,line, line) , NULL);
			END IF;
			IF startMonths = 2 THEN
				INSERT INTO output VALUES 
				(line , CONCAT(line, line,CONCAT(inputCondition," (", "FEBRUARY ", inputYear,")") ,line, line) , NULL);
			END IF;	
			IF startMonths = 3 THEN
				INSERT INTO output VALUES 
				(line , CONCAT(line, line,CONCAT(inputCondition," (", "MARCH ", inputYear,")") ,line, line) , NULL);
			END IF;		
			IF startMonths = 4 THEN
				INSERT INTO output VALUES 
				(line , CONCAT(line, line,CONCAT(inputCondition," (", "APRIL ", inputYear,")") ,line, line) , NULL);
			END IF;		
			IF startMonths = 5 THEN
				INSERT INTO output VALUES 
				(line , CONCAT(line, line,CONCAT(inputCondition," (", "MAY ", inputYear,")") ,line, line) , NULL);
			END IF;		
			IF startMonths = 6 THEN
				INSERT INTO output VALUES 
				(line , CONCAT(line, line,CONCAT(inputCondition," (", "JUNE ", inputYear,")") ,line, line) , NULL);
			END IF;	
			IF startMonths = 7 THEN
				INSERT INTO output VALUES 
				(line , CONCAT(line, line,CONCAT(inputCondition," (", "JULY ", inputYear,")") ,line, line) , NULL);
			END IF;		
			IF startMonths = 8 THEN
				INSERT INTO output VALUES 
				(line , CONCAT(line, line,CONCAT(inputCondition," (", "AUGUST ", inputYear,")") ,line, line) , NULL);
			END IF;		
			IF startMonths = 9 THEN
				INSERT INTO output VALUES 
				(line , CONCAT(line, line,CONCAT(inputCondition," (", "SEPTEMBER ", inputYear,")") ,line, line) , NULL);
			END IF;	
			IF startMonths = 10 THEN
				INSERT INTO output VALUES 
				(line , CONCAT(line, line,CONCAT(inputCondition," (", "OCTOBER ", inputYear,")") ,line, line) , NULL);
			END IF;			
			IF startMonths = 11 THEN
				INSERT INTO output VALUES 
				(line, CONCAT(line, line,CONCAT(inputCondition," (", "NOVEMBER ", inputYear,")") ,line, line) , NULL);
			END IF;	
			IF startMonths = 12 THEN
				INSERT INTO output VALUES 
				(line , CONCAT(line, line,CONCAT(inputCondition," (", "DECEMBER ", inputYear,")") ,line, line) , NULL);
			END IF;
			
			#inputting menuName etc to table output and secondary, and counting for table addition
			inserting_menu: LOOP
				IF rowCounter > totalmenu THEN
					LEAVE inserting_menu;
				END IF;
				
				SET tempMenuCode = (SELECT menuCode FROM menu LIMIT 1 OFFSET rowCounterMenu);
				SET tempMenuName = (SELECT menuName FROM menu WHERE menuCode = tempMenuCode);
			
				SET tempQuantity = 
				(SELECT COUNT(quantity) 
				FROM orderdetail
				INNER JOIN menu
				ON orderdetail.menucode = menu.menucode
				INNER JOIN orders
				ON orders.ordernumber = orderdetail.ordernumber
				WHERE ordercondition = inputCondition 
				AND MONTH(orderdate) = startMonths
				AND YEAR(orderdate) = inputYear
				AND orderdetail.menuCode = tempMenuCode); 
			
				INSERT INTO output VALUES 
				(rowCounter, tempMenuName, tempQuantity);
				
				INSERT INTO secondary VALUES 
				(rowCounter , tempMenuName , tempQuantity);
				
				UPDATE additionTable
				SET quantityBought = quantityBought + tempQuantity
				WHERE menuNumber = rowCounter;
								
				SET rowCounter = rowCounter + 1;
				SET rowCounterMenu = rowCounterMenu + 1;	
			END LOOP;
	
			#all for showing top and worst menu from each months 
			#check for max & min from quantityBought
			SET maxQuantityBought = (SELECT MAX(quantityBought) FROM secondary);
			SET minQuantityBought = (SELECT MIN(quantityBought) FROM secondary);
			
			#check if count from quantity bought is more than 1
			SET moreTop = (SELECT COUNT(quantityBought) FROM secondary WHERE quantityBought = maxQuantityBought);
			SET moreWorst = (SELECT COUNT(quantityBought) FROM secondary WHERE quantityBought = minQuantityBought);
			
			
			IF moreTOP = 1 THEN
				SET tempTop = (SELECT menuName FROM secondary WHERE quantityBought = maxQuantityBought LIMIT 1);	
					
				INSERT INTO output VALUES 
				('' , CONCAT(line, '---------', line), NULL);
				
				INSERT INTO output VALUES 
				('' , CONCAT("TOP MENU = ", tempTop, " WITH ", maxQuantityBought, " ORDER"), NULL);	
				
			ELSE 
				INSERT INTO output VALUES 
				('' , CONCAT(line, '---------', line), NULL);
			
				multiple_Top: LOOP
					IF counterMoreTop > moreTop - 1 THEN
						LEAVE multiple_Top;
					END IF;
					
					SET tempMoreTop = (SELECT menuName FROM secondary WHERE quantityBought = maxQuantityBought LIMIT 1 OFFSET counterMoreTop );
				
					INSERT INTO output VALUES 
					('' , CONCAT("TOP MENU = ", tempMoreTop, " WITH ", maxQuantityBought, " ORDER"), NULL);	
					
					SET counterMoreTop = counterMoreTop + 1;
				END LOOP;	
			END IF;
			
			
			IF moreWorst = 1 THEN
				SET tempWorst = (SELECT menuName FROM secondary WHERE quantityBought = minQuantityBought LIMIT 1);
			
				INSERT INTO output VALUES 
				('' , CONCAT(line, '---------', line), NULL);
		
				INSERT INTO output VALUES 
				('' , CONCAT("WORST MENU = ", tempWorst, " WITH ", minQuantityBought, " ORDER"), NULL);	
				
			ELSE 
				INSERT INTO output VALUES 
				('' , CONCAT(line, '---------', line), NULL);
			
				multiple_worst: LOOP	
					IF counterMoreWorst > moreWorst - 1 THEN
						LEAVE multiple_worst;
					END IF;	
					
					SET tempMoreWorst = (SELECT menuName FROM secondary WHERE quantityBought = minQuantityBought LIMIT 1 OFFSET counterMoreWorst );
				
					INSERT INTO output VALUES 
					('' , CONCAT("WORST MENU = ", tempMoreWorst, " WITH ", minQuantityBought, " ORDER"), NULL);		
					
					SET counterMoreWorst = counterMoreWorst + 1;
				END LOOP;	
			END IF;		

			SET startMonths = startMonths + 1;						
		END IF;				
	END LOOP;
	
	#all for showing summary of data from all months that were processed
	SET counterMoreTop = 0;
	SET counterMoreWorst = 0;
	
	SET mostBoughtQuantity = (SELECT MAX(quantityBought) FROM additionTable);
	SET leastBoughtQuantity = (SELECT MIN(quantityBought) FROM additionTable);
	
	SET moreMost = (SELECT COUNT(quantityBought) FROM additionTable WHERE quantityBought = mostBoughtQuantity);
	SET moreLeast = (SELECT COUNT(quantityBought) FROM additionTable WHERE quantityBought = leastBoughtQuantity);
	
		
	INSERT INTO output VALUES 
	(line , CONCAT(line, line, "SUMMARY OF DATA", line, line), NULL );
	

	IF moreMost = 1 THEN		
			SET mostBought = (SELECT menuName FROM additionTable WHERE quantityBought = mostBoughtQuantity);
							
			INSERT INTO output VALUES 
			('' , CONCAT(line, '---------', line), NULL);
			
			INSERT INTO output VALUES
			('', CONCAT("Most Bought Item Is = ", mostBought, " With Total Of ", mostBoughtQuantity, " Orders"), NULL);
				
	ELSE 
		INSERT INTO output VALUES 
		('' , CONCAT(line, '---------', line), NULL);
		
		SET counterMoreTop = 0;
	
		multiple_Most: LOOP
			IF counterMoreTop > moreMost - 1 THEN
				LEAVE multiple_Most;
			END IF;
			
			SET mostBought = (SELECT menuName FROM additionTable WHERE quantityBought = mostBoughtQuantity LIMIT 1 OFFSET counterMoreTop);
		
			INSERT INTO output VALUES
			('', CONCAT("Most Bought Item Is = ", mostBought, " With Total Of ", mostBoughtQuantity, " Orders"), NULL);
			
			SET counterMoreTop = counterMoreTop + 1;
		END LOOP;	
	END IF;
	
	IF moreLeast = 1 THEN
		SET leastBought = (SELECT menuName FROM additionTable WHERE quantityBought = leastBoughtQuantity);
		
		INSERT INTO output VALUES 
		('' , CONCAT(line, '---------', line), NULL);

		INSERT INTO output VALUES
		('', CONCAT("Least Bought Item Is = ", leastBought, " With Total Of ", leastBoughtQuantity, " Orders"), NULL);
		
	ELSE 
		INSERT INTO output VALUES 
		('' , CONCAT(line, '---------', line), NULL);
		
		SET counterMoreWorst = 0;
	
		multiple_Least: LOOP	
			IF counterMoreWorst > moreLeast - 1 THEN
				LEAVE multiple_Least;
			END IF;
			
			SET leastBought = (SELECT menuName FROM additionTable WHERE quantityBought = leastBoughtQuantity LIMIT 1 OFFSET counterMoreWorst);

			INSERT INTO output VALUES
			('', CONCAT("Least Bought Item Is = ", leastBought, " With Total Of ", leastBoughtQuantity, " Orders"), NULL);
			
			SET counterMoreWorst = counterMoreWorst + 1;
		END LOOP;	
	END IF;

	#showing table output
	SELECT *
	FROM output;	
END$

DELIMITER ;


CALL menuChecker("DineIn", 3, 2020);
CALL menuChecker("Delivery", 3, 2020);