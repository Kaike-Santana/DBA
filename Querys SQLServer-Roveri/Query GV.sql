
	USE easycollector -- 63
	GO

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*PROGRAMADOR: KAIKE NATAN													  						    */
/*VERSAO     : 1.0      DATA: 22/09/2021                                                                */
/*DESCRICAO  : RESPONSAVEL POR ATUALIZAR O RELATORIO DE PRODUÇÃO NATURA: 				  			    */
/*			   DAS GV´S GALAXIA																		    */
/*ALTERACAO                                                                                             */
/*        1. PROGRAMADOR: 															  DATA: __/__/____  */
/*           DESCRICAO  : 															 			        */                                                                                                                                         
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/


/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	VARIÁVEIS														 */
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

DECLARE
		  @DT_INICIAL	AS DATE
		, @DT_FINAL		AS DATE
		, @BASE_GV_INI  AS DATE
		, @BASE_GV_FIM	AS DATE

SET		  @DT_INICIAL	=	CAST(GETDATE() - DATEPART(DAY,GETDATE()-1) AS DATE)
SET	      @DT_FINAL		=	CAST(GETDATE() -1 AS date)
SET		  @BASE_GV_INI	=	CAST(GETDATE() - DATEPART(DAY,GETDATE()-1) AS DATE)
SET		  @BASE_GV_FIM	=	CAST(GETDATE() -1 AS date)

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	MODELAGEM DOS DADOS												 */
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

IF OBJECT_ID('TEMPDB.DBO.#TB_A') IS NOT NULL 
DROP TABLE #TB_A

	SELECT
		  DT_ACORDO			=	CAST(A.DT_ACORDO AS DATE)
		, A.ID_CLIENTE
		, ID_RA				=	CL.NM_CLIENTE_CEDENTE
		, A.ID_ACORDO
		, AD.ID_CONTRATO
		, FX_ATRASO			=
								CASE
									WHEN DATEDIFF(DD, MIN(AD.DT_VENCIMENTO), A.DT_ACORDO) BETWEEN -99999 AND 15		THEN 'B.3-15'
										WHEN DATEDIFF(DD, MIN(AD.DT_VENCIMENTO), A.DT_ACORDO) BETWEEN 16	 AND 30		THEN 'C.16-30'
											WHEN DATEDIFF(DD, MIN(AD.DT_VENCIMENTO), A.DT_ACORDO) BETWEEN 31	 AND 60		THEN 'D.31-60'	
												WHEN DATEDIFF(DD, MIN(AD.DT_VENCIMENTO), A.DT_ACORDO) BETWEEN 61	 AND 90		THEN 'E.61-90'
													WHEN DATEDIFF(DD, MIN(AD.DT_VENCIMENTO), A.DT_ACORDO) BETWEEN 91	 AND 99999	THEN 'F.>90' 
								END
	INTO #TB_A 
	FROM	
		TB_ACORDO			A WITH(NOLOCK)
	INNER JOIN
		TB_CLIENTE			CL WITH(NOLOCK)
	ON	A.ID_CLIENTE	=	CL.ID_CLIENTE
	INNER JOIN
		TB_ACORDO_DIVIDA	AD	WITH(NOLOCK)
	ON	A.ID_CLIENTE	=	AD.ID_CLIENTE
	AND 
		A.ID_ACORDO		=	AD.ID_ACORDO
	WHERE
		ID_CEDENTE		IN (1002)
	AND 
			CAST(DT_ACORDO AS DATE)	BETWEEN	@DT_INICIAL AND @DT_FINAL
	AND 
			ID_USUARIO IS NOT NULL

	AND (
		  CAST(A.DT_ACORDO AS DATE) <> CAST(A.DT_CANCELAMENTO AS DATE) 
	OR	  CAST(A.DT_CANCELAMENTO AS DATE)	IS NULL
		)

		GROUP BY
			  A.DT_ACORDO
			, A.ID_CLIENTE
			, CL.NM_CLIENTE_CEDENTE
			, A.ID_ACORDO
			, A.ID_CLIENTE
			, AD.ID_CONTRATO
		ORDER	BY
			  CL.NM_CLIENTE_CEDENTE
			, A.ID_ACORDO

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	SEPARA POR CARTEIRA AS CLIENTES DA GV GALAXIA					 */
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

