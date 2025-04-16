
Use Thesys_Homologacao
Go

Drop Table If Exists #GradeSetupTributacao
Select *
Into #GradeSetupTributacao
From OpenQuery([Mbm_Polirex],'
Select *
From Grade_Tributacao')

Drop Table If Exists #Aux_Ori_Mercadoria
Select *
Into #Aux_Ori_Mercadoria
From Tabela_Padrao
Where Cod_TabelaPadrao = 'Origem_Mercadoria'

Insert Into [dbo].[Tributacao_Setup_ICMS]
           ([Id_Tributacao]
           ,[cod_tributacao]
           ,[id_empresa_grupo]
           ,[id_empresa]
           ,[empresa]
           ,[cod_empresa]
           ,[Id_Grupo_Estoque]
           ,[cod_grupoestoque]
           ,[Id_Item]
           ,[cod_item]
           ,[Id_UF]
           ,[cod_estado]
           ,[Id_Regiao_Tab_Padrao]
           ,[cod_regiao]
           ,[contribuinte]
           ,[id_cfop]
           ,[cfop]
           ,[Id_Class_Fiscal]
           ,[Cod_ClassFiscal]
           ,[Id_Grupo_Cliente]
           ,[cod_grupocliente]
           ,[Id_Origem_Mercadoria_Tab_Padrao]
           ,[origem_mercadoria]
           ,[Id_Tipo_Produto]
           ,[cod_itemgradeinfo]
           ,[Id_Tipo_Pedido]
           ,[cod_tipopedvenda]
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
	[Id_Tributacao]					  = Tributacao.id_tributacao
,	[cod_tributacao]				  = Trim(Fato.cod_tributacao)
,	[id_empresa_grupo]				  = 14144
,	[id_empresa]					  = Empresas.Id_Empresa
,	[empresa]						  = Empresas.Nome
,	[cod_empresa]					  = Trim(Fato.Cod_Empresa)
,	[Id_Grupo_Estoque]				  = 0
,	[cod_grupoestoque]				  = '*'
,	[Id_Item]						  = 0
,	[cod_item]						  = '*'
,	[Id_UF]							  = UFS.Codigo
,	[cod_estado]					  = Trim(Fato.Cod_Estado)
,	[Id_Regiao_Tab_Padrao]			  = 0
,	[cod_regiao]					  = fato.[cod_regiao]
,	[contribuinte]					  = fato.[contribuinte]
,	[id_cfop]						  = CFOP.id_cfop
,	[cfop]							  = fato.cfo
,	[Id_Class_Fiscal]				  = 0
,	[Cod_ClassFiscal]				  = fato.cod_classfiscal
,	[Id_Grupo_Cliente]				  = 0
,	[cod_grupocliente]				  = fato.cod_grupocliente
,	[Id_Origem_Mercadoria_Tab_Padrao] = #aux_ori_mercadoria.id_tabela_padrao
,	[origem_mercadoria]				  = fato.origem_mercadoria
,	[Id_Tipo_Produto]				  = Null
,	[cod_itemgradeinfo]				  = fato.cod_itemgradeinfo
,	[Id_Tipo_Pedido]				  = Vendas_Tipos_Pedido.id_vendas_tipos_pedido
,	[cod_tipopedvenda]				  = fato.cod_tipopedvenda
,	[incl_data]						  = GetDate()
,	[incl_user]						  = 'ksantana'
,	[incl_device]					  = 'PC/10.1.0.123'
,	[modi_data]						  = Null
,	[modi_user]						  = Null
,	[modi_device]					  = Null
,	[excl_data]						  = Null
,	[excl_user]						  = Null
,	[excl_device]					  = Null
From #GradeSetupTributacao Fato
Left Join Tributacao		  On Tributacao.Cod_Tributacao		   = Fato.Cod_Tributacao	 Collate Latin1_General_Ci_Ai
Left Join Empresas			  On Empresas.Codigo_Antigo			   = Fato.Cod_Empresa		 Collate Latin1_General_Ci_Ai
Left Join UFS				  On UFS.Uf							   = Fato.Cod_Estado		 Collate Latin1_General_Ci_Ai
Left Join CFOP				  On CFOP.Cfop						   = Fato.Cfo				 Collate Latin1_General_Ci_Ai
Left Join #Aux_Ori_Mercadoria On #Aux_Ori_Mercadoria.Codigo		   = Fato.Origem_Mercadoria  Collate Latin1_General_Ci_Ai
Left Join Vendas_Tipos_Pedido On Vendas_Tipos_Pedido.Cod_TipoVenda = Fato.Cod_TipoPedVenda   Collate Latin1_General_Ci_Ai