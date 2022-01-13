SELECT  '__export__.mmp_pre_dossie_' || DOS.id
		,DOS.name AS DOSSIE
	   ,CRED.name
	   ,CLI.name
         		,DOS.processo AS PROCESSO
            ,DOS.state AS STATUS
           ,CA.name AS CAMPANHA
            ,DOS.data_conclusao AS DATA_CONCLUSÃO
        		,MC.name AS MOTIVO_CONCLUSAO
        		,DOS.cluster_novo
				           ,CASE WHEN DOS.x_estado_caso = 'a' THEN 'Ativo'
			  			    WHEN DOS.x_estado_caso = 'e' THEN 'Encerrado'
											 ELSE '' 
											 	END AS Estado
											-- 	DOS.
FROM         mmp_pre_dossie DOS

JOIN		 mmp_pre_client_group CLI
ON			 DOS.group_id
=			 CLI.id

LEFT
JOIN         res_partner CRED
ON             DOS.credenciado_id
=             CRED.id

LEFT
JOIN         mmp_pre_campanha CA
ON             DOS.campanha_id
=             CA.id
LEFT
JOIN         mmp_pre_motivo_conclusao MC
ON             DOS.motivo_conclusao_id
=             MC.id

WHERE CLI.NAME IN ('SANTANDER','Cielo','Safra','PAN','CREDIGY') AND STATE NOT IN ('10c','06me','07mr')
