
DROP PROCEDURE IF EXISTS bundle.unpark_bundle;

DELIMITER |

CREATE DEFINER='db_dev' PROCEDURE bundle.unpark_bundle (
v_bundle_id INTEGER,
v_success TINYINT
)

NOT DETERMINISTIC 
MODIFIES SQL DATA 
SQL SECURITY DEFINER

BEGIN 

/*

DANGER - this runs as DEFINER 

UnParks a previously parked partition 
This is to provide safe rollback in the event of a failure 
and 
to tidy up the parked table upon successful processing 

v_success boolean 
	1 meaning = yes i succeeded , just clean up 

	0 meaning sad face, no fail, rollback the partitions to their appropriate tables


Sample usage 

-- To unpark upon a successful bundle processing
CALL bundle.unpark_bundle_row_partition (1, 1)

-- To unpark upon a failed bundle processing (rollback) 
CALL bundle.unpark_bundle_row_partition (1, 0)

*/

DECLARE strSQL VARCHAR(5000);

DECLARE strParkedRowTableName VARCHAR(500);

DECLARE strParkedCellTableName VARCHAR(500);

DECLARE v_num_row_table_already_parked INTEGER;

DECLARE v_num_cell_table_already_parked INTEGER;

DECLARE v_message VARCHAR(200); 


-- ------------------------------------------------------------------------------------
-- parked row table name
-- ------------------------------------------------------------------------------------

SELECT CONCAT('bundle_row_parking_p', CAST(v_bundle_id AS CHAR) ) INTO strParkedRowTableName; 


-- ------------------------------------------------------------------------------------
-- parked row table name
-- ------------------------------------------------------------------------------------

SELECT CONCAT('bundle_cell_parking_p', CAST(v_bundle_id AS CHAR) ) INTO strParkedCellTableName; 

-- ------------------------------------------------------------------------------------
-- see if the row table we want to unpark from exists , if it does not, stop and pitch a fit 
-- ------------------------------------------------------------------------------------

SELECT COUNT(*) INTO v_num_row_table_already_parked
FROM INFORMATION_SCHEMA.TABLES t 
WHERE 
	t.table_schema = 'bundle_parking' and 
	CAST(t.table_name AS CHAR) = CAST(strParkedRowTableName AS CHAR);


IF v_num_row_table_already_parked = 0 THEN 
	
	SELECT CONCAT('Bundle ID:', CAST(v_bundle_id AS CHAR) , ' row table is not currently parked. Unable to unpark.')
	INTO v_message;

	SIGNAL SQLSTATE '45000'  
	SET MESSAGE_TEXT = v_message ;
	
END IF; 


-- ------------------------------------------------------------------------------------
-- see if the cell table we want to unpark from exists , if it does not, stop and pitch a fit 
-- ------------------------------------------------------------------------------------

SELECT COUNT(*) INTO v_num_cell_table_already_parked
FROM INFORMATION_SCHEMA.TABLES t 
WHERE 
	t.table_schema = 'bundle_parking' and 
	CAST(t.table_name AS CHAR) = CAST(strParkedCellTableName AS CHAR);


IF v_num_cell_table_already_parked = 0 THEN 
	
	SELECT CONCAT('Bundle ID:', CAST(v_bundle_id AS CHAR) , ' Cell table is not currently parked. Unable to unpark.')
	INTO v_message;

	SIGNAL SQLSTATE '45000'  
	SET MESSAGE_TEXT = v_message ;
	
END IF; 


-- ------------------------------------------------------------------------------------
-- unpark - failure
-- 		rollback the partition to its previous place
-- ------------------------------------------------------------------------------------
IF v_success = 0 THEN 


