INSERT INTO [dbo].[Grupos_Estoque]
           ([codigo]
           ,[descricao]
           ,[item_venda]
           ,[item_producao]
           ,[item_compraprodutivo]
           ,[item_compranaoprodutivo]
           ,[id_tipo_produto]
           ,[codigo_no_dominio]
           ,[descricao_dominio]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device])

select
			*
           ,[incl_data]		= getdate()
           ,[incl_user]		= 'ksantana'
           ,[incl_device]	= null
           ,[modi_data]		= null
           ,[modi_user]		= null
           ,[modi_device]	= null
           ,[excl_data]		= null
           ,[excl_user]		= null
           ,[excl_device]	= null
from tabela_grupo_estoque

alter table tabela_grupo_estoque drop column id_grupo_estoque


alter table [Grupos_Estoque] alter column descricao varchar(100)