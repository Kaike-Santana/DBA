
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* PROGRAMADOR: KAIKE NATAN                                                                                           */
/* VERSAO     : 1.0      																									DATA: 21/10/2021   */
/* DESCRICAO  : RESPONSAVEL POR FAZER O MAILING NEGOCIAL 																		 		 */
/*			   																										   								 */
/* ALTERACAO                                                                                                          */
/*        2. PROGRAMADOR: KAIKE NATAN																	     			DATA: 22/10/2021	 */
/*           DESCRICAO  : INCLUSAO DA FUNÇÃO DE REMOÇÃO DE CARACTERES ESPECIAIS													 */
/* ALTERACAO                                                                                                          */
/*        3. PROGRAMADOR: KAIKE NATAN																	     			DATA: 25/10/2021	 */
/*           DESCRICAO  : INCLUSAO DA FUNÇÃO ROW NUMBER PARA REMOÇÃO DOS TELEFONES DUPLICADOS								 */
/*																																							 */
/* ALTERACAO                                                                                                          */
/*        4. PROGRAMADOR: KAIKE NATAN																					DATA: 26/10/2021	 */
/*           DESCRICAO  : VALIDAÇÃO DA COLUNA NOME DO CONTATO, GARANTINDO QUE VENHA NOME DO AUTOR							 */
/*								  CASO A MESMA VENHA VAZIA, SEM ADVOGADO OU COM DEFENSORIA ESCRITO								 	 */																					
/* ALTERACAO                                                                                                          */
/*        5. PROGRAMADOR: KAIKE NATAN																					DATA: 27/10/2021	 */
/*           DESCRICAO  : AUTOMATIZAÇÃO DO PROCESSO DE DISPARO DE SMS E WHATS APP ATRAVÉS DO SQL	 						 */
/*																																							 */
/* ALTERACAO                                                                                                          */
/*        7. PROGRAMADOR: KAIKE NATAN																					DATA: 01/11/2021	 */																													                                                                                                                                                                                                  
/*           DESCRICAO  : RETIRANDO O QUE FOR DPS DA VIRGULA NA COLUNA NOME_CONTATO       									 */			
/* ALTERACAO                                                                                                          */
/*        8. PROGRAMADOR: 																									DATA: __/__/____	 */
/*           DESCRICAO  : 								 																							 */                                                                                                                                         
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	SET	statement_timeout TO 600000;	
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	PEGA AS INFORMAÇÕES ANALITICAS PARA O MAILING		    			*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS TEMP_ANALITICO_MAILING; 
CREATE TEMPORARY TABLE TEMP_ANALITICO_MAILING AS
SELECT
	 
			 '__export__.mmp_pre_dossie_' || A.ID 		AS 	EXTERNAL_ID
			,A.contato_id										AS 	ID_CONTATO
			,A.cpf 												AS 	CPF
			,LTRIM(
			 RTRIM(
			 CASE 
					WHEN D.name 		    IS NULL 
					OR   D.name   =      'Sem Advogado' 
					OR   D.name  LIKE    'Defensoria%' 
					OR   D.name  LIKE    'DEFENSORIA%'
					OR   D.name   =   	'N/H'
		   		OR   D.name   = 	   'N/A'
		   		OR   D.name  LIKE    'OAB%'
					THEN 'KAIKE' ELSE     D.name 
			 END))  												AS 	NOME_CONTATO
			,G.name												AS		NOME_AUTOR
			,A.name 												AS 	DOSSIE
			,A.processo											AS 	ID_PROCESSO
			,A.STATE 											AS 	STATUS
			,F.name 												AS 	PRODUTO
			,C.name 												AS 	CAMPANHA
			,E.dial												AS 	TELEFONE_HABILITADO
			,E.name   											AS 	STATUS_TELEFONE
			,A.FAIXA1 											AS 	VALOR_FAIXA1
			,A.faixa2 											AS 	VALOR_FAIXA_2
			,CASE 
					WHEN CHAR_LENGTH (regexp_replace(b.name, '\d', '', 'g')) < CHAR_LENGTH (b.name) 
					THEN regexp_replace(b.name, '[^0-9]', '', 'g')
					ELSE NULL 
			 END													AS 	TELEFONE
			,D.email 											AS		EMAIL_CONTATO
			,X_MARCACAO_PLANEJAMENTO_1 					AS 	CARTEIRA
			,X_MARCACAO_PLANEJAMENTO_2 					AS 	CANAL
			,H.NAME 												AS 	FASE_PROCESSO
			,A.COUNT_TYPE										AS 	RECORRENCIA

FROM		 public.mmp_pre_dossie A

INNER	 JOIN		 
			 res_partner G
ON			 (A.autor_id		=			 G.id)

INNER	 JOIN
			 res_partner D
ON			 (A.contato_id		=			 D.id)

INNER	 JOIN		  
			 mmp_pre_campanha C
