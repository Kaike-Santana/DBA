
SELECT 
    OBJECT_SCHEMA_NAME(ips.object_id) AS SchemaName,
    OBJECT_NAME(ips.object_id) AS TableName,
    i.name AS IndexName,
    ips.avg_fragmentation_in_percent,
    ips.page_count
FROM 
    sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ips
INNER JOIN 
    sys.indexes i 
    ON ips.object_id = i.object_id AND ips.index_id = i.index_id
WHERE
    ips.page_count > 100 -- Considera apenas �ndices maiores que 100 p�ginas para melhor relev�ncia
AND ips.avg_fragmentation_in_percent > 10 -- S� �ndices com fragmenta��o significativa
ORDER BY 
    ips.avg_fragmentation_in_percent DESC
