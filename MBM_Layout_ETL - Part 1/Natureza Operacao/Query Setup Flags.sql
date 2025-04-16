

Select
	cod_natoperacao
,	dim.classif_cfop
,	dim_2.descricao_tiponatureza
,	Venda
,	Compra
,	Devolucao
,	Remessa
,	Retorno
From Natureza_Operacao		 fato
left join CFOP					 dim   on dim.cfop				 = fato.cfop
left join Natureza_Operacao_Tipos dim_2 on dim_2.cod_tiponatureza = fato.cod_tiponatureza


begin tran

update Natureza_Operacao
set Venda		=  Dim.Venda		
,	Compra		=  Dim.Compra		
,	Devolucao	=  Dim.Devolucao	
,	Remessa		=  Dim.Remessa		
,	Retorno		=  Dim.Retorno		

from Natureza_Operacao		Fato
join Setup_Flag_Dev	Dim On Dim.Cod_NatOperacao = Fato.Cod_NatOperacao

--commit