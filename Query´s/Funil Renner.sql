USE [Data_Science]
GO

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* PROGRAMADOR: KAIKE NATAN									                                    */
/* VERSAO     : DATA: 11/04/2022																*/
/* DESCRICAO  : RESPONSÁVEL POR ATUALIZAR AS VISÕES DE FUNIL DA RENNER							*/
/*	ALTERACAO                                                                                   */
/*        2. PROGRAMADOR: 													 DATA: __/__/____	*/		
/*           DESCRICAO  :  			 															*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	VARIAVÉIS DE CONTROLE DO CÓDIGO												    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	DECLARE @D1			   VARCHAR(20)		=	CONCAT(CONVERT(DATE,GETDATE()-11), ' 00:00:00')		-- CARTEIRA COMEÇOU DIA 22/03
	DECLARE @D2			   VARCHAR(20)		=	CONCAT(CONVERT(DATE,GETDATE()-1), ' 23:59:59')		-- ULTIMO DIA ATUALIZADO 09/05
	DECLARE @IP			   VARCHAR(13)		=	'[10.251.1.36]'
	DECLARE @IP_MYSQL	   VARCHAR(13)		=	'[10.251.2.18]'	
	DECLARE @VAZIO		   VARCHAR(10)	    =   ''
	DECLARE @TSQL		   NVARCHAR(4000)
	DECLARE @DATA_CONTROLE DATE				=	CAST(@D1 AS DATE)
	DECLARE @DATA_INICIAL  DATE				=	CAST(@D1 AS DATE)
	DECLARE @DATA_FINAL	   DATE				=	CAST(@D2 AS DATE)	
	DECLARE @ID_CARTEIRA   VARCHAR(MAX)		=	'17'
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																							    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/


/********************************************	INICIA ETL DA INFORMAÇÕES DE ESTEIRA (ALO,CPC, CPCP, ACORDO E PAGAMENTOS)	************************************************/

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO:	ANALITICO DE PRODUÇÃO CRM														*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS ##ANALITICO_PRODUCAO
SET @TSQL = 'SELECT * INTO ##ANALITICO_PRODUCAO FROM OPENQUERY('+@IP+',
''SELECT DISTINCT
	DTAND_AND
