


DROP PROCEDURE IF EXISTS bundle.add_bundle_partition;

DELIMITER |

CREATE DEFINER='db_dev' PROCEDURE bundle.add_bundle_partition (
v_bundle_id INTEGER
)

NOT DETERMINISTIC 
MODIFIES SQL DATA 
SQL SECURITY DEFINER

BEGIN 

/*

!!!! DANGER RUNS as DEFINER 

Creates new partitions to these tables:

bundle.bundle_row
bundle.bundle_cell 


Sample Usage:
CALL bundle.add_bundle_partition (1) ;

*/

DECLARE strSQL VARCHAR(5000);

-- ---------------------------------------------------------------------------------------------
-- Add partition to bundle.bundle_row
-- ---------------------------------------------------------------------------------------------

SELECT 
CONCAT('ALTER TABLE bundle.bundle_row ADD PARTITION (PARTITION p', 
CAST(v_bundle_id AS CHAR), ' VALUES LESS THAN (', CAST((v_bundle_id + 1 ) AS CHAR), '))')
INTO strSQL
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

-- ---------------------------------------------------------------------------------------------
-- Add partition to bundle.bundle_cell
-- ---------------------------------------------------------------------------------------------

SELECT 
CONCAT( 'ALTER TABLE bundle.bundle_cell ADD PARTITION (PARTITION p', 
CAST(v_bundle_id AS CHAR), ' VALUES LESS THAN (', CAST((v_bundle_id + 1 ) AS CHAR), '))' )
INTO strSQL
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


