SELECT 

		ID 
,		processo 						AS 	NUM_PROCESSO
,		create_date						AS 	DATA
,		faixa1							AS 	FAIXA1
,		faixa2							AS 	FAIXA2
,		vl_acordo						AS  	VL_ACORDO
,		dossie_id						AS 	ID_DOSSIE
,		dt_minuta_recebida			AS		DT_MINUTA_RECEBIDA
,		dt_minuta_enviada				AS    DT_MINUTA_ENVIADA
,		vl_contraproposta				AS    VL_CONTRA_PROPOSTA
,		dt_envio_banco					AS    DT_ENVIO_BANCO
,		cpf								AS 	CPF
,		dt_audiencia					AS		DT_AUDIENCIA
,		campanha_id						AS		ID_CAMPANHA
,		cluster_novo					AS    ALCADA
,		data_conclusao					AS		DATA_CONCLUSAO
,		data_atraso						AS 	ATRASO
,		x_marcacao_planejamento_1	AS		TIPO_PLANO
,		x_marcacao_planejamento_2	AS		CANAL	
,		CASE WHEN  state								AS		status	
FROM mmp_pre_dossie
LIMIT 10000


SELECT *
FROM mmp_pre_dossie
LIMIT 10