/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																																							 */
/* PROGRAMADOR: KAIKE NATAN						                                                                         */
/* VERSAO     : 1.0      DATA: 03/11/2021                                                                             */
/* DESCRICAO  : RESPONSAVEL POR GERAR O RELATÓRIO DE RECORRENCIA E MARCAÇÃO ESTRATÉGICA			 							 */
/* ALTERACAO                                                                                                          */
/*        2. PROGRAMADOR: KAIKE NATAN																					DATA: 09/11/2021	 */
/*           DESCRICAO  : AUTOMATIZAÇÃO DO RELATÓRIO VIA SQL COM OS DEPARA DA REGRA DO NEGÓCIO 								 */
/*																																							 */
/*        3. PROGRAMADOR: KAIKE NATAN																					DATA: 17/11/2021	 */
/*           DESCRICAO  : INCLUSÃO DO COUNT NA COLUNA NOME CONTATO E VALIDAÇÃO DO CÓDIGO										 */ 
/*																																							 */
/*        4. PROGRAMADOR: 																									DATA: __/__/____	 */
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
JOIN	
					res_partner G
ON		   (A.autor_id	= G.id)

JOIN		   	res_partner D
ON			(A.contato_id = D.id)

JOIN		 		mmp_pre_campanha C
ON			(C.id =	A.campanha_id)

JOIN		   	mmp_pre_client_group F
ON			(A.group_id = F.id)

LEFT JOIN		mmp_pre_motivo_conclusao MC
ON			 (A.motivo_conclusao_id = MC.id)

JOIN		 		mmp_pre_dossie_fase H
ON			 (A.fase_id = H.ID)

WHERE		 A.state != '10c'
OR A.data_conclusao >= CURRENT_DATE - 60

/* APAGA OS NOME ZUADOS */	
DELETE FROM TEMP_MARCACAO_ESTRATEGIA
WHERE STATUS = '10c'
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : MARCAÇÃO ESTRATÉGICA DA CARTEIRA ( TRABALHISTA	)			 			*/  -- OK
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/	
DROP TABLE IF EXISTS TEMP_TRAB; 
CREATE TEMPORARY TABLE TEMP_TRAB AS
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
			,CASE WHEN LENGTH(ESTRATEGIA_PLAN_2) = 0 THEN 'OK' ELSE '' END AS ESTRATEGIA_TRAB
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
					AND ESTRATEGIA_PLAN_2 = 'Discador' 
					AND Recebido_Banco != MAX(Recebido_Banco) -12 
					THEN 'OK' 
					ELSE ESTRATEGIA_PLAN_2 
			 END AS INDENI_INICIAL_RECURSAL
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
			,CASE WHEN CAMPANHA ILIKE '%REVISIONAIS%' AND ESTRATEGIA_PLAN_2 = 'Manual' THEN 'OK' ELSE ESTRATEGIA_PLAN_2 END AS HONORARIO_SANTANDER
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
			,CASE WHEN PRODUTO = 'BMG'	AND RECORRENCIA = 'l' AND ESTRATEGIA_PLAN_2 = 'Manual' THEN 'OK' ELSE ESTRATEGIA_PLAN_2 END AS ESTRATEGIA_BMG_LISTA
			,CASE WHEN PRODUTO = 'PAN'	AND RECORRENCIA = 'l' AND ESTRATEGIA_PLAN_2 = 'Manual' THEN 'OK' ELSE ESTRATEGIA_PLAN_2 END AS ESTRATEGIA_PAN_LISTA
			,CASE 
					WHEN PRODUTO = 'BMG'	
					AND RECORRENCIA = 'i' 
					AND Recebido_Banco != MAX(Recebido_Banco) - 3 
					AND ESTRATEGIA_PLAN_2 = 'Discador' 
					THEN 'OK' 
					ELSE ESTRATEGIA_PLAN_2 
			 END AS ESTRATEGIA_BMG_INDIVIDUAL
			,CASE 
					WHEN PRODUTO = 'PAN'	
					AND RECORRENCIA = 'i' 
					AND Recebido_Banco != MAX(Recebido_Banco) - 3 
					AND ESTRATEGIA_PLAN_2 = 'Discador' 
					THEN 'OK' 
					ELSE ESTRATEGIA_PLAN_2 
			 END AS ESTRATEGIA_PAN_INDIVIDUAL
			 	
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
			,CASE WHEN PRODUTO = 'BMG'	AND RECORRENCIA = 'l' AND ESTRATEGIA_PLAN_2 = 'Manual' THEN 'OK' ELSE ESTRATEGIA_PLAN_2 END
			,CASE WHEN PRODUTO = 'PAN'	AND RECORRENCIA = 'l' AND ESTRATEGIA_PLAN_2 = 'Manual' THEN 'OK' ELSE ESTRATEGIA_PLAN_2 END
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
			
FROM TEMP_MARCACAO_ESTRATEGIA
WHERE CARTEIRA_PLAN_1 = 'PLANOS'


