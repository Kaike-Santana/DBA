
SELECT	 CONCAT('__export__.mmp_pre_dossie_',A.ID) 			AS EXTERNAL_ID 
			,A.contato_id 													AS CONTATO_ID
			,CAST(A.create_date AS DATE)								AS CREATE_DATE
			,A.dt_envio_banco 											AS Recebido_Banco
			,A.cpf 															AS CPF
			,D.name 															AS NOME_contato 
			,G.name  														AS	NOME_AUTOR
			,A.name 															AS DOSSIE
			,A.processo														AS N_PROCESSO
			,F.name 															AS PRODUTO
			,C.name 															AS CAMPANHA
			,A.faixa1 														AS VALOR_FAIXA_1
			,A.faixa2 														AS VALOR_FAIXA_2
			,X_MARCACAO_PLANEJAMENTO_1 								AS CARTEIRA_PLAN_1
			,X_MARCACAO_PLANEJAMENTO_2 								AS ESTRATEGIA_PLAN_2
			,A.count_type 													AS RECORRENCIA
			,A.data_conclusao												AS DT_CONCLUSAO 
			,C.inativa														AS STATUS_CAMPANHA
			,A.state															AS STATUS
			,A.oab															AS OAB
			,MC.name															AS MOTIVO_CONCLUSAO
			,H.name  														AS FASE
			,A.flag_wo														AS FLAG
			,A.cluster_novo
						
FROM				mmp_pre_dossie A
LEFT JOIN				res_partner G
ON		    (A.autor_id = G.id)

LEFT JOIN		   	res_partner D
ON			 (A.contato_id = D.id)

LEFT JOIN		 		mmp_pre_campanha C
ON			 (C.id =	A.campanha_id)

LEFT JOIN		   	mmp_pre_client_group F
ON			 (A.group_id = F.id)

LEFT JOIN		mmp_pre_motivo_conclusao MC
ON			 (A.motivo_conclusao_id = MC.id)

LEFT JOIN		 		mmp_pre_dossie_fase H
ON			 (A.fase_id = H.ID)

WHERE		 A.state != '10c'