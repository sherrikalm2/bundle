-- -----------------------------------------------------------------------
-- bundle.request_type
-- -----------------------------------------------------------------------

DROP TABLE IF EXISTS bundle.request_type; 

CREATE TABLE bundle.request_type  (
request_type_id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT 'Required, auto incrementing. ',
request_type varchar(250) NOT NULL COMMENT 'Required. Unique request type.',
request_type_description VARCHAR(500) COMMENT 'Optional. Describe in up to 500 chars',
-- -------------------
date_inserted datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'When this row was added to this table. Newly inserted rows default to NOW().  All other modifications prevented by trigger.',
inserted_by VARCHAR(50) NOT NULL DEFAULT 'unknown' COMMENT 'The user who first added this row', 
last_updated datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'When this row was last edited. Newly inserted rows default to NOW().  All other modifications prevented by trigger. ',
last_updated_by varchar(50) NOT NULL DEFAULT 'unknown' COMMENT 'The user who edited this row last',
last_updated_action varchar(6) NOT NULL DEFAULT 'INSERT' COMMENT 'The data in this column to be managed by trigger. Either INSERT, UPDATE. This table to do hard deletes',
-- -------------------
UNIQUE (request_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 
COMMENT 'Lookup table for the possible types of requests.';


ALTER TABLE bundle.request_type  CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci ;


-- add triggers 



/*

-- fill it up 
INSERT INTO bundle.request_type 
(request_type_id, request_type)
VALUES 
(1, 'Upload' ),
(2, 'Download')
;

select * from bundle.request_type ;

*/