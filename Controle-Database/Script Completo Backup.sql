
USE master;
GO

-- Configuração de variáveis
DECLARE @DatabaseName NVARCHAR(100)  =  'THESYS_PRODUCAO'
DECLARE @BackupPath   NVARCHAR(256)  =  N'F:\BKP_THANNER\'
DECLARE @DateString   NVARCHAR(20)   =  REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(20), GETDATE(), 120), ':', ''),' ', '_'),'-','_')
DECLARE @SQL          NVARCHAR(MAX)

-- 1. Verificação de integridade do Banco de Dados
DBCC CHECKDB (@DatabaseName) WITH NO_INFOMSGS, ALL_ERRORMSGS


-- 2. Backup Full usando SQL dinâmico
SET @SQL = N'BACKUP DATABASE [' + @DatabaseName + '] 
             TO DISK = ''' + @BackupPath + 'BACKUP_' + @DatabaseName + '_FULL_' + @DateString + '.bak''
             WITH STATUS = 10 , CHECKSUM, INIT'
print @SQL
--EXEC sp_executesql @SQL


-- 3. Backup Diferencial (executado diariamente)
SET @SQL = N'BACKUP DATABASE [' + @DatabaseName + '] 
             TO DISK = ''' + @BackupPath + 'BACKUP_' + @DatabaseName + '_DIFF_' + @DateString + '.bak''
			 WITH STATUS = 10, CHECKSUM, INIT'
print @SQL

-- 4. Backup de Log (executado a cada hora)
SET @SQL = N'BACKUP LOG [' + @DatabaseName + '] 
               TO DISK = ''' + @BackupPath + 'BACKUP_' + @DatabaseName + '_LOG_' + @DateString + '.trn'' 
               WITH STATUS = 10, CHECKSUM, INIT'
PRINT @SQL

-- 5. Time Of Retencao Arquivo
DECLARE @DeleteDate DATETIME =  DATEADD(DAY, -90, GETDATE())
EXEC master.dbo.xp_delete_file 0, @BackupPath, 'bak', @DeleteDate, 1
EXEC master.dbo.xp_delete_file 0, @BackupPath, 'trn', @DeleteDate, 1
GO