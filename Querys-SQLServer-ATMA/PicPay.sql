
USE [Reports]
GO

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* PROGRAMADOR: MARCOS CASTRO								                                    */
/* VERSAO     : DATA: 28/03/2022																*/
/* DESCRICAO  : FUNIL CAMPANHAS ORIGINAL														*/
/*																								*/
/*	ALTERACAO                                                                                   */
/*        2. PROGRAMADOR: MARCOS CASTRO										DATA: 30/03/2022	*/		
/*           DESCRICAO  : INCLUSAO DISCAGEM VISÃO CALLFLEX 										*/
/*	ALTERACAO                                                                                   */
/*        3. PROGRAMADOR: KAIKE NATAN										DATA: 19/04/2022	*/		
/*           DESCRICAO  : REMOÇÃO DOS DUPLICADOS DO ANALITICO 									*/
/*	ALTERACAO                                                                                   */
/*        4. PROGRAMADOR: KAIKE NATAN										DATA: 27/04/2022	*/		
/*           DESCRICAO  : INCLUSÃO DAS 5 OCORRENCIAS PASSADA PELA CAMILA COMO ACORDO			*/
/*	ALTERACAO                                                                                   */
/*        5. PROGRAMADOR:													DATA: __/__/____	*/		
/*           DESCRICAO  :									 									*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	--ALTER   PROC [dbo].[PRC_DS_REPORT_CAMPANHA_ORIGINAL] AS
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :VARIAVÉIS DO CÓDIGO															    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	DECLARE @D1 VARCHAR(20)		= CONCAT(CONVERT(DATE,GETDATE()-22), ' 00:00:00')
	DECLARE @D2 VARCHAR(20)		= CONCAT(CONVERT(DATE,GETDATE()-2), ' 23:59:59')
	DECLARE @TSQL VARCHAR(8000)
	DECLARE @IP VARCHAR(13)		= '[10.251.1.36]'
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :SETA AS VARIÁVEIS PARA PEGAR SEG A SEXTA											*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	/*IF(DATEPART(DW,@D1) = 1)
		BEGIN
			SET @D1 = CONCAT(CONVERT(DATE,GETDATE()-3), ' 00:00:00')
		END
	IF(DATEPART(DW,@D2) = 1)
		BEGIN
			SET @D2 = CONCAT(CONVERT(DATE,GETDATE()-3), ' 23:59:59')
		END*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :IDENTIFICADOR DE FILAS														    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #FILAS
SELECT  
 A.*
,EMPRESA	=	CASE
					WHEN NOME LIKE '%ORIGINAL%'		THEN 'BANCO ORIGINAL'
					WHEN NOME LIKE '%PAY%'			THEN 'PIC PAY'
					WHEN NOME LIKE '%VERDE%'		THEN 'BANCO ORIGINAL' ELSE 'OUTROS' 
				END 
INTO #FILAS
FROM OPENQUERY([10.251.2.18],'SELECT * FROM replica_atmspbb1.queues') A
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :ANALITICO DE CHAMADAS														    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #CHAMADAS
SELECT 
	DATA
,	HORA
,	DDD
,	ORIGEM
,	DOC
,	IDCRM
,	DURACAO
,	CONVERSADO
,	CLASSE_ORDER
,	AGENTE
,	STATUS
,	STATUSATENDIMENTO
,	ISDNCAUSE
,	TIPO
,	A.FILA
,	NOME_FILA			=	B.NOME
,	TERMINATOR
INTO #CHAMADAS
FROM DATA_SCIENCE.DBO.TB_DS_CALLFLEX_MES A WITH(NOLOCK) JOIN #FILAS B ON A.FILA = B.FILA
WHERE CALLDATE BETWEEN @D1 AND @D2
AND LEN(ORIGEM) != 5
AND B.EMPRESA IN ('PIC PAY')
AND A.FILA NOT LIKE '%Recept%' 
AND A.FILA NOT LIKE '%Transbord%'
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :ANALITICO DE PRODUTIVIDADE													    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS ##PROD_ORIGINAL
SELECT  @TSQL = 
'SELECT * INTO ##PROD_ORIGINAL FROM 
OPENQUERY('+@IP+',
''SELECT DISTINCT
	DTAND_AND
,	IDAND_AND
,	IMAPS_OCO
,	IDCON_AND
,	DESCR_OCO
,	CGCPF_DEV
,	DTATR_CON
,	IDEMP_CON
,	IDOCO_AND
,	SUB_TABULACAO		= SUBOC_AND
,	ORIGE_AND
FROM	   NECTAR.DBO.TB_ANDAMENTO 	WITH(NOLOCK)
INNER JOIN NECTAR.DBO.TB_CONTRATO 	WITH(NOLOCK) ON IDCON_CON = IDCON_AND
INNER JOIN NECTAR.DBO.TB_DEVEDOR	WITH(NOLOCK) ON IDDEV_DEV = IDDEV_CON
INNER JOIN NECTAR.DBO.TB_OCORRENCIA	WITH(NOLOCK) ON IDOCO_OCO = IDOCO_AND 
INNER JOIN NECTAR.DBO.TB_PESSOAL	WITH(NOLOCK) ON IDPES_PES = IDPES_AND 
WHERE IDEMP_CON IN (9,18)
AND DTAND_AND BETWEEN '''''+@D1+''''' AND ''''' +@D2+ '''''
AND ALCAD_PES != 9''  )'
EXEC(@TSQL)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :DELETA DUPLICIDADE DA BASE DE PRODUÇÃO											*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #PROD
SELECT 
 * 
,TIPO   = 
			CASE	
				WHEN SUB_TABULACAO LIKE '%Receptivo%' THEN 'Receptivo'
				WHEN SUB_TABULACAO LIKE '%WhatsApp%'  THEN 'WhatsApp'
													  ELSE 'Operacao'
			END
,RW	= ROW_NUMBER () OVER(PARTITION BY CGCPF_DEV, IDOCO_AND,DTAND_AND ORDER BY DTAND_AND ASC)
INTO #PROD
FROM ##PROD_ORIGINAL 

DELETE FROM #PROD WHERE RW > 1
ALTER TABLE #PROD DROP COLUMN RW 
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :ANALITICO IDCRM																	*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS ##IDCON_CON
SELECT  @TSQL = 
'SELECT * INTO ##IDCON_CON FROM 
OPENQUERY('+@IP+',
''SELECT DISTINCT
	IDCON_CON
,	CGCPF_DEV
,	IDEMP_CON
FROM	   NECTAR.DBO.TB_CONTRATO 	
INNER JOIN NECTAR.DBO.TB_DEVEDOR	WITH(NOLOCK) ON IDDEV_DEV = IDDEV_CON 
WHERE IDEMP_CON IN (18,9)'')'
EXEC(@TSQL)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO : BASE DA CAMPANHA																	*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #BASE
SELECT
	CPF
,	CAMPANHA
,	GERENCIAL
,	DT_INFO
,	RW	=	ROW_NUMBER () OVER(PARTITION BY CPF, CAMPANHA, DT_INFO ORDER BY DT_INFO ASC) 
INTO #BASE
FROM PLANNING..TB_PLAN_ORIGINAL_MAILING_CLIENTE 

DELETE FROM #BASE WHERE RW > 1
ALTER TABLE #BASE DROP COLUMN RW 
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :INCLUSAO DE IDCRM NA BASE E EXCLUSAO DE DUPLICIDADE								*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #IDCRM_BASE
SELECT 
 A.* 
,IDCON_CON
,IDEMP_CON
,RW	=	ROW_NUMBER () OVER(PARTITION BY IDCON_CON, CAMPANHA, DT_INFO ORDER BY CPF ASC) 
INTO #IDCRM_BASE
FROM #BASE A
LEFT JOIN ##IDCON_CON B ON CGCPF_DEV = CPF

DELETE FROM #IDCRM_BASE WHERE RW > 1
ALTER TABLE #IDCRM_BASE DROP COLUMN RW 
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: SINTETICO MAILING 																*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
TRUNCATE TABLE REPORTS..TEMP_BASE_SINTETICA_ORIGINAL
INSERT INTO REPORTS..TEMP_BASE_SINTETICA_ORIGINAL
SELECT 
	LOTE		=	CONVERT(DATE,DT_INFO)
,	CAMPANHA	=	UPPER(CAMPANHA)
,	CPF			=	COUNT(DISTINCT CPF) 
,	CONTABIL	=	SUM(CONVERT(MONEY,GERENCIAL))
FROM PLANNING..TB_PLAN_ORIGINAL_MAILING_CLIENTE
GROUP BY
	CONVERT(DATE,DT_INFO)
,	UPPER(CAMPANHA)
ORDER BY 
	CAMPANHA,LOTE DESC
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO:  ANALITICO DAS CHAMADAS PASSANDO PELA BASE DA CAMPANHA							*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #CHAMADAS2
SELECT 
	A.*
,	CAMPANHA	=	UPPER(CAMPANHA)
,	LOTE		=	CAST(DT_INFO AS DATE) 
,	CPF
INTO #CHAMADAS2
FROM #CHAMADAS A
INNER JOIN #IDCRM_BASE B ON CAST(IDCON_CON AS VARCHAR(MAX)) = CAST(IDCRM AS VARCHAR(MAX)) AND DATA >= CAST(DT_INFO AS DATE)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO:	ANALITICO DE PRODUTIVIDADFE PASSANDO PELA BASE DA CAMPANHA					    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #ANALITICO
SELECT DISTINCT 
 DATA			=	CONVERT(DATE,A.DTAND_AND)
,DIA_UTIL
,DT_INFO		=	CONVERT(DATE,B.DT_INFO)
,A.CGCPF_DEV
,CONTABIL		=	CONVERT(MONEY,GERENCIAL)
,OCORRENCIA		=	DESCR_DXP
,TABULADO
,ALO 	
,CPC 	
,CPC_P	
,ACORDO	
,SMS	
,EMAIL	
,URA  	
,CAMPANHA
,A.TIPO
INTO #ANALITICO
FROM #PROD A
INNER JOIN #IDCRM_BASE B ON CGCPF_DEV = CPF AND CONVERT(DATE,DTAND_AND) >= CONVERT(DATE,B.DT_INFO)
LEFT JOIN REPORTS.DBO.AUX_DEXPARA_ATMA C ON IDOCO_DXP = IDOCO_AND
LEFT JOIN DATA_SCIENCE.DBO.TB_DS_CALENDARIO D ON CONVERT(DATE,D.DATA) = CONVERT(DATE,A.DTAND_AND)
WHERE DIA NOT IN ('Domingo')
AND SISTEMA = 0

/****************************************************/

