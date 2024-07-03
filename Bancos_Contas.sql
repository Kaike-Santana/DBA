
Use Thesys_Homologacao
Go

Drop Table If Exists #BancoContasMBM
Select *
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
,	Cidade.Descricao as Cidade
,	Bairro.Descricao as Bairro
From Conta_Bancaria
Left Join Agencia On  Agencia.Cod_banco   = Conta_Bancaria.Cod_Banco
				  And Agencia.Nro_agencia = Conta_Bancaria.Nro_Agencia
Left Join Cidade  On  Cidade.Cod_Cidade   = Agencia.Cod_Cidade
Left Join Bairro  On  Bairro.Cod_Bairro   = Agencia.Cod_Bairro
')


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
	[id_empresa]			=	Empresas.Id_Empresa
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
From #BancoContasMBM Fato
Left Join Empresas				On	Empresas.codigo_antigo	      = Fato.cod_empresa		 Collate latin1_general_ci_ai
Left Join Bancos				On	Bancos.cod_banco			  = Fato.cod_banco			 Collate latin1_general_ci_ai
Left Join Plano_Contas			On	Plano_Contas.cod_planocontas  = Fato.cod_ccdespbanco	 Collate latin1_general_ci_ai
Left Join Plano_Contas As Pl_D  On  Pl_D.cod_planocontas		  = Fato.cod_contacontabildb Collate latin1_general_ci_ai
								And Pl_D.Tipo = 'D'											 Collate latin1_general_ci_ai
Left Join Plano_Contas As Pl_C  On  Pl_C.cod_planocontas		  = Fato.cod_contacontabildb Collate latin1_general_ci_ai
								And Pl_C.Tipo = 'C'											 Collate latin1_general_ci_ai

--Where Fato.Ativo = 'S'
ORDER BY fato.nome DESC