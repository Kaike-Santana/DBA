
DECLARE @sql NVARCHAR(MAX) = ''

-- Gerar scripts para truncar todas as tabelas
SELECT @sql = @sql + 'TRUNCATE TABLE ' + QUOTENAME(schema_name(schema_id)) + '.' + QUOTENAME(name) + ';' + CHAR(13)
FROM sys.tables
WHERE is_ms_shipped = 0; -- Exclui tabelas do sistema

-- Executar os scripts para truncar todas as tabelas
--EXEC sp_executesql @sql

print (@sql)
