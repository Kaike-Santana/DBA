
Select *
From OpenQuery([Mbm_PoliResinas],'
Select 
  cod_empresa, 
  razao_empresa, 
  fantasia_empresa, 
  serie, 
  nro_nfiscal, 
  cod_clifor, 
  cliente_fornecedor, 
  fantasia_cliente_forn, 
  entrada_saida, 
  tipo_operacao, 
  dt_emissao, 
  cancelada, 
  dt_saida, 
  dt_recebimento, 
  cod_transp, 
  transportadora, 
  cod_repres, 
  representante, 
  cod_condpagamento, 
  condicao_pagamento, 
  codigo, 
  descricao, 
  desc_grupoestoque, 
  desc_subgrupoestoque, 
  desc_familiacomercial, 
  familia_agrupada, 
  desc_familia_industrial, 
  quantidade, 
  valor_unitario, 
  valor_bruto, 
  perc_descto, 
  valor_descto, 
  valor_total, 
  peso_bruto, 
  peso_liquido, 
  valor_frete, 
  valor_seguro, 
  valor_despesas, 
  cod_natoperacao, 
  cfo, 
  cod_tiponatureza, 
  tipo_naturezaoperacao, 
  valor_bcalc_ipi, 
  aliq_ipi, 
  valor_ipi, 
  valor_importacao, 
  valor_bcalc_icms, 
  aliq_icms, 
  valor_icms, 
  base_icms_sub, 
  perc_icms_subst, 
  aliq_icms_sub, 
  valor_icms_sub, 
  valor_bcalc_pis, 
  aliq_pis, 
  valor_pis, 
  valor_bcalc_cofins, 
  aliq_cofins, 
  valor_cofins, 
  valor_bcalc_inss, 
  aliq_inss, 
  valor_inss, 
  valor_bcalc_ir, 
  aliq_ir, 
  valor_ir, 
  valor_bcalc_iss, 
  aliq_iss, 
  valor_iss, 
  valor_bcalc_csll, 
  aliq_csll, 
  valor_csll, 
  valor_bcalc_funrural, 
  aliq_funrural, 
  valor_funrural, 
  valor_bcalc_zonafranca, 
  valor_zonafranca, 
  valor_basefcpicmsst, 
  aliq_fcpicmsst, 
  valor_fcpicmsst, 
  preco_reposicao, 
  custo_reposicao, 
  custo_medio, 
  custo_standard, 
  cliforn_cidade, 
  cod_estado, 
  cnpj, 
  cast(unidade_negocio as varchar(1000)) as unidade_negocio 
From bi_mjc_notafiscais_venda
limit 10
')

select distinct unidade_negocio
From OpenQuery([Mbm_PoliRex],'
Select cast(unidade_negocio as varchar(1000)) as unidade_negocio 
From bi_mjc_notafiscais_venda'
)


select *
from (
Select *
From OpenQuery([Mbm_PoliResinas],'
Select Distinct 
	Fantasia_Empresa
,	Cod_Clifor
,	cnpj
,	cod_estado As UF
,	cliforn_cidade
,	fantasia_cliente_forn
,	Representante
,	Cod_CondPagamento
,	Condicao_Pagamento
,	Cast(Unidade_Negocio As Varchar(1000)) As Unidade_Negocio 

--,	dt_emissao
,	row_number() over ( partition by cod_clifor order by dt_emissao desc) as Rw
From bi_mjc_notafiscais_venda
Where Tipo_NaturezaOperacao Ilike ''%Venda%'' 
And Tipo_Operacao = ''SAIDA''
And Dt_Emissao >= ''2023-01-01 00:00:00.0000000''
and Unidade_Negocio != ''Não identificado''
Order By Fantasia_Empresa Asc, Fantasia_Empresa ')
)SubQuery
Where SubQuery.rw = 1
and SubQuery.Unidade_Negocio = 'Flexíveis'

Union All

select *
from (
Select *
From OpenQuery([Mbm_Rubberon],'
Select Distinct 
	Fantasia_Empresa
,	Cod_Clifor
,	cnpj
,	cod_estado As UF
,	cliforn_cidade
,	fantasia_cliente_forn
,	Representante
,	Cod_CondPagamento
,	Condicao_Pagamento
,	Cast(Unidade_Negocio As Varchar(1000)) As Unidade_Negocio 

--,	dt_emissao
,	row_number() over ( partition by cod_clifor order by dt_emissao desc) as Rw
From bi_mjc_notafiscais_venda
Where Tipo_NaturezaOperacao Ilike ''%Venda%'' 
And Tipo_Operacao = ''SAIDA''
And Dt_Emissao >= ''2023-01-01 00:00:00.0000000''
and Unidade_Negocio != ''Não identificado''
Order By Fantasia_Empresa Asc, Fantasia_Empresa ')
)SubQuery
Where SubQuery.rw = 1
and SubQuery.Unidade_Negocio = 'Flexíveis'

Union All

select *
from (
Select *
From OpenQuery([Mbm_PoliRex],'
Select Distinct 
	Fantasia_Empresa
,	Cod_Clifor
,	cnpj
,	cod_estado As UF
,	cliforn_cidade
,	fantasia_cliente_forn
,	Representante
,	Cod_CondPagamento
,	Condicao_Pagamento
,	Cast(Unidade_Negocio As Varchar(1000)) As Unidade_Negocio 

--,	dt_emissao
,	row_number() over ( partition by cod_clifor order by dt_emissao desc) as Rw
From bi_mjc_notafiscais_venda
Where Tipo_NaturezaOperacao Ilike ''%Venda%'' 
And Tipo_Operacao = ''SAIDA''
And Dt_Emissao >= ''2023-01-01 00:00:00.0000000''
and Unidade_Negocio != ''Não identificado''
Order By Fantasia_Empresa Asc, Fantasia_Empresa ')
)SubQuery
Where SubQuery.rw = 1
and SubQuery.Unidade_Negocio = 'Flexíveis'

Union All

select *
from (
Select *
From OpenQuery([Mbm_Mg_Polimeros],'
Select Distinct 
	Fantasia_Empresa
,	Cod_Clifor
,	cnpj
,	cod_estado As UF
,	cliforn_cidade
,	fantasia_cliente_forn
,	Representante
,	Cod_CondPagamento
,	Condicao_Pagamento
,	Cast(Unidade_Negocio As Varchar(1000)) As Unidade_Negocio 

--,	dt_emissao
,	row_number() over ( partition by cod_clifor order by dt_emissao desc) as Rw
From bi_mjc_notafiscais_venda
Where Tipo_NaturezaOperacao Ilike ''%Venda%'' 
And Tipo_Operacao = ''SAIDA''
And Dt_Emissao >= ''2023-01-01 00:00:00.0000000''
and Unidade_Negocio != ''Não identificado''
Order By Fantasia_Empresa Asc, Fantasia_Empresa ')
)SubQuery
Where SubQuery.rw = 1
and SubQuery.Unidade_Negocio = 'Flexíveis'

Union All

select *
from (
Select *
From OpenQuery([Mbm_NorteBag],'
Select Distinct 
	Fantasia_Empresa
,	Cod_Clifor
,	cnpj
,	cod_estado As UF
,	cliforn_cidade
,	fantasia_cliente_forn
,	Representante
,	Cod_CondPagamento
,	Condicao_Pagamento
,	Cast(Unidade_Negocio As Varchar(1000)) As Unidade_Negocio 

--,	dt_emissao
,	row_number() over ( partition by cod_clifor order by dt_emissao desc) as Rw
From bi_mjc_notafiscais_venda
Where Tipo_NaturezaOperacao Ilike ''%Venda%'' 
And Tipo_Operacao = ''SAIDA''
And Dt_Emissao >= ''2023-01-01 00:00:00.0000000''
and Unidade_Negocio != ''Não identificado''
Order By Fantasia_Empresa Asc, Fantasia_Empresa ')
)SubQuery
Where SubQuery.rw = 1
and SubQuery.Unidade_Negocio = 'Flexíveis'