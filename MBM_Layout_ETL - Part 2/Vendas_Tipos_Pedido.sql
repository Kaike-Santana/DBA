
Use Thesys_Homologacao
Go

Drop Table If Exists #TipoPedVenda
Select *
Into #TipoPedVenda
From OpenQuery([Mbm_PoliResinas],'
Select *
From Tipo_PedidoVenda')

Union All

Select *
From OpenQuery([Mbm_Polirex],'
Select *
From Tipo_PedidoVenda')

Union All

Select *
From OpenQuery([Mbm_Mg_Polimeros],'
Select *
From Tipo_PedidoVenda')


Drop Table If Exists #Uniq
Select *
Into #Uniq
From (
	   Select *
	   , Rw = Row_Number() Over ( Partition By Cod_TipoPedVenda Order By Dt_Atualizacao Desc)
	   From #TipoPedVenda
	 )SubQuery
Where Rw = 1


Insert Into [dbo].[Vendas_Tipos_Pedido]
           ([cod_tipovenda]
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
Select 
	[cod_tipovenda] = Fato.Cod_TipoPedVenda
,	[descricao]
,	[ativo]
,	[incl_data]		= GetDate()
,	[incl_user]		= 'ksantana'
,	[incl_device]	= 'PC/10.1.0.123'
,	[modi_data]     = Null
,	[modi_user]		= Null
,	[modi_device]	= Null
,	[excl_data]		= Null
,	[excl_user]		= Null
,	[excl_device]	= Null
From #Uniq Fato
Where Not Exists (
				   Select *
				   From Vendas_Tipos_Pedido Dim
				   Where Dim.Cod_TipoVenda = Fato.Cod_TipoPedVenda Collate Latin1_General_Ci_Ai
				 )