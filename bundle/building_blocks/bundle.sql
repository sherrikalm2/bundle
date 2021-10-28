-- -------------------------------------------------------------------------------
-- bundle.bundle
-- -------------------------------------------------------------------------------

DROP TABLE IF EXISTS bundle.cell; 
DROP TABLE IF EXISTS bundle_row; 
DROP TABLE IF EXISTS bundle.request;

DROP TABLE IF EXISTS bundle.bundle; 

CREATE TABLE bundle.bundle (
bundle_id INTEGER NOT NULL AUTO_INCREMENT COMMENT 'Required.Surrogate auto-incrementing unique identifier. ',
bundle_name VARCHAR(255) DEFAULT NULL COMMENT 'Required. Unique name for the bundle',
bundle_description VARCHAR(500) DEFAULT NULL COMMENT 'Optional. Describe in up to 500 characters',
-- --------------------
date_inserted datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'When this row was added to this table. Newly inserted rows default to NOW().  All other modifications prevented by trigger.',
inserted_by varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'unknown' COMMENT 'The user who first added this row',
last_updated datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'When this row was last edited. Newly inserted rows default to NOW().  All other modifications prevented by trigger. ',
last_updated_by varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'unknown' COMMENT 'The user who edited this row last',
last_updated_action varchar(6) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'INSERT' COMMENT 'The data in this column to be managed by trigger. Either INSERT, UPDATE',
-- --------------------
PRIMARY KEY (bundle_id),
UNIQUE KEY bundle_name (bundle_name)

) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci 
COMMENT= 'Typically a bundle exists as a spreadsheet. 
Important to note that the INSERTs to this table should only be done via the stored procedure bundle.add_bundle
'
;


ALTER TABLE bundle.bundle  CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci ;



/*

INSERT INTO bundle.bundle (bundle_name) 
VALUES 
('Test1'),
('Test2'),
('Test3')
;

-- ----------------------------------------------------- 
-- Add trigger to bundle_row
-- ----------------------------------------------------- 
BEGIN 

-- add a new bundle

INSERT INTO bundle.bundle (bundle_name) 
VALUES 
('Test1');

-- SET @bundle_id = LAST_INSERT_ID(); 

CALL bundle.add_bundle_partition (LAST_INSERT_ID());

END;


-- ----------------------------------------------------- 
-- Add trigger to bundle_cell
-- ----------------------------------------------------- 


select * from bundle.bundle

-- Error Code: 1336. Dynamic SQL is not allowed in stored function or trigger
-- this is why you gotta do a sproc when doing an insert 

*/

-- add some more cols to bundle table after roll to prod has begun 

ALTER TABLE bundle.bundle ADD COLUMN cause_id INTEGER 
COMMENT 'Optional. Fk to shared.cause.cause_id'
AFTER bundle_description 
;

ALTER TABLE bundle.bundle ADD COLUMN rei_id INTEGER 
COMMENT 'Optional. Fk to shared.rei.rei_id'
AFTER cause_id
;

ALTER TABLE bundle.bundle ADD CONSTRAINT fk_bundle_cause_id FOREIGN KEY (cause_id) REFERENCES shared.cause(cause_id); 
ALTER TABLE bundle.bundle ADD CONSTRAINT fk_bundle_rei_id FOREIGN KEY(rei_id) REFERENCES shared.rei(rei_id); 







