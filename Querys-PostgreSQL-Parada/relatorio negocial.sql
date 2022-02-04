SET 		 statement_timeout 
= 			 6000000;

SELECT	 A.ID AS EXTERNAL_ID
			,A.contato_id 				
			,D.name 							AS NOME_contato 
			,A.name 							AS DOSSIE
			,F.name 							AS GROUP
			,C.name 							AS CAMPANHA
			,A.faixa2 						AS VALOR_FAIXA_2
			,X_MARCACAO_PLANEJAMENTO_1 AS CARTEIRA
			,X_MARCACAO_PLANEJAMENTO_2 AS ESTRATÉGIA
			,A.count_type 					AS RECORRENCIA
			,C.inativa						AS STATUS_CAMPANHA
			,H.name							AS FASE
			,MC.name							AS MOTIVO_CONCLUSAO
			,A.flag_wo						AS NEGOCIADOR
			,A.state
			,A.data_conclusao	
FROM		 mmp_pre_dossie A
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
LEFT
JOIN		 mmp_pre_motivo_conclusao MC
ON			 A.motivo_conclusao_id
=			 MC.id
WHERE		 A.state <> '10c'
AND		 c.inativa = 'false'
OR			 A.data_conclusao
>=			 '2021-06-01'
AND		 c.inativa = 'false'