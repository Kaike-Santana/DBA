

DECLARE @sql NVARCHAR(MAX) = ''

-- Script para dropar todas as restrições de chave estrangeira do banco de dados
SELECT @sql = @sql + 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id)) + '.' + QUOTENAME(OBJECT_NAME(fk.parent_object_id)) + 
                  ' DROP CONSTRAINT ' + QUOTENAME(fk.name) + ';' + CHAR(13)
FROM sys.foreign_keys fk
JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id;

-- Executar o script para dropar todas as restrições de chave estrangeira do banco de dados
EXEC sp_executesql @sql

--print (@sql)


--> verifica se ainda tem fk
SELECT *
FROM sys.foreign_keys
