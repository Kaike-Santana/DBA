SELECT	 C.ID
			,C.create_date						AS DATA
			,C.call_to							AS NUMERO
			,B.name								AS ACIONAMENTO
			,D.name								AS CAMPANHA
			,F.name								AS GROUP
			,A.x_marcacao_planejamento_1	AS CARTEIRA
			,A.name								AS DOSSIE
			,A.faixa1							AS FAIXA1
			,A.faixa2							AS FAIXA2
			,A.vl_acordo						AS VL_ACORDO
			,A.state								AS STATUS
			,G.login								AS USUARIO
			,MC.name								AS MOTIVO_CONCLUSAO
			,H.name								AS FASE
FROM		 MMP_PRE_DOSSIE A
inner
JOIN		 mmp_pre_campanha D
ON			 A.campanha_id
=			 D.id
inner
JOIN		 mmp_pre_client_group F
ON			 A.group_id
=			 F.id
LEFT
JOIN		 MMP_PRE_CALL C
ON			 A.id
=			 C.dossie_id
INNER
JOIN		 res_users G
ON			 C.user_id
=			 G.id
inner
JOIN		 mmp_pre_acionamento B
ON			 C.acionamento_id
=			 B.id
left
JOIN		 mmp_pre_dossie_fase H
ON			 A.fase_id
=			 H.ID
LEFT
JOIN		 mmp_pre_motivo_conclusao MC
ON			 A.motivo_conclusao_id
=			 MC.id
WHERE		 C.create_date::VARCHAR(10)
>=			 '2021-06-01'