-- -----------------------------------------------
-- rollback unpark rows
-- -----------------------------------------------
SELECT CONCAT('ALTER TABLE bundle.bundle_row EXCHANGE PARTITION p',
CAST(v_bundle_id AS CHAR), 
' WITH TABLE bundle_parking.', strParkedRowTableName)
INTO strSQL;

		-- -------------------------------
		-- prepare to run
		-- -------------------------------

		SET @s = strSQL; 

		PREPARE stmt FROM  @s;

		-- -------------------------------
		-- do it
		-- -------------------------------
		EXECUTE stmt; 

		-- -------------------------------
		-- tidy up 
		-- -------------------------------
		DEALLOCATE PREPARE stmt;

		SET @s = '';
		SELECT '' INTO strSQL; 


-- -----------------------------------------------
-- rollback unpark cells 
-- -----------------------------------------------
SELECT CONCAT('ALTER TABLE bundle.bundle_cell EXCHANGE PARTITION p',
CAST(v_bundle_id AS CHAR), 
' WITH TABLE bundle_parking.', strParkedCellTableName)
INTO strSQL;

		-- -------------------------------
		-- prepare to run
		-- -------------------------------

		SET @s = strSQL; 

		PREPARE stmt FROM  @s;

		-- -------------------------------
		-- do it
		-- -------------------------------
		EXECUTE stmt; 

		-- -------------------------------
		-- tidy up 
		-- -------------------------------
		DEALLOCATE PREPARE stmt;

		SET @s = '';
		SELECT '' INTO strSQL; 


-- ---------------------------------------
-- drop the row parked table
-- ---------------------------------------
SELECT CONCAT('DROP TABLE bundle_parking.', strParkedRowTableName)
INTO strSQL;

		-- -------------------------------
		-- prepare to run
		-- -------------------------------

		SET @s = strSQL; 

		PREPARE stmt FROM  @s;

		-- -------------------------------
		-- do it
		-- -------------------------------
		EXECUTE stmt; 

		-- -------------------------------
		-- tidy up 
		-- -------------------------------
		DEALLOCATE PREPARE stmt;

		SET @s = '';
		SELECT '' INTO strSQL; 

-- ---------------------------------------
-- drop the cell parked table
-- ---------------------------------------
SELECT CONCAT('DROP TABLE bundle_parking.', strParkedCellTableName)
INTO strSQL;

		-- -------------------------------
		-- prepare to run
		-- -------------------------------

		SET @s = strSQL; 

		PREPARE stmt FROM  @s;

		-- -------------------------------
		-- do it
		-- -------------------------------
		EXECUTE stmt; 

		-- -------------------------------
		-- tidy up 
		-- -------------------------------
		DEALLOCATE PREPARE stmt;

		SET @s = '';
		SELECT '' INTO strSQL; 

END IF;

-- ------------------------------------------------------------------------------------
-- unpark - success
-- 		drop the old tables.
-- ------------------------------------------------------------------------------------
IF v_success = 1 THEN 

-- ---------------------------------------
-- drop the row parked table
-- ---------------------------------------
SELECT CONCAT('DROP TABLE bundle_parking.', strParkedRowTableName)
INTO strSQL;

		-- -------------------------------
		-- prepare to run
		-- -------------------------------

		SET @s = strSQL; 

		PREPARE stmt FROM  @s;

		-- -------------------------------
		-- do it
		-- -------------------------------
		EXECUTE stmt; 

		-- -------------------------------
		-- tidy up 
		-- -------------------------------
		DEALLOCATE PREPARE stmt;

		SET @s = '';
		SELECT '' INTO strSQL; 

-- ---------------------------------------
-- drop the cell parked table
-- ---------------------------------------
SELECT CONCAT('DROP TABLE bundle_parking.', strParkedCellTableName)
INTO strSQL;

		-- -------------------------------
		-- prepare to run
		-- -------------------------------

		SET @s = strSQL; 

		PREPARE stmt FROM  @s;

		-- -------------------------------
		-- do it
		-- -------------------------------
		EXECUTE stmt; 

		-- -------------------------------
		-- tidy up 
		-- -------------------------------
		DEALLOCATE PREPARE stmt;

		SET @s = '';
		SELECT '' INTO strSQL; 


END IF ;




END 

|

DELIMITER ;

