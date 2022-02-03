
DROP TABLE IF EXISTS TEMP_BASE_TEL_CONTATO;
CREATE TEMPORARY TABLE TEMP_BASE_TEL_CONTATO AS
SELECT	 A.ID AS EXTERNAL_ID
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
			,E.name AS STATUS_TELEFONE_CONTATO
			,B.name AS TELEFONE_CONTATO
			,D.email 							EMAIL_CONTATO
			,X_MARCACAO_PLANEJAMENTO_1 AS CARTEIRA
			,X_MARCACAO_PLANEJAMENTO_2 AS ESTRATÉGIA
			,H.NAME 							AS FASE
			,A.COUNT_TYPE					AS RECORRENCIA
FROM		 mmp_pre_dossie A
INNER
JOIN		 res_partner G
ON			 A.autor_id
=			 G.id
INNER
JOIN		 res_partner D
ON			 A.contato_id
=			 D.id
left
JOIN		 mmp_pre_phone_number B
ON			 D.id
=			 B.partner_id
LEFT
JOIN		 mmp_pre_phone_status E
ON			 E.id
=			 B.status_id
INNER
JOIN		 mmp_pre_campanha C
ON			 C.id
=			 A.campanha_id
INNER
JOIN		 mmp_pre_client_group F
ON			 A.group_id
=			 F.id
INNER
JOIN		 mmp_pre_dossie_fase H
ON			 A.fase_id
=			 H.ID
WHERE		 A.state = '01ac'
AND 	  	 B.name IS null

SELECT A.*
,B.STATUS_TELEFONE_AUTOR
,B.TELEFONE_AUTOR

FROM 	TEMP_BASE_TEL_CONTATO A
JOIN	TEMP_BASE_TEL_AUTOR 	 B 
ON (	A.EXTERNAL_ID = B.EXTERNAL_ID	)
WHERE TELEFONE_CONTATO IS NULL
AND 	TELEFONE_AUTOR   IS NULL 

SELECT *
FROM TEMP_BASE_TEL_AUTOR