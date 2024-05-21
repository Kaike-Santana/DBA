
--> Verifica as Fk Da Tabela
SELECT 
    FK.name AS 'Nome da Restrição de Chave Estrangeira',
    SCHEMA_NAME(T.schema_id) AS 'Esquema da Tabela Referenciadora',
    T.name AS 'Tabela Referenciadora',
    SCHEMA_NAME(R.schema_id) AS 'Esquema da Tabela Referenciada',
    R.name AS 'Tabela Referenciada',
    CR.name AS 'Coluna Referenciadora',
    CD.name AS 'Coluna Referenciada'
FROM 
    sys.foreign_keys AS FK
INNER JOIN 
    sys.tables AS T ON FK.parent_object_id = T.object_id
INNER JOIN 
    sys.tables AS R ON FK.referenced_object_id = R.object_id
INNER JOIN 
    sys.foreign_key_columns AS FKC ON FK.object_id = FKC.constraint_object_id
INNER JOIN 
    sys.columns AS CR ON FKC.parent_column_id = CR.column_id AND FKC.parent_object_id = CR.object_id
INNER JOIN 
    sys.columns AS CD ON FKC.referenced_column_id = CD.column_id AND FKC.referenced_object_id = CD.object_id
WHERE 
    R.name = 'clifor';

Go

--> Script Para Geração Das FK Novamente.
DECLARE @tableName VARCHAR(MAX)
SET @tableName = 'clifor'

DECLARE @sql VARCHAR(MAX)
SET @sql = ''

SELECT @sql = @sql + 'ALTER TABLE ' + QUOTENAME(SCHEMA_NAME(T.schema_id)) + '.' + QUOTENAME(T.name) + 
                ' ADD CONSTRAINT ' + QUOTENAME(FK.name) + 
                ' FOREIGN KEY (' + QUOTENAME(CR.name) + ')' +
                ' REFERENCES ' + QUOTENAME(SCHEMA_NAME(R.schema_id)) + '.' + QUOTENAME(R.name) +
                ' (' + QUOTENAME(CD.name) + ');' + CHAR(13)
FROM 
    sys.foreign_keys AS FK
INNER JOIN 
    sys.tables AS T ON FK.parent_object_id = T.object_id
INNER JOIN 
    sys.tables AS R ON FK.referenced_object_id = R.object_id
INNER JOIN 
    sys.foreign_key_columns AS FKC ON FK.object_id = FKC.constraint_object_id
INNER JOIN 
    sys.columns AS CR ON FKC.parent_column_id = CR.column_id AND FKC.parent_object_id = CR.object_id
INNER JOIN 
    sys.columns AS CD ON FKC.referenced_column_id = CD.column_id AND FKC.referenced_object_id = CD.object_id
WHERE 
    R.name = @tableName

PRINT @sql -- Exibe o script

Go

--> Script Para Dropar as FK Da Tabela

-- Passo 1: Armazenar as Definições das FKs
DROP TABLE IF EXISTS #DropFKStatements
SELECT 'ALTER TABLE ' + OBJECT_NAME(parent_object_id) + 
       ' DROP CONSTRAINT ' + name + ';' AS DropStatement
INTO #DropFKStatements
FROM sys.foreign_keys
WHERE referenced_object_id = OBJECT_ID('clifor');