
USE THESYS_DEV
GO

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* PROGRAMADOR: KAIKE NATAN																		*/
/* VERSAO     : DATA: 21/05/2024																*/
/* DESCRICAO  : SCRIPT PARA REPLICAR COLUNAS DAS TABELAS  DE UM DATABASE PARA OUTRO				*/
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
,			@homDB		VARCHAR(MAX) = 'thesys_homologacao'
,			@tableName	VARCHAR(MAX)
,			@schemaName VARCHAR(MAX)
,			@sql		VARCHAR(MAX) = ''
,			@sqlPart	VARCHAR(MAX) = ''
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: TABELA TEMPORÁRIA PARA ARMAZENAR OS SCRIPTS GERADOS								*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #ScriptParts
CREATE TABLE #ScriptParts (
						   ScriptPart VARCHAR(MAX)
						  );
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: LISTA DE TABELAS E ESQUEMAS NO BANCO DO DEV, EXCLUINDO AS QUE COMEÇAM COM '_'		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #DevTables;
SELECT 
    t.name AS table_name,
    s.name AS schema_name
INTO #DevTables
FROM [thesys_dev].sys.tables t
JOIN 
    [thesys_dev].sys.schemas s ON t.schema_id = s.schema_id
WHERE 
    t.type = 'U' -- Somente tabelas de usuário
    AND t.name NOT LIKE '\_%' ESCAPE '\' 
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
    DROP TABLE IF EXISTS #DevColumns;
    SELECT 
        c.name AS column_name,
        t.name AS data_type,
        c.max_length,
        c.precision,
        c.scale,
        c.is_nullable,
        c.is_identity,
        s.name AS schema_name,
        o.name AS table_name
    INTO #DevColumns
    FROM 
        [thesys_dev].sys.columns c
    JOIN 
        [thesys_dev].sys.types t ON c.user_type_id = t.user_type_id
    JOIN 
        [thesys_dev].sys.tables o ON c.object_id = o.object_id
    JOIN 
        [thesys_dev].sys.schemas s ON o.schema_id = s.schema_id
    WHERE 
        o.name = @tableName
        AND s.name = @schemaName;
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: OBTEM DETALHES DAS COLUNAS DO BANCO DE HOMOLOGAÇÃO PARA A TABELA ATUAL			*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
    DROP TABLE IF EXISTS #HomColumns;
    SELECT 
        c.name AS column_name,
        t.name AS data_type,
        c.max_length,
        c.precision,
        c.scale,
        c.is_nullable,
        c.is_identity,
        s.name AS schema_name,
        o.name AS table_name
    INTO #HomColumns
    FROM 
        [thesys_homologacao].sys.columns c
    JOIN 
        [thesys_homologacao].sys.types t ON c.user_type_id = t.user_type_id
    JOIN 
        [thesys_homologacao].sys.tables o ON c.object_id = o.object_id
    JOIN 
        [thesys_homologacao].sys.schemas s ON o.schema_id = s.schema_id
    WHERE 
        o.name = @tableName
        AND s.name = @schemaName;
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: IDENTIFICAR COLUNAS FALTANTES EM HOMOLOGAÇÃO										*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
    DROP TABLE IF EXISTS #MissingColumns;
    SELECT 
        d.column_name,
        d.data_type,
        d.max_length,
        d.precision,
        d.scale,
        d.is_nullable,
        d.is_identity,
        d.schema_name,
        d.table_name
    INTO #MissingColumns
    FROM #DevColumns d
    LEFT JOIN #HomColumns h 
        ON d.column_name = h.column_name
        AND d.table_name = h.table_name
        AND d.schema_name = h.schema_name
    WHERE h.column_name IS NULL;
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: GERA SCRIPTS DE ADIÇÃO DE COLUNAS E ARMAZENAR NA TABELA TEMPORÁRIA				*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
    INSERT INTO #ScriptParts (ScriptPart)
    SELECT 
        'ALTER TABLE ' + @homDB + '.' + d.schema_name + '.' + d.table_name +
        ' ADD ' + d.column_name + ' ' + d.data_type +
        CASE 
            WHEN d.data_type IN ('varchar', 'char', 'nvarchar', 'nchar', 'binary', 'varbinary') THEN '(' + CAST(d.max_length AS NVARCHAR(5)) + ')'
            WHEN d.data_type IN ('decimal', 'numeric') THEN '(' + CAST(d.precision AS NVARCHAR(5)) + ',' + CAST(d.scale AS NVARCHAR(5)) + ')'
            ELSE ''
        END +
        CASE 
            WHEN d.is_nullable = 1 THEN ' NULL'
            ELSE ' NOT NULL'
        END +
        CASE 
            WHEN d.is_identity = 1 THEN ' IDENTITY(1,1)'
            ELSE ''
        END + ';' + CHAR(13) + CHAR(10)
    FROM #MissingColumns d;

    FETCH NEXT FROM table_cursor INTO @tableName, @schemaName;
END

CLOSE table_cursor;
DEALLOCATE table_cursor;
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: SELECIONAR E EXIBIR OS SCRIPTS ARMAZENADOS NA TABELA TEMPORÁRIA					*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
SELECT * 
FROM #ScriptParts

-- Opcional: Executar os scripts de adição de colunas
-- DECLARE @dynamicSql NVARCHAR(MAX);
-- SELECT @dynamicSql = STRING_AGG(ScriptPart, '') FROM #ScriptParts;
-- EXEC sp_executesql @dynamicSql;