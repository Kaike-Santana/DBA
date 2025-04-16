

--> Verificar Status da Fk do Banco de Dados
SELECT 
    fk.name AS ConstraintName,
    OBJECT_NAME(fk.parent_object_id) AS TableName, -- Tabela que possui a FK
    OBJECT_NAME(fk.referenced_object_id) AS ReferencedTableName, -- Tabela referenciada
    fk.is_disabled,
    fk.is_not_trusted
FROM sys.foreign_keys fk
WHERE fk.is_not_trusted = 1 --> E Que Esta Desabilitada
AND is_disabled = 0 --> S� Fk Ativa
ORDER BY TableName ASC


--> Verificar Status da Fk do Banco de Dados
DECLARE @sql NVARCHAR(MAX);
DECLARE @individualSQL NVARCHAR(MAX);
DECLARE @commands TABLE (Command NVARCHAR(MAX)); -- Tabela tempor�ria para armazenar os comandos

-- Gerar os comandos e armazen�-los na tabela tempor�ria
INSERT INTO @commands (Command)
SELECT 
    'ALTER TABLE ' + QUOTENAME(OBJECT_NAME(parent_object_id)) + 
    ' WITH CHECK CHECK CONSTRAINT ' + QUOTENAME(name) + ';'
FROM sys.foreign_keys
WHERE is_not_trusted = 1
  AND is_disabled = 0;

-- Iterar sobre cada comando e execut�-lo
WHILE EXISTS (SELECT 1 FROM @commands)
BEGIN
    -- Obter o pr�ximo comando
    SELECT TOP 1 @individualSQL = Command FROM @commands;

    -- Executar o comando
    PRINT @individualSQL; -- Opcional: visualizar o comando antes de executar
    EXEC sp_executesql @individualSQL;

    -- Remover o comando da tabela tempor�ria ap�s execu��o
    DELETE FROM @commands WHERE Command = @individualSQL;
END;