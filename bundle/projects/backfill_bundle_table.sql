
/*
https://jira.ihme.washington.edu/browse/CENCOM-1271

create table staging.bundle_active_modelable_entity (modelable_entity_id INTEGER NOT NULL, cnt INTEGER) ;

-- screen up this could be a while
INSERT INTO staging.bundle_active_modelable_entity 
SELECT 
modelable_entity_id ,
count(*)
from epi.input_data
where last_updated_action != 'DELETE'
group by modelable_entity_id
;

Query OK, 558 rows affected (37 min 4.87 sec)
Records: 558  Duplicates: 0  Warnings: 0

ALTER TABLE staging.bundle_active_modelable_entity 
ADD COLUMN bundle_id INTEGER AFTER modelable_entity_id;


select modelable_entity_id 
from staging.bundle_active_modelable_entity
order by modelable_entity_id

CALL staging.backfill_bundle ()
~ 1 minute

-- select * from bundle.bundle

select * FROM staging.bundle_active_modelable_entity

SELECT  s.modelable_entity_id, b.*
FROM 
	staging.bundle_active_modelable_entity s
	INNER JOIN 
	bundle.bundle b 
	ON s.bundle_id = b.bundle_id


-- latency on test 
2016-08-10 18:57:58 
2016-10-07 12:09:13


-- fill bundle_shape with each bundle and 1 

INSERT INTO bundle_shape(bundle_id, shape_id) 
SELECT bundle_id, 1 as shape_id FROM bundle.bundle ; 


*/



DROP PROCEDURE IF EXISTS staging.backfill_bundle ;

DELIMITER |

CREATE DEFINER='kalm' PROCEDURE staging.backfill_bundle ()
SQL SECURITY INVOKER
NOT DETERMINISTIC 
MODIFIES SQL DATA 

BEGIN 

DECLARE v_modelable_entity_id INTEGER;
DECLARE v_modelable_entity_name VARCHAR(255);
DECLARE v_modelable_entity_description VARCHAR(500);
DECLARE v_bundle_id INTEGER ;

DECLARE flag INTEGER default 0;

-- --------------------------------------------------------------------
-- cursor that gathers the data_version_id's to loop over  
-- --------------------------------------------------------------------

    DECLARE cur CURSOR FOR
			
-- ------------------------------------------------
-- get the me ids to loop over
-- ------------------------------------------------

	SELECT
	s.modelable_entity_id ,
	me.modelable_entity_name, 
	me.modelable_entity_description
FROM 
	staging.bundle_active_modelable_entity s
	INNER JOIN 
	epi.modelable_entity me 
	ON s.modelable_entity_id = me.modelable_entity_id
ORDER BY s.modelable_entity_id
; 

    DECLARE EXIT HANDLER FOR NOT FOUND SET flag = 1;

    -- ----------------------------------------------------------------
    -- loop over the me_id's 
    -- ----------------------------------------------------------------

    OPEN cur;

    cur_loop: LOOP

    FETCH cur INTO  v_modelable_entity_id, v_modelable_entity_name, v_modelable_entity_description ;
     

    IF flag THEN 
        CLOSE cur;
        LEAVE cur_loop;
    END IF;

    -- ---------------------------
    -- no Log where we are 
    -- ---------------------------

	-- ---------------------------
    -- add bundle 
    -- ---------------------------

	INSERT INTO bundle.bundle 
	(bundle_name,
	bundle_description) 
	VALUES 
	(v_modelable_entity_name, v_modelable_entity_description)
	;

	SELECT LAST_INSERT_ID() INTO v_bundle_id; 

	CALL bundle.add_bundle_partition (v_bundle_id);

	UPDATE staging.bundle_active_modelable_entity 
	SET bundle_id = LAST_INSERT_ID()
	WHERE modelable_entity_id = v_modelable_entity_id ;

	COMMIT ;

	-- --------------------------------------------------------------------
	END LOOP cur_loop; 
	-- --------------------------------------------------------------------


END;

|

DELIMITER ;











