DROP PROCEDURE IF EXISTS bundle.add_bundle;

DELIMITER |

CREATE DEFINER='db_dev' PROCEDURE bundle.add_bundle (
v_bundle_name VARCHAR(250),
v_bundle_description VARCHAR(500),
v_cause_id INTEGER, 
v_rei_id INTEGER
)

NOT DETERMINISTIC 
MODIFIES SQL DATA 
SQL SECURITY  INVOKER 

BEGIN 
/*
-- add a new bundle
	Calls bundle.add_bundle_partition Which creates partitions where needed 
	
	Add either a cause_id or a rei_id 

Sample Usage:
CALL bundle.add_bundle(
'Test bundle name1', 
'Test bundle description',
294, -- cause_id 
NULL -- rei_id
) ;


*/

INSERT INTO bundle.bundle 
(bundle_name,
bundle_description, 
cause_id,
rei_id) 
VALUES 
(v_bundle_name, v_bundle_description, v_cause_id, v_rei_id)
;

CALL bundle.add_bundle_partition (LAST_INSERT_ID());


END 

|

DELIMITER ;

