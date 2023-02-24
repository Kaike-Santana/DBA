
USE Data_Science
GO

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* PROGRAMADOR: KAIKE NATAN									                                    */
/* VERSAO     : DATA: 18/02/2022																*/
/* DESCRICAO  : RESPONSAVEL POR MONITORAR OS ACESSOS DO DATABASE					  		    */
/*																								*/
/*	ALTERACAO                                                                                   */
/*        1. PROGRAMADOR: 													 DATA: 16/02/2022	*/		
/*           DESCRICAO  :  																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	SELECIONA OS USUARIOS COM AUTENTICAÇÃO DO WINDOWS E SUAS PERMISSOES			    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

SELECT
			 S.NAME
			,S.LOGINNAME
			,S.PASSWORD
			,L.SID
			,L.IS_DISABLED
			,S.CREATEDATE
			,S.DENYLOGIN
			,S.HASACCESS
			,S.ISNTNAME
			,S.ISNTGROUP
			,S.ISNTUSER
			,S.SYSADMIN
			,S.SECURITYADMIN
			,S.SERVERADMIN
			,S.PROCESSADMIN
			,S.DISKADMIN
			,S.DBCREATOR
			,S.BULKADMIN
FROM [SYS].[SYSLOGINS] S LEFT JOIN	[SYS].[SQL_LOGINS] L ON ( S.SID = L.SID )
WHERE sysadmin = 1
ORDER BY 
		S.NAME DESC

