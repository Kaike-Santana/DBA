
DECLARE @DT_INI  DATE
DECLARE @DT_FIM  DATE
SET     @DT_INI = '2020-09-01' 
SET     @DT_FIM = '2020-09-30'

DROP TABLE #TEMP
SELECT DATEPART (MM, DT_ENTRADA) AS MES,DT_PAGAMENTO,DIVIDA,ID_CLIENTE,

                FAIXA = CASE WHEN ATRASO_NA_ENTRADA < 8         THEN '08 <'
                WHEN ATRASO_NA_ENTRADA BETWEEN 8 AND    30      THEN '08 A 30'
                WHEN ATRASO_NA_ENTRADA BETWEEN 31 AND   60      THEN '31 A 60'
                WHEN ATRASO_NA_ENTRADA BETWEEN 61 AND   90      THEN '61 A 90'
                WHEN ATRASO_NA_ENTRADA       > 90 THEN '90 <'   END


              , CE       =   CASE WHEN CE =  1                                             THEN ID_CLIENTE END
			  , VL_CE    =   CASE WHEN CE =  1                                             THEN DIVIDA     END
              , CPC      =   CASE WHEN CPC = 1                                             THEN ID_CLIENTE END
			  , VL_CPC   =   CASE WHEN CPC = 1                                             THEN DIVIDA     END
              , AF       =   CASE WHEN AF =  1  AND  CPC = 1                               THEN ID_CLIENTE END
			  , VL_AF    =   CASE WHEN AF =  1  AND  CPC = 1                               THEN DIVIDA     END   
			  , PAGO     =   CASE WHEN AF =  1  AND  CPC = 1 AND DT_PAGAMENTO IS NOT NULL  THEN ID_CLIENTE END
			  , VL_PAGO  =   CASE WHEN AF =  1  AND  CPC = 1 AND DT_PAGAMENTO IS NOT NULL  THEN DIVIDA     END
INTO  #TEMP
FROM  TB_REL_SAFRA_AVON_REMESSA_ANALITICO
WHERE TP_SETOR LIKE '%FRONTEIRA%'
AND DT_ENTRADA BETWEEN  @DT_INI AND @DT_FIM


SELECT FAIXA
		, COUNT (*)           AS QUANTIDADE
		, SUM   (DIVIDA)      AS DIVIDA_TOTAL
		, COUNT (CE)          AS CE
		, SUM   (VL_CE)       AS VL_CE
		, CAST (COUNT (CE)    AS float) / COUNT (*)   AS PORC_CE
		, COUNT (CPC)         AS CPC
		, SUM   (VL_CPC)      AS VL_CPC
		, CAST (COUNT (CPC)   AS float) / COUNT (CE)  AS PORC_CPC
		, COUNT (AF)          AS AF
		, SUM   (VL_AF)       AS VL_AF
		, CAST (COUNT (AF)    AS float) / COUNT (CPC) AS PORC_AF
		, COUNT (PAGO)        AS PAGO
		, SUM   (VL_PAGO)     AS VL_PAGO
		, CAST (COUNT (PAGO)  AS float) / COUNT (AF)  AS PORC_PAGO		
FROM #TEMP
GROUP BY FAIXA
ORDER BY FAIXA


