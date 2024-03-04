

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* PROGRAMADOR: KAIKE NATAN									                                    */
/* VERSAO     : DATA: 03/08/2022																*/
/* DESCRICAO  : AUDITORIA DE COMANDOS DML NO SERVIDOR								  		    */
/*																								*/
/* ALTERACAO                                                                                    */
/*        3. PROGRAMADOR: 													 DATA: __/__/____	*/		
/*           DESCRICAO  :										 								*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

DECLARE @Ds_Arquivo_Trace VARCHAR(255) = (SELECT SUBSTRING([path], 0, LEN([path])-CHARINDEX('\', REVERSE([path]))+1) + '\Log.trc' FROM sys.traces WHERE is_default = 1)
SELECT
A.HostName,
A.ApplicationName,
A.NTUserName,
A.NTDomainName,
A.LoginName,
A.SPID,
A.EventClass,
B.name,
A.EventSubClass,
A.TextData,
A.StartTime,
A.DatabaseName,
A.ObjectID,
A.ObjectName,
A.TargetLoginName,
A.TargetUserName
FROM [fn_trace_gettable](@Ds_Arquivo_Trace, DEFAULT) A
JOIN master.sys.trace_events B ON A.EventClass = B.trace_event_id
WHERE A.EventClass IN ( 164, 46, 47, 108, 110, 152 ) 
AND   A.StartTime >= GETDATE()-1
AND   A.LoginName NOT IN ( 'NT AUTHORITY\NETWORK SERVICE' )
AND   A.LoginName NOT LIKE '%SQLTELEMETRY$%'
AND   A.DatabaseName <> 'tempdb'
AND   NOT (B.name LIKE 'Object:%' AND A.ObjectName IS NULL )
AND   A.ObjectName <> 'telemetry_xevents'
AND   NOT (A.ApplicationName LIKE 'Red Gate%' OR A.ApplicationName LIKE '%Intellisense%' OR A.ApplicationName = 'DacFx Deploy')
AND   NTUserName != 'SQLSERVERAGENT'
AND   A.ObjectName NOT LIKE '_WA_Sys%'

