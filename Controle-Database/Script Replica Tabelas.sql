

--CREATE DATABASE Thesys_Dev_Small; --> Aqui pode ser qualquer nome


-- Script para copiar todas as tabelas exceto Notas_Fiscais_XML
DECLARE @TableName NVARCHAR(256)

DECLARE TableCursor CURSOR FOR
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE' 
AND TABLE_NAME <> 'Notas_Fiscais_XML'

OPEN TableCursor

FETCH NEXT FROM TableCursor INTO @TableName

WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC('SELECT * INTO Thesys_Dev_Small.dbo.' + @TableName + ' FROM Thesys_Dev.dbo.' + @TableName)
    FETCH NEXT FROM TableCursor INTO @TableName
END

CLOSE TableCursor
DEALLOCATE TableCursor
