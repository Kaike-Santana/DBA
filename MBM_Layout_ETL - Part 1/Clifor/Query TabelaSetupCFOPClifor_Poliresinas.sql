

Insert Into [dbo].[Setup_CFOP_CliFor]
           ([id_empresa_grupo]
           ,[id_cfop]
           ,[id_clifor]
           ,[id_natureza]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device]
           ,[cod_natoperacao]
           ,[id_estoque_deposito]
           ,[id_natureza_retorno])

Select 
	[id_empresa_grupo]	  = Empresas.Id_Empresa_Grupo
,	[id_cfop]			  = CFOP.id_cfop
,	[id_clifor]			  = Clifor.cod_clifor
,	[id_natureza]		  = Nt_E.id_NaturezaOperacao
,	[incl_data]			  = GetDate()
,	[incl_user]			  = 'ksantana'	
,	[incl_device]		  = 'PC/10.1.0.123'
,	[modi_data]			  = Null
,	[modi_user]			  = Null
,	[modi_device]		  = Null
,	[excl_data]			  = Null
,	[excl_user]			  = Null
,	[excl_device]		  = Null
,	[cod_natoperacao]	  = Fato.Cod_Natureza_Entrada
,	[id_estoque_deposito] = Estoque_Deposito.id_estoque_deposito
,	[id_natureza_retorno] = Nt_S.id_NaturezaOperacao
--From thesys_homologacao..TabelaSetupCFOPClifor_Poliresinas Fato -- 18 linhas
From TabelaSetupCFOPClifor_Poliresinas Fato -- 18 linhas
Join Empresas					On Empresas.Codigo_Antigo		 = Fato.Emp
Join CFOP						On CFOP.cfop					 = Fato.cfop_entrada_xml
Join Clifor						On Clifor.cnpj					 = Fato.cnpj_cpf
Join Natureza_Operacao As Nt_E	On Nt_E.cod_natoperacao			 = Fato.Cod_Natureza_Entrada And Nt_E.Id_Empresa_Grupo = 1584
Join Natureza_Operacao As Nt_S	On Nt_S.cod_natoperacao			 = Fato.Cod_Natureza_Saida	 And Nt_S.Id_Empresa_Grupo = 1584
Join Estoque_Deposito			On Estoque_Deposito.Cod_Deposito = Fato.Cod_Deposito


/*

-- arrumar cagada Macus
Update TabelaSetupCFOPClifor_Poliresinas
Set   Cod_Natureza_Saida = '6924-001'
Where Cod_Natureza_Saida = '6924-002'


With Cte_Update_IdFreteClifor As (
Select Distinct 
	Setup_CFOP_CliFor.Id_Clifor
,	Tipos_Frete.id_tipo_frete
From Setup_CFOP_CliFor
Join Clifor														   On Clifor.Cod_Clifor		= Setup_CFOP_CliFor.Id_CLifor
--Join TabelaSetupCFOPClifor_Poliresinas As Base On Base.Cnpj_Cpf			= Clifor.Cnpj
Join Thesys_Homologacao..TabelaSetupCFOPClifor_Poliresinas As Base On Base.Cnpj_Cpf			= Clifor.Cnpj
Join Tipos_Frete												   On Tipos_Frete.cod_frete = Base.tipo_frete
)

--Select * From Cte_Update_IdFreteClifor

Update Fato
Set id_tipo_frete = Cte.id_tipo_frete
,	industrializacao_por_encomenda = 'S'

From Clifor Fato
Join Cte_Update_IdFreteClifor Cte On Cte.id_clifor = Fato.cod_clifor

*/