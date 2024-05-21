
USE THESYS_DEV
GO

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* PROGRAMADOR: KAIKE NATAN																		*/
/* VERSAO     : DATA: 21/05/2024																*/
/* DESCRICAO  : SCRIPT PARA REPLICAR OBJETOS DE UM DATABASE PARA OUTRO							*/
/*																								*/
/* ALTERACAO																					*/
/*        2. PROGRAMADOR:                                                  DATA: __/__/____		*/        
/*           DESCRICAO  :																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
--CREATE PROCEDURE [dbo].[PRC_COMPLETA_OBJETOS_FALTANTES] AS
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: DATABASES A SER COMPARADOS E VARIAVÉIS USADO NA CONSULTA							*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DECLARE @Database1 VARCHAR(128) = 'THESYS_DEV'
DECLARE @Database2 VARCHAR(128) = 'THESYS_HOMOLOGACAO'
,		@SQL_1	   VARCHAR(MAX)
,		@SQL_2	   VARCHAR(MAX)
,		@SQL_3	   VARCHAR(MAX)
,		@SQL_4	   VARCHAR(MAX)
,		@CrLf	   VARCHAR(2)	= CHAR(13) + CHAR(10)

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: VERIFICA TABELAS AUSENTES E CRIA													*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
SET @SQL_1 = (
    SELECT 
        STRING_AGG('CREATE TABLE ' + QUOTENAME(@Database2) + '.' + QUOTENAME(s.name) + '.' + QUOTENAME(t.name) + ' AS ' + 
        'SELECT * FROM ' + QUOTENAME(@Database1) + '.' + QUOTENAME(s.name) + '.' + QUOTENAME(t.name) + ';', @CrLf)
    FROM sys.tables t
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE t.name NOT LIKE '\_%' ESCAPE '\'
    AND NOT EXISTS (
        SELECT 1 
        FROM sys.tables t2 
        WHERE t2.name = t.name AND t2.schema_id = t.schema_id AND OBJECT_ID(QUOTENAME(@Database2) + '.' + QUOTENAME(s.name) + '.' + QUOTENAME(t.name), 'U') IS NOT NULL
    )
    AND OBJECT_ID(QUOTENAME(@Database1) + '.' + QUOTENAME(s.name) + '.' + QUOTENAME(t.name), 'U') IS NOT NULL
)

PRINT (
	   @SQL_1
	  )
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: VERIFICA VIEWS AUSENTES AUSENTES E CRIA                                           */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
SET @SQL_2 = (
    SELECT 
        STRING_AGG('CREATE VIEW ' + QUOTENAME(@Database2) + '.' + QUOTENAME(s.name) + '.' + QUOTENAME(v.name) + ' AS ' + 
        OBJECT_DEFINITION(OBJECT_ID(QUOTENAME(@Database1) + '.' + QUOTENAME(s.name) + '.' + QUOTENAME(v.name), 'V')) + ';', @CrLf)
    FROM sys.views v
    INNER JOIN sys.schemas s ON v.schema_id = s.schema_id
    WHERE NOT EXISTS (
        SELECT 1 
        FROM sys.views v2 
        WHERE v2.name = v.name AND v2.schema_id = v.schema_id AND OBJECT_ID(QUOTENAME(@Database2) + '.' + QUOTENAME(s.name) + '.' + QUOTENAME(v.name), 'V') IS NOT NULL
    )
    AND OBJECT_ID(QUOTENAME(@Database1) + '.' + QUOTENAME(s.name) + '.' + QUOTENAME(v.name), 'V') IS NOT NULL
)

PRINT (
	   @SQL_2
	  )
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: VERIFICA FUNÇÕES AUSENTES AUSENTES E CRIA                                         */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
SET @SQL_3 = (
    SELECT 
        STRING_AGG(OBJECT_DEFINITION(OBJECT_ID(QUOTENAME(@Database1) + '.' + QUOTENAME(s.name) + '.' + QUOTENAME(f.name), 'FN')) + ';', @CrLf)
    FROM sys.objects f
    INNER JOIN sys.schemas s ON f.schema_id = s.schema_id
    WHERE f.type = 'FN'
    AND NOT EXISTS (
        SELECT 1 
        FROM sys.objects f2 
        WHERE f2.name = f.name AND f2.schema_id = f.schema_id AND OBJECT_ID(QUOTENAME(@Database2) + '.' + QUOTENAME(s.name) + '.' + QUOTENAME(f.name), 'FN') IS NOT NULL
    )
)

PRINT (
	   @SQL_3
	  )
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: VERIFICA PROCEDURES AUSENTES E CRIA                                               */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
SET @SQL_4 =  (
    SELECT 
        STRING_AGG(OBJECT_DEFINITION(OBJECT_ID(QUOTENAME(@Database1) + '.' + QUOTENAME(s.name) + '.' + QUOTENAME(p.name), 'P')) + ';', @CrLf)
    FROM sys.procedures p
    INNER JOIN sys.schemas s ON p.schema_id = s.schema_id
    WHERE NOT EXISTS (
        SELECT 1 
        FROM sys.procedures p2 
        WHERE p2.name = p.name AND p2.schema_id = p.schema_id AND OBJECT_ID(QUOTENAME(@Database2) + '.' + QUOTENAME(s.name) + '.' + QUOTENAME(p.name), 'P') IS NOT NULL
    )
)

PRINT (
	   @SQL_4
	  )