,	IDAND_AND
,	IDCON_AND
,	IDCON_CON
,	IDOCO_AND
,	ORIGE_AND
,	CONTR_CON
,	DTATR_CON
,	IDEMP_CON
,	VLMAC_CON
,	VLSAL_CON
,	IMAPS_OCO
,	DESCR_OCO
,	IDPES_PES
,	USUAR_PES
,	NOME_PES
,	CGCPF_DEV
,	DESCR_DOC	=	DESCR_BND
,	DESCR_CAR
FROM	   NECTAR.DBO.TB_ANDAMENTO 	WITH(NOLOCK)
INNER JOIN NECTAR.DBO.TB_CONTRATO 	WITH(NOLOCK) ON IDCON_AND = IDCON_CON  
INNER JOIN NECTAR.DBO.TB_DEVEDOR	WITH(NOLOCK) ON IDDEV_DEV = IDDEV_CON
INNER JOIN NECTAR.DBO.TB_OCORRENCIA	WITH(NOLOCK) ON IDOCO_AND = IDOCO_OCO  
INNER JOIN NECTAR.DBO.TB_PESSOAL	WITH(NOLOCK) ON IDPES_AND = IDPES_PES
INNER JOIN NECTAR.DBO.TB_CARTEIRA	WITH(NOLOCK) ON IDCAR_CON = IDCAR_CAR
INNER JOIN NECTAR.DBO.TB_BANDEIRA	WITH(NOLOCK) ON IDBND_BND = IDBND_CON
WHERE IDEMP_CON = '''''+@ID_CARTEIRA+'''''
AND IMAPS_OCO != '''''+@VAZIO+'''''
AND DTAND_AND BETWEEN '''''+@D1+''''' AND ''''' +@D2+ ''''''')'
EXEC SP_EXECUTESQL @TSQL
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO:	TRATAMENTO DO ANALITICO DE PRODUÇÃO												*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #ETL_PRODUCAO
SELECT 
		DTAND_AND		=	CONVERT(DATE,DTAND_AND) 
,		HRAND_AND		=	DATEPART(HH,DTAND_AND) 
,		IDAND_AND
,		IMAPS_OCO
,		IDPES_PES
,		USUAR_PES
,		NOME_PES
,		CONTR_CON
,		IDCON_AND
,		IDOCO_AND
,		CGCPF_DEV
,		IDEMP_CON
,		DESCR_OCO
,		DESCR_DOC
,		DESCR_CAR
,		AGING			=	DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),CONVERT(DATE,DTAND_AND)) 
,		VLSAL_CON		=	CONVERT(MONEY,VLSAL_CON) 
INTO #ETL_PRODUCAO
FROM ##ANALITICO_PRODUCAO
WHERE IMAPS_OCO NOT IN ('PROMESSA','ACORDO')
AND IDOCO_AND NOT IN (275,604)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO:	ANALITICO DE ACORDOS															*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS ##ANALITICO_ACORDO
SET @TSQL =' SELECT * INTO ##ANALITICO_ACORDO FROM OPENQUERY('+@IP+',  
''SELECT DISTINCT
 DTVEN_PAG  
,DTPAG_PAG  
,VLVEN_PAG  
,VLPAG_PAG  
,PAGAM_PAG  
,IDACO_ACO
,DTACO_ACO  
,DTCAD_ACO
,IDPES_ACO  
,STACO_ACO   
,IDCON_ACO
,VLSAL_CON
,VLMAC_CON  
,DTATR_CON  
,PLANO_CON      
,CONTR_CON  
,IDEMP_CON   
,USUAR_PES  
,NOME_PES  
,CGCPF_DEV 
,DESCR_DOC	=	DESCR_BND
,DESCR_CAR
FROM       NECTAR.DBO.TB_ACORDO		WITH(NOLOCK)  
INNER JOIN NECTAR.DBO.TB_CONTRATO	WITH(NOLOCK) ON IDCON_CON = IDCON_ACO   
INNER JOIN NECTAR.DBO.TB_DEVEDOR	WITH(NOLOCK) ON IDDEV_DEV = IDDEV_CON  
INNER JOIN NECTAR.DBO.TB_PAGAMENTO	WITH(NOLOCK) ON IDACO_PAG = IDACO_ACO  
INNER JOIN NECTAR.DBO.TB_CARTEIRA	WITH(NOLOCK) ON IDCAR_CON = IDCAR_CAR
INNER JOIN NECTAR.DBO.TB_PESSOAL	WITH(NOLOCK) ON IDPES_PES = IDPES_ACO  
INNER JOIN NECTAR.DBO.TB_BANDEIRA	WITH(NOLOCK) ON IDBND_BND = IDBND_CON
WHERE DTACO_ACO BETWEEN '''''+@D1+''''' AND '''''+@D2 +'''''  
AND IDEMP_CON = '''''+@ID_CARTEIRA+'''''
AND PAGAM_PAG = 1 
--AND STACO_ACO = 0
AND LEFT(DTCAD_ACO,10) <> (CASE WHEN DTCAN_ACO IS NULL THEN ''''2019-01-01'''' ELSE LEFT(DTCAN_ACO,10) END)
'')'  
EXEC SP_EXECUTESQL @TSQL   
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: ETL DO ANALITICO DE ACORDOS														*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #UNION_ACORDO
SELECT     
		DTACO_ACO			=		CONVERT(DATE,DTACO_ACO)  
,		DTPAG_PAG			=		CONVERT(DATE,DTPAG_PAG) 
,		HORA				=		DATEPART(HH,DTCAD_ACO) 
,		IDEMP_CON			
,		IDPES_ACO	
,		NOME_PES		
,		AGING				=		DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),CONVERT(DATE,DTACO_ACO))   
,		VLSAL_CON			=		CONVERT(MONEY,VLSAL_CON) 
,		VLVEN_PAG			=		CONVERT(MONEY,VLVEN_PAG) 
,		VLPAG_PAG			=		CONVERT(MONEY,VLPAG_PAG) 
,		CGCPF_DEV  
,		CONTR_CON  
,		IDCON_ACO
,		67 IDOCO_OCO
,		DESCR_DOC
,		DESCR_CAR
INTO #UNION_ACORDO
FROM ##ANALITICO_ACORDO
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : LAYOUT DA PRODUÇÃO PRO UNION ALL COM ACORDOS									*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #UNION_PRODUCAO
SELECT 
	DTACO_ACO		=		CONVERT(DATE,DTAND_AND) 
,	DTPAG_PAG		=		CAST(NULL AS DATE)					 
,	HORA			=		HRAND_AND				 
,	IDEMP_EMP		=		IDEMP_CON				  
,	IDPES_ACO		=		IDPES_PES	
,	NOME_PES			  
,	AGING 			=		AGING					 
,	VLSAL_CON		=		VLSAL_CON				 
,	VLVEN_PAG		=		CAST(NULL AS MONEY)					 
,	VLPAG_PAG		=		CAST(NULL AS MONEY)					 
,	CGCPF_DEV		=		CGCPF_DEV				 
,	CONTR_CON		=		CONTR_CON				 
,	IDCON_CON		=		IDCON_AND				 
,	IDOCO_AND		=		IDOCO_AND
,	DESCR_DOC
,	DESCR_CAR
INTO #UNION_PRODUCAO
FROM #ETL_PRODUCAO
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: CRIA TEMPORÁRIA DE UNIFICAÇÃO														*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #CONSOLIDADO
CREATE TABLE 	     #CONSOLIDADO
									(				
										DATA   DATE NULL ,
										DT_PAG DATE  NULL ,
										HORA VARCHAR(MAX) NULL,
										ID_EMP  BIGINT NULL ,
										IDPES   BIGINT NULL , 
										NOME_PES VARCHAR(MAX) NULL, 
										AGING BIGINT NULL ,
										VLSAL_CON MONEY NULL,
										VLVEN_PAG MONEY NULL ,
										VLPAG_PAG MONEY NULL ,
										CPF_DEV BIGINT NULL ,
										CONTRATO_CON BIGINT NULL ,
										IDCON_CON BIGINT NULL ,
										IDOCO_OCO BIGINT NULL ,
										DESCR_COD VARCHAR(MAX) NULL ,
										DESCR_CAR VARCHAR(MAX) NULL 
									)		
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: UNIFICA ACORDO E PRODUÇÃO NO LAYOUT	 											*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
INSERT INTO #CONSOLIDADO
SELECT *
FROM #UNION_ACORDO

UNION ALL

SELECT *
FROM #UNION_PRODUCAO
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: CRIAR INDEX PARA IDOCO_OCO														*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

	CREATE NONCLUSTERED INDEX INDEX_RENNER
	ON #CONSOLIDADO (IDOCO_OCO)

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: DEPARA DAS TABULAÇÕES																*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #ULTIMATE
SELECT 
	A.DATA
,	A.DT_PAG
,	A.HORA
,	A.ID_EMP
,	A.IDPES
,	A.NOME_PES
,	A.AGING
,	A.VLSAL_CON
,	A.VLVEN_PAG
,	A.VLPAG_PAG
,	A.CPF_DEV
,	A.CONTRATO_CON
,	A.IDCON_CON
,	A.IDOCO_OCO
,	DESCR_COD			=	CASE 
								WHEN A.DESCR_COD IN ('CBRCARNE','CBRCREL','MASTER','VISA')					THEN 'CBR'
								WHEN A.DESCR_COD IN ('PLFATURA','CCRCFI','RCCRCFI','FACRELI','RFACRELI')	THEN 'CCR'
								WHEN A.DESCR_COD IN ('REPCFI','EPCFI')										THEN 'EP'
																											ELSE 'VERIFICAR'
							END
,	A.DESCR_CAR
,	DESCR_DXP
,	TABULADO
,	ALO
,	CPC
,	CPC_N
,	CPC_P
,	ACORDO
INTO #ULTIMATE
FROM #CONSOLIDADO A  
JOIN REPORTS.DBO.AUX_DEXPARA_ATMA	   C ON (IDOCO_OCO	 =	IDOCO_DXP)

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: BUSCA BASE EM COBRANÇA DA RENNER													*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS ##PRE_CHAMADA
SET @TSQL = 'SELECT * INTO ##PRE_CHAMADA FROM OPENQUERY('+@IP+',''
 SELECT 
	IDCON_CON
,	CONTR_CON
,	DTATR_CON	
,	CGCPF_DEV
,	DESCR_BND
FROM NECTAR.DBO.TB_CONTRATO	WITH(NOLOCK) 
JOIN NECTAR.DBO.TB_DEVEDOR	WITH(NOLOCK) ON IDDEV_DEV = IDDEV_CON
LEFT JOIN NECTAR.DBO.TB_BANDEIRA WITH(NOLOCK) ON IDBND_BND = IDBND_CON 
WHERE IDEMP_CON = '''''+@ID_CARTEIRA+''''' '')'
EXEC SP_EXECUTESQL @TSQL
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO : MARCA OS DUPLICADOS DA PRODUÇÃO 													*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #PRE_RW
SELECT 
	IDCON_CON
,	CONTR_CON
,	CGCPF_DEV 
,	DESCR_BND   =	CASE 
						WHEN DESCR_BND IN ('CBRCARNE','CBRCREL','MASTER','VISA')				THEN 'CBR'
						WHEN DESCR_BND IN ('PLFATURA','CCRCFI','RCCRCFI','FACRELI','RFACRELI')	THEN 'CCR'
						WHEN DESCR_BND IN ('REPCFI','EPCFI')									THEN 'EP'
																								ELSE 'VERIFICAR'
					END
,	DTATR_CON 
,	RW			=	ROW_NUMBER() OVER(PARTITION BY IDCON_CON, DESCR_BND ORDER BY CGCPF_DEV DESC) 
INTO #PRE_RW
FROM ##PRE_CHAMADA
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO : REMOVE OS DUPLICADOS DA PRODUÇÃO 												*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DELETE FROM #PRE_RW 
WHERE (
		   RW > 1 
		OR DESCR_BND IS NULL
	  )
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: IDENTIFICADOR DE FILAS DA RENNER												    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
IF OBJECT_ID ('TEMPDB..#FILAS') IS NOT NULL DROP TABLE #FILAS
SELECT DISTINCT *
INTO #FILAS
FROM OPENQUERY([10.251.2.18],'SELECT * FROM replica_atmspbb1.queues')
WHERE NOME LIKE '%RENNER%'
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: CRIA TABELA COM ANALITICO DE CHAMADAS											    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #CHAMADAS
SELECT 
		A.*
,		RW.CGCPF_DEV	
,		DESCR_BND
,		DTATR_CON
INTO #CHAMADAS
FROM DATA_SCIENCE..TB_DS_CALLFLEX_MES A 
JOIN #PRE_RW RW ON (RW.IDCON_CON =  A.IDCRM)
JOIN #FILAS FI  ON (FI.FILA		 =  A.FILA )
WHERE FI.NOME LIKE '%RENNER%'
AND A.DATA BETWEEN CAST(@D1 AS DATE) AND CAST(@D2 AS DATE)