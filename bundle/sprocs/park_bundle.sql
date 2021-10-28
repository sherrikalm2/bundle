
DROP PROCEDURE IF EXISTS bundle.park_bundle;

DELIMITER |

CREATE DEFINER='db_dev' PROCEDURE bundle.park_bundle (
v_bundle_id INTEGER
)

NOT DETERMINISTIC 
MODIFIES SQL DATA 
SQL SECURITY DEFINER

BEGIN 

/*

DANGER - this runs as DEFINER 

Parks a partition from the bundle_row table
Parks a pratition from the bundle_cell table
This is to provide safe rollback in the event of a failure 

Sample usage 

CALL bundle.park_bundle (1)

*/

DECLARE strSQL VARCHAR(5000);

DECLARE strParkedTableName VARCHAR(500);

DECLARE v_num_table_already_parked INTEGER;

DECLARE v_message VARCHAR(200); 

-- ------------------------------------------------------------------------------------
-- set the row parking table name
-- ------------------------------------------------------------------------------------

SELECT CONCAT('bundle_row_parking_p', CAST(v_bundle_id AS CHAR) ) INTO strParkedTableName; 


-- ------------------------------------------------------------------------------------
-- see if we already have this bundle_id row table parked , if we do stop and pitch a fit 
-- ------------------------------------------------------------------------------------

SELECT COUNT(*) INTO v_num_table_already_parked
FROM INFORMATION_SCHEMA.TABLES t 
WHERE 
	t.table_schema = 'bundle_parking' and 
	CAST(t.table_name AS CHAR) = CAST(strParkedTableName AS CHAR);


IF v_num_table_already_parked != 0 THEN 
	
	SELECT CONCAT('Bundle ID:', CAST(v_bundle_id AS CHAR) , ' row table is already parked. You must unpark before commencing')
	INTO v_message;

	SIGNAL SQLSTATE '45000'  
	SET MESSAGE_TEXT = v_message ;
	
END IF; 


-- ------------------------------------------------------------------------------------
-- make a table to park it into 
-- ------------------------------------------------------------------------------------

	SELECT CONCAT(
	'CREATE TABLE bundle_parking.bundle_row_parking_p', CAST(v_bundle_id AS CHAR), ' (
	bundle_id INTEGER NOT NULL ,
	seq INTEGER NOT NULL ,
	request_id INTEGER NOT NULL ,
	nid INTEGER NOT NULL ,
	underlying_nid INTEGER DEFAULT NULL ,
	-- --------------------
	PRIMARY KEY( bundle_id, seq),
	KEY(nid), 
	KEY(underlying_nid), 
	KEY(nid, underlying_nid)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPRESSED'
	) INTO strSQL 
	;

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


-- ------------------------------------------------------------------------------------
-- park the partition in our new table
-- ------------------------------------------------------------------------------------
	
	SELECT 
	CONCAT('ALTER TABLE bundle.bundle_row EXCHANGE PARTITION p', 
	CAST(v_bundle_id AS CHAR), ' WITH TABLE ', 
	'bundle_parking.bundle_row_parking_p', CAST(v_bundle_id AS CHAR)
	) INTO strSQL
	; 

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


-- ------------------------------------------------------------------------------------
-- set the cell parking table name
-- ------------------------------------------------------------------------------------

SELECT CONCAT('bundle_cell_parking_p', CAST(v_bundle_id AS CHAR) ) INTO strParkedTableName; 


-- ------------------------------------------------------------------------------------
-- see if we already have this bundle_id cell table parked , if we do stop and pitch a fit 
-- ------------------------------------------------------------------------------------

SELECT COUNT(*) INTO v_num_table_already_parked
FROM INFORMATION_SCHEMA.TABLES t 
WHERE 
	t.table_schema = 'bundle_parking' and 
	CAST(t.table_name AS CHAR) = CAST(strParkedTableName AS CHAR);


IF v_num_table_already_parked != 0 THEN 
	
	SELECT CONCAT('Bundle ID:', CAST(v_bundle_id AS CHAR) , ' cell is already parked. You must unpark before commencing')
	INTO v_message;

	SIGNAL SQLSTATE '45000'  
	SET MESSAGE_TEXT = v_message ;
	
END IF; 


-- ------------------------------------------------------------------------------------
-- make a table to park it into 
-- ------------------------------------------------------------------------------------

	SELECT CONCAT(
	'CREATE TABLE bundle_parking.bundle_cell_parking_p', CAST(v_bundle_id AS CHAR), ' (
	bundle_id INTEGER NOT NULL ,
	seq INTEGER NOT NULL ,
	bundle_column_id INTEGER NOT NULL ,
	request_id INTEGER NOT NULL,
	-- -----
	value_int INTEGER DEFAULT NULL ,
	value_double DOUBLE DEFAULT NULL,
	value_varchar varchar(2000) DEFAULT NULL ,
	-- ------
	PRIMARY KEY (bundle_id, seq, bundle_column_id)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPRESSED'
	) INTO strSQL 
	;


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


-- ------------------------------------------------------------------------------------
-- park the partition in our new table
-- ------------------------------------------------------------------------------------
	
	SELECT 
	CONCAT('ALTER TABLE bundle.bundle_cell EXCHANGE PARTITION p', 
	CAST(v_bundle_id AS CHAR), ' WITH TABLE ', 
	'bundle_parking.bundle_cell_parking_p', CAST(v_bundle_id AS CHAR)
	) INTO strSQL
	; 

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


END 

|

DELIMITER ;