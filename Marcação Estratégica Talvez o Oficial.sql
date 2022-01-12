
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/																	
/* PROGRAMADOR: KAIKE NATAN						                                                                         */
/* VERSAO     : 1.0      DATA: 03/11/2021                                                                             */
/* DESCRICAO  : RESPONSAVEL POR GERAR FAZER A MARCAÇÃO ESTRATÉGICA DAS CARTEIRAS DA EMPRESA		 							 */
/* ALTERACAO                                                                                                          */
/*        2. PROGRAMADOR: KAIKE NATAN																					DATA: 09/11/2021	 */
/*           DESCRICAO  : AUTOMATIZAÇÃO DO RELATÓRIO VIA SQL COM OS DEPARA DA REGRA DO NEGÓCIO 								 */
/*																																							 */
/*        3. PROGRAMADOR: KAIKE NATAN																					DATA: 17/11/2021	 */
/*           DESCRICAO  : INCLUSÃO DO COUNT NA COLUNA NOME CONTATO E VALIDAÇÃO DO CÓDIGO										 */ 
/*																																							 */
/*        4. PROGRAMADOR: KAIKE NATAN																					DATA: 22/11/2021	 */
/*           DESCRICAO  : INCLUSÃO DA REGRA DE DATAS DAS CARTEIRAS INDENI E PARALELO	 										 */     
/*																																							 */
/*        5. PROGRAMADOR: KAIKE NATAN																					DATA: 25/11/2021	 */
/*           DESCRICAO  : MARCAÇÕES NO CASE PARA REMOÇÃO DAS ESTRATÉGIAS CORRETAS												 */ 
/*																																							 */
/*        6. PROGRAMADOR: KAIKE NATAN																					DATA: 30/11/2021	 */
/*           DESCRICAO  : VALIDAÇÃO FINAL DA QUERY E VERSIONAMENTO DO CÓDIIGO NO GITHUB										 */ 
/*																																							 */
/*        7. PROGRAMADOR: KAIKE NATAN																					DATA: 01/12/2021	 */
/*           DESCRICAO  : AJUSTE DA REGRA DE DATA DAS CARTEIRAS INDENI E PARALELO						 						 */
/*																																							 */
/*        8. PROGRAMADOR: 																									DATA: __/__/____	 */
/*           DESCRICAO  : 						 	 																								 */                                                                                                                               
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	SET	statement_timeout TO 600000;
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : MODELAGEM DO ANALITICO, FAZENDO A TRATATIVA DA COLUNA NOME CONTATO	*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS TEMP_MARCACAO_ESTRATEGIA; 
CREATE TEMPORARY TABLE TEMP_MARCACAO_ESTRATEGIA AS
SELECT	 CONCAT('__export__.mmp_pre_dossie_',A.ID) 			AS EXTERNAL_ID 
			,A.contato_id 													AS CONTATO_ID
			,CAST(A.create_date AS DATE)								AS CREATE_DATE
			,A.dt_envio_banco 											AS Recebido_Banco
			,A.cpf 															AS CPF
			,D.name 															AS NOME_contato 
			,G.name  														AS	NOME_AUTOR
			,A.name 															AS DOSSIE
			,A.processo														AS N_PROCESSO
			,F.name 															AS PRODUTO
			,C.name 															AS CAMPANHA
			,A.faixa1 														AS VALOR_FAIXA_1
			,A.faixa2 														AS VALOR_FAIXA_2
			,X_MARCACAO_PLANEJAMENTO_1 								AS CARTEIRA_PLAN_1
			,X_MARCACAO_PLANEJAMENTO_2 								AS ESTRATEGIA_PLAN_2
			,A.count_type 													AS RECORRENCIA
			,A.data_conclusao												AS DT_CONCLUSAO 
			,C.inativa														AS STATUS_CAMPANHA
			,A.state															AS STATUS
			,A.oab															AS OAB
			,MC.name															AS MOTIVO_CONCLUSAO
			,H.name  														AS FASE
			,A.flag_wo														AS FLAG
			,A.cluster_novo
						
FROM				mmp_pre_dossie A
JOIN				res_partner G
ON		    (A.autor_id = G.id)

JOIN		   	res_partner D
ON			 (A.contato_id = D.id)

JOIN		 		mmp_pre_campanha C
ON			 (C.id =	A.campanha_id)

JOIN		   	mmp_pre_client_group F
ON			 (A.group_id = F.id)

LEFT JOIN		mmp_pre_motivo_conclusao MC
ON			 (A.motivo_conclusao_id = MC.id)

JOIN		 		mmp_pre_dossie_fase H
ON			 (A.fase_id = H.ID)

WHERE	A.count_type IS NOT NULL
AND (
			A.state != '10c'
		OR A.data_conclusao >= CURRENT_DATE - 60
	 )

/* APAGA OS NOME ZUADOS */	
DELETE FROM TEMP_MARCACAO_ESTRATEGIA
WHERE STATUS = '10c' 
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : MARCAÇÃO ESTRATÉGICA DA CARTEIRA ( TRABALHISTA	)			 			*/  -- OK
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/	
DROP TABLE IF EXISTS TEMP_TRAB; 
CREATE TEMPORARY TABLE TEMP_TRAB AS
SELECT	 
			 EXTERNAL_ID --integer
			,Recebido_Banco -- date
			,NOME_contato -- varchar
			,PRODUTO -- varchar
			,CAMPANHA -- varchar
			,VALOR_FAIXA_2 -- double precision
			,CARTEIRA_PLAN_1 -- varchar
			,ESTRATEGIA_PLAN_2 -- varchar
			,RECORRENCIA -- varchar
			,STATUS -- varchar
			,FASE	 -- varchar
			,CASE WHEN LENGTH(ESTRATEGIA_PLAN_2) = 0 THEN 'OK' ELSE ESTRATEGIA_PLAN_2 END AS ESTRATEGIA_TRAB
			,CAST(NULL AS VARCHAR) AS TWO
			,CAST(NULL AS VARCHAR) AS TRE
			,CAST(NULL AS VARCHAR) AS FOUR
			,CAST(NULL AS VARCHAR) AS FIVE
			,CAST(NULL AS VARCHAR) AS SIX
			,CAST(NULL AS VARCHAR) AS SEVEN
			,CAST(NULL AS VARCHAR) AS EIGHT
			,CAST(NULL AS VARCHAR) AS NINE
			,CAST(NULL AS VARCHAR) AS TEN
			,CAST(NULL AS VARCHAR) AS ELEVEN
			,CAST(NULL AS VARCHAR) AS TWELVE