ON			 (C.id				=		    A.campanha_id)

INNER  JOIN		 mmp_pre_client_group F
ON			 (A.group_id		=			 F.id)

INNER	 JOIN		 
			 mmp_pre_dossie_fase H
ON			 (A.fase_id			=			 H.ID)

LEFT	 JOIN		 mmp_pre_phone_number B
ON			 (D.id				=			 B.partner_id)

LEFT	 JOIN		 
			 mmp_pre_phone_status E
ON			 (E.id				=			 B.status_id)

WHERE		 
			 A.state IN ('01ac','06me')
AND		 
			 c.inativa = 'false'
AND		 
			 E.DIAL = 'sim'
AND 		 
			 X_MARCACAO_PLANEJAMENTO_2 = 'Digital'
			 
/* APAGA OS NOME ZUADOS */			 
DELETE FROM TEMP_ANALITICO_MAILING
WHERE (
			  NOME_CONTATO = 'KAIKE'
		  OR LENGTH(NOME_CONTATO) <= 2
		)

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	MODELAGEM DOS ESPAÇOS E VALIDAÇÃO DOS TELEFONES						*/
/*						PARA DISPAROS DOS SMS		  									  			*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS TEMP_MODELAGEM_MAILING; 
CREATE TEMPORARY TABLE TEMP_MODELAGEM_MAILING AS
SELECT 
			 EXTERNAL_ID
			,ID_CONTATO
			,CPF
			,REPLACE(nome_contato,',','.')								 AS NOME_CONTATO
			,NOME_AUTOR
			,DOSSIE
			,ID_PROCESSO
			,STATUS
			,PRODUTO
			,CAMPANHA
			,TELEFONE_HABILITADO
			,STATUS_TELEFONE
			,VALOR_FAIXA1
			,VALOR_FAIXA_2
			,SUBSTRING(nome_contato, 0, STRPOS(nome_contato, ' ')) AS PRIMEIRO_NOME
			,RTRIM(LTRIM(TELEFONE))	 										 AS TELEFONE
			,RTRIM(LTRIM(SUBSTRING(TELEFONE,3,1))) 					 AS VALIDACAO_CEL
			,LENGTH(RTRIM(LTRIM(TELEFONE))) 								 AS VALIDACAO_TEL
			,EMAIL_CONTATO
			,CARTEIRA
			,CANAL
			,FASE_PROCESSO
			,RECORRENCIA			
FROM	
		TEMP_ANALITICO_MAILING
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : REMOVE OS TELEFONES DUPLICADOS DA BASE DE TELEFONES		  			*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS TEMP_TABELA_FINAL;
CREATE TEMPORARY TABLE TEMP_TABELA_FINAL AS
SELECT  

 		    EXTERNAL_ID
			,ID_CONTATO
			,CPF
			,NOME_CONTATO	
			,NOME_AUTOR
			,DOSSIE
			,ID_PROCESSO
			,STATUS
			,PRODUTO
			,CAMPANHA
			,TELEFONE_HABILITADO
			,STATUS_TELEFONE
			,VALOR_FAIXA1
			,VALOR_FAIXA_2
			,PRIMEIRO_NOME
			,TELEFONE
			,VALIDACAO_CEL
			,VALIDACAO_TEL
			,EMAIL_CONTATO
			,CARTEIRA
			,CANAL
			,FASE_PROCESSO
			,UPPER(RECORRENCIA) 															  AS RECORRENCIA
         ,ROW_NUMBER () OVER (PARTITION BY TELEFONE ORDER BY EXTERNAL_ID) AS TEL_DUPLICADOS
         ,ROW_NUMBER () OVER (PARTITION BY DOSSIE   ORDER BY EXTERNAL_ID) AS DOSSIE_DUPLICADOS
FROM 
		TEMP_MODELAGEM_MAILING
WHERE
		VALIDACAO_CEL = '9'
AND 
		LENGTH(TELEFONE) = 11

/* REMOVE OS DUPLICADOS */		
DELETE FROM TEMP_TABELA_FINAL
WHERE (
			   TEL_DUPLICADOS     > 1
	 		OR DOSSIE_DUPLICADOS  > 1
	   )

/* DROPA COLUNAS DE VALIDAÇÃO */
ALTER TABLE TEMP_TABELA_FINAL
	DROP COLUMN TEL_DUPLICADOS
