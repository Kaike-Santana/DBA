/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* PROGRAMADOR: KAIKE NATAN                                                                                           */
/* VERSAO     : 1.0      																									DATA: 21/10/2021   */
/* DESCRICAO  : RESPONSAVEL POR PEGAR OS TELEFONES INCORRESTOS DA NOSSA BASE												 		 */	   								
/* ALTERACAO                                                                                                          */
/*        2. PROGRAMADOR: 																									DATA: __/__/____	 */
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
			,b.name												AS 	TELEFONE
			,B.id 												AS 	ID_TELEFONE 														
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
			 A.state != '10c'
AND		 
			 c.inativa = 'false'
AND		 
			 E.DIAL = 'sim'

			 
/* APAGA OS NOME ZUADOS */			 
DELETE FROM TEMP_ANALITICO_MAILING
WHERE (
			  NOME_CONTATO = 'KAIKE'
		  OR LENGTH(NOME_CONTATO) <= 2
		)

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
			,TELEFONE
			,ID_TELEFONE
			,EMAIL_CONTATO
			,CARTEIRA
			,CANAL
			,FASE_PROCESSO
			,UPPER(RECORRENCIA) 															  AS RECORRENCIA
         ,ROW_NUMBER () OVER (PARTITION BY TELEFONE ORDER BY EXTERNAL_ID) AS TEL_DUPLICADOS
         ,ROW_NUMBER () OVER (PARTITION BY DOSSIE   ORDER BY EXTERNAL_ID) AS DOSSIE_DUPLICADOS

FROM 
		TEMP_ANALITICO_MAILING

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



DROP TABLE IF EXISTS TEMP_MODELAGEM_TEL;
CREATE TEMPORARY TABLE TEMP_MODELAGEM_TEL AS
SELECT *
,RTRIM(
	LTRIM(
		CASE 
					  WHEN CHAR_LENGTH (regexp_replace(telefone, '\d', '', 'g')) < CHAR_LENGTH (telefone) 
					  THEN regexp_replace(telefone, '[^0-9]', '', 'g')
					  ELSE NULL 
 		END)) 	  AS TEL_TRATADO
FROM TEMP_TABELA_FINAL
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : FAZ A VALIDAÇÃO DAS COLUNAS DE TELEFONE						  			*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS TEMP_MODELAGEM_FINAL;
CREATE TEMPORARY TABLE TEMP_MODELAGEM_FINAL AS

SELECT 
	ID_TELEFONE
,	TEL_TRATADO
,	IIF(LENGTH(TEL_TRATADO) = '10' AND SUBSTRING(TEL_TRATADO,3,1) != '9','ND A FAZER',TEL_TRATADO)  AS FIXOS_INCORRETOS
,	IIF(LENGTH(TEL_TRATADO) = '11' AND SUBSTRING(TEL_TRATADO,3,1)  = '9','ND A FAZER',TEL_TRATADO) 	AS CELULARES_INCORRETOS
,	LENGTH(TEL_TRATADO)																										AS NUM_CARACTER
,	SUBSTRING(TEL_TRATADO,3,1)																								AS VL_TEL

FROM 
		TEMP_MODELAGEM_TEL
WHERE
		STATUS_TELEFONE != 'Telefone incorreto'
		
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : TABELA FINAL SOMENTE COM OS TELEFONES A SEREM TRATADOS				*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	
SELECT 
		ID_TELEFONE
,		TEL_TRATADO
,		LENGTH(TEL_TRATADO)    	   AS NUM_CARACTER
,		SUBSTRING(TEL_TRATADO,3,1) AS TIPO_TEL
FROM 
		TEMP_MODELAGEM_FINAL
WHERE
		FIXOS_INCORRETOS 		!= 'ND A FAZER'
AND 
		CELULARES_INCORRETOS != 'ND A FAZER'
		
		