FROM TEMP_MARCACAO_ESTRATEGIA
WHERE CARTEIRA_PLAN_1 = 'TRAB'
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : MARCAÇÃO ESTRATÉGICA DA CARTEIRA ( AGRESSOR	)			    			*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/	
DROP TABLE IF EXISTS TEMP_AGRESSOR; 
CREATE TEMPORARY TABLE TEMP_AGRESSOR AS
SELECT	 
			 EXTERNAL_ID
			,Recebido_Banco
			,NOME_contato 
			,PRODUTO
			,CAMPANHA
			,VALOR_FAIXA_2
			,CARTEIRA_PLAN_1 
			,ESTRATEGIA_PLAN_2
			,RECORRENCIA
			,STATUS
			,FASE	
			,CASE WHEN ESTRATEGIA_PLAN_2 = 'Manual' THEN 'OK' ELSE 'Manual' END AS ESTRATEGIA_AGRESSOR
			,CAST(NULL AS VARCHAR) AS TWO
			,CAST(NULL AS VARCHAR) AS TRE
			,CAST(NULL AS VARCHAR) AS FOUR
			,CAST(NULL AS VARCHAR) AS FIVE
			,CAST(NULL AS VARCHAR) AS SIX
			,CAST(NULL AS VARCHAR) AS SEVEN
			,CAST(NULL AS VARCHAR) AS EIGHT
			,CAST(NULL AS VARCHAR) AS NINE
			,CAST(NULL AS VARCHAR) AS TEN
			,CAST(NULL AS VARCHAR) AS ELEVEN
			,CAST(NULL AS VARCHAR) AS TWELVE
FROM TEMP_MARCACAO_ESTRATEGIA
WHERE CARTEIRA_PLAN_1 = 'AGRESSOR'
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : MARCAÇÃO ESTRATÉGICA DA CARTEIRA ( INDENI DISPENSA)		  			*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/	
DROP TABLE IF EXISTS TEMP_INDENI; 
CREATE TEMPORARY TABLE TEMP_INDENI AS
SELECT	 
			 EXTERNAL_ID
			,Recebido_Banco
			,NOME_contato 
			,PRODUTO
			,CAMPANHA
			,VALOR_FAIXA_2
			,CARTEIRA_PLAN_1 
			,ESTRATEGIA_PLAN_2
			,RECORRENCIA
			,STATUS
			,FASE	
			,CASE WHEN FASE = 'Dispensa' AND ESTRATEGIA_PLAN_2 = 'Manual' THEN 'OK' ELSE ESTRATEGIA_PLAN_2 END AS INDENI_DISPENSA
			,CASE 
					WHEN FASE != 'Dispensa'
					AND Recebido_Banco != max(Recebido_Banco) -3
					AND ESTRATEGIA_PLAN_2 = 'Discador' 
					THEN 'OK'
					ELSE ESTRATEGIA_PLAN_2 
			 END AS INDENI_INICIAL_RECURSAL
			,CASE 
					WHEN FASE != 'Dispensa'
					AND Recebido_Banco 	 = max(Recebido_Banco) -3
					AND ESTRATEGIA_PLAN_2 = 'Digital' 
					THEN 'OK'
					ELSE ESTRATEGIA_PLAN_2 
			 END AS INDENI_INICIAL_RECURSAL_DIGITAL
			,CAST(NULL AS VARCHAR) AS FOUR
			,CAST(NULL AS VARCHAR) AS FIVE
			,CAST(NULL AS VARCHAR) AS SIX
			,CAST(NULL AS VARCHAR) AS SEVEN
			,CAST(NULL AS VARCHAR) AS EIGHT
			,CAST(NULL AS VARCHAR) AS NINE
			,CAST(NULL AS VARCHAR) AS TEN
			,CAST(NULL AS VARCHAR) AS ELEVEN
			,CAST(NULL AS VARCHAR) AS TWELVE
FROM TEMP_MARCACAO_ESTRATEGIA
WHERE CARTEIRA_PLAN_1 = 'INDENI'
GROUP BY  EXTERNAL_ID
			,Recebido_Banco
			,NOME_contato 
			,PRODUTO
			,CAMPANHA
			,VALOR_FAIXA_2
			,CARTEIRA_PLAN_1 
			,ESTRATEGIA_PLAN_2
			,RECORRENCIA
			,STATUS
			,FASE	
			,CASE WHEN FASE = 'Dispensa' AND ESTRATEGIA_PLAN_2 = 'Manual' THEN 'OK' ELSE ESTRATEGIA_PLAN_2 END 
ORDER BY 
		Recebido_Banco DESC
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : MARCAÇÃO ESTRATÉGICA DA CARTEIRA ( HONORÁRIOS )	   	  			*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/	
DROP TABLE IF EXISTS TEMP_HONORÁRIO; 
CREATE TEMPORARY TABLE TEMP_HONORÁRIO AS
SELECT	 
			 EXTERNAL_ID
			,Recebido_Banco
			,NOME_contato 
			,PRODUTO
			,CAMPANHA
			,VALOR_FAIXA_2
			,CARTEIRA_PLAN_1 
			,ESTRATEGIA_PLAN_2
			,RECORRENCIA
			,STATUS
			,FASE	
			,CASE WHEN CAMPANHA ILIKE '%PPM%' AND ESTRATEGIA_PLAN_2 = 'Manual' THEN 'OK' ELSE ESTRATEGIA_PLAN_2 END AS HONORARIO_PPM
			,CASE WHEN CAMPANHA IN ('REVISIONAIS ESPECIAIS - ATÉ 10/12/2021','SANTANDER - EXIBIÇÃO - 2021','Santander - Migração Revisional 25.11.2021',
											'SANTANDER - REVISIONAIS - 06.05.2021','SANTANDER - REVISIONAIS ATIVAS - 2021','SANTANDER REVISIONAIS - VAREJO') 
														 AND ESTRATEGIA_PLAN_2 = 'Manual' THEN 'OK' ELSE ESTRATEGIA_PLAN_2 END AS HONORARIO_SANTANDER
			,CAST(NULL AS VARCHAR) AS TRE
			,CAST(NULL AS VARCHAR) AS FOUR
			,CAST(NULL AS VARCHAR) AS FIVE
			,CAST(NULL AS VARCHAR) AS SIX
			,CAST(NULL AS VARCHAR) AS SEVEN
			,CAST(NULL AS VARCHAR) AS EIGHT
			,CAST(NULL AS VARCHAR) AS NINE
			,CAST(NULL AS VARCHAR) AS TEN
			,CAST(NULL AS VARCHAR) AS ELEVEN
			,CAST(NULL AS VARCHAR) AS TWELVE
