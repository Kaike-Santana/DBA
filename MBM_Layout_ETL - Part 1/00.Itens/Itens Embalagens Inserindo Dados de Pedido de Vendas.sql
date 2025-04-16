
Use Thesys_Producao
Go

With CtePdrItem As (

	Select Distinct Nfi.id_item
	From Notas_Fiscais		 Nf
	Join Notas_Fiscais_Itens Nfi On Nfi.id_nota_fiscal = Nf.id_nota_fiscal
	Where Nf.id_empresa in (3,9,13,14,10,11)
	And Nf.tipo_emissao = 'P'
	And Nf.entrada_saida = 'S'
	And Coalesce(Nf.id_pedido_venda,'') != ''
)


Insert Into [dbo].[Itens_Embalagens]
           ([id_item]
           ,[id_embalagem]
           ,[qtd_por_emb]
           ,[emb_padrao]
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
	[id_item]	   = Fato.id_item
,	[id_embalagem] = 1
,	[qtd_por_emb]  = '25.000'
,	[emb_padrao]   = Null
,	[incl_data]	   = GetDate()
,	[incl_user]	   = 'ksantana'
,	[incl_device]  = 'PC/10.1.0.123'
,	[modi_data]	   = Null
,	[modi_user]	   = Null
,	[modi_device]  = Null
,	[excl_data]	   = Null
,	[excl_user]	   = Null
,	[excl_device]  = Null
From CtePdrItem Fato
Where Not Exists (
				   Select *
				   From Itens_Embalagens Dim
				   Where Dim.id_item = Fato.id_item
				   And Dim.id_embalagem = 1
				 )

Union All

Select 
	[id_item]	   = Fato.id_item
,	[id_embalagem] = 2
,	[qtd_por_emb]  = '1375.000'
,	[emb_padrao]   = Null
,	[incl_data]	   = GetDate()
,	[incl_user]	   = 'ksantana'
,	[incl_device]  = 'PC/10.1.0.123'
,	[modi_data]	   = Null
,	[modi_user]	   = Null
,	[modi_device]  = Null
,	[excl_data]	   = Null
,	[excl_user]	   = Null
,	[excl_device]  = Null
From CtePdrItem Fato
Where Not Exists (
				   Select *
				   From Itens_Embalagens Dim
				   Where Dim.id_item = Fato.id_item
				   And Dim.id_embalagem = 2
				 )

Union All

Select 
	[id_item]	   = Fato.id_item
,	[id_embalagem] = 3
,	[qtd_por_emb]  = '1250.000'
,	[emb_padrao]   = Null
,	[incl_data]	   = GetDate()
,	[incl_user]	   = 'ksantana'
,	[incl_device]  = 'PC/10.1.0.123'
,	[modi_data]	   = Null
,	[modi_user]	   = Null
,	[modi_device]  = Null
,	[excl_data]	   = Null
,	[excl_user]	   = Null
,	[excl_device]  = Null
From CtePdrItem Fato
Where Not Exists (
				   Select *
				   From Itens_Embalagens Dim
				   Where Dim.id_item = Fato.id_item
				   And Dim.id_embalagem = 3
				 )