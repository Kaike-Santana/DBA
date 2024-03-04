
USE tempdb;

-- Redimensionar os arquivos de log
DECLARE @logFiles TABLE (FileName NVARCHAR(100));
INSERT INTO @logFiles (FileName) VALUES
    (N'tempdev'),
    (N'templog'),
    (N'temp2'),
    (N'temp3'),
    (N'temp4'),
    (N'temp5'),
    (N'temp6'),
    (N'temp7'),
    (N'temp8');

DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql = @sql + '
DBCC SHRINKFILE (' + QUOTENAME(FileName, '''') + ', 1);
'
FROM @logFiles;

-- Execute o script dinâmico
EXEC sp_executesql @sql;
