
-- -------------------------------------------------------------------------------
-- bundle.bundle_row
-- -------------------------------------------------------------------------------

-- DROP TABLE IF EXISTS bundle.bundle_cell;
 DROP TABLE IF EXISTS bundle.bundle_row;

CREATE TABLE bundle.bundle_row (
bundle_id INTEGER NOT NULL COMMENT 'Required. Fk to bundle.bundle.bundle_id. ',
seq INTEGER NOT NULL COMMENT 'Required. Typically corresponds to a row in a csv or Excel spreadsheet. Using abbreviated sequence (seq) instead of word sequence which can cause some protability isssues.',
request_id INTEGER NOT NULL COMMENT 'Required. Fk to bundle.request.request_id',
nid INTEGER NOT NULL COMMENT 'Required. Implied foreign key to ghdx nid. ',
underlying_nid INTEGER DEFAULT NULL COMMENT 'Optional. Implied fk to ghdx underlying nid if applicable.',
-- --------------------
PRIMARY KEY( bundle_id, seq),
KEY(nid), 
KEY(underlying_nid), 
KEY(nid, underlying_nid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPRESSED
COMMENT= 'Describes the base required elements in a bundle row. The seq column typically corresponds to a row in a csv or Excel spreadsheet. 
Conceptually, this table describes the rows in a spreadsheet.'
PARTITION BY RANGE (bundle_id) 
(
PARTITION p0 VALUES LESS THAN (1)
)

;


ALTER TABLE bundle.bundle_row  CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci ;

/*

-- ?
-- add a partition to be done by insert trigger on bundle.bundle 
ALTER TABLE bundle.bundle_row 
ADD PARTITION p1 VALUES LESS THAN (2); 



ALTER TABLE bundle PARTITION BY RANGE( YEAR(purchased) ) ( 
-> PARTITION p0 VALUES LESS THAN (1990), 
-> PARTITION p1 VALUES LESS THAN (1995), 
-> PARTITION p2 VALUES LESS THAN (2000), 
-> PARTITION p3 VALUES LESS THAN (2005) 
-> ); 

*/

/*

INSERT INTO bundle.bundle_row (
bundle_id, 
seq, 
request_id,
nid
)
VALUES 
(1, 1, 1, 103215), 
(1, 2, 1, 103215), 
(1, 3, 1, 103215)
;

INSERT INTO bundle.bundle_row (
bundle_id, 
seq, 
request_id,
nid
)
VALUES 
(2, 1, 1, 103215), 
(2, 2, 2, 103215), 
(2, 3, 2, 103215)
;

*/




