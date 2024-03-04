/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* PROGRAMADOR: KAIKE NATAN									                                    */
/* VERSAO     : DATA: 21/02/2022																*/
/* DESCRICAO  : FAZ O LEVANTAMENTO DAS MAIORES TABELA DOS DATABASES DESSA INSTANCIA		  	    */
/*																								*/
/*	ALTERACAO                                                                                   */
/*        1. PROGRAMADOR: 													 DATA: __/__/____	*/		
/*           DESCRICAO  :  																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	CRIA TABELA TEMPORÁRIA PRO INSERT DO SELECT ABAIXO							    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
IF (OBJECT_ID('tempdb..#tamanho_tabelas') IS NOT NULL) DROP TABLE #tamanho_tabelas 
GO
CREATE TABLE #tamanho_tabelas (
								[Banco]				NVARCHAR(256),
								[schema]			NVARCHAR(256),
								[tabela]			NVARCHAR(256),
								[Qtd_Linhas]		BIGINT,
								[Mb_Espaco]			DECIMAL(36, 2),
								[Mb_Usado]			DECIMAL(36, 2),
								[Mb_Livre]			DECIMAL(36, 2)
							  )
GO
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	SELECIONA AS MAIORES TABELA DOS DATABASE DESSA INSTANCIA						*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
INSERT INTO #tamanho_tabelas
EXEC sys.[sp_MSforeachdb] '
IF (''?'' NOT IN (''model'', ''master'', ''tempdb'', ''msdb''))
BEGIN
SELECT 
''?'' AS [database],
s.[name] AS [schema],
t.[name] AS [table_name],
p.[rows] AS [row_count],
CAST(ROUND(((SUM(a.total_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS [size_mb],
CAST(ROUND(((SUM(a.used_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS [used_mb], 
CAST(ROUND(((SUM(a.total_pages) - SUM(a.used_pages)) * 8) / 1024.00, 2) AS NUMERIC(36, 2)) AS [unused_mb]
FROM 
[?].sys.tables t
JOIN [?].sys.indexes i ON t.[object_id] = i.[object_id]
JOIN [?].sys.partitions p ON i.[object_id] = p.[object_id] AND i.index_id = p.index_id
JOIN [?].sys.allocation_units a ON p.[partition_id] = a.container_id
LEFT JOIN [?].sys.schemas s ON t.[schema_id] = s.[schema_id]
WHERE 
t.is_ms_shipped = 0
AND i.[object_id] > 255 
GROUP BY
t.[name], 
s.[name], 
p.[rows]
END'
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	SELECT FINAL DA CONSULTA														*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
SELECT  * 
FROM #tamanho_tabelas
ORDER BY Qtd_Linhas DESC

