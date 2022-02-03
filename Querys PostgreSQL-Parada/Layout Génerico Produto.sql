		SELECT	
			DOS.ID AS ID
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
				END AS "Status"
			,MC.name AS "Motivo de Conclusão"
			,SITU.name AS SITUACAO								 							 	
			,FAS.name "Fase"
			,DOS.last_modified
			,DOS.data_conclusao AS "Data de Conclusão"
			,CAST(DOS.vl_acordo AS DOUBLE PRECISION) AS "Valor do Acordo"
			,CLI.name AS "Grupo"
			,CA.name AS "Campanha" 
FROM		 mmp_pre_dossie DOS

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
LEFT
JOIN		 mmp_pre_client CLI
ON			 DOS.client_id
=			 CLI.id
LEFT
JOIN		 mmp_pre_dossie_status SITU
ON			 DOS.dossie_status_id
=			 SITU.id
WHERE DOS.last_modified < '2021-09-01'
AND CLI.name ILIKE '%BRADESCO%'
ORDER BY DOS.last_modified DESC