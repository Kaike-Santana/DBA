
WITH GERA_COMANDO AS (
SELECT 
    'ALTER INDEX [' + i.name + '] ON [' + OBJECT_SCHEMA_NAME(ips.object_id) + '].[' + OBJECT_NAME(ips.object_id) + '] ' +
    CASE
        WHEN ips.avg_fragmentation_in_percent > 30 THEN 'REBUILD'
        WHEN ips.avg_fragmentation_in_percent BETWEEN 10 AND 30 THEN 'REORGANIZE'
    END AS Comando_Sugerido,
    ips.avg_fragmentation_in_percent
FROM 
    sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ips
INNER JOIN 
    sys.indexes i 
    ON ips.object_id = i.object_id AND ips.index_id = i.index_id
WHERE 
    ips.page_count > 100
    AND ips.avg_fragmentation_in_percent > 10 -- Só índices com fragmentação significativa
)

SELECT *
FROM GERA_COMANDO
WHERE Comando_Sugerido IS NOT NULL