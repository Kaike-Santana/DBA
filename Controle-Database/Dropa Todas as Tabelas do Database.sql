
DECLARE @sql VARCHAR(MAX) = ''

-- Gerando o script para excluir as tabelas que n�o s�o de sistema
SELECT @sql = @sql + 'DROP TABLE IF EXISTS' + QUOTENAME(name) + ';' + CHAR(13)
FROM sys.tables
WHERE is_ms_shipped = 0  -- N�o s�o tabelas de sistema
AND name != 'sysdiagrams'

-- Exibindo o script gerado
PRINT (@sql)

-- Excluindo as tabelas que n�o s�o de sistema
 --EXEC (@sql)