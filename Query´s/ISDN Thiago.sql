
USE [DATA_SCIENCE]
GO

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* PROGRAMADOR: KAIKE NATAN									                                    */
/* VERSAO     : DATA: 18/03/2022																*/
/* DESCRICAO  : PEGA AS CHAMADAS DE 10 DIAS AGRUPAPO POR OPERADORA E CARTEIRA		 		    */
/*																								*/
/*	ALTERACAO                                                                                   */
/*        2. PROGRAMADOR:													 DATA: __/__/____	*/		
/*           DESCRICAO  :										 								*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	VARIAVÉIS DO CÓDIGO															    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	DECLARE @DATA_I DATE = CONVERT(DATE,GETDATE()-1)
	DECLARE @DATA_F DATE = CONVERT(DATE,GETDATE()-1)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	ABRE CONTROLE DE FLUXO DO CÓDIGO											    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
BEGIN 
	BEGIN TRY 
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: CONSOLIDA FILAS DO MY SQL														    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #FILAS_CONSOLIDADO
SELECT * INTO #FILAS_CONSOLIDADO
FROM OPENQUERY([10.251.2.18],'SELECT * FROM replica_atmspbb1.queues')

UNION 

SELECT *
FROM OPENQUERY([10.251.2.18],'SELECT * FROM replica_atmsp2b1.queues')

UNION 

SELECT *
FROM OPENQUERY([10.251.2.18],'SELECT * FROM replica_atmsp3b1.queues')

UNION 

SELECT *
FROM OPENQUERY([10.251.2.18],'SELECT * FROM replica_atmsp4b1.queues')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: ETL DAS FILAS DO CALL FLEX													    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #FILAS
  SELECT  *
, EMPRESA	=
				CASE
					WHEN NOME LIKE '%RIACHUELO%'	THEN 'RIACHUELO'
					WHEN NOME LIKE '%ORIGINAL%'		THEN 'BANCO ORIGINAL'
					WHEN NOME LIKE '%PAY%'			THEN 'BANCO ORIGINAL'
					WHEN NOME LIKE '%VERDE%'		THEN 'BANCO ORIGINAL'
					WHEN NOME LIKE '%CAEDU%'		THEN 'CAEDU'
					WHEN NOME LIKE '%MENU%'			THEN 'MENU'
					WHEN NOME LIKE '%RIACHUE%'		THEN 'RIACHUELO' 
					WHEN NOME LIKE '%PRAVALER%'		THEN 'PRAVALER'
					WHEN NOME LIKE '%CLARO%'		THEN 'CLARO'
					WHEN NOME LIKE '%RENNER%'		THEN 'RENNER'
					WHEN NOME LIKE '%TEXA%'			THEN 'TEXA'
													ELSE 'OUTROS' 
				 END 
INTO #FILAS
FROM #FILAS_CONSOLIDADO
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	CHAMADAS																	    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #CHAMADAS
SELECT 
	DATA
,	ORIGEM
,	DOC
,	IDCRM
,	UNIQUEID
,	DDD
,	DESLIGADOPOR
,	DURACAO
,	STATUS
,	STATUSATENDIMENTO
,	STATUSNEGOCIO
,	ISDNCAUSE
,	VALOR
,	TIPO
,	ABANDONADO
,	REDIRECIONADO 
,	B.NOME
,	A.FILA
,	B.EMPRESA
,	TERMINATOR
,	CASE 
		WHEN TERMINATOR = ''				 THEN 'SEM TERMINATOR'
		WHEN TERMINATOR LIKE '%OKTOR%'		 THEN 'OKTOR' 
		WHEN TERMINATOR LIKE '%CRIVEL%'		 THEN 'CRIVEL' 
		WHEN TERMINATOR LIKE '%TELVOX%'		 THEN 'TELVOX'
		WHEN TERMINATOR LIKE '%LYNKER%'		 THEN 'LYNKER'
		WHEN TERMINATOR LIKE '%PRIMACOM%'	 THEN 'PRIMACOM'
		WHEN TERMINATOR LIKE '%TELSIM%'		 THEN 'TELSIM' 
		WHEN TERMINATOR LIKE '%GOSAT%'		 THEN 'GOSAT' 
		WHEN TERMINATOR LIKE '%VOXVISION%'   THEN 'VOXVISION'
		WHEN TERMINATOR LIKE '%VIVO%'		 THEN 'VIVO' 
		ELSE TERMINATOR	
	END OPERADORA
INTO #CHAMADAS
FROM TB_DS_CALLFLEX_MES	 A JOIN #FILAS B ON ( A.FILA  =  B.FILA )
WHERE DATA BETWEEN @DATA_I AND @DATA_F
--AND LEN(ORIGEM) != 5			-- TIRA AS CHAMADAS INTERNAS DOS OPERADORES
--AND TIPO != 'ENTRANTE'		-- DESCOMENTAR SE QUISER TIRAR OQ FOR RECEPTIVO
--AND ISDNCAUSE = 1				-- DESCOMENTAR PARA ESCOLHER O ISDN QUE VC DESEJA
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	CONTA AS CHAMADAS AGRUPADO POR TELEFONE, OPERADORA E EMPRESA				    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #PVT 
SELECT 
	EMPRESA
,   DATA
,   ISDNCAUSE			=		MAX(ISDNCAUSE)
,	FILA				=	    MAX(NOME)
,	OPERADORA			=		MAX(OPERADORA)
,	TELEFONE			=		ORIGEM
,	TENTATIVAS_TEL		=		COUNT(ORIGEM)
INTO #PVT
FROM #CHAMADAS
GROUP BY 
	EMPRESA
,   DATA
,	ORIGEM
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: PIVOT PARA LAYOUT																    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
SELECT 
		DATA
,		EMPRESA
,		FILA				=	UPPER(FILA)
,		ISDN				=	ISDNCAUSE
,		TELEFONE
,		TIPO_LIG			=	IIF(LEN(TELEFONE) < 6, 'INTERNA', 'FORA')
,		[SEM TERMINATOR]	=	ISNULL([SEM TERMINATOR] ,0)
,		[OKTOR]				=	ISNULL([OKTOR]			,0)
,		[CRIVEL]			=	ISNULL([CRIVEL]			,0)
,		[TELVOX]			=	ISNULL([TELVOX]			,0)
,		[LYNKER]			=	ISNULL([LYNKER]			,0)
,		[PRIMACOM]			=	ISNULL([PRIMACOM]		,0)
,		[TELSIM]			=	ISNULL([TELSIM]			,0)
,		[GOSAT]				=	ISNULL([GOSAT]			,0)
,		[VOXVISION]			=	ISNULL([VOXVISION]		,0)
,		[VIVO]				=	ISNULL([VIVO]			,0)
FROM #PVT C						
PIVOT(
	  SUM(
		   C.TENTATIVAS_TEL
	  ) 
		 FOR C.OPERADORA IN (
							 [SEM TERMINATOR],[OKTOR],[CRIVEL],[TELVOX],[LYNKER],[PRIMACOM],[TELSIM],[GOSAT],[VOXVISION],[VIVO]
							)
	 ) PVT
WHERE 1=1
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	FECHA CONTROLE DE FLUXO DO CÓDIGO											    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
END TRY
 	BEGIN CATCH
 		PRINT 'ERRO NÚMERO		: ' + CONVERT(VARCHAR, ERROR_NUMBER());
 		PRINT 'ERRO MENSAGEM	: ' + ERROR_MESSAGE();
 		PRINT 'ERRO SEVERITY	: ' + CONVERT(VARCHAR, ERROR_SEVERITY());
 		PRINT 'ERRO STATE		: ' + CONVERT(VARCHAR, ERROR_STATE());
 		PRINT 'ERRO LINE		: ' + CONVERT(VARCHAR, ERROR_LINE());
 		PRINT 'ERRO PROC		: ' + ERROR_PROCEDURE();
 	END CATCH;
 END