
use THESYS_HOMOLOGACAO
go

drop table if exists #BaseEstoqueLocal
select *
into #BaseEstoqueLocal
from openquery([mbm_polirex],'
select * 
from localizacao
')

insert into [dbo].[estoque_local]
           ([id_empresa]
           ,[id_estoque_deposito]
           ,[cod_localizacao]
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
           ,[excl_device])
select
	[id_empresa]			= Empresas.id_empresa
,	[id_estoque_deposito]	= Estoque_Deposito.id_estoque_deposito
,	fato.[cod_localizacao]
,	fato.[descricao]
,	fato.[ativo]
,	[incl_data]				= getdate()
,	[incl_user]				= 'ksantana'
,	[incl_device]			= null
,	[modi_data]				= null
,	[modi_user]				= null
,	[modi_device]			= null
,	[excl_data]				= null
,	[excl_user]				= null
,	[excl_device]			= null
from #BaseEstoqueLocal fato
left join empresas		   on empresas.codigo_antigo		 = fato.cod_empresa  collate latin1_general_ci_ai 
left join estoque_deposito on estoque_deposito.cod_deposito  = fato.cod_deposito collate latin1_general_ci_ai 