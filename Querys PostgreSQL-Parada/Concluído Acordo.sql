SELECT	 DOS.name AS DOSSIE
			,DOS.processo AS PROCESSO
			,AUT.name AS AUTOR
			,DOS.cpf AS CPF
		   ,DOS.faixa2 AS FAIXA_2
			,MU.name AS CIDADE
			,ES.code AS UF
			,CA.name AS CAMPANHA
			,DOS.data_conclusao
FROM		 mmp_pre_dossie DOS

LEFT
JOIN		 res_partner AUT
ON			 DOS.autor_id
=			 AUT.id
LEFT
JOIN		 res_state_city MU
ON			 DOS.l10n_br_city_id
=			 MU.id

LEFT		 
JOIN		 res_country_state ES
ON			 MU.state_id
=			 ES.id
LEFT
JOIN		 mmp_pre_campanha CA
ON			 DOS.campanha_id
=			 CA.id
LEFT
JOIN		 mmp_pre_motivo_conclusao MC
ON			 DOS.motivo_conclusao_id
=			 MC.id
WHERE  MC.name = 'Acordo'  AND CA.name IN ('BMG - LEVA 2021/02/26','PAN - (PARALELOS) Indenizatórias - Inicio 05.05.2021 - 2 LEVA','PAN - (PARALELOS) Indenizatórias - Inicio 05.05.2021 - 1 LEVA','PAN - (PARALELOS) Indenizatórias - Inicio 07.05.2021 - 3 LEVA','PAN - (PARALELOS) Indenizatórias - Inicio 28.06.2021 - 4 LEVA')
 