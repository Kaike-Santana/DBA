
USE Data_Science
GO

DROP TABLE IF EXISTS #TEMP_ITAPEVA
SELECT
	   [uniqueid]
      ,[Data]
      ,[Hora]
      ,[origem]
      ,[destino]
      ,[tipo]
      ,[idcrm]			=		REPLICATE(0,11-LEN(IDCRM)) + IDCRM
      ,[statusnegocio]
      ,[Nome_Fila]
      ,[agente]
      ,[calldate]
      ,[duracao]
      ,[conversado]
      ,[statusatendimento]
      ,[ddd]
      ,[classe_order]
      ,[status]
      ,[billsec]
      ,[bilhetado]
      ,[aftercall_tempo]
      ,[temponafila]
      ,[fila]
      ,[valor]
      ,[desligadopor]
      ,[doc]
      ,[mailing]
      ,[abandonado]
      ,[redirecionado]
      ,[isdncause]
      ,[terminator]
      ,[DID_CLID]
INTO #TEMP_ITAPEVA
FROM DATA_SCIENCE.DBO.TB_DS_CALLFLEX_MES_PICPAY WITH(NOLOCK)
WHERE Nome_Fila like '%ITAPEVA%'

/*********************************************************** PENETRAÇÃO CPFS    ******************************************************************************/
DROP TABLE IF EXISTS #PENETRACAO_BASE
SELECT 
	CPF
,	PENETRADO	=	COUNT(DISTINCT(IDCRM))
INTO #PENETRACAO_BASE
FROM (
		SELECT 
		 CPF	=	R1.IdentityNumber
		,T.idcrm
		FROM PLANNING..TB_PL_REG_01_ITAPEVA R1
		LEFT JOIN #TEMP_ITAPEVA T ON R1.IdentityNumber = T.idcrm
     ) X
GROUP BY CPF
/***********************************************************  TENTATIVAS TELEFONE  ******************************************************************************/
DROP TABLE IF EXISTS #BASE
SELECT DISTINCT
 R1.IDENTITYNUMBER                AS CPF_BASE
,CONCAT(R2.DDD,R2.NUMEROTELEFONE) AS TELEFONE_BASE
,R2.ALIASTIPOTELEFONE			  AS TIPO_TEL
,COUNT(C.IDCRM)					  AS TENTATIVA
, CASE    
        WHEN ISDNCAUSE  = '16'   THEN 'ALO'
        WHEN ISDNCAUSE  = '17'   THEN 'OCUPADO'
        WHEN ISDNCAUSE  = '18'   THEN 'OCUPADO'
        WHEN ISDNCAUSE  = '19'   THEN 'OCUPADO'
        WHEN ISDNCAUSE >= '128'  THEN 'EARS'
        ELSE 'DEMAIS'
  END 'CLASSIFICACAO'
INTO #BASE
FROM PLANNING.DBO.TB_PL_REG_01_ITAPEVA R1
JOIN PLANNING.DBO.TB_PL_REG_02_ITAPEVA R2 ON R1.CUSTOMERID				      =  R2.CUSTOMERID
LEFT JOIN #TEMP_ITAPEVA				   C  ON CONCAT(R2.DDD,R2.NUMEROTELEFONE) =  C.ORIGEM
WHERE C.ISDNCAUSE NOT IN ('1')
GROUP BY 
 R1.IDENTITYNUMBER                
,CONCAT(R2.DDD,R2.NUMEROTELEFONE) 
,R2.ALIASTIPOTELEFONE			  
, CASE    
        WHEN C.ISDNCAUSE  = '16'   THEN 'ALO'
        WHEN C.ISDNCAUSE  = '17'   THEN 'OCUPADO'
        WHEN C.ISDNCAUSE  = '18'   THEN 'OCUPADO'
        WHEN C.ISDNCAUSE  = '19'   THEN 'OCUPADO'
        WHEN C.ISDNCAUSE >= '128'  THEN 'EARS'
        ELSE 'DEMAIS'
  END 

--> PIVOT NO LAYOUT DO GUI
SELECT 
	CPF_BASE
,	TELEFONE_BASE
,	TIPO_TEL
,	[ALO]		=	ISNULL([ALO],0)
,	[OCUPADO]	=	ISNULL([OCUPADO],0)
,	[EARS]		=	ISNULL([EARS],0)
FROM #BASE
PIVOT(
	  SUM(
		   TENTATIVA
		 ) 
		 FOR CLASSIFICACAO IN (
								[ALO],[OCUPADO],[EARS]
							  )
	 ) PVT
WHERE 1=1
ORDER BY CPF_BASE DESC