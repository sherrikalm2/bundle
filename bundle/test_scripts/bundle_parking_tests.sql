
-- !!! DANGER this assumes a non production system
-- parking test 

CALL bundle.add_bundle(
'Test bundle name1', 
'Test bundle description'
) ;

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
;

CALL bundle.park_bundle (1);

/*
select * from bundle.bundle_row; -- 0 rows
select * from bundle.bundle_cell; -- 0 rows 

-- -------------------------------------------
-- test fail
-- -------------------------------------------
-- CALL bundle.unpark_bundle(1, 0); 

select * from bundle.bundle_row; -- 3 rows
select * from bundle.bundle_cell; -- 3 rows 


-- -------------------------------------------
-- test success 
-- set up test up to park event 
-- then simulate filling new stuff 
-- then unpark


INSERT INTO bundle.bundle_row (
bundle_id, 
seq, 
request_id,
nid
)
VALUES 
(1, 1, 1, 216), 
(1, 2, 1, 216), 
(1, 3, 1, 216)
;

select * from bundle.bundle_row;

INSERT INTO bundle.bundle_cell (
bundle_id, 
request_id, 
bundle_row_seq,
bundle_column_id ,
value_int
) 
VALUES 
(1, 1, 1, 1, 4),
(1, 1, 1, 2, 4),
(1, 1, 1, 3, 4)
;
select * from bundle.bundle_cell;

CALL bundle.unpark_bundle(1, 1); 

*/


