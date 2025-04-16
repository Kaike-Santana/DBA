
Drop Table If Exists #BaseMBM 
Select *
, Pk	   = Trim(Cod_Banco)   + Trim(Nro_Agencia)   + Trim(Nro_Conta)   + Trim(AaaaMm)    + Trim(Cod_Lancamento)
, Pk_TF    = Trim(Tf_CodBanco) + Trim(Tf_NroAgencia) + Trim(Tf_NroConta) + Trim(Tf_AaaaMm) + Trim(Tf_CodLancamento)
, Fk_Refer = Trim(Emp_Referencia) + Trim(Referencia)
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
  Histor_CxBanco.descricao as descr_codhistbanco,
  Histor_CxBanco.Tipo as tipo_descr_codhistbanco,
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
Left Join Histor_CxBanco On  (Histor_CxBanco.Cod_HistorCxBanco = Lancamentos.Cod_HistorCxBanco)
Left Join Portador		 On  (Portador.Cod_Banco			   = Lancamentos.Cod_Banco        )
						 And (Portador.Nro_Agencia			   = Lancamentos.Nro_Agencia      )
						 And (Portador.Nro_Conta			   = Lancamentos.Nro_Conta        )')

Union All

Select *
, Pk	   = Trim(Cod_Banco)   + Trim(Nro_Agencia)   + Trim(Nro_Conta)   + Trim(AaaaMm)    + Trim(Cod_Lancamento)
, Pk_TF    = Trim(Tf_CodBanco) + Trim(Tf_NroAgencia) + Trim(Tf_NroConta) + Trim(Tf_AaaaMm) + Trim(Tf_CodLancamento)
, Fk_Refer = Trim(Emp_Referencia) + Trim(Referencia)
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
  Histor_CxBanco.descricao as descr_codhistbanco,
  Histor_CxBanco.Tipo as tipo_descr_codhistbanco,
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
Left Join Histor_CxBanco On  (Histor_CxBanco.Cod_HistorCxBanco = Lancamentos.Cod_HistorCxBanco)
Left Join Portador		 On  (Portador.Cod_Banco			   = Lancamentos.Cod_Banco        )
						 And (Portador.Nro_Agencia			   = Lancamentos.Nro_Agencia      )
						 And (Portador.Nro_Conta			   = Lancamentos.Nro_Conta        )
Where Lancamentos.Cod_Empresa != ''001''')

Union All

Select *
, Pk	   = Trim(Cod_Banco)   + Trim(Nro_Agencia)   + Trim(Nro_Conta)   + Trim(AaaaMm)    + Trim(Cod_Lancamento)
, Pk_TF    = Trim(Tf_CodBanco) + Trim(Tf_NroAgencia) + Trim(Tf_NroConta) + Trim(Tf_AaaaMm) + Trim(Tf_CodLancamento)
, Fk_Refer = Trim(Emp_Referencia) + Trim(Referencia)
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
  Histor_CxBanco.descricao as descr_codhistbanco,
  Histor_CxBanco.Tipo as tipo_descr_codhistbanco,
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
Left Join Histor_CxBanco On  (Histor_CxBanco.Cod_HistorCxBanco = Lancamentos.Cod_HistorCxBanco)
Left Join Portador		 On  (Portador.Cod_Banco			   = Lancamentos.Cod_Banco        )
						 And (Portador.Nro_Agencia			   = Lancamentos.Nro_Agencia      )
						 And (Portador.Nro_Conta			   = Lancamentos.Nro_Conta        )
Where Lancamentos.Cod_Empresa Not In (''001'',''300'')')

Union All

Select *
, Pk	   = Trim(Cod_Banco)   + Trim(Nro_Agencia)   + Trim(Nro_Conta)   + Trim(AaaaMm)    + Trim(Cod_Lancamento)
, Pk_TF    = Trim(Tf_CodBanco) + Trim(Tf_NroAgencia) + Trim(Tf_NroConta) + Trim(Tf_AaaaMm) + Trim(Tf_CodLancamento)
, Fk_Refer = Trim(Emp_Referencia) + Trim(Referencia)
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
  Histor_CxBanco.descricao as descr_codhistbanco,
  Histor_CxBanco.Tipo as tipo_descr_codhistbanco,
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
Left Join Histor_CxBanco On  (Histor_CxBanco.Cod_HistorCxBanco = Lancamentos.Cod_HistorCxBanco)
Left Join Portador		 On  (Portador.Cod_Banco			   = Lancamentos.Cod_Banco        )
						 And (Portador.Nro_Agencia			   = Lancamentos.Nro_Agencia      )
						 And (Portador.Nro_Conta			   = Lancamentos.Nro_Conta        )
Where Lancamentos.Cod_Empresa != ''001''')

Union All