DROP TABLE IF EXISTS #ANALITICO_2
SELECT  *,
RW = ROW_NUMBER() OVER ( PARTITION BY CGCPF_DEV, DATA ORDER BY  CAMPANHA DESC)
INTO #ANALITICO_2
FROM #ANALITICO 

DELETE FROM #ANALITICO_2 WHERE RW > 1
ALTER TABLE #ANALITICO_2 DROP COLUMN RW

/***************************************************/

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :INSERE NA TABELA FISICA DE ANALITICO											    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DELETE FROM REPORTS..TEMP_BASE_ANALITICA_PROD_ORIGINAL WHERE DATA BETWEEN @D1 AND @D2
INSERT INTO REPORTS..TEMP_BASE_ANALITICA_PROD_ORIGINAL
SELECT  * FROM #ANALITICO_2 
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :INSERE NA TABELA FISICA DE ANALITICO											    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DELETE FROM REPORTS..TEMP_BASE_ANALITICA_CHAMADAS_ORIGINAL WHERE DATA BETWEEN @D1 AND @D2
INSERT INTO REPORTS..TEMP_BASE_ANALITICA_CHAMADAS_ORIGINAL
SELECT * FROM #CHAMADAS2	
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :CHAMADAS SINTETICA DIA															*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #CHAMADAS_DIA
SELECT 
	X.DATA
