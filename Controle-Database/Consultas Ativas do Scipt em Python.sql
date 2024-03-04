

SELECT
        r.session_id AS spid,
        s.login_name AS usuario,
        'RUNNING' AS status,
        DB_NAME(r.database_id) AS databasename,
        r.total_elapsed_time,
        t.text AS comando
    FROM
        sys.dm_exec_requests r
    INNER JOIN 
        sys.dm_exec_sessions s ON r.session_id = s.session_id
    CROSS APPLY 
        sys.dm_exec_sql_text(r.sql_handle) t
    WHERE s.login_name != 'sa'
	  and r.session_id > 50