FROM TEMP_MARCACAO_ESTRATEGIA
WHERE CARTEIRA_PLAN_1 = 'HONORÁRIO'
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : MARCAÇÃO ESTRATÉGICA DA CARTEIRA ( ATIVAS )			   	  			*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/	
DROP TABLE IF EXISTS TEMP_ATIVAS; 
CREATE TEMPORARY TABLE TEMP_ATIVAS AS
SELECT	 
	 EXTERNAL_ID
	,Recebido_Banco
	,NOME_contato 
	,PRODUTO
	,CAMPANHA
	,VALOR_FAIXA_2
	,CARTEIRA_PLAN_1 
	,ESTRATEGIA_PLAN_2
	,RECORRENCIA
	,STATUS
	,FASE	
	,CASE WHEN PRODUTO = 'Gyramais' AND VALOR_FAIXA_2 >= '50000' AND ESTRATEGIA_PLAN_2 = 'Manual' THEN 'OK' ELSE ESTRATEGIA_PLAN_2 END AS ATIVAS_GYRAMAIS_MAIOR_50K
	,CASE WHEN PRODUTO = 'Cielo' 	  AND VALOR_FAIXA_2 >= '50000' AND ESTRATEGIA_PLAN_2 = 'Manual' THEN 'OK' ELSE ESTRATEGIA_PLAN_2 END AS ATIVAS_CIELO_MAIOR_50K
	,CASE WHEN PRODUTO = 'Gyramais' AND VALOR_FAIXA_2 < '50000' AND ESTRATEGIA_PLAN_2 = 'Digital' THEN 'OK' ELSE ESTRATEGIA_PLAN_2 END AS ATIVAS_GYRAMAIS_MENOR_50K
	,CASE WHEN PRODUTO = 'Cielo' 	  AND VALOR_FAIXA_2 < '50000' AND ESTRATEGIA_PLAN_2 = 'Digital' THEN 'OK' ELSE ESTRATEGIA_PLAN_2 END AS ATIVAS_CIELO_MENOR_50K
	,CASE WHEN PRODUTO = 'GETNET'   		AND ESTRATEGIA_PLAN_2 = 'Manual' THEN 'OK' ELSE ESTRATEGIA_PLAN_2 								 END AS ATIVAS_GETNET
	,CASE WHEN PRODUTO = 'Minerva S.A.' AND ESTRATEGIA_PLAN_2 = 'Manual' THEN 'OK' ELSE ESTRATEGIA_PLAN_2 								 END AS ATIVAS_MINERVA_ATIVO
	,CAST(NULL AS VARCHAR) AS SIX
	,CAST(NULL AS VARCHAR) AS SEVEN
	,CAST(NULL AS VARCHAR) AS EIGHT
	,CAST(NULL AS VARCHAR) AS NINE
	,CAST(NULL AS VARCHAR) AS TEN
	,CAST(NULL AS VARCHAR) AS ELEVEN
