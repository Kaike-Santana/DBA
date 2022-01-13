SET		 statement_timeout TO 600000;
COMMIT;SELECT	 '__export__.mmp_pre_dossie_' || DOS.id AS ID
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
			,DOS.processo AS PROCESSO
			,DOS.state AS STATUS
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
