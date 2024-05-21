
USE THESYS_DEV
GO

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* PROGRAMADOR: KAIKE NATAN																		*/
/* VERSAO     : DATA: 21/05/2024																*/
/* DESCRICAO  : SCRIPT PARA REPLICAR REFERENCES DE UM DATABASE PARA OUTRO						*/
/*																								*/
/* ALTERACAO																					*/
/*        2. PROGRAMADOR:                                                  DATA: __/__/____		*/        
/*           DESCRICAO  :																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: TABELA TEMPORÁRIA PARA ARMAZENAR AS CHAVES ESTRANGEIRAS DO THESYS_DEV				*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
IF OBJECT_ID('tempdb..#DevForeignKeys') IS NOT NULL DROP TABLE #DevForeignKeys;
CREATE TABLE #DevForeignKeys (
    TableName			 VARCHAR(MAX),
    ForeignKeyName		 VARCHAR(MAX),
    ColumnName			 VARCHAR(MAX),
    ReferencedTableName  VARCHAR(MAX),
    ReferencedColumnName VARCHAR(MAX)
);
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: INSERIR AS CHAVES ESTRANGEIRAS DO THESYS_DEV NA TABELA TEMPORÁRIA					*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
INSERT INTO #DevForeignKeys (TableName, ForeignKeyName, ColumnName, ReferencedTableName, ReferencedColumnName)
SELECT 
    t.name AS TableName,
    fk.name AS ForeignKeyName,
    c.name AS ColumnName,
    rt.name AS ReferencedTableName,
    rc.name AS ReferencedColumnName
FROM 
    sys.foreign_keys fk
JOIN 
    sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
JOIN 
    sys.tables t ON fk.parent_object_id = t.object_id
JOIN 
    sys.columns c ON fkc.parent_object_id = c.object_id AND fkc.parent_column_id = c.column_id
JOIN 
    sys.tables rt ON fk.referenced_object_id = rt.object_id
JOIN 
    sys.columns rc ON fkc.referenced_object_id = rc.object_id AND fkc.referenced_column_id = rc.column_id;
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: USANDO BANCO DE DADOS THESYS_HOMOLOGACAO PARA OBTER AS CHAVES ESTRANGEIRAS		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	USE THESYS_HOMOLOGACAO
	GO
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: TABELA TEMPORÁRIA PARA ARMAZENAR AS CHAVES ESTRANGEIRAS DO THESYS_HOMOLOGACAO		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
IF OBJECT_ID('tempdb..#HomologForeignKeys') IS NOT NULL DROP TABLE #HomologForeignKeys;
CREATE TABLE #HomologForeignKeys (
    TableName VARCHAR(MAX),
    ForeignKeyName VARCHAR(MAX),
    ColumnName VARCHAR(MAX),
    ReferencedTableName VARCHAR(MAX),
    ReferencedColumnName VARCHAR(MAX)
);
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: INSERIR AS CHAVES ESTRANGEIRAS DO THESYS_HOMOLOGACAO NA TABELA TEMPORÁRIA			*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
INSERT INTO #HomologForeignKeys (TableName, ForeignKeyName, ColumnName, ReferencedTableName, ReferencedColumnName)
SELECT 
    t.name AS TableName,
    fk.name AS ForeignKeyName,
    c.name AS ColumnName,
    rt.name AS ReferencedTableName,
    rc.name AS ReferencedColumnName
FROM 
    sys.foreign_keys fk
JOIN 
    sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
JOIN 
    sys.tables t ON fk.parent_object_id = t.object_id
JOIN 
    sys.columns c ON fkc.parent_object_id = c.object_id AND fkc.parent_column_id = c.column_id
JOIN 
    sys.tables rt ON fk.referenced_object_id = rt.object_id
JOIN 
    sys.columns rc ON fkc.referenced_object_id = rc.object_id AND fkc.referenced_column_id = rc.column_id;
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: COMPARA AS REFERENCES DOS DOIS BANCOS E INSERE AS FALTANTES NO THESYS_HOMOLOGACAO	*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #MissingForeignKeys
SELECT 
    d.TableName,
    d.ForeignKeyName,
    d.ColumnName,
    d.ReferencedTableName,
    d.ReferencedColumnName
INTO #MissingForeignKeys
FROM 
    #DevForeignKeys d
LEFT JOIN 
    #HomologForeignKeys h ON d.TableName = h.TableName 
    AND d.ColumnName = h.ColumnName 
    AND d.ReferencedTableName = h.ReferencedTableName 
    AND d.ReferencedColumnName = h.ReferencedColumnName
WHERE 
    h.ForeignKeyName IS NULL;
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: TABELA TEMPORÁRIA PARA ARMAZENAR OS SCRIPTS GERADOS								*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
IF OBJECT_ID('tempdb..#GeneratedScripts') IS NOT NULL DROP TABLE #GeneratedScripts;
CREATE TABLE #GeneratedScripts (
								Script VARCHAR(MAX)
							   );
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: GERA O SCRIPTS PARA CRIAR AS REFERENCES FALTANTES NO THESYS_HOMOLOGACAO			*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DECLARE @sql VARCHAR(MAX) = '';

INSERT INTO #GeneratedScripts (Script)
SELECT 
    'ALTER TABLE ' + d.TableName + ' ADD CONSTRAINT ' + d.ForeignKeyName + 
    ' FOREIGN KEY (' + d.ColumnName + ') REFERENCES ' + d.ReferencedTableName + '(' + d.ReferencedColumnName + ');'
FROM 
    #MissingForeignKeys d;

-- Selecionar os scripts gerados
SELECT * 
FROM #GeneratedScripts;