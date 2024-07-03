
Use Thesys_Dev
Go

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* Programador: Kaike Natan																		*/
/* Versao     : Data: 12/06/2024																*/
/* Descricao  : Script De ETL Da Tabela de Setup De Vendas Do MBM								*/
/*																								*/
/* Alteracao																					*/
/*        2. Programador:                                                  Data: __/__/____		*/        
/*           Descricao  :																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Consolida Base Das 5 empresas Para Popular a Tabela Natureza_setup_vendas			*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #PreBaseSetupVendas
Select 
	Empresa = 'poliresinas',
	*
Into #PreBaseSetupVendas
From OpenQuery([mbm_poliresinas],'
select 
	fato.*
,	subgrupo_estoque.descricao as descricao_subgrupo
,	grupo_estoque.descricao	   as descricao_grupo_estoque
,	atividade.descricao        as descricao_atividade
,	grupo_cliente.descricao    as descricao_grpcliente
from grade_natoperacao fato
left join subgrupo_estoque on subgrupo_estoque.cod_subgrupoestoque = fato.cod_subgrpestoq
left join grupo_estoque    on grupo_estoque.cod_grupoestoque       = fato.cod_grupoestoque
left join atividade		   on atividade.cod_atividade			   = fato.cod_atividade
left join grupo_cliente	   on grupo_cliente.cod_grpcliente		   = fato.cod_grupocliente
')

Union All

Select 
	Empresa = 'mg_polimeros',
	*
From OpenQuery([mbm_mg_polimeros],'
select 
	fato.*
,	subgrupo_estoque.descricao as descricao_subgrupo
,	grupo_estoque.descricao	   as descricao_grupo_estoque
,	atividade.descricao        as descricao_atividade
,	grupo_cliente.descricao    as descricao_grpcliente
from grade_natoperacao fato
left join subgrupo_estoque on subgrupo_estoque.cod_subgrupoestoque = fato.cod_subgrpestoq
left join grupo_estoque    on grupo_estoque.cod_grupoestoque       = fato.cod_grupoestoque
left join atividade		   on atividade.cod_atividade			   = fato.cod_atividade
left join grupo_cliente	   on grupo_cliente.cod_grpcliente		   = fato.cod_grupocliente
where cod_empresa != ''300'' --> sempre desconsiderar esse ID na MG, cagada na migracacao do Jacksys
')

Union All

Select 
	Empresa = 'nortebag',
	*
From OpenQuery([mbm_nortebag],'
select 
	fato.*
,	subgrupo_estoque.descricao as descricao_subgrupo
,	grupo_estoque.descricao	   as descricao_grupo_estoque
,	atividade.descricao        as descricao_atividade
,	grupo_cliente.descricao    as descricao_grpcliente
from grade_natoperacao fato
left join subgrupo_estoque on subgrupo_estoque.cod_subgrupoestoque = fato.cod_subgrpestoq
left join grupo_estoque    on grupo_estoque.cod_grupoestoque       = fato.cod_grupoestoque
left join atividade		   on atividade.cod_atividade			   = fato.cod_atividade
left join grupo_cliente	   on grupo_cliente.cod_grpcliente		   = fato.cod_grupocliente
')

Union All

Select 
	Empresa = 'polirex',
	*
From OpenQuery([mbm_polirex],'
select 
	fato.*
,	subgrupo_estoque.descricao as descricao_subgrupo
,	grupo_estoque.descricao	   as descricao_grupo_estoque
,	atividade.descricao        as descricao_atividade
,	grupo_cliente.descricao    as descricao_grpcliente
from grade_natoperacao fato
left join subgrupo_estoque on subgrupo_estoque.cod_subgrupoestoque = fato.cod_subgrpestoq
left join grupo_estoque    on grupo_estoque.cod_grupoestoque       = fato.cod_grupoestoque
left join atividade		   on atividade.cod_atividade			   = fato.cod_atividade
left join grupo_cliente	   on grupo_cliente.cod_grpcliente		   = fato.cod_grupocliente
')

Union All

Select 
	Empresa = 'rubberon',
	*
From OpenQuery([mbm_rubberon],'
select 
	fato.*
,	subgrupo_estoque.descricao as descricao_subgrupo
,	grupo_estoque.descricao	   as descricao_grupo_estoque
,	atividade.descricao        as descricao_atividade
,	grupo_cliente.descricao    as descricao_grpcliente
from grade_natoperacao fato
left join subgrupo_estoque on subgrupo_estoque.cod_subgrupoestoque = fato.cod_subgrpestoq
left join grupo_estoque    on grupo_estoque.cod_grupoestoque       = fato.cod_grupoestoque
left join atividade		   on atividade.cod_atividade			   = fato.cod_atividade
left join grupo_cliente	   on grupo_cliente.cod_grpcliente		   = fato.cod_grupocliente
')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Cria Tabela Auxiliar Para Cruzar Com a Tabela Padrao								*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #Regioes
Create Table #Regioes (
					   Cod_Estado Varchar(2),
					   Regiao     Varchar(20)
					  );

Insert Into #Regioes (Cod_Estado, Regiao) 
Values ('SP', 'Sudeste'),
	   ('RJ', 'Sudeste'),
	   ('MG', 'Sudeste'),
	   ('ES', 'Sudeste'),
	   ('PR', 'Sul'),
	   ('SC', 'Sul'),
	   ('RS', 'Sul'),
	   ('AM', 'Norte'),
	   ('RR', 'Norte'),
	   ('AP', 'Norte'),
	   ('PA', 'Norte'),
	   ('TO', 'Norte'),
	   ('AC', 'Norte'),
	   ('RO', 'Norte'),
	   ('AL', 'Nordeste'),
	   ('BA', 'Nordeste'),
	   ('CE', 'Nordeste'),
	   ('MA', 'Nordeste'),
	   ('PB', 'Nordeste'),
	   ('PE', 'Nordeste'),
	   ('PI', 'Nordeste'),
	   ('RN', 'Nordeste'),
	   ('SE', 'Nordeste'),
	   ('DF', 'Centro-Oeste'),
	   ('GO', 'Centro-Oeste'),
	   ('MT', 'Centro-Oeste'),
	   ('MS', 'Centro-Oeste')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Inclui Na Base Do MBM a Regiao Que Aquela UF Pertence								*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #BaseSetupVendas
Select 
	Fato.*
,	Dim.Regiao
,	Dim_2.ID_EMPRESA_GRUPO
Into #BaseSetupVendas
From #PreBaseSetupVendas Fato
Left Join #Regioes		 Dim   On Dim.Cod_Estado = Fato.Cod_Estado
Left Join Empresas       Dim_2 On Dim_2.CODIGO_ANTIGO = Fato.cod_empresa Collate Latin1_General_Ci_Ai
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Cria Tabela Dimensao Por Uf e Seus Respectivos Codigos De UF						*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #DimensaoUF
Select Distinct Uf, CodIuf
Into #DimensaoUF
From Cidades
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Tabela Padrao Com a Regiao Da UF													*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #DimRegiaoUf
Select *
Into #DimRegiaoUf
From Tabela_Padrao
Where cod_tabelapadrao = 'regiao_nat_operacao'
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Tabela Padrao Com o Tipo De Origem Da Mercadoria									*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #DimOrigemMerc
Select *
Into #DimOrigemMerc
From Tabela_Padrao
Where cod_tabelapadrao = 'origem_mercadoria'
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Remove Cod de NatOperacao Duplicado Por Empresa									*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #NatOperacao
Select *
Into #NatOperacao
From (
	  Select *
	  ,	Rw = Row_Number() Over (Partition By id_empresa_grupo, cod_natoperacao Order By Cod_NatOperacao Desc)
	  From natureza_operacao
	 ) SubQuery
Where Rw = 1
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Cria Tabela Auxiliar Com o DexPara de Tipo de Produto								*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #AuxTipoProduto
Create Table #AuxTipoProduto (
							   Id Varchar(3) Primary Key,
							   Descricao Varchar(255),
							   Id_Dexpara Int
							 );

Insert Into #AuxTipoProduto (Id, Descricao, Id_Dexpara)
Values (101, 'Produção',				8),
	   (102, 'Revenda/Mp',				5),
	   (103, 'Outros',				    6),
	   (900, 'Material De Uso Consumo', 4)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Cria Os Indices Nas Tabelas Para Melhor Performance								*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Begin
	Create NonClustered Index Sku_Cod_Estado On #Regioes		(Cod_Estado)
	Create NonClustered Index Sku_Uf		 On #DimensaoUF		(Uf		   )
	Create NonClustered Index Sku_Descricao  On #DimRegiaoUf	(Descricao )
	Create NonClustered Index Sku_Codigo	 On #DimOrigemMerc  (Codigo    )
	Create NonClustered Index Sku_Id		 On #AuxTipoProduto (Id        )
End
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Cria Tabela Auxiliar Com o DexPara de Tipo de Produto								*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Insert Into [dbo].[Natureza_Operacao_Setup_Vendas] --alter table [Natureza_Operacao_Setup_Vendas] add Pk_Mbm varchar(100)
           ([Id_Empresa]
           ,[Id_Empresa_Grupo]
           ,[Optante_SN]
           ,[Tipo_Pessoa]
           ,[Id_Tipo_Pedido]
           ,[Id_Subgrupo_Estoque]
           ,[Id_Grupo_Estoque]
           ,[Id_UF_Origem]
           ,[Id_UF_Destino]
           ,[Id_Regiao_Tab_Padrao]
           ,[Id_Item]
           ,[Id_Class_Fiscal]
           ,[contribuinte]
           ,[Id_Natureza_Operacao]
           ,[Id_Atividade]
           ,[Id_Grupo_Cliente]
           ,[Id_Origem_Mercadoria_Tab_Padrao]
           ,[Id_Tipo_Produto]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device]
		   --,[Pk_Mbm]
		   )
Select 
	[Id_Empresa]						=  Empresas.Id_Empresa
,	[Id_Empresa_Grupo]					=  Empresas.Id_Empresa_Grupo
,	[Optante_SN]						=  Iif(Fato.Optante_Sn  = '*', Null, Fato.Optante_Sn)
,	[Tipo_Pessoa]						=  Iif(Fato.Tipo_Pessoa = '*', Null, Fato.Tipo_Pessoa)
,	[Id_Tipo_Pedido]					=  Vendas_Tipos_Pedido.id_vendas_tipos_pedido
,	[Id_Subgrupo_Estoque]				=  SubGrupos_Estoque.id_subgrupo_estoque
,	[Id_Grupo_Estoque]					=  Grupos_Estoque.id_grupo_estoque
,	[Id_UF_Origem]						=  Empresas.CodIuf
,	[Id_UF_Destino]						=  #DimensaoUF.CodIuf
,	[Id_Regiao_Tab_Padrao]				=  #DimRegiaoUf.id_tabela_padrao
,	[Id_Item]							=  Itens_Empresas.id_item
,	[Id_Class_Fiscal]					=  Class_Fiscal.id_clasfisc
,	[contribuinte]						=  Iif(Fato.Contribuinte = '*', Null, Fato.Contribuinte)
,	[Id_Natureza_Operacao]				=  #NatOperacao.id_NaturezaOperacao
,	[Id_Atividade]						=  Atividades.cod_atividade
,	[Id_Grupo_Cliente]					=  Grupo_Clientes.id_grupo_cliente
,	[Id_Origem_Mercadoria_Tab_Padrao]	=  #DimOrigemMerc.id_tabela_padrao
,	[Id_Tipo_Produto]					=  #AuxTipoProduto.Id_Dexpara
,	[incl_data]							=  GetDate()
,	[incl_user]							=  'ksantana'
,	[incl_device]						=  'PC/10.1.0.154'
,	[modi_data]							=  Null
,	[modi_user]							=  Null
,	[modi_device]						=  Null
,	[excl_data]							=  Null
,	[excl_user]							=  Null
,	[excl_device]						=  Null
--,	[Pk_Mbm]							=  fato.Empresa + '_' + convert(varchar(20),Cod_GradeNatOperacao)
From #BaseSetupVendas Fato
Left Join Empresas			  On  (Empresas.Codigo_Antigo			  = Fato.Cod_Empresa			 Collate Latin1_General_Ci_Ai) 
Left Join Vendas_Tipos_Pedido On  (Vendas_Tipos_Pedido.Cod_TipoVenda  = Fato.Cod_TipoPedVenda		 Collate Latin1_General_Ci_Ai) 
Left Join SubGrupos_Estoque   On  (SubGrupos_Estoque.Descricao	      = Fato.Descricao_SubGrupo		 Collate Latin1_General_Ci_Ai) 
Left Join Grupos_Estoque      On  (Grupos_Estoque.Descricao		      = Fato.Descricao_Grupo_Estoque Collate Latin1_General_Ci_Ai) 
Left Join #DimensaoUF		  On  (#DimensaoUF.Uf					  = Fato.Cod_Estado				 Collate Latin1_General_Ci_Ai) 
Left Join #DimRegiaoUf		  On  (#DimRegiaoUf.Descricao			  = Fato.Regiao					 Collate Latin1_General_Ci_Ai) 
Left Join Itens_Empresas	  On  (Itens_Empresas.cod_reduzido_antigo = Fato.Cod_item				 Collate Latin1_General_Ci_Ai)
Left Join Class_Fiscal		  On  (Class_Fiscal.cod_classfiscal		  = Fato.Cod_classfiscal		 Collate Latin1_General_Ci_Ai)
Left Join #NatOperacao		  On  (#NatOperacao.Cod_Natoperacao		  = Fato.Cod_Natoperacao		 Collate Latin1_General_Ci_Ai) 
							  And (#NatOperacao.id_empresa_grupo	  = Fato.Id_Empresa_Grupo									 )
Left Join Atividades		  On  (Atividades.Descricao				  = Fato.Descricao_Atividade	 Collate Latin1_General_Ci_Ai)
Left Join Grupo_Clientes	  On  (Grupo_Clientes.Descricao			  = Fato.Descricao_GrpCliente	 Collate Latin1_General_Ci_Ai)
Left Join #DimOrigemMerc	  On  (#DimOrigemMerc.Codigo			  = Fato.Origem_Mercadoria		 Collate Latin1_General_Ci_Ai)
Left Join #AuxTipoProduto	  On  (#AuxTipoProduto.Id				  = Fato.Cod_ItemGradeInfo		 Collate Latin1_General_Ci_Ai)

where #NatOperacao.id_NaturezaOperacao is null --> Sempre Verificar se Tem Id_Nat_Operacao vazio, não pode ter, caso tenha tenha popular tabela natureza_operacao