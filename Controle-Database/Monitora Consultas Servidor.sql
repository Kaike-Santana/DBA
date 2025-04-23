
SELECT 
    r.session_id,
    s.login_name,
    s.host_name,                          -- Nome do host (m�quina que est� rodando
    s.program_name,
    DB_NAME(s.database_id) AS database_name,
    r.status AS request_status,           -- Ex.: running, suspended
    r.command,
    r.cpu_time,                           -- Tempo de CPU (ms)
    r.total_elapsed_time,                 -- Tempo total (ms)
    CONVERT(VARCHAR(8), 
            DATEADD(SECOND, r.total_elapsed_time / 1000, 0), 
            108) AS elapsed_time,         -- Converte para HH:MM:SS
    r.logical_reads,
    r.reads,                              -- Leituras f�sicas
    r.writes,
    r.wait_type,
    r.wait_time,
    r.last_wait_type,
    r.blocking_session_id,
    r.start_time,
    st.text AS sql_text,                  -- Texto da query
    s.host_name AS machine_name,          -- Nome do host (m�quina)
    si.cpu_count AS cpu_cores,            -- N�mero de n�cleos de CPU
    (si.physical_memory_kb / 1024) AS physical_memory_mb  -- Mem�ria f�sica (em MB)
FROM sys.dm_exec_requests r
INNER JOIN sys.dm_exec_sessions s 
    ON r.session_id = s.session_id
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS st
CROSS JOIN sys.dm_os_sys_info si          -- Junta com informa��es do sistema
WHERE r.session_id <> @@SPID             -- Exclui a sess�o atual (da pr�pria execu��o da consulta)
ORDER BY r.total_elapsed_time DESC;      -- Ordena das consultas com maior tempo de execu��o