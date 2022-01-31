DROP TABLE IF EXISTS TEMP_ARRUMA_TELEFONE;
CREATE TEMPORARY TABLE TEMP_ARRUMA_TELEFONE AS
SELECT	 '_export.mmp_pre_dossie' || DOS.id AS ID
			,Dos.name AS DOSSIE
			,DOS.numero_contrato AS NUMERO_CONTRATO
			,DOS.processo AS PROCESSO
			,AUT.name AS AUTOR
			,AUT.cnpj_cpf AS CPF_CNPJ
			,DOS.cpf AS CPF
			,DOS.minuta_recebida_id
			,DOS.protocolo_id
			,ADV.id AS id_CONTATO
			,ADV.name AS CONTATO
			,ADV.oab AS oab_CONTATO
			,CRED.id AS id_CREDENCIADO
			,CRED.name AS CREDENCIADO
			,DOS.state AS STATUS
			,MC.name AS MOTIVO_CONCLUSAO
			,FAS.name FASE
			,SITU.name AS SITUACAO
			,DOS.faixa1 AS FAIXA_1
			,DOS.faixa2 AS FAIXA_2
			,DOS.last_modified
			,Dos.dt_envio_banco
			,CA.name AS CAMPANHA
			,DOS.numero_acordo AS NUMERO_ACORDO
			,DOS.data_conclusao AS DATA_CONCLUSÃO
			,DOS.data_modificacao_situacao AS DATA_MODIFICAÇÃO_SITUAÇÃO
			,DOS.x_estado_caso AS ESTADO_CASO
			,DOS.observacoes AS OBS
			,att.name AS Nome_do_documento_minuta
			,att_p.name AS Nome_do_documento_protocolo
			FROM		 mmp_pre_dossie DOS
			
LEFT
JOIN		 res_partner AUT
ON			 DOS.autor_id
=			 AUT.id

LEFT
JOIN		 ir_attachment att
ON			 DOS.minuta_recebida_id
=			 att.id

LEFT
JOIN		 ir_attachment att_p
ON			 DOS.protocolo_id
=			 att_p.id
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
IN 		 (9);


SELECT 
			protocolo_id
,			Nome_do_documento_protocolo
,			Nome_do_documento_minuta	
,			minuta_recebida_id  
FROM TEMP_ARRUMA_TELEFONE
WHERE (
				protocolo_id IS NOT NULL 
			OR Nome_do_documento_protocolo IS NOT NULL
			OR Nome_do_documento_minuta IS NOT NULL
			OR minuta_recebida_id IS NOT NULL
		)

SELECT * FROM ir_attachment LIMIT 10