FROM TEMP_MARCACAO_ESTRATEGIA
WHERE CARTEIRA_PLAN_1 = 'ATIVAS'
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : MARCAÇÃO ESTRATÉGICA DA CARTEIRA ( PARALELO )		   	  			*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/	
DROP TABLE IF EXISTS TEMP_PARALELO; 
CREATE TEMPORARY TABLE TEMP_PARALELO AS
SELECT	 
			 EXTERNAL_ID
			,Recebido_Banco
			,NOME_contato 
			,PRODUTO
			,CAMPANHA
			,VALOR_FAIXA_2
			,CARTEIRA_PLAN_1 
			,ESTRATEGIA_PLAN_2
			,RECORRENCIA
			,STATUS
			,FASE	
			,CASE WHEN PRODUTO = 'BMG'	 AND RECORRENCIA = 'l' AND ESTRATEGIA_PLAN_2 = 'Manual' THEN 'OK' ELSE ESTRATEGIA_PLAN_2 END AS PARALELO_BMG_LISTA
			,CASE WHEN PRODUTO = 'PAN'	 AND RECORRENCIA = 'l' AND ESTRATEGIA_PLAN_2 = 'Manual' THEN 'OK' ELSE ESTRATEGIA_PLAN_2 END AS PARALELO_PAN_LISTA
			,CASE WHEN PRODUTO = 'Omni' AND RECORRENCIA = 'l' AND ESTRATEGIA_PLAN_2 = 'Manual' THEN 'OK' ELSE ESTRATEGIA_PLAN_2 END AS PARALELO_OMNI_LISTA
			,CASE WHEN PRODUTO = 'BANCO DO BRASIL' AND RECORRENCIA = 'l' AND ESTRATEGIA_PLAN_2 = 'Manual' THEN 'OK' ELSE ESTRATEGIA_PLAN_2 END AS PARALELO_BRASIL_LISTA
			,CASE 
					WHEN PRODUTO = 'BMG'	
					AND RECORRENCIA = 'i' 
					AND Recebido_Banco != max(Recebido_Banco) -3
					AND ESTRATEGIA_PLAN_2 = 'Discador' 
					THEN 'OK' 
					ELSE ESTRATEGIA_PLAN_2
			 END AS ESTRATEGIA_BMG_INDIVIDUAL
			,CASE 
					WHEN PRODUTO = 'PAN'	
					AND RECORRENCIA = 'i' 
					AND Recebido_Banco != max(Recebido_Banco) -3
					AND ESTRATEGIA_PLAN_2 = 'Discador' 
					THEN 'OK' 
					ELSE ESTRATEGIA_PLAN_2
			 END AS ESTRATEGIA_PAN_INDIVIDUAL
			,CASE 
					WHEN PRODUTO = 'Omni'	
					AND RECORRENCIA = 'i' 
					AND Recebido_Banco != max(Recebido_Banco) -3
					AND ESTRATEGIA_PLAN_2 = 'Discador' 
					THEN 'OK' 
					ELSE ESTRATEGIA_PLAN_2
			 END AS ESTRATEGIA_OMNI_INDIVIDUAL
			 ,CASE 
					WHEN PRODUTO = 'BANCO DO BRASIL'	
					AND RECORRENCIA = 'i' 
					AND Recebido_Banco != max(Recebido_Banco) -3
					AND ESTRATEGIA_PLAN_2 = 'Discador' 
					THEN 'OK' 
					ELSE ESTRATEGIA_PLAN_2
			 END AS ESTRATEGIA_BRASIL_INDIVIDUAL
			,CASE 
					WHEN PRODUTO = 'BMG'	
					AND RECORRENCIA = 'i' 
					AND Recebido_Banco = max(Recebido_Banco) -3
					AND ESTRATEGIA_PLAN_2 = 'Digital' 
					THEN 'OK' 
					ELSE ESTRATEGIA_PLAN_2
			 END AS PARALELO_BMG_INDIVIDUAL_DIGITAL
			 ,CASE 
					WHEN PRODUTO = 'PAN'	
					AND RECORRENCIA = 'i' 
					AND Recebido_Banco = max(Recebido_Banco) -3
					AND ESTRATEGIA_PLAN_2 = 'Digital' 
					THEN 'OK' 
					ELSE ESTRATEGIA_PLAN_2
			 END AS ESTRATEGIA_PAN_INDIVIDUAL_DIGITAL 
			 ,CASE 
					WHEN PRODUTO = 'Omni'	
					AND RECORRENCIA = 'i' 
					AND Recebido_Banco = max(Recebido_Banco) -3
					AND ESTRATEGIA_PLAN_2 = 'Digital' 
					THEN 'OK'
					ELSE ESTRATEGIA_PLAN_2 
			 END AS ESTRATEGIA_OMNI_INDIVIDUAL_DIGITAL
			  ,CASE 
					WHEN PRODUTO = 'BANCO DO BRASIL'	
					AND RECORRENCIA = 'i' 
					AND Recebido_Banco = max(Recebido_Banco) -3
					AND ESTRATEGIA_PLAN_2 = 'Digital' 
					THEN 'OK'
					ELSE ESTRATEGIA_PLAN_2 
			 END AS ESTRATEGIA_BRASIL_INDIVIDUAL_DIGITAL
FROM TEMP_MARCACAO_ESTRATEGIA
WHERE CARTEIRA_PLAN_1 = 'PARALELO'
GROUP BY
			 EXTERNAL_ID
			,Recebido_Banco
			,NOME_contato 
			,PRODUTO
			,CAMPANHA
			,VALOR_FAIXA_2
			,CARTEIRA_PLAN_1 
			,ESTRATEGIA_PLAN_2
			,RECORRENCIA
			,STATUS
			,FASE	
			,CASE WHEN PRODUTO = 'BMG'	AND RECORRENCIA = 'l' AND ESTRATEGIA_PLAN_2 = 'Manual' THEN 'OK' ELSE ESTRATEGIA_PLAN_2  END
			,CASE WHEN PRODUTO = 'PAN'	AND RECORRENCIA = 'l' AND ESTRATEGIA_PLAN_2 = 'Manual' THEN 'OK' ELSE ESTRATEGIA_PLAN_2  END
			,CASE WHEN PRODUTO = 'Omni' AND RECORRENCIA = 'l' AND ESTRATEGIA_PLAN_2 = 'Manual' THEN 'OK' ELSE ESTRATEGIA_PLAN_2 END
			,CASE WHEN PRODUTO = 'BANCO DO BRASIL' AND RECORRENCIA = 'l' AND ESTRATEGIA_PLAN_2 = 'Manual' THEN 'OK' ELSE ESTRATEGIA_PLAN_2 END
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : MARCAÇÃO ESTRATÉGICA DA CARTEIRA ( PLANOS )		   	  				*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/	
DROP TABLE IF EXISTS TEMP_PLANOS; 
CREATE TEMPORARY TABLE TEMP_PLANOS AS
SELECT	 
			 EXTERNAL_ID
			,Recebido_Banco
			,NOME_contato 
			,PRODUTO
			,CAMPANHA
			,VALOR_FAIXA_2
			,CARTEIRA_PLAN_1 
			,ESTRATEGIA_PLAN_2
			,RECORRENCIA
			,STATUS
			,FASE	
			,CASE WHEN PRODUTO = 'ITAÚ' 		AND RECORRENCIA = 'l' AND ESTRATEGIA_PLAN_2 = 'Manual' THEN 'OK' ELSE ESTRATEGIA_PLAN_2 END AS ESTRATEGIA_ITAU_LISTA
			,CASE WHEN PRODUTO = 'SANTANDER' AND RECORRENCIA = 'l' AND ESTRATEGIA_PLAN_2 = 'Manual' THEN 'OK' ELSE ESTRATEGIA_PLAN_2 END AS ESTRATEGIA_SANTANDER_LISTA
			,CASE WHEN PRODUTO = 'BRADESCO'  AND RECORRENCIA = 'l' AND ESTRATEGIA_PLAN_2 = 'Manual' THEN 'OK' ELSE ESTRATEGIA_PLAN_2 END AS ESTRATEGIA_BRADESCO_LISTA
			,CASE WHEN PRODUTO =	'ITAÚ'		AND VALOR_FAIXA_2 <= '2000' AND ESTRATEGIA_PLAN_2 = 'Digital' THEN 'OK' ELSE ESTRATEGIA_PLAN_2 END ESTRATEGIA_ITAU_INDIVIDUAL_0_2K
			,CASE WHEN PRODUTO =	'ITAÚ'		AND VALOR_FAIXA_2 BETWEEN '2001' AND '5000' AND  ESTRATEGIA_PLAN_2 = 'Discador' THEN 'OK' ELSE ESTRATEGIA_PLAN_2 END ESTRATEGIA_ITAU_INDIVIDUAL_2_5K
			,CASE WHEN PRODUTO =	'ITAÚ'		AND VALOR_FAIXA_2 > '5000' AND ESTRATEGIA_PLAN_2 = 'Digital' THEN 'OK' ELSE ESTRATEGIA_PLAN_2 END ESTRATEGIA_ITAU_INDIVIDUAL_5K
			,CASE WHEN PRODUTO = 'SANTANDER' AND RECORRENCIA = 'i' AND ESTRATEGIA_PLAN_2 = 'Digital' THEN 'OK' ELSE ESTRATEGIA_PLAN_2 END AS ESTRATEGIA_SANTANDER_INDIVIDUAL
			,CASE WHEN PRODUTO = 'BRADESCO'  AND CAMPANHA = 'Bradesco - Oitava Leva' AND ESTRATEGIA_PLAN_2 = 'Manual' THEN 'OK' ELSE ESTRATEGIA_PLAN_2 END AS ESTRATEGIA_BRADESCO_8_LEVA
			,CASE WHEN PRODUTO = 'BRADESCO'  
					AND RECORRENCIA = 'i' 
					AND ESTRATEGIA_PLAN_2 = 'Digital' 
					AND campanha != 'Bradesco - Oitava Leva' 
					THEN 'OK' 
					ELSE ESTRATEGIA_PLAN_2 
			 END AS ESTRATEGIA_BRADESCO_INDIVIDUAL
			 ,CAST(NULL AS VARCHAR) AS TEN
			 ,CAST(NULL AS VARCHAR) AS ELEVEN
			 ,CAST(NULL AS VARCHAR) AS TWELVE
