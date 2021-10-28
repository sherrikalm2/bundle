
-- --------------------------------------------------------------
-- bundle.shape
-- --------------------------------------------------------------
DROP TABLE IF EXISTS bundle.shape;

CREATE TABLE bundle.shape (
shape_id int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY  COMMENT 'auto incrementing identifier',
shape varchar(64) NOT NULL COMMENT 'Required. Unique name.',
shape_description VARCHAR(500) NOT NULL COMMENT 'Required. Describe in up to 500 characters' ,
-- ---------------------
date_inserted datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'When this row was added to this table. Newly inserted rows default to NOW().  All other modifications prevented by trigger.',
inserted_by VARCHAR(50) NOT NULL DEFAULT 'unknown' COMMENT 'The user who first added this row', 
last_updated datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'When this row was last edited. Newly inserted rows default to NOW().  All other modifications prevented by trigger. ',
last_updated_by varchar(50) NOT NULL DEFAULT 'unknown' COMMENT 'The user who edited this row last',
last_updated_action varchar(6) NOT NULL DEFAULT 'INSERT' COMMENT 'The data in this column to be managed by trigger. Either INSERT, UPDATE, DELETE',
-- ---------------------
UNIQUE(shape)

) ENGINE=InnoDB DEFAULT CHARSET=utf8 
COMMENT 'Simple lookup for the delivery mechanism used to transform bundles. Things like Loading into Tier 1 . Loading into Tier 2 Dismod'
;

-- add triggers 

/*
-- seed 

INSERT INTO bundle.shape (
shape_id, 
shape, 
shape_description 
) 
VALUES 
(1, 'dismod', 'Loading into shape for dismod consumption'),
(2, 'sev', 'Loading into shape for severity split')
;

select * from bundle.shape

*/