,	DROP COLUMN DOSSIE_DUPLICADOS
,	DROP COLUMN VALIDACAO_CEL
,	DROP COLUMN VALIDACAO_TEL

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	SMS POR CARTEIRA												   			*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
SELECT 
		CARTEIRA,
		TELEFONE,
		PRIMEIRO_NOME || ',' || 
		CASE 
				WHEN CARTEIRA = 'PLANOS'   THEN 'Seu cliente tem valores a receber referente a planos economicos. Sabia? Clique no link: https://bit.ly/MMP-Contatos e fale conosco'
				WHEN CARTEIRA = 'HONORÁRIO'THEN 'Nao perca oportunidade de regularizar seu debito! Entre em contato atraves do link bit.ly/MMP-Contatos'
				WHEN CARTEIRA = 'PARALELO' THEN 'Voce pode ter valores a receber referente a acao indenizatoria. Sabia? Entre em contato atraves do link: https://bit.ly/MMP-Contatos'
				WHEN CARTEIRA = 'ATIVAS'	THEN 'Nao perca oportunidade de regularizar seu debito! Entre em contato atraves do link bit.ly/MMP-Contatos'
				WHEN CARTEIRA = 'INDENI'   THEN 'Voce pode ter valores a receber referente a acao indenizatoria. Sabia? Entre em contato atraves do link: https://bit.ly/MMP-Contatos'
		END 	AS FRASE_SMS
FROM
			TEMP_TABELA_FINAL
WHERE
			CARTEIRA NOT IN ('AGRESSOR','PPM','TRAB')
AND
			CARTEIRA IS NOT NULL
ORDER 
		BY CARTEIRA
		
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	WHATS APP PLANOS ( BRADESCO )			 					   			*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
SELECT 
			PRODUTO
,			CAMPANHA
,			CARTEIRA
,			LTRIM(RTRIM('55'|| TELEFONE ||','|| NOME_CONTATO)) AS ZAP_ZAP
			
FROM
			TEMP_TABELA_FINAL 
WHERE
			PRODUTO  = 'BRADESCO'
AND
			CARTEIRA = 'PLANOS'
AND 
			STATUS != '06me'	
ORDER 
		BY	VALOR_FAIXA_2 DESC, -- DE Z a A
			STATUS_TELEFONE ASC -- DE A a Z
LIMIT 
		500

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : 	WHATS APP PLANOS ( SANTANDER )					  			 			*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/	
SELECT 
			PRODUTO
,			CAMPANHA
,			CARTEIRA
,			LTRIM(RTRIM('55'|| TELEFONE ||','|| NOME_CONTATO)) AS ZAP_ZAP
			
FROM
		TEMP_TABELA_FINAL 
WHERE
		PRODUTO  = 'SANTANDER'
AND
		CARTEIRA = 'PLANOS'
AND 
		STATUS != '06me'	
ORDER 
		BY	VALOR_FAIXA_2 DESC, -- DE Z a A
			STATUS_TELEFONE ASC -- DE A a Z

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : 	WHATS APP ( ATIVAS )									  			 			*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/	
SELECT 
			PRODUTO
,			CAMPANHA
,			CARTEIRA
,			LTRIM(RTRIM('55'|| TELEFONE ||','|| NOME_CONTATO)) AS ZAP_ZAP
			
FROM
		TEMP_TABELA_FINAL 
WHERE
		CARTEIRA = 'ATIVAS'
AND 
		STATUS != '06me'	
ORDER 
		BY	VALOR_FAIXA_2 DESC, -- DE Z a A
			STATUS_TELEFONE ASC -- DE A a Z

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : 	WHATS APP ( PARALELO )									  			 		*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/	
SELECT 
			PRODUTO
,			CAMPANHA
,			CARTEIRA
,			LTRIM(RTRIM('55'|| TELEFONE ||','|| NOME_CONTATO)) AS ZAP_ZAP
			
FROM
		TEMP_TABELA_FINAL 
WHERE
		CARTEIRA = 'PARALELO'
AND 
		STATUS != '06me'	
ORDER 
		BY	VALOR_FAIXA_2 DESC, -- DE Z a A
			STATUS_TELEFONE ASC -- DE A a Z

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : 	WHATS APP ( INDENIZATORIO )							  			 		*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/	
SELECT 
			PRODUTO
,			CAMPANHA
,			CARTEIRA
,			LTRIM(RTRIM('55'|| TELEFONE ||','|| NOME_CONTATO)) AS ZAP_ZAP
			
FROM
		TEMP_TABELA_FINAL 
WHERE
		CARTEIRA = 'INDENI'
AND 
		STATUS != '06me'	
ORDER 
		BY	VALOR_FAIXA_2 DESC, -- DE Z a A
			STATUS_TELEFONE ASC -- DE A a Z

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : 	WHATS APP ( MINUTA ENVIADA )							  			 		*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/	
SELECT 
			PRODUTO
,			CAMPANHA
,			CARTEIRA
,			LTRIM(RTRIM('55'|| TELEFONE ||','|| NOME_CONTATO)) AS ZAP_ZAP
			
FROM
		TEMP_TABELA_FINAL 
WHERE 
		STATUS = '06me'
AND 
		CARTEIRA != 'ATIVAS'	
ORDER 
		BY	VALOR_FAIXA_2 DESC, -- DE Z a A
			STATUS_TELEFONE ASC -- DE A a Z				/* não mandar pra campanhas ativas */ 




