

INSERT INTO [THESYS_HOMOLOGACAO]..[Alertas_Setup]
           ([descricao_alerta]
           ,[modulo]
           ,[comando_sql]
           ,[tipo_frequencia]
           ,[qtd_frequencia]
           ,[datahora_inicio]
           ,[datahora_ultima_exec]
           ,[datahora_proxima_exec]
           ,[desativado])
select 
			[descricao_alerta]
           ,[modulo]
           ,[comando_sql]
           ,[tipo_frequencia]
           ,[qtd_frequencia]
           ,[datahora_inicio]
           ,[datahora_ultima_exec]
           ,[datahora_proxima_exec]
           ,[desativado]
from Alertas_Setup