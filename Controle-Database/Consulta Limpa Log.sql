
USE Data_Science 
GO

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* PROGRAMADOR: KAIKE NATAN									                                    */
/* VERSAO     : DATA: 23/02/2022																*/
/* DESCRICAO  : SCRIP DE LIMPAR LOG DAS INSTANCIAS									  		    */
/*																								*/
/*	ALTERACAO                                                                                   */
/*        2. PROGRAMADOR:													 DATA: __/__/____	*/		
/*           DESCRICAO  :										 								*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	PARA OBTER O NOME DO ARQUIVO DE DADOS E DE LOG DO BANCO DE DADOS ESPECÍFICO		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	SELECT * 
	FROM SYSFILES  
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	MUDA O BACKUP DO BANCO PARA SIMPLES												*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	ALTER DATABASE Data_Science
	SET RECOVERY SIMPLE
	GO
	ALTER DATABASE PostGreSQL
	SET RECOVERY SIMPLE
	GO
	ALTER DATABASE Reports
	SET RECOVERY SIMPLE
	GO
	ALTER DATABASE Dw_Discador
	SET RECOVERY SIMPLE
	GO
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	TRUNCA OS ARQUIVOS DE LOG DA INSTANCIA											*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	DBCC SHRINKFILE ('Data_Science_log', 1,TRUNCATEONLY);				
	GO
	DBCC SHRINKFILE ('PostGreSQL_log', 1,TRUNCATEONLY);				
	GO
	DBCC SHRINKFILE ('Reports_log', 1,TRUNCATEONLY);				
	GO
	DBCC SHRINKFILE ('DW_Discador_log', 1,TRUNCATEONLY);				
	GO
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	MUDA O BACKUP DO BANCO PARA FULL NOVAMENTE										*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	ALTER DATABASE Data_Science
	SET RECOVERY FULL
	GO
	ALTER DATABASE PostGreSQL
	SET RECOVERY FULL
	GO
	ALTER DATABASE Reports
	SET RECOVERY FULL
	GO
	ALTER DATABASE Dw_Discador
	SET RECOVERY FULL
	GO