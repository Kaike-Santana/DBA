
Use Thesys_Homologacao
Go

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* PROGRAMADOR: KAIKE NATAN									                                    */
/* VERSAO     : DATA: 06/06/2024																*/
/* DESCRICAO  : ETL DA BASE DE EVENTOS DO MBM													*/
/*																								*/
/*	ALTERACAO                                                                                   */
/*        2. PROGRAMADOR: 													 DATA: __/__/____	*/		
/*           DESCRICAO  : 																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Consolida Base De Eventos Do MBM													*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
drop table if exists #base_eventos_mbm
select 
	'polimeros' as empresa
,	*
into #base_eventos_mbm
from openquery([mbm_mg_polimeros],'
select *
from evento
')

union all

select 
	'nortebag' as empresa
,	*
from openquery([mbm_nortebag],'
select *
from evento
')

union all

select 
	'poliresinas' as empresa
,	*
from openquery([mbm_poliresinas],'
select *
from evento
')

union all

select 
	'polirex' as empresa
,	*
from openquery([mbm_polirex],'
select *
from evento
')

union all

select 
	'rubberon' as empresa
,	*
from openquery([mbm_rubberon],'
select *
from evento
')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Tabela Padrao Com os Eventos														*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
drop table if exists #tb_pd_eventos
select *
into #tb_pd_eventos
from Tabela_Padrao
where cod_tabelapadrao = 'eventos_padrao'

create nonclustered index idx_cod on #tb_pd_eventos (codigo)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Remove os Cod de Eventos Duplicados Por Empresas									*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
drop table if exists #BaseUnique
select *
into #BaseUnique
from (
		select *
		, rw = row_number() over ( partition by cod_evento order by cod_evento desc)
		from #base_eventos_mbm
	 ) SubQuery
where rw = 1
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Popula Tabela Final de Eventos Após o ETL											*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
insert into [dbo].[Eventos_Titulos]
           (
		    [id_ep]
           ,[cod_evento]
           ,[descricao_evento]
           ,[descricao_padrao]
           ,[flag]
           ,[diario_auxiliar]
           ,[conta_corrente]
           ,[integracao_contabil]
           ,[lancto_bancario]
           ,[alterar_valororiginal]
           ,[gerar_comissao]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device]
           ,[considerar_no_saldo]
           ,[sinal]
		   )
select 
	[id_ep]					=	#tb_pd_eventos.id_tabela_padrao
,	[cod_evento]			=	fato.cod_evento
,	[descricao_evento]		=	fato.descricao
,	[descricao_padrao]		=	#tb_pd_eventos.descricao
,	[flag]					=	fato.flag
,	[diario_auxiliar]		=	fato.[diario_auxiliar]		
,	[conta_corrente]		=	fato.[conta_corrente]		
,	[integracao_contabil]	=	fato.[integracao_contabil]	
,	[lancto_bancario]		=	fato.[lancto_bancario]		
,	[alterar_valororiginal]	=	fato.[alterar_valororiginal]	
,	[gerar_comissao]		=	fato.[gerar_comissao]		
,	[incl_data]				=	getdate()
,	[incl_user]				=	'ksantana'
,	[incl_device]			=	'PC'
,	[modi_data]				=	null
,	[modi_user]				=	null
,	[modi_device]			=	null
,	[excl_data]				=	null
,	[excl_user]				=	null
,	[excl_device]			=	null
,	[considerar_no_saldo]	=	iif(#tb_pd_eventos.obs is not null or #tb_pd_eventos.codigo in ('BP','BT','DE','DP','DT','EA','EB','IN'), 'S', 'N')
,	[sinal]					=	   case
									   when flag like '%+%' then '+'
									   when flag like '%-%' then '-'
									   else null
								   end 
from #BaseUnique fato 
left join #tb_pd_eventos on #tb_pd_eventos.codigo = fato.cod_evento collate sql_latin1_general_cp1_ci_ai