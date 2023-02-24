

USE DATA_SCIENCE
GO

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* PROGRAMADOR: KAIKE NATAN									                                    */
/* VERSAO     : DATA: 01/11/2022																*/
/* DESCRICAO  : RESPONSAVEL POR ATUALIZAR OS CASOS NOVOS DA VELOE SEM ACIONAMENTO 			    */
/*																								*/
/*	ALTERACAO                                                                                   */
/*        2. PROGRAMADOR: 													 DATA: __/__/____	*/		
/*           DESCRICAO  : 																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: --> PERIODO SOLICITADO PELO SETRA HOJE ATÉ MENOS 3 DIAS!						    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	DECLARE @D1 DATE	=	CONVERT(DATE,GETDATE()-3) 
	DECLARE @D2 DATE	=	CONVERT(DATE,GETDATE())

	IF (
		DATEPART(DW,GETDATE())
	   ) = 2

		SET @D1			=	CONVERT(DATE,GETDATE()-4)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: ACIONAMENTOS DO CRM NOS ÚLTIMOS 3 DIAS											*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #ACIONAMENTO_NECTAR
SELECT DISTINCT
	DTAND_AND
,	CGCPF_DEV
,	IDCON_AND
,	DESCR_SEG
,	DESCR_OCO
,	ATRASO		=	DATEDIFF(DD,DTATR_CON,DTAND_AND)
,	IMAPS_OCO
,	DTIMP_CON
INTO #ACIONAMENTO_NECTAR
FROM [10.251.1.36].NECTAR.DBO.TB_ANDAMENTO 	 WITH(NOLOCK)
JOIN [10.251.1.36].NECTAR.DBO.TB_CONTRATO 	 WITH(NOLOCK) ON IDCON_AND = IDCON_CON  
JOIN [10.251.1.36].NECTAR.DBO.TB_SEGMENTACAO WITH(NOLOCK) ON IDSEG_CON = IDSEG_SEG
JOIN [10.251.1.36].NECTAR.DBO.TB_DEVEDOR	 WITH(NOLOCK) ON IDDEV_DEV = IDDEV_CON
JOIN [10.251.1.36].NECTAR.DBO.TB_OCORRENCIA	 WITH(NOLOCK) ON IDOCO_AND = IDOCO_OCO  
WHERE IDEMP_CON = 15
AND CONVERT(DATE,DTAND_AND) BETWEEN @D1 AND @D2
AND IMAPS_OCO != ''
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: BASE IMPORTDA DOS ÚLTIMOS 3 DIAS													*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #CARTEIRA
SELECT 
	CPF_CNPJ
,	ID_CONTRATO		=	CONVERT(VARCHAR(MAX),ID_CONTRATO)
,	DIAS_ATRASO
,	DT_IMPORTACAO
,	SEGMENTACAO
,	DT_INFO
,	RW				=	ROW_NUMBER() OVER(PARTITION BY CPF_CNPJ ORDER BY SEGMENTACAO DESC)
INTO #CARTEIRA
FROM TB_DS_FOTOGRAFIA_VELOE_MES WITH(NOLOCK)
WHERE DT_IMPORTACAO BETWEEN @D1 AND @D2
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: REMOVE DUPLICADOS E DROPA COLUNA DE VALIDAÇÃO										*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	DELETE FROM #CARTEIRA WHERE RW > 1
	ALTER TABLE #CARTEIRA DROP COLUMN RW
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: TRAZ AS CHAMADAS DA CALLFLEX													    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #CHAMADAS
SELECT 
	DATA		=	CALLDATE
,	UNIQUEID
,	Y.CPF_CNPJ
,	Y.DIAS_ATRASO
,	Y.SEGMENTACAO
,	CANAL		=	'DISCADOR'
INTO #CHAMADAS
FROM TB_DS_CALLFLEX_MES X WITH(NOLOCK)
JOIN #CARTEIRA			Y ON  (Y.ID_CONTRATO =  X.IDCRM) 
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: CONSOLIDA CALLFLEX E CRM														    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #CONSOLIDADO
SELECT
	CARTEIRA		=	'VELOE' 
,	CPF				=	CGCPF_DEV 
,	DATA_ULT_ACIO	=	DTAND_AND
,	CANAL			=	CASE
							WHEN IMAPS_OCO = 'ACAO' AND DESCR_OCO = 'Envio de Whatsapp'	THEN 'WHATS'
							WHEN IMAPS_OCO = 'EMAIL'									THEN 'EMAIL'
							WHEN IMAPS_OCO = 'SMS'										THEN 'SMS'
							ELSE 'DISCADOR'
						END
,	SEGMENTACAO		=	DESCR_SEG
,	ATRASO			=	ATRASO
INTO #CONSOLIDADO
FROM #ACIONAMENTO_NECTAR

UNION ALL

SELECT
	CARTEIRA		=	'VELOE'
,	CPF				=	CPF_CNPJ
,	DATA			=	CONVERT(DATETIME,DATA)
,	CANAL
,	SEGMENTACAO
,	ATRASO			=	DIAS_ATRASO
FROM #CHAMADAS
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: PEGA ÚLTIMO ACIONAMENTO DO CPF												    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #ULTIMO_ACIONAMENTO
SELECT 
	CPF				
,	DATA_ULT_ACIO	=	MAX(DATA_ULT_ACIO)
,	CANAL
INTO #ULTIMO_ACIONAMENTO
FROM #CONSOLIDADO
GROUP BY CPF,CANAL
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: FLEGA ÚLTIMO ACIONAMENTO POR CANAL											    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #FLAG
SELECT *
,	RW	=	ROW_NUMBER() OVER(PARTITION BY CPF ORDER BY DATA_ULT_ACIO DESC)
INTO #FLAG
FROM #ULTIMO_ACIONAMENTO
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: REMOVE E DEIXA SÓ O ACIOAMENTO MAIS RECENTE POR CPF E CANAL					    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	DELETE FROM #FLAG WHERE RW > 1
	ALTER TABLE #FLAG DROP COLUMN RW
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: BASE DE TELEFONE DA CARTEIRA													    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
IF OBJECT_ID ('TEMPDB.DBO.#BASE_TELEFONE') IS NOT NULL DROP TABLE #BASE_TELEFONE  
SELECT * 
INTO #BASE_TELEFONE 
FROM OPENQUERY([10.251.1.36],'
SELECT DISTINCT    
 CGCPF_DEV AS CPF  
,IDCON_CON AS ID_CONTR  
,IDEMP_CON  
,CONCAT (DDD_TEL, TELEF_TEL) AS TELEFONE  
,STATU_TEL AS STATUS  
,DTATU_TEL AS DATA_ALT  
,TPTEL_TEL  
,SCORE_TEL AS SCORE  
,CAHOT_TEL AS HOT  
,PREFE_TEL AS PREF    
FROM NECTAR.DBO.TB_TELEFONE C WITH(NOLOCK)  
INNER JOIN NECTAR.DBO.TB_CONTRATO A WITH(NOLOCK) ON IDCON_CON = IDORI_TEL
INNER JOIN NECTAR.DBO.TB_DEVEDOR B WITH(NOLOCK)  ON IDDEV_CON = IDDEV_DEV
LEFT JOIN NECTAR.DBO.TB_BLACKLIST D WITH(NOLOCK) ON DDD_TEL   = DDD_BLK AND TELEF_TEL = TELEF_BLK
WHERE IDEMP_CON = 15
AND IDBLK_BLK IS NULL
')     
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: LAYOUT FINAL SOLICITADO PELO SETRA											    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #TESTE
SELECT *
INTO #TESTE
FROM (
		SELECT 
			CARTEIRA		=	'VELOE'
		,	CPF				=	X.CPF_CNPJ
		,   DT_IMPORTACAO	=	X.DT_IMPORTACAO
		,	DATA_ULT_ACIO	=	Y.DATA_ULT_ACIO
		,	CANAL			=	Y.CANAL
		,	SEGMENTACAO		=	X.SEGMENTACAO
		,	ATRASO			=	X.DIAS_ATRASO
		,	TELEFONE		=	ISNULL(Z.TELEFONE,'BLACKLIST')
		,	RW				=	ROW_NUMBER() OVER(PARTITION BY X.CPF_CNPJ ORDER BY X.CPF_CNPJ DESC)
		FROM #CARTEIRA			 X
		LEFT JOIN #FLAG			 Y ON (Y.CPF = X.CPF_CNPJ)
		LEFT JOIN #BASE_TELEFONE Z ON (Z.CPF = X.CPF_CNPJ)
	  )X
WHERE RW <= 5
AND (
		 DATA_ULT_ACIO IS NULL
	  OR CANAL IS NULL
)