FROM TEMP_MARCACAO_ESTRATEGIA
WHERE CARTEIRA_PLAN_1 = 'PLANOS'
ORDER BY VALOR_FAIXA_2 DESC
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : CRIAÇÃO DO LAYOUT DA TABELA FINAL							  				*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/	
DROP TABLE IF EXISTS TEMP_FINAL;
CREATE TEMPORARY TABLE TEMP_FINAL 
											 (
												ID VARCHAR NOT NULL,
												RECEBIDO_BANCO	DATE NULL,
												NOME_CONTATO VARCHAR NULL,
												PRODUTO VARCHAR NULL,
												CAMPANHA VARCHAR, 
												VALOR_ACORDO	DOUBLE PRECISION,
												CARTEIRA	VARCHAR NULL,
												ESTRATEGIA	VARCHAR NULL,
												RECORRENCIA VARCHAR NULL,
												STATUS VARCHAR NULL,
												FASE VARCHAR NULL,
												ONE VARCHAR NULL,
												TWO VARCHAR NULL,
												TRE VARCHAR NULL,
												FOUR VARCHAR NULL,
												FIVE VARCHAR NULL,
												SIX VARCHAR NULL,
												SEVEN VARCHAR NULL,
												EIGHT VARCHAR NULL,
												NINE VARCHAR NULL,
												TEN  VARCHAR NULL,
												ELEVEN VARCHAR NULL,
												TWELVE VARCHAR NULL
											 ) 
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : UNIFICAÇÃO E MODELAGEM DAS ESTRATÉGIAS DAS CARTEIRAS	  				*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/	
INSERT INTO TEMP_FINAL
SELECT *
FROM TEMP_TRAB

UNION ALL

SELECT *
FROM TEMP_AGRESSOR

UNION ALL

SELECT *
FROM TEMP_INDENI

UNION ALL

SELECT *
FROM TEMP_HONORÁRIO

UNION ALL

SELECT *
FROM TEMP_ATIVAS

UNION ALL

SELECT *
FROM TEMP_PARALELO

UNION ALL

SELECT *
FROM TEMP_PLANOS
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : DELETA AS ESTRATÉGIAS QUE JÁ ESTÃO CORRETAS	 			 				*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/	
DELETE FROM TEMP_FINAL
WHERE (
				ONE    = 'OK'
			OR	TWO    = 'OK'
			OR TRE    = 'OK'
			OR FOUR   = 'OK'
			OR FIVE   = 'OK'
			OR SIX    = 'OK'
			OR SEVEN  = 'OK'
			OR EIGHT  = 'OK'
			OR NINE   = 'OK'
			OR	TEN	 = 'OK'
			OR ELEVEN = 'OK'
			OR TWELVE = 'OK'
		)
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : DROPA AS COLUNAS DO UNION ALL		 			 							*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/	
ALTER TABLE TEMP_FINAL
	DROP COLUMN ONE
,	DROP COLUMN TWO
,	DROP COLUMN TRE
,	DROP COLUMN FOUR
,	DROP COLUMN FIVE
,	DROP COLUMN SIX
,	DROP COLUMN SEVEN
,	DROP COLUMN EIGHT
,  DROP COLUMN NINE
,	DROP COLUMN TEN
,	DROP COLUMN ELEVEN
,	DROP COLUMN TWELVE
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : ESTRATÉGIA FINAL PLANOS				 			 							*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS TEMP_PLANOS_FINAL;
CREATE TEMPORARY TABLE TEMP_PLANOS_FINAL AS
SELECT
		*
