

SELECT  '__export__.mmp_pre_dossie_' || DOS.id AS  "ID"
			,DOS.name AS "Dossiê"
			,AUT.name AS "Autor"
			,DOS.cpf AS "CPF"
			,DOS."type" AS "Tipo"
			,MU.name AS "Cidade"
			,ES.code AS "UF"
			,DOS.processo AS "Nº Processo"
			,DOS.faixa1 AS "Faixa 1"
			,DOS.faixa2 AS "Faixa 2"
			,DOS.vl_contraproposta AS "Valor Contraposposta"
			,DOS.vl_acordo AS "Valor Acordo"
			,CASE WHEN DOS.state = '10c' THEN 'Concluído'
			 	WHEN DOS.state = '01ac' THEN 'Em Contato'
			  		WHEN DOS.state = '05cp' THEN 'Contraproposta'
			  			WHEN DOS.state = '03aa' THEN 'Aprovando Alçada'
			  			    WHEN DOS.state = '06me' THEN 'Minuta Enviada'
			  			    	WHEN DOS.state = '04aan' THEN 'Aguardando Cliente'
			  			    		WHEN DOS.state = '02t' THEN 'Triagem'
			  			    			WHEN DOS.state = '08ap' THEN 'Aguardando Protocolo'
			  			    				WHEN DOS.state =  '07mr' THEN 'Minuta Recebida'
			  			    					WHEN DOS.state =  '09av' THEN 'Aguardando Validação'
			ELSE '"' 
				END AS "Status Odoo"

			,SITU.name AS "Situação"
			,FAS.name AS "Fase"
			,CA.name AS "Campanha"
			,ADV.name AS "Contato"
			,ADV.email AS "E-mail"
			,MC.name AS "Motivo Conclusão"
			,DOS.subject AS "Assunto"	
				,CASE WHEN DOS.state = '01ac' THEN 'Em contato'
			  		WHEN DOS.state = '05cp' THEN 'Em contato'
						WHEN DOS.state = '03aa' THEN 'Acordo'
			  			    WHEN DOS.state = '06me' THEN 'Acordo'
			  			    	WHEN DOS.state = '04aan' THEN 'Acordo' 
			  			    		WHEN DOS.state = '02t' THEN 'Acordo'
			  			    			WHEN DOS.state = '08ap' THEN 'Em contato'
			  			    				WHEN DOS.state =  '07mr' THEN 'Acordo'
			  			    					WHEN DOS.state =  '09av' THEN 'Em contato'
			  			    						WHEN DOS.state = '10c' AND MC.name ='Acordo' THEN 'Acordo'
			  			    							WHEN DOS.state = '10c' AND MC.name = 'Acordo realizado pelo credenciado' THEN 'Concluído'
			  			    								WHEN DOS.state = '10c' AND MC.name = 'Cliente não localizado' THEN 'Concluído'
			  			    									WHEN DOS.state = '10c' AND MC.name = 'Sem Condições' THEN 'Concluído'
			  			    										WHEN DOS.state = '10c' AND MC.name = 'Sem Contato' THEN 'Concluído'
			  			   											 	WHEN DOS.state = '10c' AND MC.name = 'Sem Interesse' THEN 'Concluído'
			  															    WHEN DOS.state = '10c' AND MC.name = 'Excluído a Pedido do Cliente' THEN 'Concluído'
			  																	WHEN DOS.state = '10c' AND MC.name = 'Acordo Parcelado' THEN 'Acordo'
																					WHEN DOS.state = '10c' AND MC.name = 'Desistência de Acordo' THEN 'Concluído'
																						WHEN DOS.state = '10c' AND MC.name = 'Contraproposta inviável' THEN 'Concluído'
																							WHEN DOS.state = '10c' AND MC.name = 'Duplicado' THEN 'Concluído'
																								WHEN DOS.state = '10c' AND MC.name = 'Sem audiência' THEN 'Concluído'
			ELSE 'KAIKAO' 
				END AS "Status Cliente"	
			,CASE
WHEN DOS.data_conclusao IS NOT NULL 						  THEN TO_CHAR(DOS.data_conclusao,'dd/mm/yyyy')
WHEN DOS.data_conclusao IS NULL AND DOS.state = '03aa'  THEN TO_CHAR(NOW() :: DATE, 'dd/mm/yyyy')
WHEN DOS.data_conclusao IS NULL AND DOS.state = '06me'  THEN TO_CHAR(NOW() :: DATE, 'dd/mm/yyyy')
WHEN DOS.data_conclusao IS NULL AND DOS.state = '04aan' THEN TO_CHAR(NOW() :: DATE, 'dd/mm/yyyy')
WHEN DOS.data_conclusao IS NULL AND DOS.state = '02t'   THEN TO_CHAR(NOW() :: DATE, 'dd/mm/yyyy')
WHEN DOS.data_conclusao IS NULL AND DOS.state = '07mr'  THEN TO_CHAR(NOW() :: DATE, 'dd/mm/yyyy')
WHEN DOS.data_conclusao IS NULL AND DOS.state = '01ac'  THEN TO_CHAR(NOW() :: DATE, 'dd/mm/yyyy')
WHEN DOS.data_conclusao IS NULL AND DOS.state = '05cp'  THEN 'NDA'
WHEN DOS.data_conclusao IS NULL AND DOS.state = '08ap'  THEN 'NDA'
WHEN DOS.data_conclusao IS NULL AND DOS.state = '09av'  THEN 'NDA'

					  	--		    						WHEN DOS.state = '10c' AND MC.name ='Acordo' THEN DOS.data_conclusao
					  	--		    							WHEN DOS.state = '10c' AND MC.name = 'Acordo realizado pelo credenciado' THEN 'Concluído'
					  	--		    								WHEN DOS.state = '10c' AND MC.name = 'Cliente não localizado' THEN 'Concluído'
					  	--		    									WHEN DOS.state = '10c' AND MC.name = 'Sem Condições' THEN 'Concluído'
					  	--		    										WHEN DOS.state = '10c' AND MC.name = 'Sem Contato' THEN 'Concluído'
					  	--		   											 	WHEN DOS.state = '10c' AND MC.name = 'Sem Interesse' THEN 'Concluído'
					  	--														    WHEN DOS.state = '10c' AND MC.name = 'Excluído a Pedido do Cliente' THEN 'Concluído'
					  	--																WHEN DOS.state = '10c' AND MC.name = 'Acordo Parcelado' THEN 'Acordo'
						--																	WHEN DOS.state = '10c' AND MC.name = 'Desistência de Acordo' THEN 'Concluído'
						--																		WHEN DOS.state = '10c' AND MC.name = 'Contraproposta inviável' THEN 'Concluído'
						--																			WHEN DOS.state = '10c' AND MC.name = 'Duplicado' THEN 'Concluído'
						--																				WHEN DOS.state = '10c' AND MC.name = 'Sem audiência' THEN 'Concluído'
		ELSE 'RETURN'
				END AS "Data Conclusão Cliente"
FROM mmp_pre_dossie DOS
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

JOIN		 mmp_pre_client_group CLI
ON			 DOS.group_id
=			 CLI.id

WHERE CLI.name = 'Gyramais' AND DOS.state = '10c'