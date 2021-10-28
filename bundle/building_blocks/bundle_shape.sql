
-- -------------------------------------------------------------------------------
-- bundle.bundle_shape
-- -------------------------------------------------------------------------------
DROP TABLE IF EXISTS bundle.bundle_shape;

CREATE TABLE bundle.bundle_shape (
bundle_id INTEGER NOT NULL COMMENT 'Required. Fk to bundle.bundle_id',
shape_id INTEGER NOT NULL COMMENT 'Required. Fk to bundle.shape',
-- ---------------------
date_inserted datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'When this row was added to this table. Newly inserted rows default to NOW().  All other modifications prevented by trigger.',
inserted_by VARCHAR(50) NOT NULL DEFAULT 'unknown' COMMENT 'The user who first added this row', 
last_updated datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'When this row was last edited. Newly inserted rows default to NOW().  All other modifications prevented by trigger. ',
last_updated_by varchar(50) NOT NULL DEFAULT 'unknown' COMMENT 'The user who edited this row last',
last_updated_action varchar(6) NOT NULL DEFAULT 'INSERT' COMMENT 'The data in this column to be managed by trigger. Either INSERT, UPDATE, DELETE',
-- ---------------------
PRIMARY KEY (bundle_id, shape_id),
CONSTRAINT fk_bundle_shape_bundle_id FOREIGN KEY(bundle_id) REFERENCES bundle.bundle(bundle_id) , 
CONSTRAINT fk_bundle_shape_shape_id FOREIGN KEY (shape_id) REFERENCES bundle.shape(shape_id)

) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci 
COMMENT= 'The deault shape(s) that a bundle get put into tier 2 as. '
;

ALTER TABLE bundle_shape  CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci ;