,	X.CAMPANHA
,	LOTE
,	DISCADAS	=	COUNT(ORIGEM)
,	PENETRADO	=	COUNT(DISTINCT CPF)
,	ATENDIDAS	=	COUNT(IIF(ISDNCAUSE = 16, ORIGEM, NULL))
,	TIPO		=	ISNULL(Y.TIPO,'Operacao')
INTO #CHAMADAS_DIA
FROM #CHAMADAS2 X
LEFT JOIN #ANALITICO_2 Y ON Y.CGCPF_DEV = X.CPF AND Y.DATA = X.Data
GROUP BY 
	X.DATA
,	X.CAMPANHA
,	LOTE
,	ISNULL(Y.TIPO,'Operacao')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :CHAMADAS SINTETICA MES															*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #CHAMADAS_MES
SELECT 
 x.CAMPANHA
,LOTE
,DISCADAS	=	COUNT(ORIGEM)
,PENETRADO	=	COUNT(DISTINCT CPF)
,ATENDIDAS	=	COUNT(IIF(ISDNCAUSE = 16, ORIGEM, NULL))
,TIPO		=	ISNULL(Y.SUB_TABULACAO,'Operacao')
INTO #CHAMADAS_MES
FROM REPORTS..TEMP_BASE_ANALITICA_CHAMADAS_ORIGINAL x
LEFT JOIN REPORTS..TEMP_BASE_ANALITICA_PROD_ORIGINAL Y ON Y.CGCPF_DEV = X.CPF AND Y.DATA = X.Data
GROUP BY 
 x.CAMPANHA
