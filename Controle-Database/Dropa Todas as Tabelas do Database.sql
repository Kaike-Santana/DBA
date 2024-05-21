
DECLARE @sql VARCHAR(MAX) = ''

-- Gerando o script para excluir as tabelas que não são de sistema
SELECT @sql = @sql + 'DROP TABLE IF EXISTS' + QUOTENAME(name) + ';' + CHAR(13)
FROM sys.tables
WHERE is_ms_shipped = 0  -- Não são tabelas de sistema
AND name != 'sysdiagrams'

-- Exibindo o script gerado
PRINT (@sql)

-- Excluindo as tabelas que não são de sistema
 --EXEC (@sql)