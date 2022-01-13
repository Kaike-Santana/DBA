SET		 statement_timeout TO 600000; COMMIT;
SELECT	 '_export.mmp_pre_dossie' || DOS.id AS ID
			,Dos.name AS DOSSIE
			,DOS.numero_contrato AS NUMERO_CONTRATO
			,AUT.name AS AUTOR
			,AUT.cnpj_cpf AS CPF_CNPJ
			,DOS.cpf AS CPF
			,ADV.id AS id_CONTATO
			,ADV.name AS CONTATO
			,ADV.oab AS oab_CONTATO
			,CRED.id AS id_CREDENCIADO
			,CRED.name AS CREDENCIADO
			,f.name AS grupo
			,DOS.processo AS PROCESSO
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
				END AS "Status Odoo" 
			,MC.name AS MOTIVO_CONCLUSAO
			,FAS.name FASE
			,SITU.name AS SITUACAO
			,DOS.faixa1 AS FAIXA_1
			,DOS.faixa2 AS FAIXA_2
			,CA.name AS CAMPANHA
			,DOS.cluster_novo AS CLUSTER_NOVO
			,DOS.numero_acordo AS NUMERO_ACORDO
			,DOS.data_conclusao AS DATA_CONCLUSÃO
			,DOS.data_modificacao_situacao AS DATA_MODIFICAÇÃO_SITUAÇÃO
			,DOS.x_estado_caso AS ESTADO_CASO
			,DOS.observacoes AS OBS
FROM		 mmp_pre_dossie DOS	
INNER  JOIN		 mmp_pre_client_group F
ON			 (DOS.group_id		=			 F.id)		
LEFT
JOIN		 res_partner AUT
ON			 DOS.autor_id
=			 AUT.id

LEFT
JOIN		 mmp_pre_motivo_conclusao MC
ON			 DOS.motivo_conclusao_id
=			 MC.id

LEFT
JOIN		 mmp_pre_campanha CA
ON			 DOS.campanha_id
=			 CA.id

LEFT
JOIN		 res_partner ADV
ON			 DOS.contato_id
=			 ADV.id

LEFT
JOIN		 res_partner CRED
ON			 DOS.credenciado_id
=			 CRED.id

LEFT
JOIN		 mmp_pre_dossie_fase FAS
ON			 DOS.fase_id			 
=			 FAS.id

LEFT
JOIN		 mmp_pre_dossie_status SITU
ON			 DOS.dossie_status_id
=			 SITU.id

WHERE		 DOS.group_id
IN 		 (2);