Select *
, Pk	   = Trim(Cod_Banco)   + Trim(Nro_Agencia)   + Trim(Nro_Conta)   + Trim(AaaaMm)    + Trim(Cod_Lancamento)
, Pk_TF    = Trim(Tf_CodBanco) + Trim(Tf_NroAgencia) + Trim(Tf_NroConta) + Trim(Tf_AaaaMm) + Trim(Tf_CodLancamento)
, Fk_Refer = Trim(Emp_Referencia) + Trim(Referencia)
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
  Histor_CxBanco.descricao as descr_codhistbanco,
  Histor_CxBanco.Tipo as tipo_descr_codhistbanco,
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
Left Join Histor_CxBanco On  (Histor_CxBanco.Cod_HistorCxBanco = Lancamentos.Cod_HistorCxBanco)
Left Join Portador		 On  (Portador.Cod_Banco			   = Lancamentos.Cod_Banco        )
						 And (Portador.Nro_Agencia			   = Lancamentos.Nro_Agencia      )
						 And (Portador.Nro_Conta			   = Lancamentos.Nro_Conta        )
Where Lancamentos.Cod_Empresa != ''001''')

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
,	Fato.*
Into #Final
From #Uniq Fato
Join Empresas On Empresas.Codigo_Antigo = Fato.Cod_Empresa Collate latin1_general_ci_ai 

Print (Convert(Char(20),GetDate(),20) + '| ' +  'Inclusao do Id_Empresa e Id_Empresa_Grupo na Base:' + ' OK! ')

Select distinct
 Fato.Cod_Banco	
,Fato.Nro_Agencia
,Fato.Nro_Conta	
,Fato.Id_Empresa
From #Final Fato 
Left Join Portadores			  On  Portadores.Cod_Portador   = Fato.Cod_Portador			   Collate latin1_general_ci_ai
								  And Portadores.Id_Empresa     = Fato.Id_Empresa 
Left Join Historico_Cxbanco As Hb On  Hb.Descricao				= Fato.Descr_CodHistBanco	   Collate latin1_general_ci_ai
								  And Hb.Tipo					= Fato.Tipo				       Collate latin1_general_ci_ai
Left Join Bancos_Contas			  On  Bancos_Contas.Cod_Banco   = Fato.Cod_Banco			   Collate latin1_general_ci_ai
								  And Bancos_Contas.Nro_Agencia = Fato.Nro_Agencia			   Collate latin1_general_ci_ai
								  And Bancos_Contas.Nro_Conta   = Fato.Nro_Conta			   Collate latin1_general_ci_ai
								  And Bancos_Contas.Id_Empresa  = Fato.Id_Empresa

Left Join Bancos_Contas As BcOri  On  BcOri.Cod_Banco		   = Fato.TF_CodBanco			   Collate latin1_general_ci_ai
								  And BcOri.Nro_Agencia		   = Fato.TF_NroAgencia			   Collate latin1_general_ci_ai
								  And BcOri.Nro_Conta		   = Fato.TF_NroConta			   Collate latin1_general_ci_ai
								  And BcOri.Id_Empresa		   = Fato.Id_Empresa
where Bancos_Contas.id_banco_conta is null




SELECT *
FROM Bancos_Contas
WHERE cod_banco = '033'
AND nro_agencia = '0986'
AND nro_conta = '13001887'



INSERT INTO BANCOS_CONTAS ( 
    id_empresa, 
    id_banco, 
    cod_banco, 
    nro_agencia, 
    nro_conta, 
    nome, 
    id_ccdespbanco, 
    cod_ccdespbanco, 
    tipo, 
    id_contacontabilcr, 
    cod_contacontabilcr, 
    senha, 
    id_contacontabildb, 
    cod_contacontabildb, 
    ultimo_cheque, 
    integracao_contabil, 
    digito_verificador, 
    ativo, 
    operacao, 
    ag_cidade, 
    ag_bairro, 
    ag_uf, 
    ag_endereco, 
    ag_fone, 
    ag_fax, 
    ag_gerente, 
    ag_email, 
    ag_digito_verificador, 
    incl_data, 
    incl_user, 
    incl_device, 
    modi_data, 
    modi_user, 
    modi_device, 
    excl_data, 
    excl_user, 
    excl_device
) VALUES (
    12, 
    36, 
    '033', 
    '0986', 
    '13001887', 
    'CONTA CORRENTE (MG)', 
    1003, 
    '5.1.4.01.0002', 
    'Conta Corrente', 
    36, 
    '1.1.1.02.0030', 
    NULL, 
    36, 
    '1.1.1.02.0030', 
    0, 
    'S', 
    '7', 
    'S', 
    NULL, 
    'SAO PAULO', 
    'JARDIM ORLANDINA', 
    'SP', 
    'RUA VERGUEIRO, 4600', 
    0, 
    0, 
    0, 
    0, 
    0, 
    '2024-02-16 17:59:44.060', 
    'admin', 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL
);