,CASE WHEN PRODUTO = 'ITAÚ' 		AND RECORRENCIA = 'l' AND (ESTRATEGIA != 'Manual' OR ESTRATEGIA IS NULL) THEN 'Manual'  END TO_DO_1
,CASE WHEN PRODUTO = 'SANTANDER' AND RECORRENCIA = 'l' AND (ESTRATEGIA != 'Manual' OR ESTRATEGIA IS NULL) THEN 'Manual' END TO_DO_2
,CASE WHEN PRODUTO = 'BRADESCO'  AND RECORRENCIA = 'l' AND (ESTRATEGIA != 'Manual' OR ESTRATEGIA IS NULL) THEN 'Manual'  END TO_DO_3
,CASE WHEN PRODUTO =	'ITAÚ'		AND VALOR_ACORDO <= '2000' AND (ESTRATEGIA != 'Digital' OR ESTRATEGIA IS NULL) THEN 'Digital' END TO_DO_4
,CASE WHEN PRODUTO =	'ITAÚ'		AND VALOR_ACORDO BETWEEN '2001' AND '5000' AND (ESTRATEGIA != 'Discador' OR ESTRATEGIA IS NULL) THEN 'Discador'  END TO_DO_5
,CASE WHEN PRODUTO =	'ITAÚ'		AND VALOR_ACORDO > '5000' AND (ESTRATEGIA != 'Digital' OR ESTRATEGIA IS NULL) THEN 'Digital' END TO_DO_6
,CASE WHEN PRODUTO = 'SANTANDER' AND RECORRENCIA = 'i' AND (ESTRATEGIA != 'Digital' OR ESTRATEGIA IS NULL) THEN 'Digital' END  TO_DO_7
,CASE WHEN PRODUTO = 'BRADESCO'  AND CAMPANHA = 'Bradesco - Oitava Leva' AND (ESTRATEGIA != 'Manual' OR ESTRATEGIA IS NULL) THEN 'Manual' END TO_DO_8
,CASE WHEN PRODUTO = 'BRADESCO'  AND RECORRENCIA = 'i' AND (ESTRATEGIA != 'Digital' OR ESTRATEGIA IS NULL) AND campanha != 'Bradesco - Oitava Leva' THEN 'Digital' END TO_DO_9
,CAST(NULL AS VARCHAR) AS TEN
,CAST(NULL AS VARCHAR) AS ELEVEN
,CAST(NULL AS VARCHAR) AS TWELVE
FROM TEMP_FINAL
WHERE CARTEIRA = 'PLANOS'
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : ESTRATÉGIA FINAL HONORÁRIO				 			 						*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS HONORÁRIO_FINAL;
CREATE TEMPORARY TABLE HONORÁRIO_FINAL AS

SELECT *
,CASE WHEN CAMPANHA ILIKE '%PPM%' AND (ESTRATEGIA != 'Manual' OR ESTRATEGIA IS NULL) THEN 'Manual'  END TO_DO_1
,CASE WHEN campanha IN 
				('REVISIONAIS ESPECIAIS - ATÉ 10/12/2021','SANTANDER - EXIBIÇÃO - 2021','Santander - Migração Revisional 25.11.2021') 
				AND (ESTRATEGIA != 'Manual' OR ESTRATEGIA IS NULL) 							 THEN 'Manual'  END TO_DO_2
,CAST(NULL AS VARCHAR) AS TRE
,CAST(NULL AS VARCHAR) AS FOUR
,CAST(NULL AS VARCHAR) AS FIVE
,CAST(NULL AS VARCHAR) AS SIX
,CAST(NULL AS VARCHAR) AS SEVEN
,CAST(NULL AS VARCHAR) AS EIGHT
,CAST(NULL AS VARCHAR) AS NINE
,CAST(NULL AS VARCHAR) AS TEN
,CAST(NULL AS VARCHAR) AS ELEVEN
,CAST(NULL AS VARCHAR) AS TWELVE

FROM TEMP_FINAL
WHERE CARTEIRA = 'HONORÁRIO'
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : ESTRATÉGIA FINAL ATIVAS				 			 							*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS ATIVAS_FINAL;
CREATE TEMPORARY TABLE ATIVAS_FINAL AS

SELECT *
,CASE WHEN PRODUTO = 'Gyramais' AND VALOR_ACORDO >= '50000' AND (ESTRATEGIA != 'Manual' OR ESTRATEGIA IS NULL) THEN 'Manual'   END AS ATIVAS_GYRAMAIS_MAIOR_50K
,CASE WHEN PRODUTO = 'Cielo' 	  AND VALOR_ACORDO >= '50000' AND (ESTRATEGIA != 'Manual' OR ESTRATEGIA IS NULL) THEN 'Manual'   END AS ATIVAS_CIELO_MAIOR_50K
,CASE WHEN PRODUTO = 'Gyramais' AND VALOR_ACORDO < '50000' AND (ESTRATEGIA  != 'Digital' OR ESTRATEGIA IS NULL) THEN 'Digital' END AS ATIVAS_GYRAMAIS_MENOR_50K
,CASE WHEN PRODUTO = 'Cielo' 	  AND VALOR_ACORDO < '50000' AND (ESTRATEGIA  != 'Digital' OR ESTRATEGIA IS NULL) THEN 'Digital' END AS ATIVAS_CIELO_MENOR_50K
,CASE WHEN PRODUTO = 'GETNET'   		AND (ESTRATEGIA != 'Manual' OR ESTRATEGIA IS NULL) THEN 'Manual'								    END AS ATIVAS_GETNET
,CASE WHEN PRODUTO = 'Minerva S.A.' AND (ESTRATEGIA != 'Manual' OR ESTRATEGIA IS NULL) THEN 'Manual' 						 		    END AS ATIVAS_MINERVA_ATIVO
,CAST(NULL AS VARCHAR) AS TWO
,CAST(NULL AS VARCHAR) AS TRE
,CAST(NULL AS VARCHAR) AS FOUR
,CAST(NULL AS VARCHAR) AS TEN
,CAST(NULL AS VARCHAR) AS ELEVEN
,CAST(NULL AS VARCHAR) AS TWELVE

FROM TEMP_FINAL
WHERE CARTEIRA = 'ATIVAS'
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : ESTRATÉGIA FINAL AGRESSOR						 								*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS AGRESSOR_FINAL;
CREATE TEMPORARY TABLE AGRESSOR_FINAL AS

SELECT *
,CASE WHEN ESTRATEGIA != 'Manual' OR ESTRATEGIA IS NULL THEN 'Manual' END AS ESTRATEGIA_AGRESSOR
,CAST(NULL AS VARCHAR) AS TWO
,CAST(NULL AS VARCHAR) AS TRE
,CAST(NULL AS VARCHAR) AS FOUR
,CAST(NULL AS VARCHAR) AS FIVE
,CAST(NULL AS VARCHAR) AS SIX
,CAST(NULL AS VARCHAR) AS SEVEN
,CAST(NULL AS VARCHAR) AS EIGHT
,CAST(NULL AS VARCHAR) AS NINE
,CAST(NULL AS VARCHAR) AS TEN
,CAST(NULL AS VARCHAR) AS ELEVEN
,CAST(NULL AS VARCHAR) AS TWELVE
FROM TEMP_FINAL
WHERE CARTEIRA = 'AGRESSOR'
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : ESTRATÉGIA FINAL TRAB						 									*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS TRAB_FINAL;
CREATE TEMPORARY TABLE TRAB_FINAL AS

