SELECT	 CLI.NAME AS CLIENTE
			,CA.NAME AS CAMPANHA
			,FAS.name AS FASE
			,DOS.state AS STATUS, COUNT(1) AS QTDE
			
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

INNER JOIN 
(SELECT
DISTINCT CA.id AS ID_CAMPANHA
from mmp_pre_dossie DOS
INNER JOIN mmp_pre_client_group CLI ON CLI.id = DOS.group_id
INNER JOIN mmp_pre_campanha CA ON CA.id = DOS.campanha_id
WHERE DOS.state NOT IN ('10c')
) K ON K.ID_CAMPANHA = DOS.campanha_id
GROUP BY 1,2,3,4