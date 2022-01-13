SET		 statement_timeout TO 600000;
SELECT DOS.name AS DOSSIE
           ,CASE WHEN DOS.state = '10c' THEN 'Concluído'
			  			    WHEN DOS.state = '01ac' THEN 'Aguardando Contato'
			  			    WHEN DOS.state = '05cp' THEN 'Contraproposta'
			  			    WHEN DOS.state = '03aa' THEN 'Aprovando Alçada'
			  			    WHEN DOS.state = '06me' THEN 'Minuta Enviada'
			  			    WHEN DOS.state = '04aan' THEN 'Aguardando Cliente'
			  			    WHEN DOS.state = '02t' THEN 'Triagem'
			  			    WHEN DOS.state = '08ap' THEN 'Aguardando Protocolo'
			  			    WHEN DOS.state =  '07mr' THEN 'Minuta Recebida'
											 ELSE '"' 
											 	END AS Status
           ,SITU.name AS SITUACAO
            ,CA.name AS CAMPANHA
            ,MC.name AS MOTIVO_CONCLUSAO
				,DOS.vl_acordo AS VALOR_ACORDO 
            ,CASE WHEN DOS.situacao_acordo = 'pd' THEN 'Promessa em Dia'
           				 WHEN DOS.situacao_acordo = 'pq' THEN 'Promessa Quebrada'
           				 WHEN DOS.situacao_acordo = 'al' THEN 'Acordo Liquidado'
           				 WHEN DOS.situacao_acordo = 'ad' THEN 'Acordo em Dia'
           				 WHEN DOS.situacao_acordo = 'aa' THEN 'Acordo em Atraso'
           				 WHEN DOS.situacao_acordo = 'aq' THEN 'Acordo Quebrado'
           				 ELSE '"' 
											 	END AS situacao_acordo
											 	,dos.data_conclusao
											 	,extract( month from dos.data_conclusao ) as mes
												,case when dos.faixa2 between 1 and 1000 then 'Acordos Fechados até $1000'
														when dos.faixa2 between 1001 and 2000  then 'Acordos Fechados de $1001 a $2000'
														 when  dos.faixa2 between 2001 and 3000 then 'Acordos Fechados de $2001 a $3000'
														 when  dos.faixa2 between 3001 and 4000 then 'Acordos Fechados de $3001 a $4000'
														 when  dos.faixa2 > 4001 then 'acordos acima de $4000'
														else 'n/a'
											 END AS SLIDE_4
												,CASE WHEN DOS.faixa2 BETWEEN 1 AND 500 THEN 'Até $500,00'
									  	 				WHEN DOS.faixa2 BETWEEN 501 AND 1000  THEN 'Até $1.000,00'
														 WHEN  DOS.faixa2 BETWEEN 1001 AND 2000 THEN 'Até $2.000,00'
														 WHEN  DOS.faixa2 BETWEEN 2001 AND 3000 THEN 'Até $3.000,00'
														 WHEN  DOS.faixa2 BETWEEN 3001 AND 5000 THEN 'Até $5,000,00'
														 WHEN  DOS.faixa2 > 5001 THEN 'Acima de $5,000,00'
													ELSE 'N/A'
											 END AS SLIDE_5
											 
											 	,CASE WHEN DOS.faixa2 BETWEEN 5001 AND 10000 THEN 'De $5.001,00 a $10.000,00'
									  	 				WHEN DOS.faixa2 BETWEEN 10001 AND 20000  THEN 'De $10.001,00 a $20.000,00'
														 WHEN  DOS.faixa2 BETWEEN 20001 AND 30000 THEN 'De $20.001,00 a $30.000,00'
														 WHEN  DOS.faixa2 BETWEEN 30001 AND 40000 THEN 'De $30.001,00 a $40.000,00'
														 WHEN  DOS.faixa2 BETWEEN 40001 AND 50000 THEN 'De $40.001,00 a $50.000,00'
														 WHEN  DOS.faixa2 BETWEEN 50001 AND 100000 THEN 'De $50.001,00 a $100.000,00'
														 WHEN  DOS.faixa2 > 100000 THEN 'Acima de $100.000,00'
													ELSE 'N/A'
											 END AS SLIDE_8
											,DOS.cluster_novo AS CLUSTER_NOVO	
											,DOS.create_date AS DATA_CRIAÇÃO 
											,DOS.faixa2
											,DOS.numero_acordo
											
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

WHERE CLI.NAME = 'ITAÚ' AND CA.name LIKE 'ITAÚ - PLANOS - 2021%'