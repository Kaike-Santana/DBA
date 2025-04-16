
Use Thesys_Dev
Go

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* Programador: Kaike Natan									                                    */
/* Versao     : Data: 08/08/2024																*/
/* Descricao  : Script de ETL da Base Bancos Movimentacoes do MBM Para o Thesys					*/
/*																								*/
/*	Alteracao                                                                                   */
/*        2. Programador: 													 Data: __/__/____	*/		
/*           Descricao  : 																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	Create Procedure Prc_Etl_Bancos_Movimentacoes_MBM As 
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Consolida a Base de Bancos Movimentacoes(Lancamentos) das 5 Empresas do MBM		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #BaseMBM 
Select *
,	Pk	       = Trim(Cod_Banco)   + Trim(Nro_Agencia)   + Trim(Nro_Conta)   + Trim(AaaaMm)    + Trim(Cod_Lancamento)
,	Pk_TF      = Trim(Tf_CodBanco) + Trim(Tf_NroAgencia) + Trim(Tf_NroConta) + Trim(Tf_AaaaMm) + Trim(Tf_CodLancamento)
Into #BaseMBM
From OpenQuery([Mbm_PoliResinas],'
Select 
  Lancamentos.cod_banco, 
  Lancamentos.cod_lancamento, 
  Lancamentos.nro_agencia, 
  Lancamentos.nro_conta, 
  Lancamentos.aaaamm, 
  Lancamentos.dt_bompara, 
  Lancamentos.cod_natrecdesp, 
  Lancamentos.cod_historcxbanco, 
  Lancamentos.dt_emissao, 
  Lancamentos.cod_empresa, 
  Lancamentos.docto, 
  Lancamentos.historico, 
  Lancamentos.valor, 
  Lancamentos.tipo, 
  Lancamentos.saldo, 
  cast(Lancamentos.obs as varchar(1000)) as obs, 
  Lancamentos.conciliado, 
  Lancamentos.saldo_conciliado, 
  Lancamentos.origem_lancto, 
  Lancamentos.anomes, 
  Lancamentos.nominal, 
  Lancamentos.referencia, 
  Lancamentos.emp_referencia, 
  Lancamentos.cod_contacontabilcr, 
  Lancamentos.cod_contacontabildb, 
  Lancamentos.exp_sisterceiro, 
  Lancamentos.tf_codbanco, 
  Lancamentos.tf_nroagencia, 
  Lancamentos.tf_nroconta, 
  Lancamentos.tf_aaaamm, 
  Lancamentos.tf_codlancamento, 
  Lancamentos.tipo_documento, 
  Lancamentos.chave_conciliacaoauto, 
  Lancamentos.dt_change, 
  Lancamentos.congelado, 
  Lancamentos.cod_grupo, 
  Lancamentos.cod_id, 
  Lancamentos.cod_descricao, 
  Lancamentos.cod_alocacao, 
  Lancamentos.exp_regimecaixa, 
  Lancamentos.valor_conciliacao, 
  Lancamentos.cod_lancamentopai,
  Portador.Cod_Portador
From Lancamentos
Left Join Portador  On  (Portador.Cod_Banco   = Lancamentos.Cod_Banco  )
				    And (Portador.Nro_Agencia = Lancamentos.Nro_Agencia)
				    And (Portador.Nro_Conta   = Lancamentos.Nro_Conta  )
')

Union All

Select *
,	Pk	       = Trim(Cod_Banco)   + Trim(Nro_Agencia)   + Trim(Nro_Conta)   + Trim(AaaaMm)    + Trim(Cod_Lancamento)
,	Pk_TF      = Trim(Tf_CodBanco) + Trim(Tf_NroAgencia) + Trim(Tf_NroConta) + Trim(Tf_AaaaMm) + Trim(Tf_CodLancamento)
From OpenQuery([Mbm_Rubberon],'
Select 
  Lancamentos.cod_banco, 
  Lancamentos.cod_lancamento, 
  Lancamentos.nro_agencia, 
  Lancamentos.nro_conta, 
  Lancamentos.aaaamm, 
  Lancamentos.dt_bompara, 
  Lancamentos.cod_natrecdesp, 
  Lancamentos.cod_historcxbanco, 
  Lancamentos.dt_emissao, 
  Lancamentos.cod_empresa, 
  Lancamentos.docto, 
  Lancamentos.historico, 
  Lancamentos.valor, 
  Lancamentos.tipo, 
  Lancamentos.saldo, 
  cast(Lancamentos.obs as varchar(1000)) as obs, 
  Lancamentos.conciliado, 
  Lancamentos.saldo_conciliado, 
  Lancamentos.origem_lancto, 
  Lancamentos.anomes, 
  Lancamentos.nominal, 
  Lancamentos.referencia, 
  Lancamentos.emp_referencia, 
  Lancamentos.cod_contacontabilcr, 
  Lancamentos.cod_contacontabildb, 
  Lancamentos.exp_sisterceiro, 
  Lancamentos.tf_codbanco, 
  Lancamentos.tf_nroagencia, 
  Lancamentos.tf_nroconta, 
  Lancamentos.tf_aaaamm, 
  Lancamentos.tf_codlancamento, 
  Lancamentos.tipo_documento, 
  Lancamentos.chave_conciliacaoauto, 
  Lancamentos.dt_change, 
  Lancamentos.congelado, 
  Lancamentos.cod_grupo, 
  Lancamentos.cod_id, 
  Lancamentos.cod_descricao, 
  Lancamentos.cod_alocacao, 
  Lancamentos.exp_regimecaixa, 
  Lancamentos.valor_conciliacao, 
  Lancamentos.cod_lancamentopai,
  Portador.Cod_Portador
From Lancamentos
Left Join Portador  On  (Portador.Cod_Banco   = Lancamentos.Cod_Banco  )
				    And (Portador.Nro_Agencia = Lancamentos.Nro_Agencia)
				    And (Portador.Nro_Conta   = Lancamentos.Nro_Conta  )
Where Lancamentos.Cod_Empresa != ''001''')

Union All

Select *
,	Pk	       = Trim(Cod_Banco)   + Trim(Nro_Agencia)   + Trim(Nro_Conta)   + Trim(AaaaMm)    + Trim(Cod_Lancamento)
,	Pk_TF      = Trim(Tf_CodBanco) + Trim(Tf_NroAgencia) + Trim(Tf_NroConta) + Trim(Tf_AaaaMm) + Trim(Tf_CodLancamento)
From OpenQuery([Mbm_Polirex],'
Select 
  Lancamentos.cod_banco, 
  Lancamentos.cod_lancamento, 
  Lancamentos.nro_agencia, 
  Lancamentos.nro_conta, 
  Lancamentos.aaaamm, 
  Lancamentos.dt_bompara, 
  Lancamentos.cod_natrecdesp, 
  Lancamentos.cod_historcxbanco, 
  Lancamentos.dt_emissao, 
  Lancamentos.cod_empresa, 
  Lancamentos.docto, 
  Lancamentos.historico, 
  Lancamentos.valor, 
  Lancamentos.tipo, 
  Lancamentos.saldo, 
  cast(Lancamentos.obs as varchar(1000)) as obs, 
  Lancamentos.conciliado, 
  Lancamentos.saldo_conciliado, 
  Lancamentos.origem_lancto, 
  Lancamentos.anomes, 
  Lancamentos.nominal, 
  Lancamentos.referencia, 
  Lancamentos.emp_referencia, 
  Lancamentos.cod_contacontabilcr, 
  Lancamentos.cod_contacontabildb, 
  Lancamentos.exp_sisterceiro, 
  Lancamentos.tf_codbanco, 
  Lancamentos.tf_nroagencia, 
  Lancamentos.tf_nroconta, 
  Lancamentos.tf_aaaamm, 
  Lancamentos.tf_codlancamento, 
  Lancamentos.tipo_documento, 
  Lancamentos.chave_conciliacaoauto, 
  Lancamentos.dt_change, 
  Lancamentos.congelado, 
  Lancamentos.cod_grupo, 
  Lancamentos.cod_id, 
  Lancamentos.cod_descricao, 
  Lancamentos.cod_alocacao, 
  Lancamentos.exp_regimecaixa, 
  Lancamentos.valor_conciliacao, 
  Lancamentos.cod_lancamentopai,
  Portador.Cod_Portador
From Lancamentos
Left Join Portador  On  (Portador.Cod_Banco   = Lancamentos.Cod_Banco  )
				    And (Portador.Nro_Agencia = Lancamentos.Nro_Agencia)
				    And (Portador.Nro_Conta   = Lancamentos.Nro_Conta  )
Where Cod_Empresa != ''001''')

Union All

Select *
,	Pk	       = Trim(Cod_Banco)   + Trim(Nro_Agencia)   + Trim(Nro_Conta)   + Trim(AaaaMm)    + Trim(Cod_Lancamento)
,	Pk_TF      = Trim(Tf_CodBanco) + Trim(Tf_NroAgencia) + Trim(Tf_NroConta) + Trim(Tf_AaaaMm) + Trim(Tf_CodLancamento)
From OpenQuery([Mbm_Mg_Polimeros],'
Select 
  Lancamentos.cod_banco, 
  Lancamentos.cod_lancamento, 
  Lancamentos.nro_agencia, 
  Lancamentos.nro_conta, 
  Lancamentos.aaaamm, 
  Lancamentos.dt_bompara, 
  Lancamentos.cod_natrecdesp, 
  Lancamentos.cod_historcxbanco, 
  Lancamentos.dt_emissao, 
  Lancamentos.cod_empresa, 
  Lancamentos.docto, 
  Lancamentos.historico, 
  Lancamentos.valor, 
  Lancamentos.tipo, 
  Lancamentos.saldo, 
  cast(Lancamentos.obs as varchar(1000)) as obs, 
  Lancamentos.conciliado, 
  Lancamentos.saldo_conciliado, 
  Lancamentos.origem_lancto, 
  Lancamentos.anomes, 
  Lancamentos.nominal, 
  Lancamentos.referencia, 
  Lancamentos.emp_referencia, 
  Lancamentos.cod_contacontabilcr, 
  Lancamentos.cod_contacontabildb, 
  Lancamentos.exp_sisterceiro, 
  Lancamentos.tf_codbanco, 
  Lancamentos.tf_nroagencia, 
  Lancamentos.tf_nroconta, 
  Lancamentos.tf_aaaamm, 
  Lancamentos.tf_codlancamento, 
  Lancamentos.tipo_documento, 
  Lancamentos.chave_conciliacaoauto, 
  Lancamentos.dt_change, 
  Lancamentos.congelado, 
  Lancamentos.cod_grupo, 
  Lancamentos.cod_id, 
  Lancamentos.cod_descricao, 
  Lancamentos.cod_alocacao, 
  Lancamentos.exp_regimecaixa, 
  Lancamentos.valor_conciliacao, 
  Lancamentos.cod_lancamentopai,
  Portador.Cod_Portador
From Lancamentos
Left Join Portador  On  (Portador.Cod_Banco   = Lancamentos.Cod_Banco  )
				    And (Portador.Nro_Agencia = Lancamentos.Nro_Agencia)
				    And (Portador.Nro_Conta   = Lancamentos.Nro_Conta  )
Where Cod_Empresa Not In (''001'',''300'')')

Union All

Select *
,	Pk	       = Trim(Cod_Banco)   + Trim(Nro_Agencia)   + Trim(Nro_Conta)   + Trim(AaaaMm)    + Trim(Cod_Lancamento)
,	Pk_TF      = Trim(Tf_CodBanco) + Trim(Tf_NroAgencia) + Trim(Tf_NroConta) + Trim(Tf_AaaaMm) + Trim(Tf_CodLancamento)
From OpenQuery([Mbm_NorteBag],'
Select 
  Lancamentos.cod_banco, 
  Lancamentos.cod_lancamento, 
  Lancamentos.nro_agencia, 
  Lancamentos.nro_conta, 
  Lancamentos.aaaamm, 
  Lancamentos.dt_bompara, 
  Lancamentos.cod_natrecdesp, 
  Lancamentos.cod_historcxbanco, 
  Lancamentos.dt_emissao, 
  Lancamentos.cod_empresa, 
  Lancamentos.docto, 
  Lancamentos.historico, 
  Lancamentos.valor, 
  Lancamentos.tipo, 
  Lancamentos.saldo, 
  cast(Lancamentos.obs as varchar(1000)) as obs, 
  Lancamentos.conciliado, 
  Lancamentos.saldo_conciliado, 
  Lancamentos.origem_lancto, 
  Lancamentos.anomes, 
  Lancamentos.nominal, 
  Lancamentos.referencia, 
  Lancamentos.emp_referencia, 
  Lancamentos.cod_contacontabilcr, 
  Lancamentos.cod_contacontabildb, 
  Lancamentos.exp_sisterceiro, 
  Lancamentos.tf_codbanco, 
  Lancamentos.tf_nroagencia, 
  Lancamentos.tf_nroconta, 
  Lancamentos.tf_aaaamm, 
  Lancamentos.tf_codlancamento, 
  Lancamentos.tipo_documento, 
  Lancamentos.chave_conciliacaoauto, 
  Lancamentos.dt_change, 
  Lancamentos.congelado, 
  Lancamentos.cod_grupo, 
  Lancamentos.cod_id, 
  Lancamentos.cod_descricao, 
  Lancamentos.cod_alocacao, 
  Lancamentos.exp_regimecaixa, 
  Lancamentos.valor_conciliacao, 
  Lancamentos.cod_lancamentopai,
  Portador.Cod_Portador
From Lancamentos
Left Join Portador  On  (Portador.Cod_Banco   = Lancamentos.Cod_Banco  )
				    And (Portador.Nro_Agencia = Lancamentos.Nro_Agencia)
				    And (Portador.Nro_Conta   = Lancamentos.Nro_Conta  )
Where Cod_Empresa != ''001''')

Print (Convert(Char(20),GetDate(),20) + '| ' +  'OpenQuery da Base MBM:' + ' OK! ')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Garante a Integridade dos Dados de Acordo Com a PK do MBM							*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #Uniq
Select *
Into #Uniq
From (
		Select *
		,	Rw = Row_Number() Over ( Partition By Pk Order By Pk Desc)
		From #BaseMBM 
	 )SubQuery
Where Rw = 1

Print (Convert(Char(20),GetDate(),20) + '| ' +  'RowNumber, Deixando Base Uniq:' + ' OK! ')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Inclui na Base do MBM o Id_Empresa e Id_Empresa_Grupo do Thesys					*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #Final
Select
	Empresas.Id_Empresa_Grupo
,	Empresas.Id_Empresa
,	fato.*
Into #Final
From #Uniq Fato
Join Empresas On Empresas.Codigo_Antigo = Fato.Cod_Empresa Collate latin1_general_ci_ai 

Print (Convert(Char(20),GetDate(),20) + '| ' +  'Inclusao do Id_Empresa e Id_Empresa_Grupo na Base:' + ' OK! ')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Insere Apenas os Dados incrementais na Tabela Fisica: Bancos_Movimentacoes		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Insert Into [dbo].[Bancos_Movimentacoes] 
           (
			[id_portador]
           ,[id_historcxbanco]
           ,[id_empresa_grupo]
           ,[Competencia_Mes]
           ,[Competencia_Ano]
           ,[dt_bompara]
           ,[dt_emissao]
           ,[docto]
           ,[historico_livre]
           ,[valor]
           ,[tipo]
           ,[obs]
           ,[conciliado]
           ,[origem_lancto]
           ,[nominal]
           ,[id_bordero]
           ,[cod_contacontabilcr]
           ,[cod_contacontabildb]
           ,[id_portador_transf]
           ,[id_bancos_mov_transf]
           ,[cod_lancamento]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device]
           ,[dt_conciliacao]
           ,[anomes]
           ,[valor_sinal]
           ,[id_portador_origem_transf]
           ,[id_portador_destino_transf]
           ,[id_banco_conta]
           ,[id_bc_origem_transf]
           ,[id_bc_destino_transf]
		   ,[Pk]
		   ,[Pk_TF]
		   )
Select 
	[id_portador]				 = Portadores.Id_Portador
,	[id_historcxbanco]			 = Null
,	[id_empresa_grupo]			 = Fato.Id_Empresa_Grupo
,	[Competencia_Mes]			 = Right(Fato.AaaaMM,2)
,	[Competencia_Ano]			 = Left(Fato.AaaaMM,4)
,	[dt_bompara]				 = Convert(Date,Fato.Dt_BomPara )
,	[dt_emissao]				 = Convert(Date,Fato.Dt_Emissao)
,	[docto]						 = Fato.Docto
,	[historico_livre]			 = Fato.Historico
,	[valor]						 = Fato.Valor
,	[tipo]						 = Case 
									   When Fato.Tipo = 'C' Then 'CREDITO'
									   When Fato.Tipo = 'D' Then 'DEBITO'
									   Else 'Verificar Case When'
								   End
,	[obs]						 = Fato.Obs
,	[conciliado]				 = Fato.Conciliado
,	[origem_lancto]				 = Case 
									   When Fato.Origem_Lancto In ('C','D','M') Then 'MANUAL'
									   When Fato.Origem_Lancto In ('E','F','I')	Then 'CONTAS_RECEBER'
									   When Fato.Origem_Lancto In ('P', 'R')    Then 'CONTAS_PAGAR'
									   When Fato.Origem_Lancto = 'T'			Then 'TRANSFERENCIA'
									   Else 'Verificar Case When'
								   End
,	[nominal]					 = Fato.Nominal
,	[id_bordero]				 = Null 
,	[cod_contacontabilcr]		 = Fato.Cod_ContaContabilCr
,	[cod_contacontabildb]		 = Fato.Cod_ContaContabilDb
,	[id_portador_transf]		 = Null --> Colunas Que Vao Ser Deletadas Posteriormente
,	[id_bancos_mov_transf]		 = Null 
,	[cod_lancamento]			 = Fato.Cod_Lancamento
,	[incl_data]					 = GetDate()
,	[incl_user]					 = 'ksantana'
,	[incl_device]				 = 'PC/10.1.0.123'
,	[modi_data]					 = Null
,	[modi_user]					 = Null
,	[modi_device]				 = Null
,	[excl_data]					 = Null
,	[excl_user]					 = Null
,	[excl_device]				 = Null
,	[dt_conciliacao]			 = Fato.Dt_Change   
,	[anomes]					 = Fato.AnoMes
,	[valor_sinal]				 = Iif(Fato.Tipo = 'D', (Fato.Valor * - 1), Fato.Valor)
,	[id_portador_origem_transf]	 = Null --> Colunas Que Vao Ser Deletadas Posteriormente
,	[id_portador_destino_transf] = Null	--> Colunas Que Vao Ser Deletadas Posteriormente
,	[id_banco_conta]			 = Bancos_Contas.Id_Banco_Conta
,	[id_bc_origem_transf]		 = BcOri.Id_Banco_Conta
,	[id_bc_destino_transf]		 = Iif(BcOri.Id_Banco_Conta Is Not Null, Bancos_Contas.Id_Banco_Conta, Null)
,	[Pk]						 = Fato.Pk
,	[Pk_TF]						 = Fato.Pk_TF
From #Final Fato 
Left Join Portadores			 On  Portadores.Cod_Portador   = Fato.Cod_Portador  Collate latin1_general_ci_ai
								 And Portadores.Id_Empresa     = Fato.Id_Empresa 
Left Join Portadores    As P2	 On  P2.Cod_Portador		   = Fato.Cod_Portador  Collate latin1_general_ci_ai
								 And P2.Id_Empresa		       = Fato.Id_Empresa 
Left Join Bancos_Contas			 On  Bancos_Contas.Cod_Banco   = Fato.Cod_Banco     Collate latin1_general_ci_ai
								 And Bancos_Contas.Nro_Agencia = Fato.Nro_Agencia   Collate latin1_general_ci_ai
								 And Bancos_Contas.Nro_Conta   = Fato.Nro_Conta     Collate latin1_general_ci_ai
								 And Bancos_Contas.Id_Empresa  = Fato.Id_Empresa

Left Join Bancos_Contas As BcOri On  BcOri.Cod_Banco		   = Fato.TF_CodBanco   Collate latin1_general_ci_ai
								 And BcOri.Nro_Agencia		   = Fato.TF_NroAgencia Collate latin1_general_ci_ai
								 And BcOri.Nro_Conta		   = Fato.TF_NroConta   Collate latin1_general_ci_ai
								 And BcOri.Id_Empresa		   = Fato.Id_Empresa
Where Not Exists (
				  Select *
				  From Bancos_Movimentacoes Dim
				  Where Dim.Pk = Fato.Pk Collate latin1_general_ci_ai
				 )
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Merge Referenciando Coluna Id_Bancos_Mov_Transf Para Casos de Transf Entra Contas	*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Merge Into Bancos_Movimentacoes As Target
Using Bancos_Movimentacoes As Source
On Target.Pk_Tf = Source.Pk
When Matched Then
    Update 
	Set Target.Id_Bancos_Mov_Transf = Source.Id_bancos_mov;