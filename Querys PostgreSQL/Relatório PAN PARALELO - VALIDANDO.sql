SELECT DOS.name AS DOSSIE
		,DOS.processo AS PROCESSO
		,DOS.faixa1 AS FAIXA_1
		,DOS.faixa2 AS FAIXA_2
		,DOS.vl_acordo AS VALOR_ACORDO
           ,CASE WHEN DOS.state = '10c' THEN 'Concluído'
			  			    WHEN DOS.state = '01ac' THEN 'Aguardando Contato'
			  			    WHEN DOS.state = '05cp' THEN 'Contraproposta'
			  			    WHEN DOS.state = '03aa' THEN 'Aprovando Alçada'
			  			    WHEN DOS.state = '06me' THEN 'Minuta Enviada'
			  			    WHEN DOS.state = '04aan' THEN 'Aguardando Cliente'
			  			    WHEN DOS.state = '02t' THEN 'Triagem'
			  			    WHEN DOS.state = '08ap' THEN 'Aguardando Protocolo'
			  			    WHEN DOS.state =  '07mr' THEN 'Minuta Recebida'
			  			    WHEN DOS.state =  '09av' THEN 'Aguardando Validação'
											 ELSE '"' 
											 	END AS STATUS_ODOO
				,CASE WHEN DOS.state = '10c' AND MC.name = 'Acordo' THEN 'Acordo Realizado'
							 WHEN DOS.state = '10c' AND MC.name = 'Contraproposta inviável' THEN 'Pretensão Superior'
							 WHEN DOS.state = '10c' AND MC.name = 'Cliente não localizado' THEN 'Sem Contato'
							 WHEN DOS.state = '10c' AND MC.name = 'Sem Interesse' THEN 'Desinteresse'
							 WHEN DOS.state = '10c' AND MC.name = 'Obrigação impossível' THEN 'OBF Impossível'
							 WHEN DOS.state = '10c' AND MC.name = 'Fase processual inapta' THEN 'Sentenciado'
							 WHEN DOS.state = '10c' AND MC.name = 'Matéria Inapta' THEN 'Não Elegível'
							 WHEN DOS.state = '10c' AND MC.name = 'Acordo realizado pelo credenciado' THEN 'Não Elegível'
							WHEN DOS.state = '10c' AND MC.name = 'Agressor' THEN 'Advogado/Autor Ofensivo'
			  			    WHEN DOS.state = '01ac' THEN 'Em Negociação'
			  			    WHEN DOS.state = '05cp' THEN 'Contraproposta'
			  			    WHEN DOS.state = '03aa' THEN 'Pretensão Superior'
			  			    WHEN DOS.state = '06me' THEN 'Acordo Realizado'
			  			    WHEN DOS.state = '04aan' THEN 'Pretensão Superior'
			  			    WHEN DOS.state = '02t' THEN 'Em Negociação'
			  			    WHEN DOS.state = '08ap' THEN 'Acordo Realizado'
			  			    WHEN DOS.state =  '07mr' THEN 'Acordo Realizado' 
							 WHEN DOS.state =  '09av' THEN 'Em Negociação'
										 ELSE '"' 
											 	END AS STATUS_CLIENTE
            ,SITU.name AS SITUAÇÃO
            ,CA.name AS CAMPANHA
            ,MC.name AS MOTIVO_CONCLUSÃO 
FROM         mmp_pre_dossie DOS

JOIN		 mmp_pre_client_group CLI
ON			 DOS.group_id
=			 CLI.id

LEFT
JOIN         res_partner ADV
ON             DOS.contato_id
=             ADV.id
LEFT
JOIN         res_partner AUT
ON             DOS.autor_id
=             AUT.id
LEFT
JOIN         res_partner CRED
ON             DOS.credenciado_id
=             CRED.id
LEFT
JOIN         res_state_city MU
ON             DOS.l10n_br_city_id
=             MU.id
LEFT
JOIN         res_country_state ES
ON             MU.state_id
=             ES.id
LEFT
JOIN         mmp_pre_dossie_status SITU
ON             DOS.dossie_status_id
=             SITU.id
LEFT
JOIN         mmp_pre_dossie_fase FAS
ON             DOS.fase_id
=             FAS.id
LEFT
JOIN         mmp_pre_campanha CA
ON             DOS.campanha_id
=             CA.id
LEFT
JOIN         mmp_pre_motivo_conclusao MC
ON             DOS.motivo_conclusao_id
=             MC.id
WHERE  CA.name IN ('PAN - (PARALELOS) Indenizatórias - Inicio 05.05.2021 - 2 LEVA','PAN - (PARALELOS) Indenizatórias - Inicio 05.05.2021 - 1 LEVA','PAN - (PARALELOS) Indenizatórias - Inicio 07.05.2021 - 3 LEVA')



