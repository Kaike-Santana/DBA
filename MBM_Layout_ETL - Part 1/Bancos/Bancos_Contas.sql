
Use Thesys_Homologacao
Go

Drop Table If Exists #BancoContasMBM
Select *
,	Pk = Trim(Cod_Banco) + Trim(Nro_Agencia) + Trim(Nro_Conta)
Into #BancoContasMBM
From OpenQuery([MBM_Poliresinas],'
Select 
	Conta_Bancaria.*
,	Agencia.Cod_Estado 
,	Agencia.Endereco
,	Agencia.Fone
,	Agencia.Fax
,	Agencia.Gerente
,	Agencia.Email
,	Agencia.Digito_Verificador As Digito_Verificador_Ag
,	Cidade.Descricao		   As Cidade
,	Bairro.Descricao		   As Bairro
,	Plano_Contas.Tipo		   As Tipo_ContaContabilCr
,	P2.Tipo					   As Tipo_ContaContabilDb
,	P3.Tipo					   As Tipo_Cod_CcDespBanco
From Conta_Bancaria
Left Join Plano_Contas		 On  Plano_Contas.Cod_PlanoContas = Conta_Bancaria.Cod_ContaContabilCr
							 And Plano_Contas.Cod_Empresa     = Conta_Bancaria.Cod_Empresa
Left Join Plano_Contas As P2 On  P2.Cod_PlanoContas			  = Conta_Bancaria.Cod_ContaContabilDb
							 And P2.Cod_Empresa				  = Conta_Bancaria.Cod_Empresa
Left Join Plano_Contas As P3 On  P3.Cod_PlanoContas			  = Conta_Bancaria.Cod_CcDespBanco
							 And P3.Cod_Empresa				  = Conta_Bancaria.Cod_Empresa
Left Join Agencia			 On  Agencia.Cod_banco			  = Conta_Bancaria.Cod_Banco
							 And Agencia.Nro_agencia		  = Conta_Bancaria.Nro_Agencia
Left Join Cidade			 On  Cidade.Cod_Cidade			  = Agencia.Cod_Cidade
Left Join Bairro			 On  Bairro.Cod_Bairro			  = Agencia.Cod_Bairro
')

Union All

Select *
,	Pk = Trim(Cod_Banco) + Trim(Nro_Agencia) + Trim(Nro_Conta)
From OpenQuery([MBM_Rubberon],'
Select 
	Conta_Bancaria.*
,	Agencia.Cod_Estado 
,	Agencia.Endereco
,	Agencia.Fone
,	Agencia.Fax
,	Agencia.Gerente
,	Agencia.Email
,	Agencia.Digito_Verificador As Digito_Verificador_Ag
,	Cidade.Descricao		   As Cidade
,	Bairro.Descricao		   As Bairro
,	Plano_Contas.Tipo		   As Tipo_ContaContabilCr
,	P2.Tipo					   As Tipo_ContaContabilDb
,	P3.Tipo					   As Tipo_Cod_CcDespBanco
From Conta_Bancaria
Left Join Plano_Contas		 On  Plano_Contas.Cod_PlanoContas = Conta_Bancaria.Cod_ContaContabilCr
							 And Plano_Contas.Cod_Empresa     = Conta_Bancaria.Cod_Empresa
Left Join Plano_Contas As P2 On  P2.Cod_PlanoContas			  = Conta_Bancaria.Cod_ContaContabilDb
							 And P2.Cod_Empresa				  = Conta_Bancaria.Cod_Empresa
Left Join Plano_Contas As P3 On  P3.Cod_PlanoContas			  = Conta_Bancaria.Cod_CcDespBanco
							 And P3.Cod_Empresa				  = Conta_Bancaria.Cod_Empresa
Left Join Agencia			 On  Agencia.Cod_banco			  = Conta_Bancaria.Cod_Banco
							 And Agencia.Nro_agencia		  = Conta_Bancaria.Nro_Agencia
Left Join Cidade			 On  Cidade.Cod_Cidade			  = Agencia.Cod_Cidade
Left Join Bairro			 On  Bairro.Cod_Bairro			  = Agencia.Cod_Bairro
Where Conta_Bancaria.Cod_Empresa != ''001''
')

Union All

Select *
,	Pk = Trim(Cod_Banco) + Trim(Nro_Agencia) + Trim(Nro_Conta)
From OpenQuery([MBM_Mg_Polimeros],'
Select 
	Conta_Bancaria.*
,	Agencia.Cod_Estado 
,	Agencia.Endereco
,	Agencia.Fone
,	Agencia.Fax
,	Agencia.Gerente
,	Agencia.Email
,	Agencia.Digito_Verificador As Digito_Verificador_Ag
,	Cidade.Descricao		   As Cidade
,	Bairro.Descricao		   As Bairro
,	Plano_Contas.Tipo		   As Tipo_ContaContabilCr
,	P2.Tipo					   As Tipo_ContaContabilDb
,	P3.Tipo					   As Tipo_Cod_CcDespBanco
From Conta_Bancaria
Left Join Plano_Contas		 On  Plano_Contas.Cod_PlanoContas = Conta_Bancaria.Cod_ContaContabilCr
							 And Plano_Contas.Cod_Empresa     = Conta_Bancaria.Cod_Empresa
Left Join Plano_Contas As P2 On  P2.Cod_PlanoContas			  = Conta_Bancaria.Cod_ContaContabilDb
							 And P2.Cod_Empresa				  = Conta_Bancaria.Cod_Empresa
Left Join Plano_Contas As P3 On  P3.Cod_PlanoContas			  = Conta_Bancaria.Cod_CcDespBanco
							 And P3.Cod_Empresa				  = Conta_Bancaria.Cod_Empresa
Left Join Agencia			 On  Agencia.Cod_banco			  = Conta_Bancaria.Cod_Banco
							 And Agencia.Nro_agencia		  = Conta_Bancaria.Nro_Agencia
Left Join Cidade			 On  Cidade.Cod_Cidade			  = Agencia.Cod_Cidade
Left Join Bairro			 On  Bairro.Cod_Bairro			  = Agencia.Cod_Bairro
Where Conta_Bancaria.Cod_Empresa Not In (''001'',''300'')
')

Union All

Select *
,	Pk = Trim(Cod_Banco) + Trim(Nro_Agencia) + Trim(Nro_Conta)
From OpenQuery([MBM_Polirex],'
Select 
	Conta_Bancaria.*
,	Agencia.Cod_Estado 
,	Agencia.Endereco
,	Agencia.Fone
,	Agencia.Fax
,	Agencia.Gerente
,	Agencia.Email
,	Agencia.Digito_Verificador As Digito_Verificador_Ag
,	Cidade.Descricao		   As Cidade
,	Bairro.Descricao		   As Bairro
,	Plano_Contas.Tipo		   As Tipo_ContaContabilCr
,	P2.Tipo					   As Tipo_ContaContabilDb
,	P3.Tipo					   As Tipo_Cod_CcDespBanco
From Conta_Bancaria
Left Join Plano_Contas		 On  Plano_Contas.Cod_PlanoContas = Conta_Bancaria.Cod_ContaContabilCr
							 And Plano_Contas.Cod_Empresa     = Conta_Bancaria.Cod_Empresa
Left Join Plano_Contas As P2 On  P2.Cod_PlanoContas			  = Conta_Bancaria.Cod_ContaContabilDb
							 And P2.Cod_Empresa				  = Conta_Bancaria.Cod_Empresa
Left Join Plano_Contas As P3 On  P3.Cod_PlanoContas			  = Conta_Bancaria.Cod_CcDespBanco
							 And P3.Cod_Empresa				  = Conta_Bancaria.Cod_Empresa
Left Join Agencia			 On  Agencia.Cod_banco			  = Conta_Bancaria.Cod_Banco
							 And Agencia.Nro_agencia		  = Conta_Bancaria.Nro_Agencia
Left Join Cidade			 On  Cidade.Cod_Cidade			  = Agencia.Cod_Cidade
Left Join Bairro			 On  Bairro.Cod_Bairro			  = Agencia.Cod_Bairro
Where Conta_Bancaria.Cod_Empresa != ''001''
')

Union All

Select *
,	Pk = Trim(Cod_Banco) + Trim(Nro_Agencia) + Trim(Nro_Conta)
From OpenQuery([MBM_NorteBag],'
Select 
	Conta_Bancaria.*
,	Agencia.Cod_Estado 
,	Agencia.Endereco
,	Agencia.Fone
,	Agencia.Fax
,	Agencia.Gerente
,	Agencia.Email
,	Agencia.Digito_Verificador As Digito_Verificador_Ag
,	Cidade.Descricao		   As Cidade
,	Bairro.Descricao		   As Bairro
,	Plano_Contas.Tipo		   As Tipo_ContaContabilCr
,	P2.Tipo					   As Tipo_ContaContabilDb
,	P3.Tipo					   As Tipo_Cod_CcDespBanco
From Conta_Bancaria
Left Join Plano_Contas		 On  Plano_Contas.Cod_PlanoContas = Conta_Bancaria.Cod_ContaContabilCr
							 And Plano_Contas.Cod_Empresa     = Conta_Bancaria.Cod_Empresa
Left Join Plano_Contas As P2 On  P2.Cod_PlanoContas			  = Conta_Bancaria.Cod_ContaContabilDb
							 And P2.Cod_Empresa				  = Conta_Bancaria.Cod_Empresa
Left Join Plano_Contas As P3 On  P3.Cod_PlanoContas			  = Conta_Bancaria.Cod_CcDespBanco
							 And P3.Cod_Empresa				  = Conta_Bancaria.Cod_Empresa
Left Join Agencia			 On  Agencia.Cod_banco			  = Conta_Bancaria.Cod_Banco
							 And Agencia.Nro_agencia		  = Conta_Bancaria.Nro_Agencia
Left Join Cidade			 On  Cidade.Cod_Cidade			  = Agencia.Cod_Cidade
Left Join Bairro			 On  Bairro.Cod_Bairro			  = Agencia.Cod_Bairro
Where Conta_Bancaria.Cod_Empresa != ''001''
')

Drop Table If Exists #Uniq
Select *
Into #Uniq
From (
	   Select *
	   , Rw = Row_Number() Over ( Partition By Pk Order By Dt_Change Desc)
	   From #BancoContasMBM
	 ) SubQuery
Where Rw = 1

Drop Table If Exists #Final
Select 
  Id_Empresa	   = Empresas.Id_Empresa
, Id_Empresa_Grupo = Empresas.Id_Empresa_Grupo
, Fato.*
Into #Final
From #Uniq Fato
Join Empresas On Empresas.Codigo_Antigo = Fato.Cod_Empresa Collate latin1_general_ci_ai


Insert Into [dbo].[Bancos_Contas]
           ([id_empresa]
           ,[id_banco]
           ,[cod_banco]
           ,[nro_agencia]
           ,[nro_conta]
           ,[nome]
           ,[id_ccdespbanco]
           ,[cod_ccdespbanco]
           ,[tipo]
           ,[id_contacontabilcr]
           ,[cod_contacontabilcr]
           ,[senha]
           ,[id_contacontabildb]
           ,[cod_contacontabildb]
           ,[ultimo_cheque]
           ,[integracao_contabil]
           ,[digito_verificador]
           ,[ativo]
           ,[operacao]
           ,[ag_cidade]
           ,[ag_bairro]
           ,[ag_uf]
           ,[ag_endereco]
           ,[ag_fone]
           ,[ag_fax]
           ,[ag_gerente]
           ,[ag_email]
           ,[ag_digito_verificador]
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
	[id_empresa]			=	Fato.Id_Empresa
,	[id_banco]				=	Bancos.id_banco
,	[cod_banco]				=	fato.cod_banco
,	[nro_agencia]			=	fato.nro_agencia
,	[nro_conta]				=	fato.nro_conta
,	[nome]					=	fato.nome
,	[id_ccdespbanco]		=	Plano_Contas.id_plano
,	[cod_ccdespbanco]		=	fato.[cod_ccdespbanco]
,	[tipo]					=	fato.[tipo]					
,	[id_contacontabilcr]	=	Pl_C.id_plano
,	[cod_contacontabilcr]	=	fato.cod_contacontabilcr
,	[senha]					=	fato.[senha]					
,	[id_contacontabildb]	=	Pl_D.id_plano	
,	[cod_contacontabildb]	=	fato.cod_contacontabildb	
,	[ultimo_cheque]			=	fato.[ultimo_cheque]			
,	[integracao_contabil]	=	fato.[integracao_contabil]	
,	[digito_verificador]	=	fato.[digito_verificador]	
,	[ativo]					=	fato.[ativo]					
,	[operacao]				=	fato.[operacao]				
,	[ag_cidade]				=	Fato.Cidade				
,	[ag_bairro]				=	fato.Bairro				
,	[ag_uf]					=	fato.Cod_Estado					
,	[ag_endereco]			=	fato.Endereco			
,	[ag_fone]				=	fato.Fone				
,	[ag_fax]				=	fato.Fax				
,	[ag_gerente]			=	fato.Gerente			
,	[ag_email]				=	fato.Email				
,	[ag_digito_verificador]	=	fato.Digito_Verificador_Ag
,	[incl_data]				=	GetDate()
,	[incl_user]				=	'ksantana'
,	[incl_device]			=	'PC/10.1.0.154'
,	[modi_data]				=	Null
,	[modi_user]				=	Null
,	[modi_device]			=	Null
,	[excl_data]				=	Null
,	[excl_user]				=	Null
,	[excl_device]			=	Null
--,	Rw						=	Row_Number() Over ( Partition By Fato.Cod_Banco, Fato.Nro_Agencia, Fato.Nro_Conta Order by Fato.Cod_Banco Desc)
From #Final Fato
Left Join Bancos				On	Bancos.cod_banco			  = Fato.cod_banco			  Collate Latin1_General_Ci_Ai
Left Join Plano_Contas			On	Plano_Contas.cod_planocontas  = Fato.cod_ccdespbanco	  Collate Latin1_General_Ci_Ai
								And Plano_Contas.Tipo			  = Fato.Tipo_Cod_CcDespBanco Collate Latin1_General_Ci_Ai
Left Join Plano_Contas As Pl_D  On  Pl_D.cod_planocontas		  = Fato.Cod_ContaContabilDb  Collate Latin1_General_Ci_Ai
								And Pl_D.Tipo					  =	Fato.Tipo_ContaContabilDb Collate Latin1_General_Ci_Ai
Left Join Plano_Contas As Pl_C  On  Pl_C.cod_planocontas		  = Fato.Cod_ContaContabilCr  Collate Latin1_General_Ci_Ai
								And Pl_C.Tipo					  =	Fato.Tipo_ContaContabilCr Collate Latin1_General_Ci_Ai
Where Not Exists (
				   Select *
				   From Bancos_Contas Dim
				   Where Dim.Cod_Banco   = Fato.Cod_Banco    Collate latin1_general_ci_ai
				   And	 Dim.Nro_Agencia = Fato.Nro_Agencia  Collate latin1_general_ci_ai
				   And	 Dim.Nro_Conta   = Fato.Nro_Conta    Collate latin1_general_ci_ai
				   And   Dim.Id_Empresa  = Fato.Id_Empresa
				 )

--Where Fato.Ativo = 'S'
ORDER BY fato.nome DESC