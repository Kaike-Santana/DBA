SELECT	 C.ID
			,C.create_date::VARCHAR(10)	AS DATA
			,C.call_to							AS NUMERO
			,B.name								AS ACIONAMENTO
			,D.name								AS CAMPANHA
			,F.name								AS GROUP
			,A.name								AS DOSSIE
			,A.state								AS STATUS
			,Z.name								AS USUARIO
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
INNER
JOIN		 res_partner Z
ON			 G.partner_id
=			 Z.id
WHERE		 C.create_date::VARCHAR(10)
>=			 '2021-06-01'