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
DROP TABLE IF EXISTS TEMP_ANALITICO_RECORRENCIA; 
CREATE TEMPORARY TABLE TEMP_ANALITICO_RECORRENCIA AS

SELECT	 CONCAT('__export__.mmp_pre_dossie_',A.ID) 			AS EXTERNAL_ID
			,A.contato_id 													AS CONTATO_ID
			,CAST(A.create_date AS DATE)								AS CREATE_DATE
			,A.dt_envio_banco 											AS Recebido_Banco
			,A.cpf 															AS CPF
			,upper(CASE 
					WHEN D.name 		    IS NULL 
					OR   D.name   =      'Sem Advogado' 
					OR   D.name  LIKE    'Defensoria%' 
					OR   D.name  LIKE    'DEFENSORIA%'
					OR   D.name  LIKE    'Defensor%'
					OR   D.name  LIKE    'DEFENSOR%'
					OR   D.name   =   	'N/H'
		   		OR   D.name   = 	   'N/A'
		   		OR   D.name  LIKE    'OAB%'
		   		OR   D.name  LIKE    'PARTE SEM ADVOGADO'
		   		OR   D.name  LIKE    'Juizado Sem Advogado'
		   		OR   D.name  LIKE    'Sem Patrocinio'
		   		OR   D.name  LIKE    'Parte Sem Advogado'
		   		OR   D.name  ILIKE   '%sem advo%'
		   		OR   D.name  ILIKE   '%Defenso%'
		   		OR	  D.name  LIKE    'sem%'
		   		OR   D.name   = 		'SEM ADV CADASTRADO'
		   		OR   D.name   = 		'SEM PROCURADOR'
					THEN 'FLAG'  ELSE     D.name 
			 END)																AS NOME_contato 
			,G.name  														AS	NOME_AUTOR
			,A.name 															AS DOSSIE
			,A.processo														AS N_PROCESSO
			,F.name 															AS PRODUTO
			,C.name 															AS CAMPANHA
			,A.faixa1 														AS VALOR_FAIXA_1
			,A.faixa2 														AS VALOR_FAIXA_2
			,X_MARCACAO_PLANEJAMENTO_1 								AS CARTEIRA_PLAN_1
			,X_MARCACAO_PLANEJAMENTO_2 								AS ESTRATÉGIA_PLAN_2
			,A.count_type 													AS RECORRENCIA
			,A.data_conclusao												AS DT_CONCLUSAO 
			,C.inativa														AS STATUS_CAMPANHA
			,A.state															AS STATUS
			,A.oab															AS OAB
			,H.name  														AS FASE
						
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

JOIN		 		mmp_pre_dossie_fase H
ON			 (A.fase_id = H.ID)

WHERE		 A.state != '10c'
OR A.data_conclusao >= CURRENT_DATE - 60

/* APAGA OS NOME ZUADOS */	
DELETE FROM TEMP_ANALITICO_RECORRENCIA
WHERE (
		     NOME_CONTATO = 'FLAG'
		  OR CAMPANHA ILIKE '%agressor%'
		  OR CAMPANHA ILIKE '%traba%'
		  OR LENGTH(NOME_CONTATO) <= 2
		  OR CARTEIRA_PLAN_1 IN ('AGRESSOR','ATIVAS','PPM','TRAB','TESTE')
		  OR CAMPANHA  		IN ( 'PPM - Sucumbência','BMG - PROJETO ADV. AGRESSOR - 16.11','CIELO - RECEBA MAIS - CARGA ATUALIZADA - AJUIZAVEL'
		  								  'CIELO - RECEBA MAIS - CARGA ATUALIZADA - NÃO AJUIZAVEL','Pan - Projeto Agressor 2021','SANTANDER AGRESSOR - 12/2021'
										  'SANTANDER AGRESSOR - 2021 - Bruno Medeiros Durão','SANTANDER AGRESSOR - 2021 - Fernando Carlos Fernandes Martins',
										  'SANTANDER AGRESSOR - 2021 - JULYANA FRANCO GOMES','SANTANDER AGRESSOR - 2021 - Pedro Francisco Guimarães Solino'
										)
		)	
		SELECT * FROM TEMP_ANALITICO_RECORRENCIA
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : CONTA QUANTAS VEZES O NOME CONTATO SE REPETE			    			*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS TEMP_REC_1; 
CREATE TEMPORARY TABLE TEMP_REC_1 AS

SELECT 

		nome_contato
,     COUNT(nome_contato)	AS REC_1
FROM TEMP_ANALITICO_RECORRENCIA
GROUP BY 1
ORDER BY 1
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : CONTA QUANTAS VEZES O NOME CONTATO SE REPETE			    			*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS TEMP_REC_2; 
CREATE TEMPORARY TABLE TEMP_REC_2 AS

SELECT 
		*
,		CASE WHEN REC_1 > 1 THEN 'l' ELSE 'i' END REC_2
FROM 	TEMP_REC_1

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : FAZ A COMPARAÇÃO COM A COLUNA ORIGINAL VENDO O QUE FOI ALTERADO	*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS TEMP_RECORRENCIA_3; 
CREATE TEMPORARY TABLE TEMP_RECORRENCIA_3 AS

SELECT 
			X.*	
,			Y.rec_1
,			Y.rec_2
,			CASE WHEN X.recorrencia = Y.rec_2 THEN 'VERDADEIRO' ELSE 'FALSO' END Validacao
FROM 	TEMP_ANALITICO_RECORRENCIA X
LEFT JOIN TEMP_REC_2 			   Y ON (X.nome_contato = Y.nome_contato)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: DELETA VERDADEIRO, CONCLUÍDO E OQ ERA LISTA E PASSOU A SER INDIVIDUAL */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DELETE FROM TEMP_RECORRENCIA_3
WHERE validacao = 'VERDADEIRO'
DELETE FROM TEMP_RECORRENCIA_3
WHERE (
				recorrencia = 'l'
			OR recorrencia IS null
		)
AND rec_2 = 'i' 

DELETE FROM TEMP_RECORRENCIA_3
WHERE status = '10c'

SELECT * FROM TEMP_RECORRENCIA_3
				