SELECT *
,CASE WHEN LENGTH(ESTRATEGIA) != 0 THEN '' END AS ESTRATEGIA_TRAB
,CAST(NULL AS VARCHAR) AS TWO
,CAST(NULL AS VARCHAR) AS TRE
,CAST(NULL AS VARCHAR) AS FOUR
,CAST(NULL AS VARCHAR) AS FIVE
,CAST(NULL AS VARCHAR) AS SIX
,CAST(NULL AS VARCHAR) AS SEVEN
,CAST(NULL AS VARCHAR) AS EIGHT
,CAST(NULL AS VARCHAR) AS NINE
,CAST(NULL AS VARCHAR) AS TEN
,CAST(NULL AS VARCHAR) AS ELEVEN
,CAST(NULL AS VARCHAR) AS TWELVE
FROM TEMP_FINAL
WHERE CARTEIRA = 'TRAB'
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : ESTRATÉGIA FINAL PARALELO					 									*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS PARALELO_FINAL;
CREATE TEMPORARY TABLE PARALELO_FINAL AS

SELECT	 
			 ID 
			,RECEBIDO_BANCO	
			,NOME_CONTATO 
			,PRODUTO 
			,CAMPANHA 
			,VALOR_ACORDO
			,CARTEIRA	
			,ESTRATEGIA	
			,RECORRENCIA 
			,STATUS 
			,FASE 
			,CASE WHEN PRODUTO = 'BMG'	 AND RECORRENCIA = 'l' AND (ESTRATEGIA != 'Manual' OR ESTRATEGIA IS NULL) THEN 'Manual'  END AS PARALELO_BMG_LISTA
			,CASE WHEN PRODUTO = 'PAN'	 AND RECORRENCIA = 'l' AND (ESTRATEGIA != 'Manual' OR ESTRATEGIA IS NULL) THEN 'Manual'  END AS PARALELO_PAN_LISTA
			,CASE WHEN PRODUTO = 'Omni' AND RECORRENCIA = 'l' AND (ESTRATEGIA != 'Manual' OR ESTRATEGIA IS NULL) THEN 'Manual'  END AS PARALELO_OMNI_LISTA
			,CASE WHEN PRODUTO = 'BANCO DO BRASIL' AND RECORRENCIA = 'l' AND (ESTRATEGIA != 'Manual' OR ESTRATEGIA IS NULL) THEN 'Manual'  END AS PARALELO_BRASIL_LISTA
			,CASE 
					WHEN PRODUTO = 'BMG'	
					AND RECORRENCIA = 'i' 
					AND Recebido_Banco != max(Recebido_Banco) -3
					AND (ESTRATEGIA != 'Discador' OR ESTRATEGIA IS NULL)
					THEN 'Discador' 
			 END AS ESTRATEGIA_BMG_INDIVIDUAL
			,CASE 
					WHEN PRODUTO = 'PAN'	
					AND RECORRENCIA = 'i' 
					AND Recebido_Banco 	 != max(Recebido_Banco) -3
					AND (ESTRATEGIA != 'Discador' OR ESTRATEGIA IS NULL)
					THEN 'Discador' 
			 END AS ESTRATEGIA_PAN_INDIVIDUAL
			,CASE 
					WHEN PRODUTO = 'Omni'	
					AND RECORRENCIA = 'i' 
					AND Recebido_Banco != max(Recebido_Banco) -3
					AND (ESTRATEGIA != 'Discador' OR ESTRATEGIA IS NULL) 
					THEN 'Discador' 
			 END AS ESTRATEGIA_OMNI_INDIVIDUAL
			 ,CASE 
					WHEN PRODUTO = 'BANCO DO BRASIL'	
					AND RECORRENCIA = 'i' 
					AND Recebido_Banco != max(Recebido_Banco) -3
					AND (ESTRATEGIA	!= 'Discador' OR ESTRATEGIA IS NULL)
					THEN 'Discador' 
			 END AS ESTRATEGIA_BRASIL_INDIVIDUAL
			,CASE 
					WHEN PRODUTO = 'BMG'	
					AND RECORRENCIA = 'i' 
					AND Recebido_Banco = max(Recebido_Banco) -3
					AND (ESTRATEGIA != 'Digital' OR ESTRATEGIA IS NULL)
					THEN 'Digital' 
			 END AS PARALELO_BMG_INDIVIDUAL_DIGITAL
			 ,CASE 
					WHEN PRODUTO = 'PAN'	
					AND RECORRENCIA = 'i' 
					AND Recebido_Banco = max(Recebido_Banco) -3
					AND (ESTRATEGIA != 'Digital' OR ESTRATEGIA IS NULL)
					THEN 'Digital' 
			 END AS ESTRATEGIA_PAN_INDIVIDUAL_DIGITAL 
			 ,CASE 
					WHEN PRODUTO = 'Omni'	
					AND RECORRENCIA = 'i' 
					AND Recebido_Banco = max(Recebido_Banco) -3
					AND (ESTRATEGIA != 'Digital' OR ESTRATEGIA IS NULL) 
					THEN 'Digital'
			 END AS ESTRATEGIA_OMNI_INDIVIDUAL_DIGITAL
			 ,CASE 
					WHEN PRODUTO = 'BANCO DO BRASIL'	
					AND RECORRENCIA = 'i' 
					AND Recebido_Banco = max(Recebido_Banco) -3
					AND (ESTRATEGIA != 'Digital' OR ESTRATEGIA IS NULL) 
					THEN 'Digital'
			 END AS ESTRATEGIA_BRASIL_INDIVIDUAL_DIGITAL
