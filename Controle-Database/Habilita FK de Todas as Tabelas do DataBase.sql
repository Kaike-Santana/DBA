DECLARE @tableName NVARCHAR(256);
DECLARE @constraintName NVARCHAR(256);
DECLARE @sql NVARCHAR(MAX);

DECLARE constraint_cursor CURSOR FOR
SELECT 
    QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id)) + '.' + QUOTENAME(OBJECT_NAME(fk.parent_object_id)) AS tableName,
    QUOTENAME(fk.name) AS constraintName
FROM 
    sys.foreign_keys fk
WHERE 
    fk.is_disabled = 1; -- Seleciona todas as foreign keys desabilitadas

OPEN constraint_cursor;
FETCH NEXT FROM constraint_cursor INTO @tableName, @constraintName;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Construindo e executando o comando para habilitar cada constraint
    SET @sql = 'ALTER TABLE ' + @tableName + ' CHECK CONSTRAINT ' + @constraintName + ';';
    PRINT @sql; -- Opcional: imprime o comando que está sendo executado
    EXEC sp_executesql @sql;

    FETCH NEXT FROM constraint_cursor INTO @tableName, @constraintName;
END;

CLOSE constraint_cursor;
DEALLOCATE constraint_cursor;