IF OBJECT_ID('TEMPDB.DBO.#BASE_ESTRATIFICADA') IS NOT NULL 
DROP TABLE #BASE_ESTRATIFICADA
SELECT [DT_REF]
      ,[ID_CEDENTE]
      ,[ID_CLIENTE]
      ,[ID_RA]
      ,[NU_CPF_CNPJ]
      ,[NM_CONTRATO_CEDENTE]
      ,[NM_CAMPANHA]
      ,[NU_CAMPANHA]
      ,[ANO_CAMPANHA]
      ,[ATRASO]
      ,[DT_VENCIMENTO]
      ,[VL_DIVIDA]
      ,[TP_STATUS]
      ,[FAIXA1]
      ,[FAIXA2]
      ,[FAIXA3]
  INTO #BASE_ESTRATIFICADA
  FROM [172.20.1.66].[DB_REPORT].[dbo].[TB_REL_NATURA_GESTAO_ESTRATIFICACAO]
  WHERE DT_REF BETWEEN @BASE_GV_INI  AND  @BASE_GV_FIM 
  ORDER BY DT_REF DESC

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	PEGA O LAYOUT DA MODELAGEM, SEPARANDO SÓ O QUE É GALAXIA		 */
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

IF OBJECT_ID('TEMPDB.DBO.#AcordoGv') IS NOT NULL 
DROP TABLE #AcordoGv

SELECT 
		TB1.*
,		TB2.ID_DETALHE
,		TIPO_GV	=	CASE WHEN TB2.ID_DETALHE = '352' THEN 'GV-GALAXIA' ELSE 'DEU RUIM' END

INTO #AcordoGv
FROM #TB_A TB1
LEFT JOIN
	TB_CONTRATO_DETALHE TB2
ON TB1.ID_CONTRATO = TB2.ID_CONTRATO
WHERE TB2.ID_DETALHE = 352
AND NM_DETALHE_VALOR = 'V031'
ORDER BY 
		DT_ACORDO desc

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	SEPARA CARTEIRA POR DIA											 */
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

IF OBJECT_ID('TEMPDB.DBO.#CARTEIRA_GV_DIA') IS NOT NULL 
DROP TABLE #CARTEIRA_GV_DIA

SELECT 
		DT_ACORDO 
,		CARTEIRA_DIA	=	COUNT(1)	

INTO #CARTEIRA_GV_DIA
FROM #ACORDOGV X
JOIN
	 #BASE_ESTRATIFICADA Y
ON X.ID_CLIENTE =	Y.ID_CLIENTE
AND X.ID_RA		=	Y.ID_RA
GROUP BY
		DT_ACORDO

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	SEPARA ACORDO POR DIA											 */
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

IF OBJECT_ID('TEMPDB.DBO.#ACORDO_GV_DIA') IS NOT NULL 
DROP TABLE #ACORDO_GV_DIA

SELECT 
		DT_ACORDO
,		ACORDO_DIA	 =	COUNT(1)

INTO #ACORDO_GV_DIA
FROM #AcordoGv
GROUP BY
		DT_ACORDO

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	CRIA TABELA DA FUSÃO											 */
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

SELECT
		X.DT_ACORDO
,		CARTEIRA_DIA
,		Y.ACORDO_DIA
FROM #CARTEIRA_GV_DIA X
	 JOIN
	 #ACORDO_GV_DIA   Y
ON X.DT_ACORDO	=	Y.DT_ACORDO
ORDER BY 
		X.DT_ACORDO asc
