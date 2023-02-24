
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* PROGRAMADOR: KAIKE NATAN									                                    */
/* VERSAO     : DATA: 04/03/2022																*/
/* DESCRICAO  : ANALISE SOBRE TODOS OS JOBS DO BANCO											*/
/*																								*/
/*	ALTERACAO                                                                                   */
/*        2. PROGRAMADOR: 													 DATA: __/__/____	*/		
/*           DESCRICAO  :  			 															*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	SETA A LINGUAGEM PADRÃO PARA BRASILEIRA											*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	SET LANGUAGE 'BRAZILIAN'

	DECLARE @DATA_INI DATE = CAST(GETDATE() AS date)
	DECLARE @DATA_FIN DATE = CAST(GETDATE() AS date)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :CRUZA AS TABELAS DE SISTEMA DOS JOBS E FAZ A MODELAGEM DOS DADOS					*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
SELECT 
	NOME_JOB				=		[sJOB].[name]
,	ATIVO					=		CASE [sJOB].[enabled] WHEN 1 THEN 'SIM' WHEN 0 THEN 'NAO' END
,	STATUS_JOB				=		IIF([sJOBHy].run_status = 0, 'FALHOU' , 'SUCESSO')
,	ID_STEP_FALHA			=		[sJOBHy].step_id 
,	NOME_STEP_FALHA			=		[sJOBHy].step_name 
,	ERRO_COMANDO			=		[sJOBHy].message 
,	DIA_EXE_JOB				=		CONVERT(DATE, Cast([sJOBHy].run_date AS VARCHAR(8)), 111)
,	DATA_CRIACAO			=		[sJOB].[date_created] 
,	ULTIMA_MODIFICACAO		=		[sJOB].[date_modified]
,	QTD_STEP_JOB			=		[sJSTP].[step_id]
,	NOME_STEP				=		[sJSTP].[step_name]
,	BANCO_JOB				=		[sJSTP].[database_name]
,	COMANDO_JOB				=		REPLACE(REPLACE(REPLACE([sJSTP].[command], CHAR(10) + CHAR(13), ' '), CHAR(13), ' '), CHAR(10), ' ') 
,	OCORRENCIA_JOB			=		CASE [sSCH].[freq_type] 
										 WHEN 1 THEN 'One Time' 
										 WHEN 4 THEN 'Daily' 
										 WHEN 8 THEN 'Weekly' 
										 WHEN 16 THEN 'Monthly' 
										 WHEN 32 THEN 'Monthly - Relative to Frequency Interval' 
										 WHEN 64 THEN 'Start automatically when SQL Server Agent starts'
										 WHEN 128 THEN 'Start whenever the CPUs become idle'
									END 
,	FREQUENCIA				=		CASE 
										[sSCH].[freq_subday_type]
											 WHEN 1 THEN 'Occurs once at ' + 
												STUFF(STUFF(RIGHT('000000' + 
													CAST([sSCH].[active_start_time] AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
														WHEN 2 THEN 'Occurs every ' + 
															CAST([sSCH].[freq_subday_interval] AS VARCHAR(3)) + 
																' Second(s) between ' + 
																	STUFF(STUFF(RIGHT('000000' + 
																		CAST([sSCH].[active_start_time] AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':') +
																			' & ' + STUFF(STUFF(RIGHT('000000'
																				+ CAST([sSCH].[active_end_time] AS VARCHAR(6))
																					, 6), 3, 0, ':'), 6, 0, ':')
																						WHEN 4 THEN 'Occurs every ' + 
																							CAST([sSCH].[freq_subday_interval] AS VARCHAR(3)) + 
																								' Minute(s) between ' + 
																							STUFF(STUFF(RIGHT('000000' + 
																						CAST([sSCH].[active_start_time] AS VARCHAR(6))
																					, 6), 3, 0, ':'), 6, 0, ':')
																				+ ' & ' + STUFF(STUFF(RIGHT('000000' 
																			+ CAST([sSCH].[active_end_time] 
																		AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
																	WHEN 8 THEN 'Occurs every ' + 
																CAST([sSCH].[freq_subday_interval] AS VARCHAR(3)) 
															+ ' Hour(s) between ' + STUFF(STUFF(RIGHT('000000' 
														+ CAST([sSCH].[active_start_time] AS VARCHAR(6))
													, 6), 3, 0, ':'), 6, 0, ':')
												+ ' & ' + STUFF(STUFF(RIGHT('000000' 
											+ CAST([sSCH].[active_end_time] 
										AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
									END 
FROM 
			[msdb].[dbo].[sysjobsteps]			AS [sJSTP]
INNER JOIN  [msdb].[dbo].[sysjobs]				AS [sJOB]	 ON [sJSTP].[job_id]		= [sJOB].[job_id]
LEFT JOIN   [msdb].[dbo].[sysjobsteps]			AS [sOSSTP]	 ON [sJSTP].[job_id]		= [sOSSTP].[job_id] AND [sJSTP].[on_success_step_id] = [sOSSTP].[step_id]
LEFT JOIN   [msdb].[dbo].[sysjobsteps]			AS [sOFSTP]	 ON [sJSTP].[job_id]		= [sOFSTP].[job_id] AND [sJSTP].[on_fail_step_id]	 = [sOFSTP].[step_id]
LEFT JOIN   [msdb].[dbo].[sysproxies]			AS [sPROX]	 ON [sJSTP].[proxy_id]	    = [sPROX].[proxy_id]
LEFT JOIN   [msdb].[dbo].[syscategories]		AS [sCAT]	 ON [sJOB].[category_id]    = [sCAT].[category_id]
LEFT JOIN   [msdb].[sys].[database_principals]  AS [sDBP]	 ON [sJOB].[owner_sid]	    = [sDBP].[sid]
LEFT JOIN   [msdb].[dbo].[sysjobschedules]		AS [sJOBSCH] ON [sJOB].[job_id]		    = [sJOBSCH].[job_id]
LEFT JOIN   [msdb].[dbo].[sysschedules]			AS [sSCH]	 ON [sJOBSCH].[schedule_id] = [sSCH].[schedule_id]
LEFT JOIN   [msdb].[dbo].[sysjobhistory]		AS [sJOBHy]  ON [sJOBHy].[job_id]		= [sJOB].[job_id]

WHERE CASE [sJOB].[enabled] WHEN 1 THEN 'SIM' WHEN 0 THEN 'NAO' END != 'NÃO'
AND	  IIF([sJOBHy].run_status = 0, 'FALHOU' , 'SUCESSO') != 'SUCESSO'
AND   CONVERT(DATE, Cast([sJOBHy].run_date AS VARCHAR(8)), 111) BETWEEN @DATA_INI AND @DATA_FIN
ORDER BY NOME_JOB 