FROM TEMP_FINAL
WHERE CARTEIRA = 'PARALELO'
GROUP BY
			 ID 
			,RECEBIDO_BANCO	
			,NOME_CONTATO 
			,PRODUTO 
			,CAMPANHA 
			,VALOR_ACORDO
			,CARTEIRA	
			,ESTRATEGIA	
			,RECORRENCIA 
			,STATUS 
			,FASE 
			,CASE WHEN PRODUTO = 'BMG'	AND RECORRENCIA = 'l' AND (ESTRATEGIA != 'Manual' OR ESTRATEGIA IS NULL) THEN 'OK' END
			,CASE WHEN PRODUTO = 'PAN'	AND RECORRENCIA = 'l' AND (ESTRATEGIA != 'Manual' OR ESTRATEGIA IS NULL)  THEN 'OK' END
			,CASE WHEN PRODUTO = 'Omni' AND RECORRENCIA = 'l' AND (ESTRATEGIA != 'Manual' OR ESTRATEGIA IS NULL) THEN 'OK' END
			,CASE WHEN PRODUTO = 'BANCO DO BRASIL' AND RECORRENCIA = 'l' AND (ESTRATEGIA != 'Manual' OR ESTRATEGIA IS NULL) THEN 'Manual' END
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : ESTRATÉGIA FINAL INDENI					 									*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS INDENI_FINAL;
CREATE TEMPORARY TABLE INDENI_FINAL AS 

SELECT	 
			 ID 
			,RECEBIDO_BANCO	
			,NOME_CONTATO 
			,PRODUTO 
			,CAMPANHA 
			,VALOR_ACORDO
			,CARTEIRA	
			,ESTRATEGIA	
			,RECORRENCIA 
			,STATUS 
			,FASE 
			,CASE WHEN FASE = 'Dispensa' AND (ESTRATEGIA != 'Manual' OR ESTRATEGIA IS NULL) THEN 'Manual' END AS INDENI_DISPENSA
			,CASE 
					WHEN FASE != 'Dispensa'
					AND (ESTRATEGIA != 'Discador' OR ESTRATEGIA IS NULL)
					AND Recebido_Banco 	 != max(Recebido_Banco) -3
					THEN 'Discador'
			 END AS INDENI_INICIAL_RECURSAL
			,CASE 
					WHEN FASE != 'Dispensa'
					AND (ESTRATEGIA != 'Digital' OR ESTRATEGIA IS NULL)
					AND Recebido_Banco = max(Recebido_Banco) -3
					THEN 'Digital'
			 END AS INDENI_INICIAL_RECURSAL_DIGITAL
			,CAST(NULL AS VARCHAR) AS FOUR
			,CAST(NULL AS VARCHAR) AS FIVE
			,CAST(NULL AS VARCHAR) AS SIX
			,CAST(NULL AS VARCHAR) AS SEVEN
			,CAST(NULL AS VARCHAR) AS EIGHT
			,CAST(NULL AS VARCHAR) AS NINE
			,CAST(NULL AS VARCHAR) AS TEN
			,CAST(NULL AS VARCHAR) AS ELEVEN
			,CAST(NULL AS VARCHAR) AS TWELVE
FROM TEMP_FINAL
WHERE CARTEIRA = 'INDENI'
GROUP BY  ID 
			,RECEBIDO_BANCO	
			,NOME_CONTATO 
			,PRODUTO 
			,CAMPANHA 
			,VALOR_ACORDO
			,CARTEIRA	
			,ESTRATEGIA	
			,RECORRENCIA 
			,STATUS 
			,FASE 	
			,CASE WHEN FASE = 'Dispensa' AND (ESTRATEGIA = 'Manual' OR ESTRATEGIA IS NULL) THEN 'OK' END 
ORDER BY 
		Recebido_Banco DESC
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : CRIA TABELA FINAL							 									*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS FINALMENTE_ACABOU;
CREATE TEMPORARY TABLE FINALMENTE_ACABOU 
											 (
												ID VARCHAR NOT NULL,
												RECEBIDO_BANCO	DATE NULL,
												NOME_CONTATO VARCHAR NULL,
												PRODUTO VARCHAR NULL,
												CAMPANHA VARCHAR, 
												VALOR_ACORDO	DOUBLE PRECISION,
												CARTEIRA	VARCHAR NULL,
												ESTRATEGIA	VARCHAR NULL,
												RECORRENCIA VARCHAR NULL,
												STATUS VARCHAR NULL,
												FASE VARCHAR NULL,
												ONE VARCHAR NULL,
												TWO VARCHAR NULL,
												TRE VARCHAR NULL,
												FOUR VARCHAR NULL,
												FIVE VARCHAR NULL,
												SIX VARCHAR NULL,
												SEVEN VARCHAR NULL,
												EIGHT VARCHAR NULL,
												NINE VARCHAR NULL,
												TEN VARCHAR NULL,
												ELEVEN VARCHAR NULL,
												TWELVE VARCHAR NULL
											 ) 
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : UNIFICAÇÃO DO LAYOUT FINAL													*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
INSERT INTO FINALMENTE_ACABOU
SELECT *
FROM TEMP_PLANOS_FINAL

UNION ALL

SELECT *
FROM HONORÁRIO_FINAL

UNION ALL

SELECT *
FROM ATIVAS_FINAL

UNION ALL

SELECT *
FROM AGRESSOR_FINAL

UNION ALL

SELECT *
FROM INDENI_FINAL

UNION ALL

SELECT *
FROM PARALELO_FINAL
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : LAYOUT FINAL JÁ COM AS ESTATÉGIAS CORRIGIDAS							*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/ 
SELECT 
 		ID /* TROCAR POR > * PARA VERIFICAÇÃO */
,		COALESCE(one,two,tre,four,five,six,seven,eight,nine,ten,eleven,twelve) AS TO_DO_ESTRATEGIA
FROM FINALMENTE_ACABOU
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : SELECIONA DA BASE O QUE ESTÁ COM A CARTEIRA ERRADA					*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
SELECT *
FROM TEMP_MARCACAO_ESTRATEGIA
WHERE (
				carteira_plan_1 NOT IN ('PLANOS','PARALELO','HONORÁRIO','INDENI','ATIVAS','TRAB','AGRESSOR') 
			OR carteira_plan_1 IS NULL
		)


