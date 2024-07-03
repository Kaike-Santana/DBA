
Use Thesys_Dev
Go

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* PROGRAMADOR: KAIKE NATAN									                                    */
/* VERSAO     : DATA: 06/06/2024																*/
/* DESCRICAO  : ETL DA BASE DE CONTABILIZACOES FINANCEIRAS										*/
/*																								*/
/*	ALTERACAO                                                                                   */
/*        2. PROGRAMADOR: 													 DATA: __/__/____	*/		
/*           DESCRICAO  : 																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Consolida Base De Eventos Do MBM													*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
drop table if exists #Base_ContFinanc_mbm
select 
	'polimeros' as empresa
,	*
into #Base_ContFinanc_mbm
from openquery([mbm_mg_polimeros],'
select *
from contabilizacao_financeira
')

union all

select 
	'nortebag' as empresa
,	*
from openquery([mbm_nortebag],'
select *
from contabilizacao_financeira
')

union all

select 
	'poliresinas' as empresa
,	*
from openquery([mbm_poliresinas],'
select *
from contabilizacao_financeira
')

union all

select 
	'polirex' as empresa
,	*
from openquery([mbm_polirex],'
select *
from contabilizacao_financeira
')

union all

select 
	'rubberon' as empresa
,	*
from openquery([mbm_rubberon],'
select *
from contabilizacao_financeira
')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Tabela Padrao Com os Eventos														*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
drop table if exists #Tb_Tp_ContaDebito
select *
into #Tb_Tp_ContaDebito
from Tabela_Padrao
where cod_tabelapadrao = 'tipos_contas_contabeis_cd'

create nonclustered index idx_cod on #Tb_Tp_ContaDebito (codigo)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Tabela Padrao Com os Eventos														*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
drop table if exists #Tb_Tp_ContaCredito
select *
into #Tb_Tp_ContaCredito
from Tabela_Padrao
where cod_tabelapadrao = 'tipos_contas_contabeis_cc'

create nonclustered index idx_cod on #Tb_Tp_ContaCredito (codigo)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Remove os Cod de Eventos Duplicados Por Empresas									*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/


-- THANNER PEDIU PARA SUSPENDER, ESSES DADOS VIRÃO DO SOFTARE