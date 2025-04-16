
use THESYS_HOMOLOGACAO
go

drop table if exists #BaseDeposito 
select *
into #BaseDeposito
from openquery([mbm_polirex],'
select * 
from deposito
')

drop table if exists #Tipo_EstDep
select *
into #Tipo_EstDep
from Tabela_Padrao
where cod_tabelapadrao = 'tipo_estoque_deposito'

create nonclustered index sku_cod on #Tipo_EstDep (codigo)


insert into [Estoque_Deposito]
           ([id_empresa]
           ,[descricao]
           ,[saldo_negativo]
           ,[tipo_estoque]
           ,[somente_qtde]
           ,[permite_alocacaoauto]
           ,[seq_alocacaoauto]
           ,[visualizar_depositopv]
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
           ,[cod_deposito]
           ,[id_armazem])

select
	[id_empresa]			=	Empresas.Id_Empresa
,	fato.[descricao]
,	fato.[saldo_negativo]
,	[tipo_estoque]			=   #Tipo_EstDep.id_tabela_padrao
,	fato.[somente_qtde]
,	fato.[permite_alocacaoauto]
,	fato.[seq_alocacaoauto]
,	fato.[visualizar_depositopv]
,	fato.[ativo]
,	[incl_data]				=	getdate()
,	[incl_user]				=	'ksantana'
,	[incl_device]		    =   null
,	[modi_data]				=   null
,	[modi_user]				=   null
,	[modi_device]			=   null
,	[excl_data]				=   null
,	[excl_user]				=   null
,	[excl_device]			=   null
,	fato.[cod_deposito]			
,	[id_armazem]			=   Null
from #BaseDeposito Fato
Join Empresas	       On Empresas.Codigo_Antigo = fato.cod_empresa collate latin1_general_ci_ai 
Left Join #Tipo_EstDep On #Tipo_EstDep.Codigo	 = fato.tipo		collate latin1_general_ci_ai 

update Estoque_Deposito
set id_armazem = 1 --> CD Mauá
where id_empresa in (10,11)
