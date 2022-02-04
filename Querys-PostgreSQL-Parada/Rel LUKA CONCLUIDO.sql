SELECT 	CLI.NAME AS CLIENTE
			,CA.NAME AS CAMPANHA
			,FAS.name AS FASE
			,DOS.state AS STATUS
			,DOS.data_conclusao AS data_conclusao
			,MC.name AS MOTIVOCONCLUSAO
			,COUNT(1) AS QTDE
			
FROM		 mmp_pre_dossie DOS

INNER
JOIN		 mmp_pre_client_group CLI
ON			 DOS.group_id
=			 CLI.id

INNER
JOIN		 mmp_pre_campanha CA
ON			 DOS.campanha_id
=			 CA.id

JOIN		 mmp_pre_dossie_fase FAS
ON			 DOS.fase_id			 
=			 FAS.id

LEFT
JOIN		 mmp_pre_motivo_conclusao MC
ON			 DOS.motivo_conclusao_id
=			 MC.id
INNER JOIN 
(SELECT
DISTINCT CA.id AS ID_CAMPANHA
from mmp_pre_dossie DOS
INNER JOIN mmp_pre_client_group CLI ON CLI.id = DOS.group_id
INNER JOIN mmp_pre_campanha CA ON CA.id = DOS.campanha_id
--WHERE DOS.state = '10c' AND DOS.data_conclusao >= '2021-01-01 00:00:00'
) K ON K.ID_CAMPANHA = DOS.campanha_id
WHERE DOS.state = '10c' AND DOS.data_conclusao >= '2021-01-01 00:00:00'
GROUP BY 1,2,3,4,5,6

