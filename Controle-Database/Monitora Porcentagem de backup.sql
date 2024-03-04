
--> Acompanha % de backup e restore do banco de dados

SELECT session_id AS SPID, command, a.text AS Query, start_time, percent_complete
FROM sys.dm_exec_requests r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) a
WHERE r.command IN ('BACKUP DATABASE', 'RESTORE DATABASE');