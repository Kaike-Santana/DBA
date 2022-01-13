SELECT DISTINCT '__export__.mmp_pre_dossie_' || DOS.id 
		,CLI.name
		,AUT.name AS AUTOR
		,DOS.name AS DOSSIE
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
            ,dos.data_conclusao
            ,DOS.faixa2 AS Faixa_2
            ,DOS.processo AS NºPROCESSO
            ,DOS.vl_acordo AS Valor_Acordo
             			,CASE WHEN DOS.parcelas = '1' THEN 'A vista'
			  			    ELSE 'Parcelado' 
			  			    END AS FORMA_PGTO
			  	,DOS.parcelas AS NºPARCELAS
            ,PAR.valor AS Valor_Parcela
            ,DOS.vl_contraproposta AS Contraproposta

FROM         mmp_pre_dossie DOS

JOIN		 mmp_pre_client_group CLI
ON			 DOS.group_id
=			 CLI.id

LEFT
JOIN		 res_partner AUT
ON			 DOS.autor_id
=			 AUT.id

LEFT
JOIN 		mmp_pre_parcelas PAR
ON 		DOS.id
= 			PAR.dossie_id

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

WHERE CLI.NAME = 'Gyramais'