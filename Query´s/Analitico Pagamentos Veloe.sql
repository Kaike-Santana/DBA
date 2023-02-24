

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* PROGRAMADOR: KAIKE NATAN									                                    */
/* VERSAO     : DATA: 20/07/2022																*/
/* DESCRICAO  : RESPONSAVEL POR ATUALIZAR O DAILY D-1 DA VELOE									*/
/*																								*/
/*	ALTERACAO                                                                                   */
/*        2. PROGRAMADOR: 													 DATA: __/__/____	*/		
/*           DESCRICAO  :  			 															*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	VARIAVÉIS DE CONTROLE DO CÓDIGO												    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
BEGIN;
	DECLARE @DATA_INICIAL	 DATE	 =	'2022-04-01'		
	DECLARE @DATA_FINAL		 DATE	 =	'2022-06-30'
	DECLARE @ID_CARTEIRA	 INT	 =	 15
	DECLARE @INICIO_CARTEIRA DATE 	 =	(SELECT MIN(CONVERT(DATE,DTAND_AND)) FROM [10.251.1.36].NECTAR.DBO.TB_ANDAMENTO JOIN [10.251.1.36].NECTAR.DBO.TB_CONTRATO ON IDCON_AND = IDCON_CON WHERE IDEMP_CON = @ID_CARTEIRA)
	PRINT (@INICIO_CARTEIRA) --> 1 DIA DA CARTEIRA NA ATMA
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	ANALITICO DE PAGAMENTOS	VELOE												    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
SELECT 
  DATA_VENC		=	CONVERT(DATE,DTVEN_PAG) 
, DATA_PGTO		=	CONVERT(DATE,DTPAG_PAG)   
, VALOR_PAGO	=	CONVERT(MONEY,VLPAG_PAG)  
, CPF_DEVEDOR	=	CGCPF_DEV  
, ID_CONTRATO	=	IDCON_CON
, ATRASO		=	
					CASE  
						WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),CONVERT(DATE,DTACO_ACO)) BETWEEN -9999 AND 30	 THEN '00.<30'
						WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),CONVERT(DATE,DTACO_ACO)) BETWEEN	31   AND 60  THEN '01.31 A 60'
						WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),CONVERT(DATE,DTACO_ACO)) BETWEEN	61   AND 90	 THEN '02.61 A 90'
						WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),CONVERT(DATE,DTACO_ACO)) BETWEEN	91   AND 360 THEN '03.91 A 360'
						WHEN DATEDIFF(DAY,CONVERT(DATE,DTATR_CON),CONVERT(DATE,DTACO_ACO)) > 360				 THEN '04.>360'
						ELSE 'VERIFICAR' 
					END     
FROM	  [10.251.1.36].NECTAR.DBO.TB_CONTRATO     
JOIN	  [10.251.1.36].NECTAR.DBO.TB_ACORDO     ON IDCON_CON = IDCON_ACO  
JOIN	  [10.251.1.36].NECTAR.DBO.TB_PAGAMENTO  ON IDACO_ACO = IDACO_PAG  
JOIN	  [10.251.1.36].NECTAR.DBO.TB_DEVEDOR    ON IDDEV_CON = IDDEV_DEV 
WHERE IDEMP_CON = @ID_CARTEIRA
AND DTVEN_PAG BETWEEN @DATA_INICIAL and @DATA_FINAL
AND PAGAM_PAG = 1

END;