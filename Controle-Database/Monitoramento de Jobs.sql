
Set Language 'Brazilian'
Go

Declare @Periodo  varchar(max) 
Declare @Frase    varchar(max) = 'Monitoramento dos Jobs referente ao servidor: '
Declare @Servidor varchar(max) = upper(@@servername)

If(
	datepart(hour,getdate()) between 0 and 12
  )
Set @periodo = 'Bom dia, Segue' + ' ' + @Frase + @Servidor

If(
	datepart(hour,getdate()) between 13 and 18
  )
Set @periodo = 'Boa Tarde, Segue' + ' ' + @Frase + @Servidor

If(
	datepart(hour,getdate()) between 19 and 23
  )
Set @periodo = 'Boa Noite, Segue' + ' ' + @Frase  + @Servidor

Declare @body Nvarchar(MAX) = 
'<table border=1 width=''100%''><tr><th colspan=''4'' bgcolor=''darkblue''>'
+ '<h3> '''+@periodo+''' </h3></th></tr>' 
+ '<tr bgcolor=''lightblue''><th>Nome do Job<th>Ultima Vez executou<th>Status do Job<th>Status da Ultima Execucao</tr>' 
+ CAST( (
Select Distinct Name As [TD] 
,convert(nvarchar(20),CONVERT(DATETIME,RTRIM(run_date),113),103) AS [TD]
,CASE WHEN enabled=1 THEN 'Habilitada'
ELSE 'Desabilitado'
END AS [TD]
,CASE   
	WHEN SJH.run_status= 0 THEN  'Falho'
	WHEN SJH.run_status= 1 THEN  'Sucesso'
	WHEN SJH.run_status= 2 THEN  'Tentando'
	WHEN SJH.run_status= 3 THEN  'Cancelado'
	ELSE  'Desconhecido'
END AS [TD]
FROM   msdb..sysjobhistory SJH  
JOIN   msdb..sysjobs SJ  ON     SJH.job_id=sj.job_id 
WHERE  step_id = 0
AND CONVERT(DATETIME,RTRIM(run_date),113) >= DATEADD(d,-1,GetDate())
and SJH.instance_id = (select MAX(b.instance_id) from msdb..sysjobhistory b where SJH.job_id=b.job_id) 
and sj.name Not In ('syspolicy_purge_history','backup_plaster')
ORDER BY 1,2,3,4
FOR XML RAW('tr'), ELEMENTS 
) AS NVARCHAR(MAX))
+ '<tr><td colspan=''4'' bgcolor=''darkblue'' align=''right''>'
+ 'Informacao extraida em: ' + CONVERT( nvarchar, GETDATE(), 113) + '</td></tr></table>';

If (
@Body = null
)
Set @Body = 'Parabéns nenhum job falhou no dia: ' + DATENAME(DAY,GETDATE()) + ' de ' + DATENAME(MONTH,GETDATE()) + ' de ' + DATENAME(YEAR,GETDATE())

Begin Try
	Execute msdb.dbo.sp_send_dbmail 
	@profile_name = 'MSSQLServer',
	@recipients = 'kaike.santana@atrpservices.com.br;marcos.alves@atrpservices.com.br;thanner.almeida@atrpservices.com.br',
	@subject = 'Relatório dos Status dos Jobs',
	@body = @body,
	@body_format = 'HTML',
	@query_result_width = 90,
	@query_result_separator = ' ',
	@query_result_header = 0,
	@attach_query_result_as_file = 0,
	@execute_query_database = 'master'
End Try

Begin Catch
	 Select
          error_number() as errornumber,
          error_severity() as errorseverity,
          error_state() as errorstate,
          error_procedure() as errorprocedure,
          error_line() as errorline,
          error_message() as errormessage;
End Catch