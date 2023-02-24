
SELECT 
	sys.dm_exec_sessions.session_id AS SESSION_ID
,	(USER_OBJECTS_ALLOC_PAGE_COUNT * 8) AS kb_alocado_objeto
,	(INTERNAL_OBJECTS_ALLOC_PAGE_COUNT * 8) AS INTERNAL_KB
,	DB_NAME(SYS.dm_exec_sessions.database_id) AS BANCO
,	HOST_NAME AS HOT
,	PROGRAM_NAME AS AA
,	LOGIN_NAME
,	STATUS
,	ROW_COUNT AS LINHAS
FROM sys.dm_db_session_space_usage JOIN sys.dm_exec_sessions ON sys.dm_db_session_space_usage.session_id = sys.dm_exec_sessions.session_id
WHERE sys.dm_exec_sessions.session_id > 50

