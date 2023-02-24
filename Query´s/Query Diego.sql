
USE DATA_SCIENCE
GO

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* PROGRAMADOR: KAIKE NATAN									                                    */
/* VERSAO     : DATA: 12/08/2022																*/
/* DESCRICAO  : ATUALIZA O RELATÓRIO HORA HORA DE DISCAGENS ISDN					 		    */
/*																								*/
/*	ALTERACAO                                                                                   */
/*        2. PROGRAMADOR: 													DATA: __/__/____	*/		
/*           DESCRICAO  : 																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	--CREATE OR ALTER PROCEDURE PRC_DS_INTRA_HORA_ISDN AS
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: IDENTIFICADOR DE FILAS DO AD PARA EXPURGAR DO RELATÓRIO						    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
IF OBJECT_ID ('TEMPDB..#FILAS') IS NOT NULL DROP TABLE #FILAS
SELECT DISTINCT *
INTO #FILAS
FROM OPENQUERY([10.251.2.18],'SELECT * FROM replica_atmspbb1.queues')
WHERE NOME LIKE '%AD%'
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: PEGA CHAMADAS DO PAINEL DA RIACHUELO QUE NÃO SEJA AD							    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #CALL_RIACHUELO
SELECT * 
INTO #CALL_RIACHUELO
FROM DATA_SCIENCE.DBO.TB_DS_CALLFLEX_D0_RIACHUELO
WHERE FILA NOT IN (SELECT DISTINCT FILA FROM #FILAS)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: PEGA CHAMADAS DO PAINEL DAS OUTRAS CARTEIRAS									    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #CALL_OUTRAS_CARTEIRAS
SELECT *
INTO #CALL_OUTRAS_CARTEIRAS
FROM DATA_SCIENCE.DBO.CALLFLEX_D0
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: CONSOLIDA AS CHAMADAS DOS 2 PAINÉIS											    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #CALL
SELECT * INTO #CALL FROM #CALL_RIACHUELO

UNION ALL

SELECT * FROM #CALL_OUTRAS_CARTEIRAS
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: CONTA CHAMADAS AGRUPADO POR HORA, FILA E ISND									    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #PVT
SELECT 
	HORA		=	LEFT(HORA,2) 
,	FILA		=	CONVERT(VARCHAR(20),FILA) + '-' + NOME_FILA
,	ISDNCAUSE
,	DISCAGENS	=	COUNT(DISTINCT(UNIQUEID))
INTO #PVT
FROM #CALL
WHERE LEFT(HORA,2) >= 7
AND FILA NOT IN (9992,9995) -- URA
GROUP BY LEFT(HORA,2),CONVERT(VARCHAR(20),FILA) + '-' + NOME_FILA,ISDNCAUSE
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: FAZ O PIVOT PARA DEIXAR NO LAYOUT DE COMPARATIVO POR HORA NO EXCEL			    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
TRUNCATE TABLE PLANNING.DBO.TB_DS_CHAMADAS_ISDN
INSERT INTO    PLANNING.DBO.TB_DS_CHAMADAS_ISDN
SELECT 
	FILA
,	ISDNCAUSE
,	[07]	=	ISNULL([07],0)
,	[08]	=	ISNULL([08],0)
,	[09]	=	ISNULL([09],0)
,	[10]	=	ISNULL([10],0)
,	[11]	=	ISNULL([11],0)
,	[12]	=	ISNULL([12],0)
,	[13]	=	ISNULL([13],0)
,	[14]	=	ISNULL([14],0)
,	[15]	=	ISNULL([15],0)
,	[16]	=	ISNULL([16],0)
,	[17]	=	ISNULL([17],0)
,	[18]	=	ISNULL([18],0)
,	[19]	=	ISNULL([19],0)
,	[20]	=	ISNULL([20],0)
,	[21]	=	ISNULL([21],0)
FROM #PVT
PIVOT(
	  SUM(
		   DISCAGENS
		 ) 
		 FOR HORA IN (
					  [07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21]
					 )
	 ) PVT
WHERE 1=1