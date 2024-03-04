
USE [Data_Science]
GO

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* PROGRAMADOR: KAIKE NATAN									                                    */
/* VERSAO     : DATA: 12/08/2022																*/
/* DESCRICAO  : ATUALIZA O RELATÓRIO HORA HORA DE DISCAGENS ISDN					 		    */
/*																								*/
/*	ALTERACAO                                                                                   */
/*        2. PROGRAMADOR: KAIKE NATAN										DATA: 23/08/2022	*/		
/*           DESCRICAO  : INCLUSÃO DOS FILTROS POR OPERADORA E CARTEIRA							*/
/*	ALTERACAO                                                                                   */
/*        3. PROGRAMADOR: KAIKE NATAN										DATA: 17/11/2022	*/		
/*           DESCRICAO  : INCLUSÃO DO PAINEL DA PIC E DA RENNER									*/
/*	ALTERACAO                                                                                   */
/*        4. PROGRAMADOR: 													DATA: __/__/____	*/		
/*           DESCRICAO  : 																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	--ALTER PROCEDURE [dbo].[PRC_DS_INTRA_HORA_ISDN] AS

	DECLARE @vDATA VARCHAR(10) = CONVERT(DATE,GETDATE()-1)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: TRAZ AS INFORMAÇÔES D-0 DOS PAINEIS (1,2,3 E 4)								    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
SET NOCOUNT ON;
/*
DROP TABLE IF EXISTS #CALL_D0
SELECT 
	NOME_FILA
,	HORA
,	FILA
,	ISDNCAUSE
,	UNIQUEID
,	AGENTE
,	DATA
,   TERMINATOR
INTO #CALL_D0
FROM DATA_SCIENCE.DBO.TB_DS_CALLFLEX_D0_RIACHUELO WITH(NOLOCK)

UNION ALL

SELECT 
	NOME_FILA
,	HORA
,	FILA
,	ISDNCAUSE
,	UNIQUEID
,	AGENTE
,	DATA
,   TERMINATOR
FROM DATA_SCIENCE.DBO.TB_DS_CALLFLEX_D0_RENNER WITH(NOLOCK)

UNION ALL

SELECT 
	NOME_FILA
,	HORA
,	FILA
,	ISDNCAUSE
,	UNIQUEID
,	AGENTE
,	DATA
,   TERMINATOR
FROM DATA_SCIENCE.DBO.TB_DS_CALLFLEX_D0_PICPAY WITH(NOLOCK)

UNION ALL

SELECT 
	NOME_FILA
,	HORA
,	FILA
,	ISDNCAUSE
,	UNIQUEID
,	AGENTE
,	DATA
,   TERMINATOR
FROM DATA_SCIENCE.DBO.CALLFLEX_D0 WITH(NOLOCK) */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: TRAZ AS INFORMAÇÔES D-1 DOS PAINEIS (1, 2, 3 E 4)								    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #CHAMADAS_D1
SELECT 
	NOME_FILA
,	HORA
,	FILA
,	ISDNCAUSE
,	UNIQUEID
,	AGENTE  
,	DATA
,   TERMINATOR
INTO #CHAMADAS_D1
FROM DATA_SCIENCE.DBO.TB_DS_CALLFLEX_MES WITH(NOLOCK)
WHERE TIPO = N'DIS'
AND DATA = @vDATA

UNION ALL

SELECT 
	NOME_FILA
,	HORA
,	FILA
,	ISDNCAUSE
,	UNIQUEID
,	AGENTE
,	DATA
,   TERMINATOR
FROM DATA_SCIENCE.DBO.TB_DS_CALLFLEX_MES_RIACHUELO WITH(NOLOCK)
WHERE TIPO = N'DIS'
AND DATA = @vDATA

UNION ALL

SELECT 
	NOME_FILA
,	HORA
,	FILA
,	ISDNCAUSE
,	UNIQUEID
,	AGENTE
,	DATA
,   TERMINATOR
FROM DATA_SCIENCE.DBO.TB_DS_CALLFLEX_MES_RENNER WITH(NOLOCK)
WHERE TIPO = N'DIS'
AND DATA = @vDATA

UNION ALL

SELECT 
	NOME_FILA
,	HORA
,	FILA
,	ISDNCAUSE
,	UNIQUEID
,	AGENTE
,	DATA
,   TERMINATOR
FROM DATA_SCIENCE.DBO.TB_DS_CALLFLEX_MES_PICPAY WITH(NOLOCK)
WHERE TIPO = N'DIS'
AND DATA = @vDATA
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: TRAZ AS INFORMAÇÔES D-1 DOS PAINEIS (1, 2, 3 E 4)								    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DELETE FROM TB_DS_ANALITICO_CALLFLEX_HIT_RATE WHERE DATA = @vDATA
INSERT INTO TB_DS_ANALITICO_CALLFLEX_HIT_RATE
SELECT * FROM #CHAMADAS_D1
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: CONTA CHAMADAS AGRUPADO POR HORA, FILA E ISND									    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
TRUNCATE TABLE TB_DS_SINTETICO_CALLFLEX_HIT_RATE
INSERT   INTO  TB_DS_SINTETICO_CALLFLEX_HIT_RATE
SELECT 
	DATA
,	HORA		=	LEFT(HORA,2) 
,	ROTA		=	LOWER(TERMINATOR)
,	DISCAGENS	=	COUNT(DISTINCT(UNIQUEID))
,	ATENDIDAS   =   SUM(IIF(ISDNCAUSE = 16, 1, 0))
FROM TB_DS_ANALITICO_CALLFLEX_HIT_RATE
GROUP BY 
	DATA
,	LEFT(HORA,2)
,	LOWER(TERMINATOR)