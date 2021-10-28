echo start 

basePath=${1:-/home/kalm/git/epi/bundle}

basePathEpi=${2:-/home/kalm/git/epi}

targetHost=(modeling-epi-db.ihme.washington.edu)

echo tier 3 

echo drop epi.t3_model_version_csmr
mysql -h${targetHost} -N -e "drop table if exists epi.t3_model_version_csmr"

echo drop epi.t3_model_version_dismod
mysql -h${targetHost} -N -e "drop table if exists epi.t3_model_version_dismod"

echo drop epi.t3_model_version_emr
mysql -h${targetHost} -N -e "drop table if exists epi.t3_model_version_emr"

echo tier 2 
echo drop bundle_dismod_study_covariate
mysql -h${targetHost} -N -e "drop table if exists epi.bundle_dismod_study_covariate"

echo drop epi.bundle_dismod
mysql -h${targetHost} -N -e "drop table if exists epi.bundle_dismod"

echo drop IF EXISTS schema bundle_parking; 
mysql -h${targetHost} -N -e "drop schema IF EXISTS bundle_parking"

echo create schema bundle_parking; 
mysql -h${targetHost} -N -e "create schema bundle_parking"

echo drop IF EXISTS schema bundle; 
mysql -h${targetHost} -N -e "drop schema IF EXISTS bundle"

echo create schema bundle; 
mysql -h${targetHost} -N -e "create schema bundle"

echo add the bundle table 
mysql -h${targetHost} bundle < ${basePath}/building_blocks/bundle.sql

echo add the bundle table triggers 
mysql -h${targetHost} bundle < ${basePath}/triggers/bundle_triggers.sql

echo add the default bundle value
mysql -h${targetHost} -N -e "INSERT INTO bundle.bundle 
(bundle_id,
bundle_name,
bundle_description) 
VALUES 
(-1, 'DO NOT USE - Internal Only', 'Placeholder id for legacy data.')"


echo add the request_status table 
mysql -h${targetHost} bundle < ${basePath}/building_blocks/request_status.sql

echo add the request_status triggers 
mysql -h${targetHost} bundle < ${basePath}/triggers/request_status_triggers.sql

echo fill the request_status_table
mysql -h${targetHost} bundle -N -e "
INSERT INTO bundle.request_status 
(request_status_id, request_status)
VALUES 
(1, 'Request submitted' ),
(2, 'Processing'),
(3, 'Uploaded  '), 
(4, 'Errors')
"

echo add the request_type table 
mysql -h${targetHost} bundle < ${basePath}/building_blocks/request_type.sql

echo add the request_type triggers 
mysql -h${targetHost} bundle < ${basePath}/triggers/request_type_triggers.sql

echo fill the request type table 
mysql -h${targetHost} bundle -N -e "
INSERT INTO bundle.request_type 
(request_type_id, request_type)
VALUES 
(1, 'Upload' ),
(2, 'Download')
"

echo add the shape table
mysql -h${targetHost} bundle < ${basePath}/building_blocks/shape.sql

echo add the shape table triggers 
mysql -h${targetHost} bundle < ${basePath}/triggers/shape_triggers.sql

echo fill the delivery_type_table
mysql -h${targetHost} bundle -N -e "
INSERT INTO bundle.shape (
shape_id, 
shape, 
shape_description 
) 
VALUES 
(1, 'dismod', 'Loading into shape for dismod consumption'),
(2, 'sev', 'Loading into shape for severity split')
;
"

echo add the request table 
mysql -h${targetHost} bundle < ${basePath}/building_blocks/request.sql

echo add the request table triggers
mysql -h${targetHost} bundle < ${basePath}/triggers/request_triggers.sql

echo add the bundle_column table
mysql -h${targetHost} bundle < ${basePath}/building_blocks/bundle_column.sql

echo add the bundle_row table 
mysql -h${targetHost} bundle < ${basePath}/building_blocks/bundle_row.sql

echo add the bundle_cell table
mysql -h${targetHost} bundle < ${basePath}/building_blocks/bundle_cell.sql

echo add the bundle_shape table 
mysql -h${targetHost} bundle < ${basePath}/building_blocks/bundle_shape.sql

echo add the bundle_shape triggers 
mysql -h${targetHost} bundle < ${basePath}/triggers/bundle_shape_triggers.sql

echo add sproc add_bundle_partition
mysql -h${targetHost} bundle < ${basePath}/sprocs/add_bundle_partition.sql

echo add sproc add_bundle
mysql -h${targetHost} bundle < ${basePath}/sprocs/add_bundle.sql

echo add sproc park_bundle
mysql -h${targetHost} bundle < ${basePath}/sprocs/park_bundle.sql

echo add sproc unpark_bundle
mysql -h${targetHost} bundle < ${basePath}/sprocs/unpark_bundle.sql


echo tier2
echo 

echo add epi.bundle_dismod table
mysql -h${targetHost} epi < ${basePathEpi}/building_blocks/bundle_dismod.sql 

echo add epi.bundle_dismod_study_covariate
mysql -h${targetHost} epi < ${basePathEpi}/building_blocks/bundle_dismod_study_covariate.sql 


echo tier 3 

echo add epi.t3_model_version_dismod
mysql -h${targetHost} epi < ${basePathEpi}/building_blocks/t3_model_version_dismod.sql 

echo add epi.t3_model_version_csmr
mysql -h${targetHost} epi < ${basePathEpi}/building_blocks/t3_model_version_csmr.sql 

echo add epi.t3_model_version_emr
mysql -h${targetHost} epi < ${basePathEpi}/building_blocks/t3_model_version_emr.sql 




echo t2 to t3 sprocs 

mysql -h${targetHost} epi < ${basePathEpi}/sprocs/load_t3_model_version_dismod.sql
mysql -h${targetHost} epi < ${basePathEpi}/sprocs/load_t3_model_version_study_covariate.sql

echo delete cleanup sproc mods 

mysql -h${targetHost} epi < ${basePathEpi}/sprocs/load_t3_model_version_study_covariate.sql



echo complete







