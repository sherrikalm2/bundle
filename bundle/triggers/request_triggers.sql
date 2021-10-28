



-- ----------------------------------------------------------------------------------------------------------- 
-- ----------------------------------------------------------------------------------------------------------- 
-- ----------------------------------------------------------------------------------------------------------- 

-- ----------------------------------------------------- 
 -- INSERT TRIGGER ON bundle.request 
-- ----------------------------------------------------- 
DROP TRIGGER IF EXISTS bundle.tr_request_insert ; 

DELIMITER | 

CREATE 
DEFINER='db_dev'
TRIGGER bundle.tr_request_insert 
BEFORE INSERT ON bundle.request 

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

-- logging in as db_dev overrides
-- If inserted_by IS NULL or zero length string then use the current user 
-- otherwise use what is passed in 
    IF v_user != 'db_dev' THEN
		IF NEW.inserted_by IS NULL OR NEW.inserted_by = '' OR NEW.inserted_by = 'unknown' THEN 
			SET NEW.inserted_by =  v_user;
		END IF; 
    END IF;

    IF v_user != 'db_dev' THEN
        SET NEW.last_updated = NOW(); 
    END IF;

-- logging in as db_dev overrides
-- If last_updated_by IS NULL or zero length string then use the current user 
-- otherwise use what is passed in 
    IF v_user != 'db_dev' THEN
		IF NEW.last_updated_by IS NULL OR NEW.last_updated_by = '' THEN 
			SET NEW.last_updated_by =  v_user;
		END IF; 
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
 -- UPDATE TRIGGER ON bundle.request
-- ----------------------------------------------------- 
DROP TRIGGER IF EXISTS bundle.tr_request_update ; 

DELIMITER | 

CREATE 
DEFINER='db_dev'
TRIGGER bundle.tr_request_update 
BEFORE UPDATE ON bundle.request

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















