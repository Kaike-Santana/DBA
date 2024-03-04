
WITH indexcols AS
 (SELECT object_id AS id,
 index_id AS indid,
 name,
    i.is_disabled,
	 (SELECT CASE keyno
	 WHEN 0 THEN NULL
	 ELSE colid
	 END AS [data()]
	 FROM sys.sysindexkeys AS k
	 WHERE k.id = i.object_id
	 AND k.indid = i.index_id
	 ORDER BY keyno,
	 colid
	 FOR XML PATH('') ) AS cols,
  
	 (SELECT CASE keyno
	 WHEN 0 THEN colid
	 ELSE NULL
	 END AS [data()]
	 FROM sys.sysindexkeys AS k
	 WHERE k.id = i.object_id
	 AND k.indid = i.index_id
	 ORDER BY colid
	 FOR XML PATH('') ) AS inc,
	 STUFF((SELECT  ', ' + COLUMN_DATA_KEY_COLS.name + ' ' + CASE WHEN INDEX_COLUMN_DATA_KEY_COLS.is_descending_key = 1 THEN 'DESC' ELSE 'ASC' END -- Include column order (ASC / DESC)
                                FROM    sys.tables AS T
                                            INNER JOIN sys.indexes INDEX_DATA_KEY_COLS
                                            ON T.object_id = INDEX_DATA_KEY_COLS.object_id
                                            INNER JOIN sys.index_columns INDEX_COLUMN_DATA_KEY_COLS
                                            ON INDEX_DATA_KEY_COLS.object_id = INDEX_COLUMN_DATA_KEY_COLS.object_id
                                            AND INDEX_DATA_KEY_COLS.index_id = INDEX_COLUMN_DATA_KEY_COLS.index_id
                                            INNER JOIN sys.columns COLUMN_DATA_KEY_COLS
                                            ON T.object_id = COLUMN_DATA_KEY_COLS.object_id
                                            AND INDEX_COLUMN_DATA_KEY_COLS.column_id = COLUMN_DATA_KEY_COLS.column_id
                                WHERE   i.object_id = INDEX_DATA_KEY_COLS.object_id
                                            AND i.index_id = INDEX_DATA_KEY_COLS.index_id
                                            AND INDEX_COLUMN_DATA_KEY_COLS.is_included_column = 0
                                ORDER BY INDEX_COLUMN_DATA_KEY_COLS.key_ordinal
                                FOR XML PATH('')), 1, 2, '') AS key_column_list ,
	STUFF(( SELECT  ', ' + COLUMN_DATA_INC_COLS.name
    FROM    sys.tables AS T
                INNER JOIN sys.indexes INDEX_DATA_INC_COLS
                ON T.object_id = INDEX_DATA_INC_COLS.object_id
                INNER JOIN sys.index_columns INDEX_COLUMN_DATA_INC_COLS
                ON INDEX_DATA_INC_COLS.object_id = INDEX_COLUMN_DATA_INC_COLS.object_id
                AND INDEX_DATA_INC_COLS.index_id = INDEX_COLUMN_DATA_INC_COLS.index_id
                INNER JOIN sys.columns COLUMN_DATA_INC_COLS
                ON T.object_id = COLUMN_DATA_INC_COLS.object_id
                AND INDEX_COLUMN_DATA_INC_COLS.column_id = COLUMN_DATA_INC_COLS.column_id
    WHERE   i.object_id = INDEX_DATA_INC_COLS.object_id
                AND i.index_id = INDEX_DATA_INC_COLS.index_id
                AND INDEX_COLUMN_DATA_INC_COLS.is_included_column = 1
    ORDER BY INDEX_COLUMN_DATA_INC_COLS.key_ordinal
    FOR XML PATH('')), 1, 2, '') AS include_column_list
 
 FROM sys.indexes AS i 
 ),
 indexsize  AS
 (SELECT i.index_id, i.object_id, i.[name] AS IndexName, p.data_compression_desc
    ,((SUM(s.[used_page_count]) * 8) /1024 )/1024. AS IndexSizeGB
FROM sys.dm_db_partition_stats AS s
INNER JOIN sys.indexes AS i ON s.[object_id] = i.[object_id]    AND s.[index_id] = i.[index_id]
inner join sys.partitions p on p.partition_id = s.partition_id
GROUP BY i.index_id, i.object_id, i.[name],p.data_compression_desc, i.is_disabled)
 
SELECT DB_NAME() AS 'DBName',
 OBJECT_SCHEMA_NAME(c1.id) + '.' + OBJECT_NAME(c1.id) AS 'TableName',
c1.name + CASE c1.indid WHEN 1 THEN ' (clustered index)' ELSE ' (nonclustered index)' END AS 'IndexName', 
idxs.IndexSizeGB,
c1.is_disabled,
 c1.key_column_list,
 c1.include_column_list,
c2.name + CASE c2.indid
 WHEN 1 THEN ' (clustered index)'
 ELSE ' (nonclustered index)'
 END AS 'ExactDuplicatedIndexName',
idxsd.IndexSizeGB AS Duplicated_IndexSizeGB, 
 c2.is_disabled Duplicated_Is_disabled,
 c2.key_column_list Duplicated_key_column_list,
 c2.include_column_list key_column_list_include_column_list
FROM indexcols AS c1
INNER JOIN indexcols AS c2 ON c1.id = c2.id AND c1.indid < c2.indid AND c1.cols = c2.cols AND c1.inc = c2.inc
LEFT JOIN indexsize AS idxs ON idxs.index_id = c1.indid AND idxs.object_id = c1.id
LEFT JOIN indexsize AS idxsd ON idxsd.index_id = c2.indid AND idxsd.object_id = c2.id