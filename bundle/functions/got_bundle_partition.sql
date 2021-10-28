


SELECT 
	PARTITION_NAME,
	CAST(SUBSTRING_INDEX(PARTITION_NAME, 'p', -1) AS UNSIGNED) as bundle_id
FROM 
	INFORMATION_SCHEMA.PARTITIONS
WHERE 
	table_schema = 'bundle' and 
	table_name = 'bundle_row'
;

