

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: CONSULTA MEM�RIA DO SERVIDOR E MEM�RIA "VAZIA" DE FRAGMENTA��O DE DISCO			*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
SELECT 
	COUNT(1) * 8 / 1024 AS MBUSED
,	SUM (CONVERT(BIGINT,[FREE_SPACE_IN_BYTES])) / (1024 * 1024) AS MBEMPTY
FROM SYS.dm_os_buffer_descriptors;
GO
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: CONSULTA MEM�RIA "VAZIA" POR BANCO  DE FRAGMENTA��O DE DISCO						*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
SELECT 
	CASE WHEN [database_id] = 32767
	THEN N'RESOURCE DATABASE' 
	ELSE DB_NAME ([database_id]) END AS DATABASENAME,
	COUNT(1) * 8 / 1024 AS MBUSED,
	SUM(CONVERT(BIGINT,[FREE_SPACE_IN_BYTES])) / (1024 * 1024) AS MBEMPTY
FROM SYS.DM_OS_BUFFER_DESCRIPTORS
GROUP BY 
[database_id]
GO
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: CONSULTA MEM�RIA MAXIMA DO SERVIDOR DISPONIVEL									*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
SELECT c.value, c.value_in_use
FROM sys.configurations c WHERE c.[name] = 'max server memory (MB)'