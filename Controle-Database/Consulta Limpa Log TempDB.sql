

USE TEMPDB
GO

--> Para Saber o espaço ocupado do TEMPDB/TEMPLOG, executar comando abaixo:
sp_helpdb tempdb

--> Checar o espaço que pode ser liberado:
SELECT name ,size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS int)/128.0 AS AvailableSpaceInMB
FROM sys.database_files;

--> Executar o comando abaixo para identificar as transações que estão utilizando o TEMPDB:
DBCC OPENTRAN
GO

--DBCC INPUTBUFFER(81);

SP_HELPDB TEMPDB
GO

CHECKPOINT; 
GO
-- Clean all buffers and caches
DBCC DROPCLEANBUFFERS; 
DBCC FREEPROCCACHE;
DBCC FREESYSTEMCACHE('ALL');
DBCC FREESESSIONCACHE;
GO

USE [tempdb]
GO
DBCC SHRINKFILE (N'tempdev' , 1, TRUNCATEONLY)
GO
DBCC SHRINKFILE (N'templog' , 1, TRUNCATEONLY)
GO
DBCC SHRINKFILE (N'temp2' , 1, TRUNCATEONLY)
GO
DBCC SHRINKFILE (N'temp3' , 1, TRUNCATEONLY)
GO
DBCC SHRINKFILE (N'temp4' , 1, TRUNCATEONLY)
GO
DBCC SHRINKFILE (N'temp5' , 1, TRUNCATEONLY)
GO
DBCC SHRINKFILE (N'temp6' , 1, TRUNCATEONLY)
GO
DBCC SHRINKFILE (N'temp7' , 1, TRUNCATEONLY)
GO
DBCC SHRINKFILE (N'temp8' , 1, TRUNCATEONLY)
GO