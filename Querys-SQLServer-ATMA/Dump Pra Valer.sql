USE [Data_Science]
GO


/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* PROGRAMADOR: KAIKE NATAN										                                */
/* VERSAO     : DATA: 18/03/2022																*/
/* DESCRICAO  : RESPONSÁVEL POR ATUALIZAR O DUMP DA PRA VALER D-1					  		    */
/*																								*/
/*	ALTERACAO                                                                                   */
/*        2. PROGRAMADOR: KAIKE NATAN										 DATA: 21/03/2022	*/		
/*           DESCRICAO  : NOVO LAYOUT DO CLIENTE												*/
/*	ALTERACAO                                                                                   */
/*        3. PROGRAMADOR: KAIKE NATAN										 DATA: 24/03/2022	*/		
/*           DESCRICAO  : ROW NUMBER DA TABELA DE BAIXA E TRANSAÇÃO								*/
/*	ALTERACAO                                                                                   */
/*        4. PROGRAMADOR: KAIKE NATAN										 DATA: 25/03/2022	*/		
/*           DESCRICAO  : TIRANDO FUNDO DE FINANCIAMENTO 0										*/
/*	ALTERACAO                                                                                   */
/*        5. PROGRAMADOR: KAIKE NATAN										 DATA: 27/04/2022	*/		
/*           DESCRICAO  : ESTRUTURAÇÃO DO LAYOUT PARA PEGAR TODAS AS DISCAGENS					*/
/*	ALTERACAO                                                                                   */
/*        6. PROGRAMADOR: KAIKE NATAN 										 DATA: 29/04/2022	*/		
/*           DESCRICAO  : RESTRUTURAÇÃO DO LAYOUT PARA TER A VISÃO CARGA DIA					*/
/*	ALTERACAO                                                                                   */
/*        7. PROGRAMADOR: KAIKE NATAN										 DATA: 05/05/2022	*/		
/*           DESCRICAO  : IF PARA QUE O PROCESSO SÓ EXECUTE DE SEG A SABÁDO						*/
/*	ALTERACAO                                                                                   */
/*        8. PROGRAMADOR: KAIKE NATAN										 DATA: 06/05/2022	*/		
/*           DESCRICAO  : INCLUSÂO DO WHILE PARA FOTOGRAFIA COMPLETA COM TODOS OS CONTRATOS 	*/
/*	ALTERACAO                                                                                   */
/*        9. PROGRAMADOR: 													 DATA: __/__/____	*/		
/*           DESCRICAO  :										 								*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	VARIÁVEL DE CONTROLE														    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
BEGIN TRANSACTION
	DECLARE @D1   VARCHAR(50)			=    CONCAT(CONVERT(DATE,GETDATE()-1),' ' + '00:00:00.000')
	DECLARE @D2   VARCHAR(50)			=    CONCAT(CONVERT(DATE,GETDATE()-1),' ' + '23:59:59.599')
	DECLARE @IP   VARCHAR(13)			=   '[10.251.1.36]'
	DECLARE @TSQL VARCHAR(MAX)
	DECLARE @MENSAGEM VARCHAR(MAX)		=	'PROCESO MÃO DEVE SER INICIADO, HOJE É DOMINGO!'
	DECLARE @ID_CARTEIRA VARCHAR(MAX)	=	16
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: QUANDO PROCESSOR EXECUTAR NA SEGUNDA, SETA VARIÁVEL PARA SEXTA					*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	IF(DATEPART(DW,GETDATE()) = 2)
		BEGIN
			SET @D1 = CONCAT(CONVERT(DATE,GETDATE()-2), ' 00:00:00.000')
		END
	IF(DATEPART(DW,GETDATE()) = 2)
		BEGIN
			SET @D2 = CONCAT(CONVERT(DATE,GETDATE()-2), ' 23:59:59.599')
		END
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: BASE ATIVA																	    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS ##TRA 
SET @TSQL = 'SELECT * INTO ##TRA FROM OPENQUERY('+@IP+',
''SELECT  
	IDCON_TRA
,	AGENC_TRA
FROM [NECTAR].[DBO].TB_TRANSACAO WITH(NOLOCK)
JOIN [NECTAR].[DBO].TB_CONTRATO  WITH(NOLOCK) ON  IDCON_TRA = IDCON_CON  
WHERE IDEMP_CON = '''''+@ID_CARTEIRA+'''''
AND AGENC_TRA != 0'')'
EXEC (@TSQL)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	BASE BAIXADA																    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS ##BAI 
SET @TSQL = 'SELECT * INTO ##BAI FROM OPENQUERY('+@IP+',
''SELECT DISTINCT
	IDCON_BAI
,	AGENC_BAI
FROM [NECTAR].[DBO].TB_BAIXA	 WITH(NOLOCK)
JOIN [NECTAR].[DBO].TB_CONTRATO  WITH(NOLOCK) ON IDCON_BAI = IDCON_CON 
WHERE IDEMP_CON = '''''+@ID_CARTEIRA+'''''
AND AGENC_BAI != 0'')'
EXEC (@TSQL)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	CRIA TABELA DE UNIFICAÇÃO													    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
IF OBJECT_ID('TEMPDB.DBO.#AUX_TRANSACAO','U') IS NOT NULL
DROP TABLE #AUX_TRANSACAO 
CREATE TABLE #AUX_TRANSACAO		
								(			
									IDCON_TRA VARCHAR(MAX) NULL ,
									AGENC_TRA CHAR(50)  NULL 
								)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: LAYOUT FINAL UNFICANDO AS 2 E JÁ DEIXA COMO LAYOUT PARA CÓDIGO ABAIXO			    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
INSERT INTO #AUX_TRANSACAO

SELECT * FROM ##TRA

UNION ALL

SELECT * FROM ##BAI
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: CARTEIRA DO PERIODO DA PROCEDURE												    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #BASE
SELECT DISTINCT 
	X.*
,	Y.AGENC_TRA
INTO #BASE
FROM  DATA_SCIENCE.DBO.TB_DS_FOTOGRAFIA_PRA_VALER_CONSOLIDADO_DIA X
JOIN  #AUX_TRANSACAO Y ON Y.IDCON_TRA = X.ID_CONTRATO
WHERE ATUALIZACAO BETWEEN CONVERT(DATE,@D1) AND CONVERT(DATE,@D2)
AND DESCR_SIT != 'QUITADO'
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: LAYOUT DA CARTEIRA DE ACORDO COM DUMP DO CLIENTE									*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #CARTEIRA
SELECT 
	DT_INFO			=	CONVERT(DATE,ATUALIZACAO)
,	ID_CONTRATO
,	CPF_CNPJ
,	AGENC_TRA
,	RATING
,	SALDO			=	SUM(SALDO) 
INTO #CARTEIRA
FROM #BASE
GROUP BY 
	CONVERT(DATE,ATUALIZACAO)
,	ID_CONTRATO
,	CPF_CNPJ
,	AGENC_TRA
,	RATING
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: PEGA O ANALITICO DA PRODUÇÃO DO DIA											    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
IF OBJECT_ID ('TEMPDB.DBO.##PROD') IS NOT NULL DROP TABLE ##PROD 
SET @TSQL = 'SELECT * INTO ##PROD FROM OPENQUERY('+@IP+',
''SELECT DISTINCT
	DTAND_AND
,	IDAND_AND
,	IMAPS_OCO
,	IDCON_AND		=	CONVERT(VARCHAR(MAX),IDCON_AND)
,	IDCON_CON
,	DESCR_OCO
,	CGCPF_DEV
,	DTATR_CON
,	IDEMP_CON
,	IDOCO_AND
,	VLSAL_CON 
FROM	   NECTAR.DBO.TB_ANDAMENTO 	WITH(NOLOCK)
INNER JOIN NECTAR.DBO.TB_CONTRATO 	WITH(NOLOCK) ON IDCON_CON = IDCON_AND
INNER JOIN NECTAR.DBO.TB_DEVEDOR	WITH(NOLOCK) ON IDDEV_DEV = IDDEV_CON
INNER JOIN NECTAR.DBO.TB_OCORRENCIA	WITH(NOLOCK) ON IDOCO_OCO = IDOCO_AND
WHERE IDEMP_CON = '''''+@ID_CARTEIRA+'''''
AND IMAPS_OCO <> ''''''''
AND DTAND_AND >= '''''+@D1+''''' AND DTAND_AND <= '''''+@D2+'''''
'')'
EXEC (@TSQL)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: PEGA O ANALITICO DA PRODUÇÃO DO DIA, JUNTANDO COM O FUNDO DE FINANCIAMENTO		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #TABULACAO
SELECT 
	 X.*
,	 Y.AGENC_TRA
INTO #TABULACAO
FROM	  ##PROD X 
JOIN #AUX_TRANSACAO Y ON (Y.IDCON_TRA = IDCON_AND)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: MARCA OS DUPLICADOS															    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #VALIDA
SELECT *
,	RW		=	ROW_NUMBER() OVER(PARTITION BY IDAND_AND ORDER BY IDCON_CON DESC)
INTO #VALIDA
FROM #TABULACAO
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: DELETA OS DUPLICADOS															    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	DELETE FROM #VALIDA WHERE RW > 1
	ALTER TABLE #VALIDA DROP COLUMN RW
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: FAZ A PARTE DE ETL DO ANALITICO ACIMA											    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
IF OBJECT_ID ('TEMPDB.DBO.#TMP') IS NOT NULL DROP TABLE #TMP
SELECT DISTINCT
	DATA		=	CAST(DTAND_AND AS DATE)
,	IDCON_CON
,	A.CGCPF_DEV	
,	FUNDO		=	A.AGENC_TRA
,	CASE																	 
		WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),CONVERT(DATE,DTAND_AND)) < 0						THEN '05 A 30'
		WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),CONVERT(DATE,DTAND_AND)) BETWEEN	0    AND 4		THEN '05 A 30'
		WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),CONVERT(DATE,DTAND_AND)) BETWEEN	5    AND 30		THEN '05 A 30'
		WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),CONVERT(DATE,DTAND_AND)) BETWEEN	31   AND 60		THEN '31 A 60'
		WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),CONVERT(DATE,DTAND_AND)) BETWEEN	61   AND 90		THEN '61 A 90'
		WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),CONVERT(DATE,DTAND_AND)) BETWEEN	91   AND 120	THEN '91 A 120'
		WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),CONVERT(DATE,DTAND_AND)) BETWEEN	121  AND 150	THEN '121 A 150'
		WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),CONVERT(DATE,DTAND_AND)) BETWEEN	151  AND 180	THEN '151 A 180'
		WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),CONVERT(DATE,DTAND_AND)) BETWEEN	181  AND 210	THEN '181 A 210'
		WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),CONVERT(DATE,DTAND_AND)) BETWEEN	211  AND 240	THEN '211 A 240'
		WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),CONVERT(DATE,DTAND_AND)) BETWEEN	241  AND 270	THEN '241 A 270'
		WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),CONVERT(DATE,DTAND_AND)) BETWEEN	271  AND 300	THEN '271 A 300'
		WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),CONVERT(DATE,DTAND_AND)) BETWEEN	301  AND 330	THEN '301 A 330'
		WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),CONVERT(DATE,DTAND_AND)) BETWEEN	331  AND 360	THEN '331 A 360'
		WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),CONVERT(DATE,DTAND_AND)) BETWEEN	361  AND 540	THEN '361 A 540'
		WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),CONVERT(DATE,DTAND_AND)) BETWEEN	541  AND 720	THEN '541 A 720'
		WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),CONVERT(DATE,DTAND_AND)) BETWEEN	721  AND 1080	THEN '721 A 1080'
		WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),CONVERT(DATE,DTAND_AND)) BETWEEN	1081 AND 1440	THEN '1081 A 1440'
		WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),CONVERT(DATE,DTAND_AND)) BETWEEN	1441 AND 1800	THEN '1441 A 1800'
		WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),CONVERT(DATE,DTAND_AND)) > 1800					THEN '1801 A 9999'
	END FAIXA_ATRASO
,	IIF(A.IDOCO_AND = 323 ,1,0) DESCONHECE
,	B.TABULADO ACIONAMENTO
,	B.ALO ALO
,	B.CPC CPC
,	B.CPC_P CPC_P
,	B.ACORDO ACORDO 
,	CASE WHEN A.IDOCO_AND = 1067 THEN 1 ELSE 0 END AS EXCECAO 
,	CASE WHEN A.IDOCO_AND = 604 THEN 1 ELSE 0 END  AS NEGOCIACAO 
,	CONVERT(MONEY,VLSAL_CON) AS VLSAL_CON
INTO #TMP
--FROM #TABULACAO A
FROM #VALIDA A
LEFT  JOIN REPORTS.DBO.AUX_DEXPARA_ATMA B ON B.IDOCO_DXP = A.IDOCO_AND
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: LEVANTA BASE DE COBRANÇA DA CARTEIRA INTEIRA									    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS ##PRE_CHAMADA
SET @TSQL = 'SELECT * INTO ##PRE_CHAMADA FROM OPENQUERY('+@IP+',''
 SELECT 
 IDCON_CON		=	CONVERT(VARCHAR(MAX),IDCON_CON)
,CONTR_CON
,DTATR_CON	
,CGCPF_DEV
,VLSAL_CON
FROM	  NECTAR.DBO.TB_CONTRATO	WITH(NOLOCK) 
JOIN	  NECTAR.DBO.TB_DEVEDOR		WITH(NOLOCK) ON IDDEV_DEV = IDDEV_CON
LEFT JOIN  (
				SELECT DISTINCT
				IDCON_TRA
			   ,IDDOC_TRA
			   ,FLAG		=	''''TRA''''
				FROM	   NECTAR.DBO.TB_TRANSACAO WITH(NOLOCK)
				INNER JOIN NECTAR.DBO.TB_CONTRATO  WITH(NOLOCK) ON IDCON_TRA = IDCON_CON AND IDEMP_CON = '''''+@ID_CARTEIRA+'''''
				WHERE AGENC_TRA != ''''0''''
				UNION ALL
				SELECT DISTINCT
				IDCON_BAI
			   ,IDDOC_BAI
			   ,FLAG		=	''''BAI''''
				FROM	   NECTAR.DBO.TB_BAIXA	   WITH(NOLOCK)
				INNER JOIN NECTAR.DBO.TB_CONTRATO  WITH(NOLOCK) ON IDCON_BAI = IDCON_CON AND IDEMP_CON = '''''+@ID_CARTEIRA+'''''
				WHERE AGENC_BAI != ''''0''''
			) T ON T.IDCON_TRA = IDCON_CON

LEFT JOIN NECTAR.DBO.TB_DOCUMENTO	WITH(NOLOCK) ON IDDOC_DOC = IDDOC_TRA  
WHERE IDEMP_CON = '''''+@ID_CARTEIRA+''''' '')'
EXEC (@TSQL)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: IDENTIFICADOR DE FILAS DA PRAVALER											    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
IF OBJECT_ID ('TEMPDB..#FILAS') IS NOT NULL DROP TABLE #FILAS
SELECT DISTINCT *
INTO #FILAS
FROM OPENQUERY([10.251.2.18],'SELECT * FROM replica_atmspbb1.queues')
WHERE NOME LIKE 'PRAVA%'
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: BUSCA O ANALITICO DE CHAMADAS													    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
IF OBJECT_ID ('TEMPDB.DBO.#CALL') IS NOT NULL DROP TABLE #CALL
SELECT 
		DATA			=	 A.DATA
,		CPF				=	 C.CGCPF_DEV
,		IDCON_CON		=	 C.IDCON_CON
,		DISCAGENS		=	 A.UNIQUEID 
,		VLSAL_CON		=	 C.VLSAL_CON
,		FUNDO			=	 B.AGENC_TRA
,		FAIXA_ATRASO	=
							 CASE																	 
							 	 WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),A.DATA) BETWEEN -9999  AND 4		THEN '05 A 30'
							 	 WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),A.DATA) BETWEEN	0    AND 4		THEN '05 A 30'
							 	 WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),A.DATA) BETWEEN	5    AND 30		THEN '05 A 30'
							 	 WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),A.DATA) BETWEEN	31   AND 60		THEN '31 A 60'
							 	 WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),A.DATA) BETWEEN	61   AND 90		THEN '61 A 90'
							 	 WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),A.DATA) BETWEEN	91   AND 120	THEN '91 A 120'
							 	 WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),A.DATA) BETWEEN	121  AND 150	THEN '121 A 150'
							 	 WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),A.DATA) BETWEEN	151  AND 180	THEN '151 A 180'
							 	 WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),A.DATA) BETWEEN	181  AND 210	THEN '181 A 210'
							 	 WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),A.DATA) BETWEEN	211  AND 240	THEN '211 A 240'
							 	 WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),A.DATA) BETWEEN	241  AND 270	THEN '241 A 270'
							 	 WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),A.DATA) BETWEEN	271  AND 300	THEN '271 A 300'
							 	 WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),A.DATA) BETWEEN	301  AND 330	THEN '301 A 330'
							 	 WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),A.DATA) BETWEEN	331  AND 360	THEN '331 A 360'
							 	 WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),A.DATA) BETWEEN	361  AND 540	THEN '361 A 540'
							 	 WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),A.DATA) BETWEEN	541  AND 720	THEN '541 A 720'
							 	 WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),A.DATA) BETWEEN	721  AND 1080	THEN '721 A 1080'
							 	 WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),A.DATA) BETWEEN	1081 AND 1440	THEN '1081 A 1440'
							 	 WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),A.DATA) BETWEEN	1441 AND 1800	THEN '1441 A 1800'
							 	 WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),A.DATA) > 1800					THEN '1801 A 9999'
							 END 
INTO #CALL 
FROM DATA_SCIENCE.DBO.TB_DS_CALLFLEX_MES A 
JOIN ##PRE_CHAMADA	 C	ON C.IDCON_CON  =  A.IDCRM 
JOIN #AUX_TRANSACAO  B	ON B.IDCON_TRA  =  A.IDCRM
JOIN #FILAS			 D	ON D.FILA		=  A.FILA
WHERE 
	A.DATA BETWEEN CONVERT(DATE,@D1) AND CONVERT(DATE,@D2)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: MARCA OS DUPLICADOS															    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #DUPLICADOS
SELECT *
,	RW	= ROW_NUMBER() OVER (PARTITION BY DISCAGENS ORDER BY DISCAGENS DESC)
INTO #DUPLICADOS 
FROM #CALL
ORDER BY RW DESC
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: REMOVE OS DUPLICADOS															    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DELETE FROM #DUPLICADOS
WHERE RW > 1

ALTER TABLE #DUPLICADOS
DROP COLUMN RW
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: FAZ A MODELAGEM DAS TABULAÇÕES												    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
IF OBJECT_ID ('TEMPDB.DBO.#FINAL') IS NOT NULL DROP TABLE #FINAL
SELECT 
	DATA					 =		CAST(A.DATA AS DATE)
,	LIGA					 =		A.FAIXA_ATRASO
,	CPF_DEV					 =		A.CGCPF_DEV
,	FUNDO					 =		A.FUNDO
,	SALDO					 =		A.VLSAL_CON
,	IDCON_CON				 =		A.IDCON_CON
,	DESCONHECE				 =		COUNT(CASE WHEN DESCONHECE > 0													THEN A.CGCPF_DEV   ELSE NULL END)
,	DESCONHECE_UNIQ			 =		COUNT(DISTINCT CASE WHEN DESCONHECE > 0											THEN A.CGCPF_DEV   ELSE NULL END)
,   ACIONAMENTO				 =		COUNT(CASE WHEN ACIONAMENTO > 0													THEN A.CGCPF_DEV   ELSE NULL END)
,   ACIONAMENTO_UNIQ		 =		COUNT(DISTINCT CASE WHEN ACIONAMENTO > 0										THEN A.CGCPF_DEV   ELSE NULL END)
,	ALO						 =		COUNT(CASE WHEN ALO > 0															THEN A.CGCPF_DEV   ELSE NULL END)
,	ALO_UNIQ				 =		COUNT(DISTINCT CASE WHEN ALO > 0												THEN A.CGCPF_DEV   ELSE NULL END)
,	CPC						 =		COUNT(CASE WHEN CPC > 0 														THEN A.CGCPF_DEV   ELSE NULL END) 
,	CPC_UNIQ				 =		COUNT(DISTINCT CASE WHEN CPC > 0 												THEN A.CGCPF_DEV   ELSE NULL END)
,	ACORDO					 =		COUNT(CASE WHEN ACORDO > 0														THEN A.CGCPF_DEV   ELSE NULL END) 
,	ACORDO_UNIQ				 =		COUNT(DISTINCT CASE WHEN ACORDO > 0												THEN A.CGCPF_DEV   ELSE NULL END) 
,	NEGOCIACAO				 =		COUNT(CASE WHEN A.NEGOCIACAO > 0 AND A.ACORDO = 0 AND A.EXCECAO = 0				THEN A.CGCPF_DEV   ELSE NULL END) 
,	NEGOCIACAO_UNIQ			 =		COUNT(DISTINCT CASE WHEN A.NEGOCIACAO > 0 AND A.ACORDO = 0 AND A.EXCECAO = 0    THEN A.CGCPF_DEV   ELSE NULL END) 
,	EXCECAO					 =		COUNT(CASE WHEN EXCECAO > 0 AND ACORDO = 0										THEN A.CGCPF_DEV   ELSE NULL END)
,	EXCECAO_UNIQ			 =		COUNT(DISTINCT CASE WHEN EXCECAO > 0 AND ACORDO = 0								THEN A.CGCPF_DEV   ELSE NULL END) 
,	VLSAL_ACO				 =		SUM(CASE WHEN ACORDO > 0														THEN A.VLSAL_CON   ELSE 0	 END) 
,	VLSAL_NEG				 =		SUM(CASE WHEN A.NEGOCIACAO > 0 AND A.ACORDO = 0 AND A.EXCECAO = 0				THEN A.VLSAL_CON   ELSE 0	 END) 
,	VLSAL_EXE				 =		SUM(CASE WHEN EXCECAO > 0 AND ACORDO = 0										THEN A.VLSAL_CON   ELSE 0	 END)  
INTO #FINAL
FROM  #TMP A
GROUP BY 
	A.DATA
,	A.FAIXA_ATRASO
,	A.CGCPF_DEV
,	A.FUNDO
,	A.VLSAL_CON
,	A.IDCON_CON
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: DEIXA A TABELA DE CHAMADAS SINTÉTICA POR CLUSTER								    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #CALL_USAR
SELECT 
		DATA
,		FAIXA_ATRASO
,		CPF
,		FUNDO
,		VLSAL_CON
,		IDCON_CON
,		DISCAGENS			=	COUNT(DISTINCT DISCAGENS)
,		DISCAGENS_UNIQ		=	COUNT(DISTINCT CPF)
INTO #CALL_USAR
FROM #CALL
GROUP BY
		DATA
,		FAIXA_ATRASO
,		CPF
,		FUNDO
,		VLSAL_CON
,		IDCON_CON
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: UNIFICAÇÃO DAS 3 BASES, CARTEIRA, TABULAÇÃO E CHAMADAS						    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS ##FINAL
SELECT 
		DATA				=	CARTEIRA.DT_INFO
,		CPF					=	CARTEIRA.CPF_CNPJ
,		FUNDO				=	CARTEIRA.AGENC_TRA
,		FAIXA_ATRASO		=	CARTEIRA.RATING
,		VLSAL_CON			=	CARTEIRA.SALDO
,		DISCAGENS			=	CHAMADA.DISCAGENS
,		DISCAGENS_UNIQ		=	CHAMADA.DISCAGENS_UNIQ
,		DESCONHECE			=	TABULACAO.DESCONHECE
,		DESCONHECE_UNIQ		=	TABULACAO.DESCONHECE_UNIQ
,		ACIONAMENTO			=	TABULACAO.ACIONAMENTO
,		ACIONAMENTO_UNIQ	=	TABULACAO.ACIONAMENTO_UNIQ
,		ALO					=	TABULACAO.ALO
,		ALO_UNIQ			=	TABULACAO.ALO_UNIQ
,		CPC					=	TABULACAO.CPC
,		CPC_UNIQ			=	TABULACAO.CPC_UNIQ
,		ACORDO				=	TABULACAO.ACORDO
,		ACORDO_UNIQ			=	TABULACAO.ACORDO_UNIQ
,		NEGOCIACAO			=	TABULACAO.NEGOCIACAO
,		NEGOCIACAO_UNIQ		=	TABULACAO.NEGOCIACAO_UNIQ
,		EXCECAO				=	TABULACAO.EXCECAO
,		EXCECAO_UNIQ		=	TABULACAO.EXCECAO_UNIQ
INTO ##FINAL
FROM #CARTEIRA		 CARTEIRA	
LEFT JOIN #FINAL	 TABULACAO  ON	(TABULACAO.IDCON_CON  =  CARTEIRA.ID_CONTRATO) 
								AND (TABULACAO.DATA		  =	 CARTEIRA.DT_INFO	 )

LEFT JOIN #CALL_USAR CHAMADA	ON  (CHAMADA.IDCON_CON    =	 CARTEIRA.ID_CONTRATO) 
								AND (CHAMADA.DATA		  =	 CARTEIRA.DT_INFO 	 )
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: LAYOUT SOLICTADO PELO CLIENTE PRA VALER										    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS ##BCP
SELECT * INTO ##BCP
FROM (
		SELECT 
		EMPRESA				=		ISNULL('ATMA'																				,0)
	,	DATA				=		ISNULL(CAST(F.DATA	AS VARCHAR(MAX))														,0)
	,	CPF_DEV				=		ISNULL(F.CPF																				,0)
	,	FUNDO				=		ISNULL(F.FUNDO																				,0)
	,	FAIXA_ATRASO		=		ISNULL(F.FAIXA_ATRASO																		,0)
	,	SALDO				=		ISNULL(CAST(F.VLSAL_CON															AS VARCHAR)	,0)
	,	DISCAGEM			=		ISNULL(CAST(IIF(ACIONAMENTO > 0 AND DISCAGENS = 0,1,DISCAGENS)				    AS VARCHAR)	,0)
	,	ACIONAMENTO			=		ISNULL(CAST(ACIONAMENTO															AS VARCHAR)	,0)
	,	ALO					=		ISNULL(CAST(ALO																	AS VARCHAR)	,0)
	,	DESCONHECE			=		ISNULL(CAST(DESCONHECE														    AS VARCHAR)	,0)
	,	CPC					=		ISNULL(CAST(F.CPC															    AS VARCHAR)	,0)
	,	PROMESSA			=		ISNULL(CAST(F.ACORDO + F.NEGOCIACAO + EXCECAO								    AS VARCHAR)	,0)
	,	DISCAGENS_UNIQUE	=		ISNULL(CAST(IIF(F.DISCAGENS_UNIQ >= 1, 1, 0)								    AS VARCHAR)	,0)
	,	ACIONAMENTO_UNIQUE  =		ISNULL(CAST(IIF(F.ACIONAMENTO_UNIQ >= 1, 1, 0)								    AS VARCHAR)	,0)
	,	ALO_UNIQUE			=		ISNULL(CAST(IIF(F.ALO_UNIQ >= 1, 1, 0)										    AS VARCHAR)	,0)
	,	DESCONHECE_UNIQUE	=		ISNULL(CAST(IIF(F.DESCONHECE_UNIQ >= 1, 1, 0)								    AS VARCHAR)	,0)
	,	CPC_UNIQUE			=		ISNULL(CAST(IIF(F.CPC_UNIQ >= 1, 1, 0)										    AS VARCHAR)	,0)
	,	PROMESSA_UNIQUE		=		ISNULL(CAST(IIF(F.ACORDO_UNIQ + F.NEGOCIACAO_UNIQ + F.EXCECAO_UNIQ >= 1, 1, 0)	AS VARCHAR)	,0)
	,	ID_C				=		ISNULL(2																					,0)
		FROM ##FINAL F

		UNION  

		SELECT 
		EMPRESA				=		'EMPRESA'
   ,	DATA				=		'DATA'
   ,	CPF_DEV				=		'CPF_DEV'
   ,	FUNDO				=		'FUNDO'
   ,	FAIXA_ATRASO		=		'FAIXA_ATRASO'
   ,	SALDO				=		'SALDO'
   ,	DISCAGEM			=		'DISCAGEM'			
   ,	ACIONAMENTO			=		'ACIONAMENTO'			
   ,	ALO					=		'ALO'					
   ,	DESCONHECE			=		'DESCONHECE'			
   ,	CPC					=		'CPC'					
   ,	PROMESSA			=		'PROMESSA'			
   ,	DISCAGENS_UNIQUE	=		'DISCAGENS_UNIQUE'	
   ,	ACIONAMENTO_UNIQUE	=		'ACIONAMENTO_UNIQUE'	
   ,	ALO_UNIQUE			=		'ALO_UNIQUE'			
   ,	DESCONHECE_UNIQUE	=		'DESCONHECE_UNIQUE'	
   ,	CPC_UNIQUE			=		'CPC_UNIQUE'			
   ,	PROMESSA_UNIQUE		=		'PROMESSA_UNIQUE'	
   ,	ID_C				=		1  

) A
COMMIT TRANSACTION
----------------------------------------------------------------- EXPORTA BCP PARA A PASTA -----------------------------------------------------------------
SET LANGUAGE 'BRAZILIAN'

DECLARE @DATA VARCHAR(20)					=	(SELECT REPLACE(CONVERT(VARCHAR(20),CONVERT(DATE,@D1) ,103),'/',''))
IF (DATEPART(DW,GETDATE()) = 2)	SET @DATA	=	(SELECT REPLACE(CONVERT(VARCHAR(20),GETDATE() -2 ,103),'/',''))
DECLARE @NOMENCLATURA_DISPARO VARCHAR(MAX)	=	'DUMP_PRA_VALER_'+@DATA+'.txt'

SET @TSQL = 'master..xp_cmdshell ''bcp "SELECT EMPRESA,DATA,CPF_DEV,FUNDO,FAIXA_ATRASO,SALDO,DISCAGEM,ACIONAMENTO,ALO,DESCONHECE,CPC,PROMESSA,DISCAGENS_UNIQUE,ACIONAMENTO_UNIQUE,ALO_UNIQUE,DESCONHECE_UNIQUE,CPC_UNIQUE,PROMESSA_UNIQUE FROM ##BCP ORDER BY ID_C ASC" queryout "\\polaris\NectarServices\Administrativo\Temporario\PraValer\Dump"\'+@NOMENCLATURA_DISPARO+' -c -T '''
EXEC (@TSQL)

DROP TABLE IF EXISTS ##FINAL
DROP TABLE IF EXISTS ##BCP

/*
-- Utilizando queryout, pode-se exportar o resultado de uma query
EXEC master.dbo.xp_cmdshell 'bcp "SELECT * FROM ##FINAL" queryout "\\polaris\NectarServices\Administrativo\Temporario\PraValer\Dump.csv" -c -T'

-- Utilizando out, pode-se exportar um objeto
EXEC master.dbo.xp_cmdshell 'bcp [Data_science].[dbo].[teste] out "C:\Users\kaike.santana.csv" -c -T'
*/



