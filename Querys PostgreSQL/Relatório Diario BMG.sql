SELECT	 '__export__.mmp_pre_dossie_' || DOS.id AS ID
			,DOS.name AS DOSSIE
			,AUT.name AS AUTOR
			,AUT.cnpj_cpf AS CPF_CNPJ
			,DOS.cpf AS CPF
			,DOS."type" AS TIPO
			,MU.name AS CIDADE
			,ES.code AS UF
			,DOS.processo AS PROCESSO
			,DOS.faixa1 AS FAIXA_1
			,DOS.faixa2 AS FAIXA_2
			,DOS.vl_contraproposta AS VALOR_CONTRAPROPOSTA
			,DOS.vl_acordo AS VALOR_ACORDO
			,DOS.state AS STATUS
			,SITU.name AS SITUACAO
			,FAS.name FASE
			,CA.name AS CAMPANHA
			,ADV.name AS CONTATO
			,ADV.email AS CONTATO_EMAIL
			,DOS.data_conclusao AS DATA_CONCLUSÃO
			,MC.name AS MOTIVO_CONCLUSAO
		--	,DOS.create_date
FROM		 mmp_pre_dossie DOS
LEFT
JOIN		 res_partner ADV
ON			 DOS.contato_id
=			 ADV.id
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
JOIN		 mmp_pre_dossie_status SITU
ON			 DOS.dossie_status_id
=			 SITU.id
LEFT
JOIN		 mmp_pre_dossie_fase FAS
ON			 DOS.fase_id			 
=			 FAS.id
LEFT
JOIN		 mmp_pre_campanha CA
ON			 DOS.campanha_id
=			 CA.id
LEFT
JOIN		 mmp_pre_motivo_conclusao MC
ON			 DOS.motivo_conclusao_id
=			 MC.id
WHERE		 DOS.group_id
IN 		 (22) AND CA.name = 'BMG - LEVA 2021/02/26'