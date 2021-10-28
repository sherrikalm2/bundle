
-- -------------------------------------------------------------------------------
-- bundle.bundle_cell
-- -------------------------------------------------------------------------------
DROP TABLE IF EXISTS bundle.bundle_cell; 

CREATE TABLE bundle.bundle_cell (
bundle_id INTEGER NOT NULL COMMENT 'Reuired. Denormalized for performance. This is derivable from the etl_version_id.',
seq INTEGER NOT NULL COMMENT 'Required. What row is this cell in? Fk to bundle.bundle_row.seq.',
bundle_column_id INTEGER NOT NULL COMMENT 'Required. What column is this cell in? Fk to bundle.bundle_column.bundle_column_id',
request_id INTEGER NOT NULL COMMENT 'Required. Fk to bundle.etl_version.etl_version_id',
-- -----
value_int INTEGER DEFAULT NULL COMMENT 'Optional. At least one value column should have a value. Integer type values get stored here',
value_double DOUBLE DEFAULT NULL COMMENT 'Optional. At least one value column should have a value. Double type values get stored here',
value_varchar varchar(1000) DEFAULT NULL COMMENT 'Optional. At least one value column should have a value. Text type values get stored here',
-- ------
PRIMARY KEY (bundle_id, seq, bundle_column_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPRESSED
COMMENT= 'This table is likely to get enormous. Partition by bundle_id. All Fks are implied as adding partitioning removes referential constrainsts.'
PARTITION BY RANGE (bundle_id) (
PARTITION p0 VALUES LESS THAN (1)
)
;

ALTER TABLE bundle.bundle_cell  CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci ;

/*

INSERT INTO bundle.bundle_cell (
bundle_id, 
request_id, 
bundle_row_seq,
bundle_column_id ,
value_int
) 
VALUES 
(1, 1, 1, 1, 100),
(1, 1, 1, 2, 42),
(1, 1, 1, 3, 16)


*/


-- make this bigger 

ALTER TABLE bundle.bundle_cell CHANGE COLUMN
value_varchar value_varchar varchar(2000) DEFAULT NULL COMMENT 'Optional. At least one value column should have a value. Text type values get stored here'
;
