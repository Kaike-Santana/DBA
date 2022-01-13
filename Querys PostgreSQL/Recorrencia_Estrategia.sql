SET 		 statement_timeout 
= 			 6000000;

SELECT	 CONCAT('__export__.dossie_dossie_',A.ID) AS EXTERNAL_ID
			,A.contato_id 
			,A.cpf AS CPF
			,D.name AS NOME_contato 
			,G.name  NOME_AUTOR
			,A.name AS DOSSIE
			,A.processo
			,F.name AS PRODUTO
			,C.name AS CAMPANHA
			,A.faixa1 AS VALOR_FAIXA_1
			,A.faixa2 AS VALOR_FAIXA_2
			,X_MARCACAO_PLANEJAMENTO_1 AS CARTEIRA
			,X_MARCACAO_PLANEJAMENTO_2 AS ESTRATÉGIA
			,A.count_type AS RECORRENCIA
			,A.data_conclusao 
			,C.inativa		AS STATUS_CAMPANHA
			,A.state	AS STATUS
			,A.oab	AS OAB
			,MC.name	AS MOTIVO_CONCLUSAO
			,H.name  AS FASE
			,A.flag_wo
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
LEFT
JOIN		 mmp_pre_motivo_conclusao MC
ON			 A.motivo_conclusao_id
=			 MC.id
INNER
JOIN		 mmp_pre_dossie_fase H
ON			 A.fase_id
=			 H.ID
WHERE		 A.state <> '10c'
AND		 c.inativa = 'false'
OR			 A.data_conclusao
>=			 '2021-06-01'
AND		 c.inativa = 'false'