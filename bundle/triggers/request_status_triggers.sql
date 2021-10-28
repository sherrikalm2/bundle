

-- ----------------------------------------------------------------------------------------------------------- 
-- ----------------------------------------------------------------------------------------------------------- 
-- ----------------------------------------------------------------------------------------------------------- 

-- ----------------------------------------------------- 
 -- INSERT TRIGGER ON bundle.request_status 
-- ----------------------------------------------------- 
DROP TRIGGER IF EXISTS bundle.tr_request_status_insert ; 

DELIMITER | 

CREATE 
DEFINER='db_dev'
TRIGGER bundle.tr_request_status_insert 
BEFORE INSERT ON bundle.request_status 

FOR EACH ROW  

BEGIN 

DECLARE v_user VARCHAR(50);

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



END; 
| 
DELIMITER ; 

-- ----------------------------------------------------------------------------------------------------------- 
-- ----------------------------------------------------------------------------------------------------------- 
-- ----------------------------------------------------------------------------------------------------------- 


-- ----------------------------------------------------- 
 -- UPDATE TRIGGER ON bundle.request_status
-- ----------------------------------------------------- 
DROP TRIGGER IF EXISTS bundle.tr_request_status_update ; 

DELIMITER | 

CREATE 
DEFINER='db_dev'
TRIGGER bundle.tr_request_status_update 
BEFORE UPDATE ON bundle.request_status

FOR EACH ROW  

BEGIN 


DECLARE v_user VARCHAR(50);

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

END; 
| 
DELIMITER ; 

-- ----------------------------------------------------------------------------------------------------------- 
-- ----------------------------------------------------------------------------------------------------------- 
-- ----------------------------------------------------------------------------------------------------------- 

DROP TRIGGER IF EXISTS bundle.tr_request_status_delete; 

DELIMITER | 

CREATE
DEFINER='db_dev'
TRIGGER bundle.tr_request_status_delete
BEFORE DELETE ON bundle.request_status
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















