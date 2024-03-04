-- Cria��o da tabela de log, se ainda n�o existir
IF NOT EXISTS (
				SELECT 1 
				FROM INFORMATION_SCHEMA.TABLES 
				WHERE TABLE_NAME = 'BackupLog'
			   )
BEGIN
    CREATE TABLE BackupLog (
        LogID INT IDENTITY(1,1) PRIMARY KEY,
        ServerName NVARCHAR(50),
        DatabaseName NVARCHAR(100),
        BackupType NVARCHAR(10),
        BackupFileName NVARCHAR(200),
        StartTime DATETIME,
        EndTime DATETIME,
        IsSuccess BIT,
        ErrorMessage NVARCHAR(MAX)
    )
END

-- Programador: Kaike Natam
-- Data: 2023-08-06
-- Descri��o: Respons�vel por Fazer Backup Din�mico Dos Bancos de Dados do Wolverine
-- Version: 1.0

-- Vari�veis de Controle
DECLARE @CurrentDate AS DATE = GETDATE()
DECLARE @BackupType AS NVARCHAR(10)
DECLARE @BackupPath AS NVARCHAR(200) = '\\noturno\Wolverine_BKP\'
DECLARE @BackupFileName AS NVARCHAR(200)
DECLARE @DatabaseName AS NVARCHAR(100)
DECLARE @ServerName AS NVARCHAR(50) = @@SERVERNAME

-- Definir o tipo de backup com base no dia da semana
IF DATEPART(WEEKDAY, @CurrentDate) = 7  -- 7 � s�bado
    SET @BackupType = 'Full'
ELSE
    SET @BackupType = 'Diff'

-- Faz o backup de todos os bancos, Usando um Cursor
DECLARE db_cursor CURSOR FOR  
SELECT name
FROM master.dbo.sysdatabases  
WHERE dbid in (6,11) -- Excluir bancos de sistema, se necess�rio

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @DatabaseName  

WHILE @@FETCH_STATUS = 0  
BEGIN  
    -- Deixa o Nome do Backup como: NomeDoBanco + Data (DDMMYYYY) + tipo do bkp
    SET @BackupFileName = @BackupPath + 
        @DatabaseName + 
        '_' + 
        REPLACE(CONVERT(NVARCHAR(10), @CurrentDate, 103), '/', '') + 
        '_' + 
        @BackupType + 
        '.bak'

    -- Grava o in�cio do backup no log
    INSERT INTO BackupLog (ServerName, DatabaseName, BackupType, BackupFileName, StartTime, IsSuccess)
    VALUES (@ServerName, @DatabaseName, @BackupType, @BackupFileName, GETDATE(), NULL)

    BEGIN TRY
        -- Executa o backup para cada banco
        IF @BackupType = 'Full'
            BACKUP DATABASE @DatabaseName TO DISK = @BackupFileName WITH INIT
        ELSE
            BACKUP DATABASE @DatabaseName TO DISK = @BackupFileName WITH DIFFERENTIAL

        -- Grava o sucesso do backup no log
        UPDATE BackupLog SET EndTime = GETDATE(), IsSuccess = 1 WHERE BackupFileName = @BackupFileName
    END TRY
    BEGIN CATCH
        -- Grava o erro do backup no log
        UPDATE BackupLog SET EndTime = GETDATE(), IsSuccess = 0, ErrorMessage = ERROR_MESSAGE() WHERE BackupFileName = @BackupFileName
    END CATCH

    FETCH NEXT FROM db_cursor INTO @DatabaseName  
END  

CLOSE db_cursor  
DEALLOCATE db_cursor