,LOTE
,ISNULL(Y.SUB_TABULACAO,'Operacao')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :ANALITICO UNIQUE DIA															    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #UNIQUE_DIA
SELECT 
		A.DATA
,		A.DIA_UTIL
,		A.DT_INFO
,		A.CGCPF_DEV
,		A.TIPO
,		A.OCORRENCIA
,		A.TABULADO
,		A.ALO
,		A.CPC
,		A.CPC_P
,		ACORDO		=	A.ACORDO + A.OCORRENCIAS_ACORDO
,		A.SALDO
,		A.CAMPANHA
INTO #UNIQUE_DIA
FROM (
			SELECT DISTINCT 
			DATA
		,	DIA_UTIL
		,	DT_INFO
		,	CGCPF_DEV
		,	TIPO
		,	OCORRENCIA
		,	TABULADO
		,	ALO
		,	CPC
		,	CPC_P
		,	ACORDO	
		,	OCORRENCIAS_ACORDO	= 	CASE WHEN OCORRENCIA IN ('Ação Sms - Renovação Automatica','Ação Sms Fase 2 - Renovação','Ação Sms Kgiro - Reneg','Ação Sms Kgiro - Renova','Ação Sms Original-renovação','Ação Sms Pic Pay - Renovação') THEN 1 ELSE 0 END 
		,	SALDO				=	IIF(ACORDO = 1, CONTABIL,0)
		,	CAMPANHA
FROM #ANALITICO_2 ) A
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :ANALITICO UNIQUE MES															    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #UNIQUE_MES
SELECT 
	A.DT_INFO
,	A.CGCPF_DEV
,	A.SUB_TABULACAO
,	A.TABULADO
,	A.ALO
,	A.CPC
,	A.CPC_P
,	ACORDO	=	A.ACORDO + A.OCORRENCIAS_ACORDO
,	A.SALDO
,	A.CAMPANHA
INTO #UNIQUE_MES
FROM (
		 SELECT DISTINCT 
		 DT_INFO
		,CGCPF_DEV
		,SUB_TABULACAO
		,TABULADO
		,ALO
		,CPC
		,CPC_P
		,ACORDO
		,SALDO				=	IIF(ACORDO = 1, CONTABIL,0)
		,CAMPANHA
		,OCORRENCIAS_ACORDO	= 	CASE WHEN OCORRENCIA IN ('Ação Sms - Renovação Automatica','Ação Sms Fase 2 - Renovação','Ação Sms Kgiro - Reneg','Ação Sms Kgiro - Renova','Ação Sms Original-renovação','Ação Sms Pic Pay - Renovação') THEN 1 ELSE 0 END 
FROM REPORTS..TEMP_BASE_ANALITICA_PROD_ORIGINAL ) A
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :SINTETICO UNIQUE DIA																*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DELETE FROM REPORTS..TEMP_FUNIL_CAMPANHA_ORIGINAL WHERE DATA BETWEEN @D1 AND @D2
INSERT INTO REPORTS..TEMP_FUNIL_CAMPANHA_ORIGINAL
SELECT
	A.DATA
,	DIA_UTIL
,	A.DT_INFO
,	CAMPANHA	   =	UPPER(A.CAMPANHA)
,	CARTEIRA	   =	CPF
,	CONTABIL	   
,	DISCAGENS	   =	C.DISCADAS
,	PENETRACAO	   =	PENETRADO
,	ATENDIDAS	   =	ATENDIDAS
,	TABULADO	   =	COUNT(DISTINCT IIF(TABULADO = 1,CGCPF_DEV,NULL))
,	ALO				=	COUNT(DISTINCT IIF(ALO = 1,CGCPF_DEV,NULL))
,	CPC				=	COUNT(DISTINCT IIF(CPC = 1,CGCPF_DEV,NULL))
,	CPC_P		   =	COUNT(DISTINCT IIF(CPC_P = 1,CGCPF_DEV,NULL))
,	ACORDO		   =	COUNT(DISTINCT IIF(ACORDO = 1,CGCPF_DEV,NULL))
,	SALDO		   =	SUM(SALDO)
,	SUB_TABULACAO =    A.TIPO
FROM #UNIQUE_DIA A
LEFT JOIN REPORTS..TEMP_BASE_SINTETICA_ORIGINAL B ON B.LOTE = A.DT_INFO AND A.CAMPANHA = B.CAMPANHA
LEFT JOIN #CHAMADAS_DIA C ON A.DT_INFO = C.LOTE AND A.CAMPANHA = C.CAMPANHA AND A.DATA = C.DATA AND C.TIPO = A.TIPO
WHERE C.DISCADAS IS NOT NULL
GROUP BY 
	A.DATA
,	A.DT_INFO
,	A.CAMPANHA
,	CPF
,	CONTABIL
,	C.DISCADAS
,	PENETRADO
,	ATENDIDAS
,	DIA_UTIL
,	A.TIPO
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: SINTETICO UNIQUE MES																*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
TRUNCATE TABLE REPORTS..TEMP_FUNIL_CAMPANHA_ORIGINAL_UNIQUE
INSERT INTO REPORTS..TEMP_FUNIL_CAMPANHA_ORIGINAL_UNIQUE
SELECT
	A.DT_INFO
,	CAMPANHA	=	UPPER(A.CAMPANHA)
,	CARTEIRA	=	CPF
,	CONTABIL	
,	DISCAGENS	=	C.DISCADAS
,	PENETRACAO	=	PENETRADO
,	ATENDIDAS	=	ATENDIDAS
,	TABULADO	=	COUNT(DISTINCT IIF(TABULADO = 1,CGCPF_DEV,NULL))
,	ALO			=	COUNT(DISTINCT IIF(ALO		= 1,CGCPF_DEV,NULL))
,	CPC			=	COUNT(DISTINCT IIF(CPC		= 1,CGCPF_DEV,NULL))
,	CPC_P		=	COUNT(DISTINCT IIF(CPC_P	= 1,CGCPF_DEV,NULL))
,	ACORDO		=	COUNT(DISTINCT IIF(ACORDO	= 1,CGCPF_DEV,NULL))
,	SALDO		=	SUM(SALDO)
,	A.SUB_TABULACAO
FROM #UNIQUE_MES A
LEFT JOIN REPORTS..TEMP_BASE_SINTETICA_ORIGINAL B ON  A.DT_INFO = B.LOTE AND A.CAMPANHA = B.CAMPANHA
LEFT JOIN #CHAMADAS_MES C ON A.DT_INFO = C.LOTE AND A.CAMPANHA = C.CAMPANHA AND C.TIPO = A.SUB_TABULACAO
WHERE C.DISCADAS IS NOT NULL
GROUP BY 
	A.DT_INFO
,	A.CAMPANHA
,	CPF
,	CONTABIL
,	C.DISCADAS
,	PENETRADO
,	ATENDIDAS
,	A.SUB_TABULACAO
