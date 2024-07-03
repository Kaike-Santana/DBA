USE [THESYS_DEV]
GO

INSERT INTO Centro_Custo
           ([cod_centrocusto]
           ,[descricao]
           ,[ativo]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device]
           ,[grupo]
           ,[observacoes])
select 
			[cod_centrocusto]	=	4110
           ,[descricao]			=	'LOG�STICA CD MAUA-RH'
           ,[ativo]				=   'S'
           ,[incl_data]			=	getdate()
           ,[incl_user]			=	'ksantana'
           ,[incl_device]		=	null
           ,[modi_data]			=	null
           ,[modi_user]			=	null
           ,[modi_device]		=	null
           ,[excl_data]			=	null
           ,[excl_user]			=	null
           ,[excl_device]		=	null
           ,[grupo]		=	'LOG�STICA'
           ,[observacoes] = 'Despesas e custos associados �s opera��es log�sticas no CD de Mau�/SP.'
from [Centro_Custo]
