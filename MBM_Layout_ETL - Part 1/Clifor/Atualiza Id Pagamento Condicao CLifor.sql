

Drop Table If Exists #BaseCondPagCli
Select *
Into #BaseCondPagCli
From OpenQuery([Mbm_PoliResinas],'
select  
	n.dt_emissao
,	n.cod_empresa
,	n.cod_clifor
,	cf.fantasia
,	cf.cgc_cpf
,	pc.tipo_compra
,	n.cod_condpagamento
,	cp.descricao
,	n.entrada_saida
from nota_fiscal n 
join clifor		   cf  on  cf.cod_clifor	    = n.cod_clifor
join pedido_compra pc  on  pc.cod_pedidocompra  = n.cod_pedidocompra
					   and pc.cod_empresa       = n.cod_empresa
join cond_pagamento cp on  cp.cod_condpagamento = n.cod_condpagamento
where n.dt_emissao >= ''2024-01-01'' 
and n.dt_cancelado is null 
and nro_nfiscal = (
					Select Max(nro_nfiscal) 
					From nota_fiscal n2 
					Where n2.cod_empresa = n.cod_empresa 
					And   n2.cod_clifor  = n.cod_clifor
					And   n2.dt_cancelado is null 
					And   n2.cod_pedidocompra is not null
				  )
')

Union All

Select *
From OpenQuery([Mbm_Rubberon],'
select  
	n.dt_emissao
,	n.cod_empresa
,	n.cod_clifor
,	cf.fantasia
,	cf.cgc_cpf
,	pc.tipo_compra
,	n.cod_condpagamento
,	cp.descricao
,	n.entrada_saida
from nota_fiscal n 
join clifor		   cf  on  cf.cod_clifor	    = n.cod_clifor
join pedido_compra pc  on  pc.cod_pedidocompra  = n.cod_pedidocompra
					   and pc.cod_empresa       = n.cod_empresa
join cond_pagamento cp on  cp.cod_condpagamento = n.cod_condpagamento
where n.dt_emissao >= ''2024-01-01'' 
and n.dt_cancelado is null 
and nro_nfiscal = (
					Select Max(nro_nfiscal) 
					From nota_fiscal n2 
					Where n2.cod_empresa = n.cod_empresa 
					And   n2.cod_clifor  = n.cod_clifor
					And   n2.dt_cancelado is null 
					And   n2.cod_pedidocompra is not null
				  )
and n.cod_empresa != ''001''
')

Union All

Select *
From OpenQuery([Mbm_Mg_Polimeros],'
select  
	n.dt_emissao
,	n.cod_empresa
,	n.cod_clifor
,	cf.fantasia
,	cf.cgc_cpf
,	pc.tipo_compra
,	n.cod_condpagamento
,	cp.descricao
,	n.entrada_saida
from nota_fiscal n 
join clifor		   cf  on  cf.cod_clifor	    = n.cod_clifor
join pedido_compra pc  on  pc.cod_pedidocompra  = n.cod_pedidocompra
					   and pc.cod_empresa       = n.cod_empresa
join cond_pagamento cp on  cp.cod_condpagamento = n.cod_condpagamento
where n.dt_emissao >= ''2024-01-01'' 
and n.dt_cancelado is null 
and nro_nfiscal = (
					Select Max(nro_nfiscal) 
					From nota_fiscal n2 
					Where n2.cod_empresa = n.cod_empresa 
					And   n2.cod_clifor  = n.cod_clifor
					And   n2.dt_cancelado is null 
					And   n2.cod_pedidocompra is not null
				  )
and n.cod_empresa Not In (''001'',''300'')
')

Union All

Select *
From OpenQuery([Mbm_Polirex],'
select  
	n.dt_emissao
,	n.cod_empresa
,	n.cod_clifor
,	cf.fantasia
,	cf.cgc_cpf
,	pc.tipo_compra
,	n.cod_condpagamento
,	cp.descricao
,	n.entrada_saida
from nota_fiscal n 
join clifor		   cf  on  cf.cod_clifor	    = n.cod_clifor
join pedido_compra pc  on  pc.cod_pedidocompra  = n.cod_pedidocompra
					   and pc.cod_empresa       = n.cod_empresa
join cond_pagamento cp on  cp.cod_condpagamento = n.cod_condpagamento
where n.dt_emissao >= ''2024-01-01'' 
and n.dt_cancelado is null 
and nro_nfiscal = (
					Select Max(nro_nfiscal) 
					From nota_fiscal n2 
					Where n2.cod_empresa = n.cod_empresa 
					And   n2.cod_clifor  = n.cod_clifor
					And   n2.dt_cancelado is null 
					And   n2.cod_pedidocompra is not null
				  )
and n.cod_empresa != ''001''
')

Union All

Select *
From OpenQuery([Mbm_NorteBag],'
select  
	n.dt_emissao
,	n.cod_empresa
,	n.cod_clifor
,	cf.fantasia
,	cf.cgc_cpf
,	pc.tipo_compra
,	n.cod_condpagamento
,	cp.descricao
,	n.entrada_saida
from nota_fiscal n 
join clifor		   cf  on  cf.cod_clifor	    = n.cod_clifor
join pedido_compra pc  on  pc.cod_pedidocompra  = n.cod_pedidocompra
					   and pc.cod_empresa       = n.cod_empresa
join cond_pagamento cp on  cp.cod_condpagamento = n.cod_condpagamento
where n.dt_emissao >= ''2024-01-01'' 
and n.dt_cancelado is null 
and nro_nfiscal = (
					Select Max(nro_nfiscal) 
					From nota_fiscal n2 
					Where n2.cod_empresa = n.cod_empresa 
					And   n2.cod_clifor  = n.cod_clifor
					And   n2.dt_cancelado is null 
					And   n2.cod_pedidocompra is not null
				  )
and n.cod_empresa != ''001''
')

Drop Table If Exists #Uniq
Select *
Into #Uniq
From (
	   Select *
	   ,	Rw = Row_Number () Over ( Partition By Cgc_Cpf Order By Convert(Date,Dt_Emissao) Desc)
	   From #BaseCondPagCli
	 )SubQuery
Where Rw = 1


Drop Table If Exists #Update
Select Fato.*
,	Pgc.id_pagamento_condicao
,	Clifor.cod_clifor as Id_Clifor
Into #Update 
From #Uniq Fato
Join Pagamentos_Condicoes Pgc On Pgc.cod_condpagamento = Fato.cod_condpagamento Collate Latin1_General_Ci_Ai
Left Join Clifor On Isnull(Clifor.Cnpj,Clifor.Cpf)     = Fato.Cgc_Cpf		    Collate Latin1_General_Ci_Ai


Update Fato
Set Id_Condicao_Pagamento = Dim.id_pagamento_condicao

From Clifor  Fato
Join #Update Dim On Dim.Id_Clifor = Fato.Cod_CLifor

