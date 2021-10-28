
-- -----------------------------------------------------------------------
-- bundle.request_status
-- -----------------------------------------------------------------------

DROP TABLE IF EXISTS bundle.request_status; 

CREATE TABLE bundle.request_status  (
request_status_id int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT 'Required, auto incrementing. ',
request_status varchar(250) NOT NULL COMMENT 'Required. Unique request status.',
-- -------------------
date_inserted datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'When this row was added to this table. Newly inserted rows default to NOW().  All other modifications prevented by trigger.',
inserted_by VARCHAR(50) NOT NULL DEFAULT 'unknown' COMMENT 'The user who first added this row', 
last_updated datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'When this row was last edited. Newly inserted rows default to NOW().  All other modifications prevented by trigger. ',
last_updated_by varchar(50) NOT NULL DEFAULT 'unknown' COMMENT 'The user who edited this row last',
last_updated_action varchar(6) NOT NULL DEFAULT 'INSERT' COMMENT 'The data in this column to be managed by trigger. Either INSERT, UPDATE. This table to do hard deletes',
-- -------------------
UNIQUE (request_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT 'Lookup table for the possible status states an epi upload request can have.';


ALTER TABLE bundle.request_status  CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci ;


-- add triggers 



/*

-- fill it up 
INSERT INTO bundle.request_status 
(request_status_id, request_status)
VALUES 
(1, 'Request submitted' ),
(2, 'Processing'),
(3, 'Uploaded  '), 
(4, 'Errors')
;

select * from bundle.request_status ;

*/



