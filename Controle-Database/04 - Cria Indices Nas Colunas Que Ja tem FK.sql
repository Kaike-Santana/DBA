DECLARE @sql VARCHAR(MAX) = '';

-- Criar tabela temporária para armazenar os comandos SQL
DROP TABLE IF EXISTS #SQLCommands;
CREATE TABLE #SQLCommands (
    CommandText VARCHAR(MAX)
);

-- Obter todas as chaves estrangeiras e suas tabelas
WITH FK_Columns AS (
    SELECT 
        FK.TABLE_NAME AS FK_Table,
        CU.COLUMN_NAME AS FK_Column,
        PK.TABLE_NAME AS PK_Table,
        PT.COLUMN_NAME AS PK_Column
    FROM 
        INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS AS RC
        INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS FK 
            ON RC.CONSTRAINT_NAME = FK.CONSTRAINT_NAME
        INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS PK 
            ON RC.UNIQUE_CONSTRAINT_NAME = PK.CONSTRAINT_NAME
        INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS CU 
            ON RC.CONSTRAINT_NAME = CU.CONSTRAINT_NAME
        INNER JOIN (
            SELECT 
                i1.TABLE_NAME,
                i2.COLUMN_NAME
            FROM 
                INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS i1
                INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS i2 
                    ON i1.CONSTRAINT_NAME = i2.CONSTRAINT_NAME
            WHERE i1.CONSTRAINT_TYPE = 'PRIMARY KEY'
        ) AS PT 
            ON PT.TABLE_NAME = PK.TABLE_NAME AND PT.COLUMN_NAME = CU.COLUMN_NAME
    WHERE FK.CONSTRAINT_TYPE = 'FOREIGN KEY'
)

-- Encontrar tabelas que têm colunas correspondentes para criar FKs e índices, se não existirem
INSERT INTO #SQLCommands (CommandText)
SELECT 
    'IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS RC JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE KCU ON RC.CONSTRAINT_NAME = KCU.CONSTRAINT_NAME WHERE KCU.TABLE_NAME = ''' + FK_Table + ''' AND KCU.COLUMN_NAME = ''' + FK_Column + ''') BEGIN ALTER TABLE ' + QUOTENAME(FK_Table) + ' ADD CONSTRAINT FK_' + FK_Table + '_' + FK_Column + '_' + PK_Table + ' FOREIGN KEY (' + QUOTENAME(FK_Column) + ') REFERENCES ' + QUOTENAME(PK_Table) + '(' + QUOTENAME(PK_Column) + '); END; IF NOT EXISTS (SELECT 1 FROM sys.index_columns ic JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id WHERE ic.object_id = OBJECT_ID(''' + FK_Table + ''') AND c.name = ''' + FK_Column + ''') BEGIN CREATE NONCLUSTERED INDEX IDX_' + FK_Table + '_' + FK_Column + ' ON ' + QUOTENAME(FK_Table) + ' (' + QUOTENAME(FK_Column) + '); END;'
FROM 
    FK_Columns
ORDER BY FK_Table ASC;

-- Selecionar e exibir os comandos armazenados
SELECT CommandText FROM #SQLCommands;

-- Opcional: Executar os comandos SQL armazenados
-- DECLARE @command NVARCHAR(MAX);
-- DECLARE @cursor CURSOR FOR SELECT CommandText FROM #SQLCommands;
-- OPEN @cursor;
-- FETCH NEXT FROM @cursor INTO @command;
-- WHILE @@FETCH_STATUS = 0
-- BEGIN
--     EXEC sp_executesql @command;
--     FETCH NEXT FROM @cursor INTO @command;
-- END;
-- CLOSE @cursor;
-- DEALLOCATE @cursor;