
USE THESYS_DEV
GO

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* PROGRAMADOR: KAIKE NATAN																		*/
/* VERSAO     : DATA: 21/05/2024																*/
/* DESCRICAO  : SCRIPT PARA REPLICAR INDICES DE UM DATABASE PARA OUTRO							*/
/*																								*/
/* ALTERACAO																					*/
/*        2. PROGRAMADOR:                                                  DATA: __/__/____		*/        
/*           DESCRICAO  :																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: DATABASES A SER COMPARADOS E VARIAVÉIS USADO NA CONSULTA							*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
SET NOCOUNT ON;
DECLARE @devDB		VARCHAR(MAX) = 'thesys_dev'
,		@homDB		VARCHAR(MAX) = 'thesys_homologacao'
,		@tableName	VARCHAR(MAX)
,		@schemaName VARCHAR(MAX)
,		@sql		VARCHAR(MAX) = ''
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: TABELA TEMPORÁRIA PARA ARMAZENAR OS SCRIPTS GERADOS								*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #ScriptParts;
CREATE TABLE #ScriptParts (
							ScriptPart NVARCHAR(MAX)
						  );
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: LISTA DE TABELAS E ESQUEMAS NO BANCO DO DEV, EXCLUINDO AS QUE COMEÇAM COM '_'		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #DevTables;
SELECT 
  t.name AS table_name,
  s.name AS schema_name
INTO #DevTables
FROM 
    [thesys_dev].sys.tables t
JOIN 
    [thesys_dev].sys.schemas s ON t.schema_id = s.schema_id
WHERE 
    t.type = 'U' -- Somente tabelas de usuário
    AND t.name NOT LIKE '\_%' ESCAPE '\'; -- Excluir tabelas que começam com '_'
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: LOOP PARA ITERAR SOBRE TODAS AS TABELAS											*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DECLARE table_cursor CURSOR FOR 
SELECT table_name, schema_name FROM #DevTables;

OPEN table_cursor;
FETCH NEXT FROM table_cursor INTO @tableName, @schemaName;

WHILE @@FETCH_STATUS = 0
BEGIN
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: OBTEM DETALHES DAS COLUNAS DO BANCO DE DESENVOLVIMENTO PARA A TABELA ATUAL		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
    DROP TABLE IF EXISTS #DevIndexes;
    SELECT 
        i.name AS index_name,
        i.type_desc AS index_description,
        STUFF((
            SELECT ', ' + c.name
            FROM [thesys_dev].sys.index_columns ic
            JOIN [thesys_dev].sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
            WHERE ic.object_id = i.object_id AND ic.index_id = i.index_id AND ic.is_included_column = 0
            ORDER BY ic.key_ordinal
            FOR XML PATH(''), TYPE).value('.', 'VARCHAR(MAX)'), 1, 2, '') AS index_keys,
        STUFF((
            SELECT ', ' + c.name
            FROM [thesys_dev].sys.index_columns ic
            JOIN [thesys_dev].sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
            WHERE ic.object_id = i.object_id AND ic.index_id = i.index_id AND ic.is_included_column = 1
            ORDER BY ic.index_column_id
            FOR XML PATH(''), TYPE).value('.', 'VARCHAR(MAX)'), 1, 2, '') AS included_columns
    INTO #DevIndexes
    FROM 
        [thesys_dev].sys.indexes i
    JOIN 
        [thesys_dev].sys.tables t ON i.object_id = t.object_id
    JOIN 
        [thesys_dev].sys.schemas s ON t.schema_id = s.schema_id
    WHERE 
        t.name = @tableName
        AND s.name = @schemaName
        AND i.type IN (1, 2) -- 1 = CLUSTERED, 2 = NONCLUSTERED
    ORDER BY i.name;
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: OBTEM DETALHES DAS COLUNAS DO BANCO DE HOMOLOGAÇÃO PARA A TABELA ATUAL			*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
    DROP TABLE IF EXISTS #HomIndexes;
    SELECT 
        i.name AS index_name,
        i.type_desc AS index_description,
        STUFF((
            SELECT ', ' + c.name
            FROM [thesys_homologacao].sys.index_columns ic
            JOIN [thesys_homologacao].sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
            WHERE ic.object_id = i.object_id AND ic.index_id = i.index_id AND ic.is_included_column = 0
            ORDER BY ic.key_ordinal
            FOR XML PATH(''), TYPE).value('.', 'VARCHAR(MAX)'), 1, 2, '') AS index_keys,
        STUFF((
            SELECT ', ' + c.name
            FROM [thesys_homologacao].sys.index_columns ic
            JOIN [thesys_homologacao].sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
            WHERE ic.object_id = i.object_id AND ic.index_id = i.index_id AND ic.is_included_column = 1
            ORDER BY ic.index_column_id
            FOR XML PATH(''), TYPE).value('.', 'VARCHAR(MAX)'), 1, 2, '') AS included_columns
    INTO #HomIndexes
    FROM 
        [thesys_homologacao].sys.indexes i
    JOIN 
        [thesys_homologacao].sys.tables t ON i.object_id = t.object_id
    JOIN 
        [thesys_homologacao].sys.schemas s ON t.schema_id = s.schema_id
    WHERE 
        t.name = @tableName
        AND s.name = @schemaName
        AND i.type IN (1, 2) -- 1 = CLUSTERED, 2 = NONCLUSTERED
    ORDER BY i.name;
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: IDENTIFICAR ÍNDICES FALTANTES EM HOMOLOGAÇÃO										*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #MissingIndexes;
SELECT 
        d.index_name,
        d.index_description,
        d.index_keys,
        d.included_columns
    INTO #MissingIndexes
    FROM #DevIndexes d
    LEFT JOIN (
        SELECT 
            index_keys,
            included_columns
        FROM #HomIndexes
        GROUP BY 
            index_keys,
            included_columns
    ) h
    ON d.index_keys = h.index_keys
    AND ISNULL(d.included_columns, '') = ISNULL(h.included_columns, '')
    WHERE h.index_keys IS NULL;
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: GERAR SCRIPTS DE CRIAÇÃO DE ÍNDICES E ARMAZENAR NA TABELA TEMPORÁRIA				*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
    INSERT INTO #ScriptParts (ScriptPart)
    SELECT 
        'CREATE ' + d.index_description + ' INDEX ' + d.index_name +
        ' ON ' + @homDB + '.' + @schemaName + '.' + @tableName + ' (' + d.index_keys + ')' + 
        CASE 
            WHEN d.included_columns IS NOT NULL AND d.included_columns <> '' THEN 
                ' INCLUDE (' + d.included_columns + ');' 
            ELSE 
                ';' 
        END + CHAR(13) + CHAR(10)
    FROM #MissingIndexes d;

    FETCH NEXT FROM table_cursor INTO @tableName, @schemaName;
END

CLOSE table_cursor;
DEALLOCATE table_cursor;
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: SELECIONAR E EXIBIR OS SCRIPTS ARMAZENADOS NA TABELA TEMPORÁRIA					*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
SELECT *
FROM #ScriptParts;

-- Opcional: Executar os scripts de criação de índices
-- DECLARE @dynamicSql NVARCHAR(MAX);
-- SELECT @dynamicSql = STRING_AGG(ScriptPart, '') FROM #ScriptParts;
-- EXEC sp_executesql @dynamicSql;