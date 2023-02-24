
USE Data_Science
GO

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* PROGRAMADOR: KAIKE NATAN									                                    */
/* VERSAO     : DATA: 08/06/2022																*/
/* DESCRICAO  : PEGA O ÚLTIMO ACIONAMENTO DA BASE DE PA FIXA DA RIACHUELO			 		    */
/*																								*/
/*	ALTERACAO                                                                                   */
/*        2. PROGRAMADOR:													 DATA: __/__/____	*/		
/*           DESCRICAO  :										 								*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: PEGA A BASE DE CONTRATOS DA CARTEIRA											    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #BASE
SELECT
		IDCON_CON
,		CGCPF_DEV
,		DTINC_CON
,		DTDEV_CON
,		CONTR_CON
INTO #BASE
FROM [10.251.1.36].NECTAR.DBO.TB_CONTRATO WITH(NOLOCK) 
JOIN [10.251.1.36].NECTAR.DBO.TB_DEVEDOR  WITH(NOLOCK) ON IDDEV_CON  =  IDDEV_DEV
WHERE IDEMP_CON = 19
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: PEGA A ÚLTIMA TABULAÇÃO POR CONTRATO											    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #PASSAGEM
SELECT
		IDCON_CON
,		CGCPF_DEV
,		DTINC_CON
,		DTDEV_CON
,		DTAND_AND
,		DESCR_OCO
,		CONTR_CON
,		RW		=		ROW_NUMBER () OVER(PARTITION BY CONTR_CON ORDER BY DTAND_AND DESC)
INTO #PASSAGEM
FROM [10.251.1.36].NECTAR.DBO.TB_ANDAMENTO 
JOIN [10.251.1.36].NECTAR.DBO.TB_CONTRATO    WITH(NOLOCK) ON IDCON_CON  =  IDCON_AND
JOIN [10.251.1.36].NECTAR.DBO.TB_DEVEDOR 	 WITH(NOLOCK) ON IDDEV_CON  =  IDDEV_DEV
JOIN [10.251.1.36].NECTAR.DBO.TB_OCORRENCIA  WITH(NOLOCK) ON IDOCO_OCO  =  IDOCO_AND
WHERE IDEMP_CON = 19
AND IMAPS_OCO != ''
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: PEGA A ÚLTIMA TABULAÇÃO POR CONTRATO											    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	DELETE FROM #PASSAGEM WHERE RW > 1
	ALTER TABLE #PASSAGEM DROP COLUMN RW
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: PEGA A ÚLTIMA TABULAÇÃO POR CONTRATO											    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
SELECT
		CONTRATO			=	 A.CONTR_CON 
,		CPF					=	 A.CGCPF_DEV
,		ULT_ACIONAMENTO		=	 CONVERT(DATE,P.DTAND_AND)
,		TABULACAO			=	 P.DESCR_OCO
,		DATA_ENTRADA		=	 CONVERT(DATE,P.DTINC_CON) 
,		DATA_EXPIRACAO		=	 CONVERT(DATE,P.DTDEV_CON) 
FROM #BASE A						 
LEFT JOIN #PASSAGEM P ON P.IDCON_CON = A.IDCON_CON
