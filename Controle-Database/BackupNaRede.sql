
USE [MASTER];
GO
BACKUP DATABASE [DW_METALFRIO] TO DISK = N'\\noturno\Wolverine_BKP\.bak' 
WITH NOFORMAT, 
NOINIT,  
NAME = N'\\noturno\Wolverine_BKP\.bak', 
SKIP, 
REWIND, 
NOUNLOAD, 
COMPRESSION,  
STATS = 10
