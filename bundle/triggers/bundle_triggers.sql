
-- ----------------------------------------------------------------------------------------------------------- 
-- ----------------------------------------------------------------------------------------------------------- 
-- ----------------------------------------------------------------------------------------------------------- 

-- ----------------------------------------------------- 
 -- INSERT TRIGGER ON bundle.bundle 
-- ----------------------------------------------------- 
DROP TRIGGER IF EXISTS bundle.tr_bundle_insert ; 

DELIMITER | 

CREATE 
DEFINER = 'db_dev'
TRIGGER bundle.tr_bundle_insert 
BEFORE INSERT ON bundle.bundle 

FOR EACH ROW  

BEGIN 

DECLARE v_user VARCHAR(50);

DECLARE v_message VARCHAR(200); 


SELECT LEFT(USER() ,  POSITION('@' IN USER() ) -1  )  INTO v_user; 


    -- ----------------------------------------------------- 
    -- do not allow overwrite of user and time striping unless logged in as db_dev
    -- ----------------------------------------------------- 
    IF v_user != 'db_dev' THEN
        SET NEW.date_inserted = NOW();  
    END IF;

    IF v_user != 'db_dev' THEN
        SET NEW.inserted_by =  v_user;
    END IF;

    IF v_user != 'db_dev' THEN
        SET NEW.last_updated = NOW(); 
    END IF;

    IF v_user != 'db_dev' THEN
        SET NEW.last_updated_by =  v_user;
    END IF;

    IF v_user != 'db_dev' THEN
        SET NEW.last_updated_action =  'INSERT';
    END IF;

    -- ----------------------------------------------------- 
	-- prevent a bundle from having both a cause_id and a rei_id 
	-- if a user attempts to add a bundle with both stop, pitch a fit and fail 
    -- ----------------------------------------------------- 
	IF (IF(ISNULL(NEW.cause_id), 0, 1 ) + IF(ISNULL(NEW.rei_id), 0, 1 ) ) = 2 THEN 
		-- send a nasty gram and fail to insert 
		SELECT 'Cannot have both a cause_id and rei_id associated with a bundle.  Please pick only one. '
		INTO v_message;

		SIGNAL SQLSTATE '45000'  
		SET MESSAGE_TEXT = v_message ;
	END IF; 

END; 
| 
DELIMITER ; 

-- ----------------------------------------------------------------------------------------------------------- 
-- ----------------------------------------------------------------------------------------------------------- 
-- ----------------------------------------------------------------------------------------------------------- 


-- ----------------------------------------------------- 
 -- UPDATE TRIGGER ON bundle.bundle
-- ----------------------------------------------------- 
DROP TRIGGER IF EXISTS bundle.tr_bundle_update ; 

DELIMITER | 

CREATE 
DEFINER = 'db_dev'
TRIGGER bundle.tr_bundle_update 
BEFORE UPDATE ON bundle.bundle

FOR EACH ROW  

BEGIN 

DECLARE v_user VARCHAR(50);

DECLARE v_message VARCHAR(200); 

SELECT LEFT(USER() ,  POSITION('@' IN USER() ) -1  )  INTO v_user; 

    -- ----------------------------------------------------- 
    -- do not allow overwrite of user and time striping unless logged in as db_dev
    -- ----------------------------------------------------- 
    IF v_user != 'db_dev' THEN
        SET NEW.date_inserted = OLD.date_inserted;
    END IF;

    IF v_user != 'db_dev' THEN
        SET NEW.inserted_by =  OLD.inserted_by;
    END IF;

    IF v_user != 'db_dev' THEN
        SET NEW.last_updated = NOW(); 
    END IF;

    IF v_user != 'db_dev' THEN
        SET NEW.last_updated_by =  v_user;
    END IF;

    IF v_user != 'db_dev'  THEN
        IF NEW.last_updated_action = 'DELETE' THEN 
           SET NEW.last_updated_action = 'DELETE';
        ELSE
            SET NEW.last_updated_action =  'UPDATE';
        END IF; 
    END IF;


    -- ----------------------------------------------------- 
	-- prevent a bundle from having both a cause_id and a rei_id 
	-- if a user attempts to add a bundle with both stop, pitch a fit and fail 
    -- ----------------------------------------------------- 
	IF (IF(ISNULL(NEW.cause_id), 0, 1 ) + IF(ISNULL(NEW.rei_id), 0, 1 ) ) = 2 THEN 
		-- send a nasty gram and fail to insert 
		SELECT 'Cannot have both a cause_id and rei_id associated with a bundle.  Please pick only one. '
		INTO v_message;

		SIGNAL SQLSTATE '45000'  
		SET MESSAGE_TEXT = v_message ;
	END IF; 

END; 
| 
DELIMITER ; 



-- maybe add trigger cascade on delete ? 
-- want to allow hard deletes on this 
-- that simultaneoulsy remove the rows and cells and columns 

-- ----------------------------------------------------------------------------------------------------------- 
-- ----------------------------------------------------------------------------------------------------------- 
-- ----------------------------------------------------------------------------------------------------------- 

DROP TRIGGER IF EXISTS bundle.tr_bundle_delete; 

DELIMITER | 

CREATE
DEFINER = 'db_dev'
TRIGGER bundle.tr_bundle_delete
BEFORE DELETE ON bundle.bundle
FOR EACH ROW
BEGIN 

DECLARE v_user VARCHAR(50);

SELECT LEFT(USER() ,  POSITION('@' IN USER() ) -1  )  INTO v_user; 

    -- ----------------------------------------------------- 
    -- MySQL does not support an UPDATE statement from a delete trigger 
    --      just send an error message
    -- ----------------------------------------------------- 
    IF v_user != 'db_dev' THEN

        SIGNAL SQLSTATE '45000'  
        SET MESSAGE_TEXT = 'Cannot DELETE this row unless logged in as db_dev. Please use UPDATE to set the last_updated_action  = \'DELETE\' instead';
    
    END IF;

END;

|

DELIMITER ; 

