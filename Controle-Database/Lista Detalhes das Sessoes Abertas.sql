
Select Distinct
ES.session_id,
ES.login_name,
Upper(ES.[Status]) AS [Status],
(Select Db_name(ER.database_id)) as databasename,
ER.wait_time,
ER.total_elapsed_time,
 Convert(varchar, Dateadd(Second, ER.total_elapsed_time / 1000, 0), 108) AS TempoExecucaoFormatado,
ES.last_request_start_time,
ES.last_request_end_time,
(Select [Text] From Master.sys.dm_exec_sql_text(EC.most_recent_sql_handle)) as sqlscript,
ES.[host_name],
ES.[program_name],
ES.client_interface_name,
ES.cpu_time,
ES.total_scheduled_time,
ES.total_elapsed_time,
EC.net_transport,
ES.nt_domain,
ES.nt_user_name,
EC.client_net_address,
EC.local_net_address,
ER.wait_type,
ER.wait_resource,
blocking_session_id 
FROM sys.dm_exec_sessions    ES
INNER JOIN 
	 sys.dm_exec_connections EC ON EC.session_id = ES.session_id
INNER JOIN 
sys.dm_exec_requests ER ON   EC.session_id = ER.session_id
Where Upper(ES.[Status]) not in ('Sleeping','Dormant')
And (SELECT [Text] FROM master.sys.dm_exec_sql_text(EC.most_recent_sql_handle)) is not null
Order By ER.total_elapsed_time desc