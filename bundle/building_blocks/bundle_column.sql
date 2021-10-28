-- -------------------------------------------------------------------------------
-- bundle.bundle_column
-- -------------------------------------------------------------------------------

DROP TABLE IF EXISTS bundle.bundle_column;

CREATE TABLE bundle.bundle_column (
bundle_column_id INTEGER NOT NULL AUTO_INCREMENT COMMENT 'Auto incrementing identifier.',
bundle_id INTEGER NOT NULL COMMENT 'Required. Fk to bundle.bundle_id', 
request_id INTEGER NOT NULL COMMENT 'Required. Fk to bundle.request.request_id',
sort_order INTEGER NOT NULL COMMENT 'Required. For new loads, the order they appear. Partial loads add additional columns last',
bundle_column_name varchar(50) DEFAULT NULL COMMENT 'The column name gleaned from the bundle load. Must be unique within the bundle',
UNIQUE (bundle_column_id),
PRIMARY KEY (bundle_id, sort_order ),
UNIQUE(bundle_id, bundle_column_name),
CONSTRAINT fk_bundle_column_bundle_id FOREIGN KEY(bundle_id) REFERENCES bundle.bundle(bundle_id),
CONSTRAINT fk_bundle_column_request_id FOREIGN KEY(request_id) REFERENCES bundle.request(request_id) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci 
COMMENT= 'The conceptual column names associated with a bundle. Typicaly, the column names in a spreadsheet. 
Column names must be unique for a bundle.'
;

ALTER TABLE bundle.bundle_column  CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci ;


-- no triggers



