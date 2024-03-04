

-- Defina os servidores vinculados
DECLARE @linkedServerOrigem NVARCHAR(100) = 'FACAACORDO'
DECLARE @linkedServerDestino NVARCHAR(100) = 'Polaris'

-- Variáveis para armazenar os nomes das tabelas
DECLARE @tableName NVARCHAR(100)
DECLARE @sql NVARCHAR(MAX)

-- Criar uma tabela temporária para armazenar os nomes das tabelas
DROP TABLE IF EXISTS TempTables
CREATE TABLE TempTables (TableName NVARCHAR(100))

-- Consultar as tabelas do servidor vinculado de origem
SET @sql = '
    INSERT INTO TempTables
    SELECT TABLE_NAME
    FROM OPENQUERY([' + @linkedServerOrigem + '], ''SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = ''''BASE TABLE'''';'')'

-- Executar o SQL dinâmico
EXEC sp_executesql @sql

-- Iterar sobre as tabelas e realizar o SELECT * INTO no servidor de destino
DECLARE tableCursor CURSOR FOR
SELECT TableName FROM TempTables

OPEN tableCursor
FETCH NEXT FROM tableCursor INTO @tableName

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Montar o SQL dinâmico para realizar o SELECT * INTO
    SET @sql = '
        SELECT *
        INTO [' + @linkedServerDestino + '].[Planning].[dbo].' + @tableName + '
        FROM [' + @linkedServerOrigem + '].[facaacordonew].[facaacordonew].' + @tableName

    -- Executar o SQL dinâmico
    --EXEC sp_executesql @sql
	print @sql

    FETCH NEXT FROM tableCursor INTO @tableName
END

-- Fechar e desalocar o cursor
CLOSE tableCursor
DEALLOCATE tableCursor

-- Limpar a tabela temporária
DROP TABLE TempTables
