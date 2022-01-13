SET 		 statement_timeout 
= 			 6000000;

SELECT	 A.id				AS EXTERNAL_ID 
			,A.state			AS STATUS
			,A.name			AS DOSSIE
			,F.name			AS GROUP
			,C.NAME			AS CAMPANHA
			,H.NAME			AS FASE
			,MC.name			AS MOTIVO_CONCLUSAO
			,A.data_conclusao	AS DATA_CONCLUSAO
FROM		 mmp_pre_dossie A
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
WHERE		 A.STATE
IN			('01ac',
			 '02t',
			'03aa',
			'04aan',
			'06me',
			'08ap',
			'10c')
AND		 F.name
NOT 
IN			('PPM')
AND 		 A.data_conclusao
>=			 '2021-07-01'
OR			 A.data_conclusao
ISNULL	 
AND		 A.STATE
IN			('01ac',
			 '02t',
			'03aa',
			'04aan',
			'06me',
			'08ap',
			'10c')

