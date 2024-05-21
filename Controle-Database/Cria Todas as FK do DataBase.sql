DECLARE @sql NVARCHAR(MAX) = ''

-- Script para recriar todas as restrições de chave estrangeira do banco de dados
SELECT @sql = @sql + 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id)) + '.' + QUOTENAME(OBJECT_NAME(fk.parent_object_id)) + 
                  ' ADD CONSTRAINT ' + QUOTENAME(fk.name) + ' FOREIGN KEY (' + STUFF((SELECT ', ' + QUOTENAME(fkc.name)
                                                                                      FROM sys.columns AS fkc
                                                                                      WHERE OBJECT_NAME(fkc.object_id) = OBJECT_NAME(fk.parent_object_id)
                                                                                      AND fkc.column_id IN (SELECT constraint_column_id
                                                                                                            FROM sys.foreign_key_columns
                                                                                                            WHERE constraint_object_id = fk.object_id)
                                                                                      FOR XML PATH('')), 1, 2, '') +
                  ') REFERENCES ' + QUOTENAME(OBJECT_SCHEMA_NAME(fk.referenced_object_id)) + '.' + QUOTENAME(OBJECT_NAME(fk.referenced_object_id)) +
                  ' (' + STUFF((SELECT ', ' + QUOTENAME(rc.name)
                                FROM sys.columns AS rc
                                WHERE OBJECT_NAME(rc.object_id) = OBJECT_NAME(fk.referenced_object_id)
                                AND rc.column_id IN (SELECT referenced_column_id
                                                      FROM sys.foreign_key_columns
                                                      WHERE constraint_object_id = fk.object_id)
                                FOR XML PATH('')), 1, 2, '') +
                  ');' + CHAR(13)
FROM sys.foreign_keys fk;

-- Exibir o script gerado para verificar antes de executar
PRINT (@sql)
-- Executar o script para recriar todas as restrições de chave estrangeira do banco de dados
-- EXEC sp_executesql @sql
