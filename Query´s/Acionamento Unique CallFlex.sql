
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* PROGRAMADOR: KAIKE NATAN									                                    */
/* VERSAO     : DATA: 20/05/2022																*/
/* DESCRICAO  : RESPONSÁVEL POR ATUALIZAR O RELATÓRIO DE ACIOMENTOS								*/
/*																								*/
/* ALTERACAO                                                                                    */
/*        2. PROGRAMADOR: 													 DATA: __/__/____	*/		
/*           DESCRICAO  :  			 															*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	VARIAVÉIS DE CONTROLE DO CÓDIGO												    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DECLARE @DATA_INICIAL DATE			  =		 CONVERT(DATE,GETDATE()-2)
DECLARE @DATA_FINAL   DATE			  =		 CONVERT(DATE,GETDATE()-2)
DECLARE @IP			  VARCHAR(13)	  =		'[10.251.1.36]'
DECLARE @TSQL		  NVARCHAR(4000)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: BUSCA BASE EM COBRANÇA DA RENNER													*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS ##BASE_COBRANCA
SET @TSQL = 'SELECT * INTO ##BASE_COBRANCA FROM OPENQUERY('+@IP+',''
SELECT DISTINCT
	IDCON_CON
,	CONTR_CON
,	DTATR_CON
,	CGCPF_DEV
FROM NECTAR.DBO.TB_CONTRATO	WITH(NOLOCK) 
JOIN NECTAR.DBO.TB_DEVEDOR	WITH(NOLOCK) ON IDDEV_DEV = IDDEV_CON
WHERE IDEMP_CON = 9 '')'
EXEC SP_EXECUTESQL @TSQL
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: IDENTIFICADOR DE FILAS														    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #FILAS
SELECT  
 A.*
,EMPRESA	=	CASE WHEN NOME LIKE '%ORIGINAL%' THEN 'BANCO ORIGINAL' ELSE 'OUTROS' END 
INTO #FILAS
FROM OPENQUERY([10.251.2.18],'SELECT * FROM replica_atmspbb1.queues') A
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: CHAMADAS CALLFLEX	ANALITICO													    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #CHAMADAS_ANALITICO
SELECT DISTINCT
   CPF_DEV		=	 C.CGCPF_DEV 
,  DISCAGENS	=	 COUNT(DISTINCT(UNIQUEID)) 
INTO #CHAMADAS_ANALITICO
FROM DATA_SCIENCE.DBO.TB_DS_CALLFLEX_MES A  
JOIN #FILAS B WITH(NOLOCK) ON  A.FILA		=	B.FILA  AND B.EMPRESA = 'BANCO ORIGINAL'
JOIN ##BASE_COBRANCA C	   ON  C.IDCON_CON	=	A.IDCRM 
WHERE DATA BETWEEN @DATA_INICIAL AND @DATA_FINAL
GROUP BY C.CGCPF_DEV
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: CHAMADAS CALLFLEX	SINTÉTICO													    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #CHAMADAS_SINTETICO
SELECT DISTINCT
   FLAG			=	 'ATMA'
,  DISCAGENS	=	  COUNT(DISTINCT(UNIQUEID)) 
INTO #CHAMADAS_SINTETICO
FROM DATA_SCIENCE.DBO.TB_DS_CALLFLEX_MES A  
JOIN #FILAS B WITH(NOLOCK) ON  A.FILA		=	B.FILA  AND B.EMPRESA = 'BANCO ORIGINAL'
JOIN ##BASE_COBRANCA C	   ON  C.IDCON_CON	=	A.IDCRM 
WHERE DATA BETWEEN @DATA_INICIAL AND @DATA_FINAL
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: TABULAÇÃO ANALITICA DO PERIODO												    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
IF OBJECT_ID('TEMPDB..#ACIONAMENTO_ANALITICO') IS NOT NULL DROP TABLE #ACIONAMENTO_ANALITICO
SELECT DISTINCT
	CGCPF_DEV
,	ALO			=		CASE WHEN IMAPS_OCO IN ('ALO','CPC_N','CPC_P','PROMESSA') THEN 1 ELSE 0 END                    
,	CPC			=		CASE WHEN IMAPS_OCO IN ('CPC_P','PROMESSA') THEN 1 ELSE 0 END          
,	ACORDO		=		CASE WHEN IMAPS_OCO IN ('PROMESSA') THEN 1 ELSE 0 END 
INTO #ACIONAMENTO_ANALITICO
FROM [10.251.1.36].NECTAR.DBO.TB_ANDAMENTO	WITH(NOLOCK)
JOIN [10.251.1.36].NECTAR.DBO.TB_OCORRENCIA WITH(NOLOCK)  ON IDOCO_AND = IDOCO_OCO
JOIN [10.251.1.36].NECTAR.DBO.TB_CONTRATO	WITH(NOLOCK)  ON IDCON_AND = IDCON_CON
JOIN [10.251.1.36].NECTAR.DBO.TB_DEVEDOR	WITH(NOLOCK)  ON IDDEV_DEV = IDDEV_CON
WHERE CONVERT(DATE,DTAND_AND) BETWEEN @DATA_INICIAL AND @DATA_FINAL
AND IDEMP_CON = 9
AND IMAPS_OCO <> ''
AND IMAPS_OCO IN ('ALO','CPC_N','CPC_P','PROMESSA')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: TABULAÇÃO SINTÉTICA DO PERIODO												    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #ACIONAMENTO_SINTETICO
SELECT 
	ALO		=	SUM(ALO)
,	CPC		=	SUM(CPC)
,	ACORDO	=	SUM(ACORDO)
,	FLAG	=	'ATMA'
INTO #ACIONAMENTO_SINTETICO
FROM #ACIONAMENTO_ANALITICO
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: CARTEIRA DO PERIODO ANALITICO													    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #CARTEIRA_ANALITICA	 
SELECT DISTINCT CPF
INTO #CARTEIRA_ANALITICA
FROM ESTOQUE_ORIGINAL_MES
WHERE DT_INFO BETWEEN @DATA_INICIAL AND @DATA_FINAL
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: CARTEIRA DO PERIODO SINTÉTICO													    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #CARTEIRA_SINTETICA	 
SELECT DISTINCT 
	BASE	=	 COUNT(DISTINCT(CPF))
,	FLAG	=	'ATMA'
INTO #CARTEIRA_SINTETICA
FROM ESTOQUE_ORIGINAL_MES
WHERE DT_INFO BETWEEN @DATA_INICIAL AND @DATA_FINAL
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: LAYOUT FINAL DO QUE NÃO FOI ACIONADO VISÃO ANALITICA							    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
SELECT  
		CPF_DEV			=		ISNULL(X.CPF			,0)
,		DISCAGENS		=		ISNULL(SUM(Z.DISCAGENS) ,0) 
,		ALO				=		ISNULL(SUM(Y.ALO)		,0)
,		CPC				=		ISNULL(SUM(Y.CPC)		,0)
,		ACORDO			=		ISNULL(SUM(Y.ACORDO)	,0)
FROM #CARTEIRA_ANALITICA X 
LEFT JOIN #ACIONAMENTO_ANALITICO Y ON Y.CGCPF_DEV	=	X.CPF 
LEFT JOIN #CHAMADAS_ANALITICO    Z ON Z.CPF_DEV		=	X.CPF
GROUP BY ISNULL(X.CPF,0)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: LAYOUT FINAL DO QUE NÃO FOI ACIONADO VISÃO SINTÉTICA							    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
SELECT  
		BASE			=		ISNULL(X.BASE	  ,0)
,		DISCAGENS		=		ISNULL(Z.DISCAGENS,0) 
,		ALO				=		ISNULL(Y.ALO	  ,0)
,		CPC				=		ISNULL(Y.CPC	  ,0)
,		ACORDO			=		ISNULL(Y.ACORDO	  ,0)
FROM #CARTEIRA_SINTETICA X 
JOIN #ACIONAMENTO_SINTETICO Y ON Y.FLAG = X.FLAG 
JOIN #CHAMADAS_SINTETICO    Z ON Z.FLAG = X.FLAG