

SET 		 statement_timeout 
= 			 6000000;

SELECT	 CONCAT('__export__.mmp_pre_dossie_',A.ID) AS EXTERNAL_ID
			,A.contato_id
			,A.cpf AS CPF
			,D.name AS NOME_contato
			,G.name  NOME_AUTOR
			,A.name AS DOSSIE
			,A.processo
			,A.STATE AS STATUS
			,F.name AS PRODUTOaccount_config_settings
			,C.name AS CAMPANHA
			,A.FAIXA1 AS VALOR_FAIXA1
			,A.faixa2 AS VALOR_FAIXA_2
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
WHERE		 A.state IN ('01ac')
