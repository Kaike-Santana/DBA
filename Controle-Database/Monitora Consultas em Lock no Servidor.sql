

SELECT blocking_session_id
, 'kill' + ' ' + convert(varchar(10),session_id) as kill_dinamico,
* 
FROM sys.dm_exec_requests 
WHERE blocking_session_id <> 0 