

DECLARE @D1 DATE =  CONCAT(CAST(GETDATE() - DATEPART(DAY,GETDATE() -1) AS DATE), ' 00:00:00:000') -- 1 DIA DO MÊS 
DECLARE @D2 DATE =  EOMONTH(GETDATE())															  -- ÚLTIMO DIA DO MÊS 

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	TABULAÇÃO DO PERIODO														    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
IF OBJECT_ID('TEMPDB..#ACIONAMENTO') IS NOT NULL DROP TABLE #ACIONAMENTO
SELECT DISTINCT
	CGCPF_DEV
,	IMAPS_OCO
,	CASE WHEN IMAPS_OCO IN ('ALO','CPC_N','CPC_P','PROMESSA') THEN 1 ELSE 0 END ALO                    
,	CASE WHEN IMAPS_OCO IN ('CPC_P','PROMESSA') THEN 1 ELSE 0 END CPC          
,	CASE WHEN IMAPS_OCO IN ('PROMESSA') THEN 1 ELSE 0 END ACORDO  
INTO #ACIONAMENTO
FROM [10.251.1.36].nectar.dbo.TB_ANDAMENTO	WITH(NOLOCK)
JOIN [10.251.1.36].nectar.dbo.TB_OCORRENCIA WITH(NOLOCK)  ON IDOCO_AND = IDOCO_OCO
JOIN [10.251.1.36].nectar.dbo.TB_CONTRATO	WITH(NOLOCK)  ON IDCON_AND = IDCON_CON
JOIN [10.251.1.36].nectar.dbo.TB_DEVEDOR	WITH(NOLOCK)  ON IDDEV_DEV = IDDEV_CON
WHERE 
	CONVERT(DATE,DTAND_AND) BETWEEN @D1 AND @D2
AND 
	IDEMP_CON IN (8,9)
AND 
	IMAPS_OCO <> ''
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: CARTEIRA DO PERIODO															    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #CARTEIRA	 
SELECT DISTINCT CPF
INTO #CARTEIRA
FROM ESTOQUE_ORIGINAL_MES
WHERE DT_INFO BETWEEN CONVERT(DATE,@D1) AND CONVERT(DATE,@D2)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: LAYOUT FINAL DO QUE NÃO FOI ACIONADO VISÃO ANALITICA							    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
SELECT  
		CPF_CARTEIRA	=		ISNULL(X.CPF   ,0)
,		PENETRACAO		=		ISNULL(SUM(IIF(Y.CGCPF_DEV IS NOT NULL,1,0)),0) 
,		ALO				=		ISNULL(SUM(Y.ALO)   ,0)
,		CPC				=		ISNULL(SUM(Y.CPC)   ,0)
,		ACORDO			=		ISNULL(SUM(Y.ACORDO),0)
FROM #CARTEIRA			X
LEFT JOIN #ACIONAMENTO  Y ON Y.CGCPF_DEV = X.CPF
GROUP BY ISNULL(X.CPF   ,0)
HAVING (
		 ISNULL(SUM(IIF(Y.CGCPF_DEV IS NOT NULL,1,0)),0) > 3 -- MUDAR PARA O QUE VC QUER VÊ DE PENETRAÇÃO
	   )
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: LAYOUT FINAL DO QUE NÃO FOI ACIONADO VISÃO ANALITICA							    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
SELECT 
		CPF			=	ISNULL(COUNT(DISTINCT X.CPF)				,0)
,		PENETRACAO	=	ISNULL(SUM(IIF(Y.CGCPF_DEV IS NOT NULL,1,0)),0) 
,		ALO			=	ISNULL(SUM(Y.ALO   )						,0)
,		CPC			=	ISNULL(SUM(Y.CPC   )						,0)
,		ACORDO		=	ISNULL(SUM(Y.ACORDO)						,0)
FROM #CARTEIRA			X
LEFT JOIN #ACIONAMENTO  Y ON Y.CGCPF_DEV = X.CPF