
-- -----------------------------------------------------
-- one or the other cause_id or rei_id 
-- bundle trigger testing 
-- -----------------------------------------------------

-- test insert event 

-- this should fial 
CALL bundle.add_bundle(
'Test bundle name1', 
'Test bundle description',
294, -- cause_id 
86 -- rei_id
) ;

-- Error Code: 1644. Cannot have both a cause_id and rei_id associated with a bundle.  Please pick only one. 
-- sweet ! 

-- this should succeed 
CALL bundle.add_bundle(
'Test bundle name1', 
'Test bundle description',
294, -- cause_id 
NULL -- rei_id
) ;

-- all good 

-- test update event 

-- this should fail 
UPDATE bundle.bundle SET rei_id = 86 where bundle_id = 1; 
-- Error Code: 1644. Cannot have both a cause_id and rei_id associated with a bundle.  Please pick only one. 

-- this should succeed 
UPDATE bundle.bundle SET cause_id = NULL, rei_id = 86 where bundle_id = 1; 
-- all good 












