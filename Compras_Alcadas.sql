USE [THESYS_DEV]
GO

INSERT INTO [THESYS_HOMOLOGACAO]..[Compras_Alcadas]
           ([id_empresa]
           ,[id_centro_custo]
           ,[id_usuario]
           ,[nivel_aprovador]
           ,[valor_minimo]
           ,[valor_maximo]
           ,[ativo]
           ,[id_usuario_substituto]
           ,[substituto_ativo]
           ,[substituto_data_ini]
           ,[substituto_data_fim]
           ,[aprova_rc]
           ,[aprova_pc]
           ,[aprova_desp_imp]
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
	[id_empresa]	=	dim_2.ID_EMPRESA
--,	id_empresa_old = Empresas.ID_EMPRESA
--,	compras_alcadas.[id_centro_custo]
,	dim_3.id_centro_custo
,	compras_alcadas.[id_usuario]
,	compras_alcadas.[nivel_aprovador]
,	compras_alcadas.[valor_minimo]
,	compras_alcadas.[valor_maximo]
,	compras_alcadas.[ativo]
,	compras_alcadas.[id_usuario_substituto]
,	compras_alcadas.[substituto_ativo]
,	compras_alcadas.[substituto_data_ini]
,	compras_alcadas.[substituto_data_fim]
,	compras_alcadas.[aprova_rc]
,	compras_alcadas.[aprova_pc]
,	compras_alcadas.[aprova_desp_imp]
,	compras_alcadas.[incl_data]
,	compras_alcadas.[incl_user]
,	compras_alcadas.[incl_device]
,	compras_alcadas.[modi_data]
,	compras_alcadas.[modi_user]
,	compras_alcadas.[modi_device]
,	compras_alcadas.[excl_data]
,	compras_alcadas.[excl_user]
,	compras_alcadas.[excl_device]
from Compras_Alcadas
 join Empresas on Empresas.ID_EMPRESA = Compras_Alcadas.id_empresa
 join thesys_homologacao..Empresas dim_2 on dim_2.DESCRICAO = Empresas.DESCRICAO
 left join Centro_Custo on Centro_Custo.id_centro_custo = Compras_Alcadas.id_centro_custo
 left join thesys_homologacao..Centro_Custo dim_3 on dim_3.descricao = Centro_Custo.descricao