/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* PROGRAMADOR: KAIKE NATAN                                                                                           */
/* VERSAO     : 1.0      																									DATA: 10/12/2021   */
/* DESCRICAO  : RESPONSAVEL POR PEGAR TODA BASE DE TELEFONES DE CONTATO E AUTOR 											 		 */			
/* ALTERACAO                                                                                                          */
/*        2. PROGRAMADOR: 																									DATA: __/__/____	 */
/*           DESCRICAO  : 								 																							 */                                                                                                                                         
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : PEGA A BASE DO CONTATO ( ADVOGADO )						    			*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS TEMP_BASE_TEL_CONTATO;
CREATE TEMPORARY TABLE TEMP_BASE_TEL_CONTATO AS

SELECT	 CONCAT('__export__.mmp_pre_dossie_',A.ID) AS EXTERNAL_ID
			,A.autor_id
			,A.contato_id
			,A.cpf AS CPF
			,D.name AS NOME_contato
			,G.name  NOME_AUTOR
			,A.name AS DOSSIE
			,A.processo
			,A.STATE AS STATUS
			,F.name AS PRODUTO
			,C.name AS CAMPANHA
			,E.dial
			,A.FAIXA1 AS VALOR_FAIXA1
			,A.faixa2 AS VALOR_FAIXA_2
			,CASE WHEN E.name IS NULL THEN 'Sem Telefone' ELSE E.name END AS STATUS_TELEFONE_CONTATO
			,CASE WHEN B.name IS NULL THEN 'Sem Telefone' ELSE B.Name END AS TELEFONE_CONTATO
			,D.email 							EMAIL_CONTATO
			,X_MARCACAO_PLANEJAMENTO_1 AS CARTEIRA
			,X_MARCACAO_PLANEJAMENTO_2 AS ESTRATÉGIA
			,H.NAME 							AS FASE
			,A.COUNT_TYPE					AS RECORRENCIA
FROM		 mmp_pre_dossie 				 A
INNER JOIN		 res_partner 			 G ON	(A.autor_id   = G.id)
INNER JOIN		 res_partner 			 D ON	(A.contato_id = D.id)
LEFT JOIN		 mmp_pre_phone_number B ON	(D.id 		  = B.partner_id)
LEFT JOIN		 mmp_pre_phone_status E ON	(E.id 		  = B.status_id)
INNER JOIN		 mmp_pre_campanha     C ON	(C.id 		  = A.campanha_id)
INNER JOIN		 mmp_pre_client_group F ON	(A.group_id   = F.id)
INNER JOIN		 mmp_pre_dossie_fase  H ON	(A.fase_id 	  = H.ID)
WHERE		 A.state = '01ac'
AND 	  	 B.name IS NULL	-- descomentar para pegar só que telefone NULL
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : PEGA A BASE DO AUTOR DO PROCESSO							    			*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS TEMP_BASE_TEL_AUTOR;
CREATE TEMPORARY TABLE TEMP_BASE_TEL_AUTOR AS

SELECT	 CONCAT('__export__.mmp_pre_dossie_',A.ID) AS EXTERNAL_ID
			,A.autor_id
			,A.contato_id
			,A.cpf AS CPF
			,D.name AS NOME_contato
			,G.name  NOME_AUTOR
			,A.name AS DOSSIE
			,A.processo
			,A.STATE AS STATUS
			,F.name AS PRODUTO
			,C.name AS CAMPANHA
			,E.dial
			,A.FAIXA1 AS VALOR_FAIXA1
			,A.faixa2 AS VALOR_FAIXA_2
			,CASE WHEN E.name IS NULL THEN 'Sem Telefone' ELSE E.name END AS STATUS_TELEFONE_AUTOR
			,CASE WHEN B.name IS NULL THEN 'Sem Telefone' ELSE B.name END AS TELEFONE_AUTOR
			,D.email 							EMAIL_CONTATO
			,X_MARCACAO_PLANEJAMENTO_1 AS CARTEIRA
			,X_MARCACAO_PLANEJAMENTO_2 AS ESTRATÉGIA
			,H.NAME 							AS FASE
			,A.COUNT_TYPE					AS RECORRENCIA
FROM		 mmp_pre_dossie A
INNER JOIN		 res_partner 			 G ON	(A.autor_id   = G.id)
INNER JOIN		 res_partner 			 D ON	(A.contato_id = D.id)
LEFT JOIN		 mmp_pre_phone_number B ON	(G.id 		  = B.partner_id)
LEFT JOIN		 mmp_pre_phone_status E ON	(E.id 		  = B.status_id)
INNER JOIN		 mmp_pre_campanha 	 C ON	(C.id 		  = A.campanha_id)
INNER JOIN		 mmp_pre_client_group F ON	(A.group_id   = F.id)
INNER JOIN		 mmp_pre_dossie_fase  H ON	(A.fase_id 	  = H.ID)
WHERE		 A.state = '01ac'
AND 	  	 B.name IS NULL		-- descomentar para pegar só que telefone NULL
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : UNIFICA AS 2 BASES DE TELEFONES								    			*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
SET 		 statement_timeout 
= 			 6000000;

SELECT 
			A.*
, 			B.STATUS_TELEFONE_AUTOR
,			B.TELEFONE_AUTOR

FROM 	TEMP_BASE_TEL_CONTATO A
JOIN	TEMP_BASE_TEL_AUTOR 	 B 
ON 	(A.EXTERNAL_ID 	= 	B.EXTERNAL_ID)

WHERE 
		A.TELEFONE_CONTATO = 'Sem Telefone'			-- descomentar para pegar só que telefone NULL
AND   
		B.TELEFONE_AUTOR 	 = 'Sem Telefone'
AND ( 
		
			A.recorrencia = 'i'
		OR b.recorrencia = 'i'
	 )









