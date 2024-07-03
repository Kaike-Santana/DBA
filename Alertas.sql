
USE [THESYS_DEV]
GO

INSERT INTO [THESYS_HOMOLOGACAO]..[Alertas]
           ([id_usuario]
           ,[datahora_insercao]
           ,[lido]
           ,[datahora_leitura]
           ,[verificado]
           ,[datahora_verificacao]
           ,[statusID]
           ,[mensagem_alerta]
           ,[num_alerta])
SELECT 
	[id_usuario]
,	[datahora_insercao]
,	[lido]
,	[datahora_leitura]
,	[verificado]
,	[datahora_verificacao]
,	[statusID]
,	[mensagem_alerta]
,	[num_alerta]
FROM Alertas