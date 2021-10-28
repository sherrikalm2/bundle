
-- -------------------------------------------------------------------------------
-- bundle.request
-- -------------------------------------------------------------------------------
DROP TABLE IF EXISTS bundle.request;

CREATE TABLE bundle.request (
request_id INTEGER NOT NULL AUTO_INCREMENT COMMENT 'Surrogate auto increment identifying integer',
bundle_id INTEGER NOT NULL COMMENT 'Required. Fk to bundle.bundle_id',
request_status_id INTEGER NOT NULL DEFAULT 2 COMMENT 'Required. Fk to bundle.request_status.request_status_id',
request_type_id INTEGER NOT NULL COMMENT 'Required. Fk to bundle.request_type.request_type_id',
requested_by VARCHAR(250) NOT NULL COMMENT 'Required. Who is wanting this work done?',
request_params VARCHAR(2000) COMMENT 'Optional. JSON string of request args.  Filepath is often stored here.', 
error_log_path VARCHAR(1000) COMMENT 'Optional. Full path to error log file on file system. ',
source_repo VARCHAR(500) NOT NULL COMMENT 'Required. Path to source code being run to complete this request.', 
-- ---------------------
date_inserted datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'When this row was added to this table. Newly inserted rows default to NOW().  All other modifications prevented by trigger.',
inserted_by VARCHAR(50) NOT NULL DEFAULT 'unknown' COMMENT 'The user who first added this row', 
last_updated datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'When this row was last edited. Newly inserted rows default to NOW().  All other modifications prevented by trigger. ',
last_updated_by varchar(50) NOT NULL DEFAULT 'unknown' COMMENT 'The user who edited this row last',
last_updated_action varchar(6) NOT NULL DEFAULT 'INSERT' COMMENT 'The data in this column to be managed by trigger. Either INSERT, UPDATE, DELETE',
-- ---------------------
PRIMARY KEY (request_id),
CONSTRAINT fk_request_bundle_id FOREIGN KEY (bundle_id) REFERENCES bundle.bundle(bundle_id), 
CONSTRAINT fk_request_request_status_id FOREIGN KEY(request_status_id) REFERENCES bundle.request_status(request_status_id),
CONSTRAINT fk_request_request_type_id FOREIGN KEY(request_type_id) REFERENCES bundle.request_type(request_type_id)

) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci 
COMMENT= 'Describes the event of moving of a bundle from one place to another.  Typical event types as follows:
A bundle gets loaded into tier 1 tables,
A bundle gets promoted to tier 2 dismod, 
A bundle gets promoted to tier 2 gpr. 
Expected growth ~40-100,000 rows per round.'
;

ALTER TABLE bundle.request CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci ;

-- add triggers 

/*
-- add a sample row for testing parking of partitions
INSERT INTO bundle.request(
bundle_id, 
request_status_id, 
delivery_type_id, 
source_repo
)
VALUES 
(1, -- bundle_id
2,  -- request_status_id 2 processing
1, -- delivery_type_id tier1
'source_repo ' -- source_repo 
) 
 
*/


