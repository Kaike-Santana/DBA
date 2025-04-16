

USE THESYS_HOMOLOGACAO
GO

INSERT INTO [dbo].[Compras_Alcadas]
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

SELECT 
	[id_empresa]		= 11
,	[id_centro_custo]
,	[id_usuario]
,	[nivel_aprovador]
,	[valor_minimo]
,	[valor_maximo]
,	[ativo]
,	[id_usuario_substituto]
,	[substituto_ativo]
,	[substituto_data_ini]
,	[substituto_data_fim]
,	[aprova_rc]
,	[aprova_pc]
,	[aprova_desp_imp]
,	[incl_data]
,	[incl_user]
,	[incl_device]
,	[modi_data]
,	[modi_user]
,	[modi_device]
,	[excl_data]
,	[excl_user]
,	[excl_device]
FROM Compras_Alcadas
where id_empresa  = 4


Select *
From Empresas