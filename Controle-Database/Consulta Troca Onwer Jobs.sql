
USE DATA_SCIENCE
GO

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* PROGRAMADOR: KAIKE NATAN									                                    */
/* VERSAO     : DATA: 24/02/2022																*/
/* DESCRICAO  : SCRIP PARA TROCAR DO OWNER DOS JOBS, EXECUTA O COMANDO A NIVEL INSTANCIA		*/
/*																								*/
/*	ALTERACAO                                                                                   */
/*        2. PROGRAMADOR:													 DATA: __/__/____	*/		
/*           DESCRICAO  :										 								*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	CONSULTA NA INSTANCIA TODOS OS JOBS E SEUS OWNER´S								*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
SELECT 
		A.JOB_ID
,		A.NAME AS JOB_NAME
,		B.NAME AS USER_NAME
,		B.SID
FROM	MSDB.DBO.SYSJOBS A LEFT JOIN SYS.SERVER_PRINCIPALS B ON (A.OWNER_SID = B.SID)
ORDER BY USER_NAME DESC
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	PROCEDURE PARA 	TROCAR OS ONWER´S DOS JOBS			 							*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

EXEC MSDB.DBO.SP_MANAGE_JOBS_BY_LOGIN
@ACTION = N'REASSIGN',  
@CURRENT_OWNER_LOGIN_NAME = N'ATMATEC\bruno.oliveira',  
@NEW_OWNER_LOGIN_NAME = N'DBA';