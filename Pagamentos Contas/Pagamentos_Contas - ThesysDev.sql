
Use Thesys_Dev
Go

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* Programador: Kaike Natan																		*/
/* Versao     : Data: 07/06/2024																*/
/* Descricao  : Script De ETL Da Tabela De Pagamentos Contas Do MBM Para o Thesys				*/
/*																								*/
/* ALTERACAO																					*/
/*        2. Programador:                                                  Data: __/__/____		*/        
/*           Descricao  :																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	Alter Procedure Prc_Etl_Pagamentos_Contas_MBM As
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Base MBM de Contas a Pagar da PoliResinas											*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Begin;
Drop table if exists #BaseContasPagarMBM
Select *
Into #BaseContasPagarMBM
From openquery([mbm_poliresinas],'
select 
  cod_empresa, 
  cod_clifor, 
  serie, 
  nro_titulo, 
  parcela, 
  cod_portador, 
  pai_codclifor, 
  pai_serie, 
  cod_natrecdesp, 
  cod_tipopagto, 
  pai_nrotitulo, 
  fato.cod_tipodocto, 
  tipodocto.descricao as descricao_doc, 
  pai_parcela, 
  dt_emissao, 
  dt_vencto, 
  dt_baixa, 
  valor, 
  saldo, 
  situacao, 
  calculardescto, 
  dt_limitedescto, 
  historico, 
  tipodescto, 
  valordescto, 
  percentualdescto, 
  calcularjuros, 
  tipojuros, 
  valorjuros, 
  percentualjuros, 
  calcularmulta, 
  tipomulta, 
  valormulta, 
  percentualmulta, 
  pedido_compra, 
  nro_nfiscal, 
  nro_nobanco, 
  tipo_titulo, 
  origem_titulo, 
  fazer_deposito, 
  banco_fornec, 
  agencia_fornec, 
  conta_fornec, 
  conciliado, 
  dt_conciliado, 
  enviado_banco, 
  dt_enviadobanco, 
  valor_ir, 
  cod_ccir, 
  valor_bcalc_ir, 
  valor_iss, 
  valor_inss, 
  cod_cciss, 
  valor_bcalc_iss, 
  valor_bcalc_inss, 
  cod_ccinss, 
  gps_codpagto, 
  gps_compete, 
  gps_valoutrasent, 
  gps_jurosmulta, 
  gps_identificador, 
  darf_dtapuracao, 
  darf_cnpj, 
  darf_codreceita, 
  darf_referencia, 
  darf_valmulta, 
  darf_juros, 
  codigo_barra, 
  darf_valreceita, 
  tipo_codigobarra, 
  darf_percentual, 
  cod_ccpis, 
  valor_bcalc_pis, 
  valor_pis, 
  cod_cccofins, 
  valor_bcalc_cofins, 
  valor_cofins, 
  cod_cccsll, 
  valor_bcalc_csll, 
  valor_csll, 
  anotacoes :: varchar(65535) as anotacoes, 
  cr_serie, 
  cr_codclifor, 
  cr_nronfiscal, 
  fato.dt_change, 
  liberado_pagto, 
  usuario_liberoupagto, 
  dt_liberoupagto, 
  convertido, 
  nome_contribuinte, 
  cod_carga, 
  status_enviadobanco, 
  gps_valorinss, 
  dt_agendadopara, 
  status_enviadobanco1, 
  seq_previsaocpmensal, 
  dtvencto_congelado, 
  tipotitulo_congelado, 
  cod_portadorcongelado, 
  congelado, 
  saldo_congelado, 
  cod_moeda, 
  valor_taxamoeda, 
  valor_om, 
  nro_processo, 
  declaracao_importacao, 
  valor_faturacomercial, 
  valor_invoice, 
  cod_ccfunrural, 
  valor_bcalc_funrural, 
  valor_funrural, 
  cod_pedidovenda, 
  nro_processoimp, 
  id_integracao, 
  parcela_desdobrada, 
  ano_compet_titulo, 
  mes_compet_titulo, 
  cod_grupo, 
  cod_id, 
  cod_descricao, 
  cod_alocacao, 
  cod_cliforsacador, 
  cod_situacaotitulo, 
  fgts_codreceita, 
  valor_sestsenat, 
  cod_ccsestsenat, 
  valor_bcalc_sestsenat, 
  exp_id, 
  exp_mensagem, 
  exp_situacao, 
  exp_data, 
  exp_hora, 
  despimp_nroprocesso, 
  despimp_sequencia, 
  calcula_juroscomposto, 
  dt_inclusao 
from 
  cpcada fato 
  left join tipodocto on tipodocto.cod_tipodocto = fato.cod_tipodocto')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Tabela Padrao Com Os Tipos De Pagamentos Que Popula a Coluna FormaPGTO			*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #Tb_Aux_TpPag
select *
into #Tb_Aux_TpPag
from Tabela_Padrao
where cod_tabelapadrao = 'tipos_pagamentos'

Create Nonclustered Index Idx_Cod_Pag On #Tb_Aux_TpPag (Codigo)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Separa Nº da Parcela Atual Com o Maximo Para Criar Coluna Dps no Layout			*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #ParcelasCTE;
Select 
    Fato.*,
    Count(*) Over (Partition By cod_clifor, nro_titulo) As TotalParcelas
Into #ParcelasCTE
From #BaseContasPagarMBM Fato;
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Criação da tabela temporária ParcelasNumeradas									*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #ParcelasNumeradas;
Select *
, (Try_Cast(parcela AS INT) - Row_Number() Over (Partition By cod_clifor, nro_titulo Order By Try_Cast(parcela As Int)) + 1) As ParcelaInicial
Into #ParcelasNumeradas
From #ParcelasCTE;
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Tabela Final no Layout da Tabela de Pagamentos Contas								*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop table If Exists #LayoutTabela
Select 
    [ID_EMPRESA]                = Empresas.id_empresa,
    [empresa]                   = Empresas.nome,
    [cod_empresa]               = Empresas.codigo_antigo,
    [cod_clifor]                = Clifor.cod_clifor,
    [serie]                     = IIF(ParcelasNumeradas.serie IS NULL OR ParcelasNumeradas.serie = '', '*', ParcelasNumeradas.serie),
    [NumeroTitulo]              = ParcelasNumeradas.nro_titulo,
    [Parcela]                   = TRIM(CAST(parcela AS VARCHAR(20))) + '/' + TRIM(CAST(TotalParcelas AS VARCHAR(20))),
    [ID_Portador]               = Portadores.id_portador,
    [ID_FormaPgto]              = #Tb_Aux_TpPag.id_tabela_padrao,
    [ID_TipoDoc]                = Tipos_Documentos.id_tipodoc,
    [DataEmissao]               = CONVERT(DATE, ParcelasNumeradas.dt_emissao),
    [DataVencimento]            = CONVERT(DATE, ParcelasNumeradas.dt_vencto),
    [DataBaixa]                 = CONVERT(DATE, ParcelasNumeradas.Dt_Baixa),
    [Valor]                     = ParcelasNumeradas.valor,
    [Saldo]						= ParcelasNumeradas.Saldo,
    [Situacao]                  = Iif(ParcelasNumeradas.situacao In ('DV','CA'), 'CAN', ParcelasNumeradas.situacao),
    [Historico]                 = ParcelasNumeradas.Historico,
    [CalcularJuros]             = ParcelasNumeradas.CalcularJuros,
    [TipoJuros]                 = ParcelasNumeradas.TipoJuros,
    [ValorJuros]                = ParcelasNumeradas.ValorJuros,
    [PercentualJuros]           = ParcelasNumeradas.PercentualJuros,
    [CalcularMulta]             = ParcelasNumeradas.CalcularMulta,
    [TipoMulta]                 = ParcelasNumeradas.TipoMulta,
    [ValorMulta]                = ParcelasNumeradas.ValorMulta,
    [PercentualMulta]           = ParcelasNumeradas.PercentualMulta,
    [ID_PedidoCompra]           = NULL,
    [NumeroNF]                  = ParcelasNumeradas.nro_nfiscal,
    [NumeroNoBanco]             = ParcelasNumeradas.nro_nobanco,
    [TipoTitulo]                = ParcelasNumeradas.Tipo_Titulo,
    [OrigemTitulo]              = ParcelasNumeradas.Origem_Titulo,
    [EnviadoBanco]              = ParcelasNumeradas.enviado_banco,
    [DataEnvioBanco]            = convert(date,ParcelasNumeradas.dt_enviadobanco),
    [ID_Plano_IR]               = NULL,
    [ir_bcalc]                  = ParcelasNumeradas.valor_bcalc_ir,
    [ir_perc]                   = ParcelasNumeradas.valor_ir,
    [ir_valor]                  = ParcelasNumeradas.valor_ir,
    [ID_Plano_ISS]              = NULL,
    [iss_bcalc]                 = ParcelasNumeradas.valor_bcalc_iss,
    [iss_perc]                  = ParcelasNumeradas.valor_iss,
    [iss_valor]                 = ParcelasNumeradas.valor_iss,
    [ID_Plano_INSS]             = NULL,
    [inss_bcalc]                = ParcelasNumeradas.valor_bcalc_inss,
    [inss_perc]                 = ParcelasNumeradas.valor_inss,
    [inss_valor]                = ParcelasNumeradas.valor_inss,
    [ID_Plano_PIS]              = NULL,
    [pis_bcalc]                 = ParcelasNumeradas.valor_bcalc_pis,
    [pis_perc]                  = ParcelasNumeradas.valor_pis,
    [pis_valor]                 = ParcelasNumeradas.valor_pis,
    [ID_Plano_COFINS]           = NULL,
    [cofins_bcalc]              = ParcelasNumeradas.valor_bcalc_cofins,
    [cofins_perc]               = ParcelasNumeradas.valor_bcalc_cofins,
    [cofins_valor]              = ParcelasNumeradas.valor_cofins,
    [ID_Plano_CSLL]             = NULL,
    [csll_bcalc]                = ParcelasNumeradas.valor_bcalc_csll,
    [csll_perc]                 = ParcelasNumeradas.valor_csll,
    [csll_valor]                = ParcelasNumeradas.valor_csll,
    [TipoCodigoBarras]          = ParcelasNumeradas.tipo_codigobarra,
    [CodigoBarras]              = ParcelasNumeradas.codigo_barra,
    [Anotacoes]                 = ParcelasNumeradas.Anotacoes,
    [StatusPagamento]           = ParcelasNumeradas.liberado_pagto,
    [StatusUsuarioID]           = 1,
    [StatusDataHora]            = getdate(),
    [StatusEnvioBanco]          = NULL,
    [GPS_ValorINSS]             = NULL,
    [DataAgendamento]           = convert(date,null),
    [ID_Moeda]                  = NULL,
    [ValorTaxaMoeda]            = NULL,
    [ValorOM]                   = NULL,
    [NumeroProcessoImp]         = NULL,
    [ParcelaDesdobrada]         = NULL,
    [TituloAnoCompetencia]      = ParcelasNumeradas.ano_compet_titulo,
    [TituloMesCompetencia]      = ParcelasNumeradas.mes_compet_titulo,
    [FGTSCodReceita]            = NULL,
    [DespImpNumeroProcesso]     = NULL,
    [DespImpSequencia]          = NULL,
    [incl_data]                 = getdate(),
    [incl_user]                 = 'ksantana',
    [incl_device]               = 'PC/10.1.0.154',
    [modi_data]                 = convert(datetime,null),
    [modi_user]                 = NULL,
    [modi_device]               = NULL,
    [excl_data]                 = convert(datetime,null),
    [excl_user]                 = NULL,
    [excl_device]               = NULL,
    [ID_CliFor_SacadorAvalista] = NULL,
    [ID_Pag_Solicit]            = NULL,
    [id_compra_importacao]      = NULL,
    [ID_Bordero]                = NULL,
    [ID_Pag_Conta_Agrupado]     = NULL,
    [ID_Pag_Conta_Origem]       = NULL,
    [titulo_imposto]            = NULL,
    [id_nota_fiscal]            = NULL,
    [SerieNF]                   = NULL,
    [id_tp_pgto_elet]           = NULL,
    [NumeroNoCliente]           = NULL,
    [ArqRemProc]                = NULL,
	[cod_retorno]				= NULL,
	parcelasnumeradas.cod_clifor as cod_clifor_mbm,
	parcelasnumeradas.parcela    as parcela_mbm

into #LayoutTabela
from #ParcelasNumeradas as parcelasnumeradas																	    
left join empresas		   on empresas.codigo_antigo     = parcelasnumeradas.cod_empresa   collate sql_latin1_general_cp1_ci_ai
left join clifor		   on clifor.cod_antigo		     = parcelasnumeradas.cod_clifor    collate sql_latin1_general_cp1_ci_ai and clifor.cod_empresa = 'poliresinas'
left join portadores	   on portadores.cod_portador    = parcelasnumeradas.cod_portador  collate sql_latin1_general_cp1_ci_ai and portadores.id_empresa_grupo = 1584 -- poliresinas
left join Tipos_Documentos on Tipos_Documentos.descricao = parcelasnumeradas.descricao_doc collate sql_latin1_general_cp1_ci_ai
left join #Tb_Aux_TpPag	   on #Tb_Aux_TpPag.codigo       = parcelasnumeradas.cod_tipopagto collate sql_latin1_general_cp1_ci_ai
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Insert Apenas Do Diferencial Na Tabela											*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Insert Into [dbo].[Pagamentos_Contas]
           ([ID_EMPRESA]
           ,[empresa]
           ,[cod_empresa]
           ,[cod_clifor]
           ,[serie]
           ,[NumeroTitulo]
           ,[Parcela]
           ,[ID_Portador]
           ,[ID_FormaPgto]
           ,[ID_TipoDoc]
           ,[DataEmissao]
           ,[DataVencimento]
           ,[DataBaixa]
           ,[Valor]
           ,[Saldo]
           ,[Situacao]
           ,[Historico]
           ,[CalcularJuros]
           ,[TipoJuros]
           ,[ValorJuros]
           ,[PercentualJuros]
           ,[CalcularMulta]
           ,[TipoMulta]
           ,[ValorMulta]
           ,[PercentualMulta]
           ,[ID_PedidoCompra]
           ,[NumeroNF]
           ,[NumeroNoBanco]
           ,[TipoTitulo]
           ,[OrigemTitulo]
           ,[EnviadoBanco]
           ,[DataEnvioBanco]
           ,[ID_Plano_IR]
           ,[ir_bcalc]
           ,[ir_perc]
           ,[ir_valor]
           ,[ID_Plano_ISS]
           ,[iss_bcalc]
           ,[iss_perc]
           ,[iss_valor]
           ,[ID_Plano_INSS]
           ,[inss_bcalc]
           ,[inss_perc]
           ,[inss_valor]
           ,[ID_Plano_PIS]
           ,[pis_bcalc]
           ,[pis_perc]
           ,[pis_valor]
           ,[ID_Plano_COFINS]
           ,[cofins_bcalc]
           ,[cofins_perc]
           ,[cofins_valor]
           ,[ID_Plano_CSLL]
           ,[csll_bcalc]
           ,[csll_perc]
           ,[csll_valor]
           ,[TipoCodigoBarras]
           ,[CodigoBarras]
           ,[Anotacoes]
           ,[StatusPagamento]
           ,[StatusUsuarioID]
           ,[StatusDataHora]
           ,[StatusEnvioBanco]
           ,[GPS_ValorINSS]
           ,[DataAgendamento]
           ,[ID_Moeda]
           ,[ValorTaxaMoeda]
           ,[ValorOM]
           ,[NumeroProcessoImp]
           ,[ParcelaDesdobrada]
           ,[TituloAnoCompetencia]
           ,[TituloMesCompetencia]
           ,[FGTSCodReceita]
           ,[DespImpNumeroProcesso]
           ,[DespImpSequencia]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device]
           ,[ID_CliFor_SacadorAvalista]
           ,[ID_Pag_Solicit]
           ,[id_compra_importacao]
           ,[ID_Bordero]
           ,[ID_Pag_Conta_Agrupado]
           ,[ID_Pag_Conta_Origem]
           ,[titulo_imposto]
           ,[id_nota_fiscal]
           ,[SerieNF]
           ,[id_tp_pgto_elet]
           ,[NumeroNoCliente]
           ,[ArqRemProc]
           ,[cod_retorno]
		   )
Select 
	[ID_EMPRESA]
,	[empresa]
,	[cod_empresa]
,	[cod_clifor]
,	[serie]
,	[NumeroTitulo]
,	[Parcela]
,	[ID_Portador]
,	[ID_FormaPgto]
,	[ID_TipoDoc]
,	[DataEmissao]
,	[DataVencimento]
,	[DataBaixa]
,	[Valor]
,	[Saldo]
,	[Situacao]
,	[Historico]
,	[CalcularJuros]
,	[TipoJuros]
,	[ValorJuros]
,	[PercentualJuros]
,	[CalcularMulta]
,	[TipoMulta]
,	[ValorMulta]
,	[PercentualMulta]
,	[ID_PedidoCompra]
,	[NumeroNF]
,	[NumeroNoBanco]
,	[TipoTitulo]
,	[OrigemTitulo]
,	[EnviadoBanco]
,	[DataEnvioBanco]
,	[ID_Plano_IR]
,	[ir_bcalc]
,	[ir_perc]
,	[ir_valor]
,	[ID_Plano_ISS]
,	[iss_bcalc]
,	[iss_perc]
,	[iss_valor]
,	[ID_Plano_INSS]
,	[inss_bcalc]
,	[inss_perc]
,	[inss_valor]
,	[ID_Plano_PIS]
,	[pis_bcalc]
,	[pis_perc]
,	[pis_valor]
,	[ID_Plano_COFINS]
,	[cofins_bcalc]
,	[cofins_perc]
,	[cofins_valor]
,	[ID_Plano_CSLL]
,	[csll_bcalc]
,	[csll_perc]
,	[csll_valor]
,	[TipoCodigoBarras]
,	[CodigoBarras]
,	[Anotacoes]
,	[StatusPagamento]
,	[StatusUsuarioID]
,	[StatusDataHora]
,	[StatusEnvioBanco]
,	[GPS_ValorINSS]
,	[DataAgendamento]
,	[ID_Moeda]
,	[ValorTaxaMoeda]
,	[ValorOM]
,	[NumeroProcessoImp]
,	[ParcelaDesdobrada]
,	[TituloAnoCompetencia]
,	[TituloMesCompetencia]
,	[FGTSCodReceita]
,	[DespImpNumeroProcesso]
,	[DespImpSequencia]
,	[incl_data]
,	[incl_user]
,	[incl_device]
,	[modi_data]
,	[modi_user]
,	[modi_device]
,	[excl_data]
,	[excl_user]
,	[excl_device]
,	[ID_CliFor_SacadorAvalista]
,	[ID_Pag_Solicit]
,	[id_compra_importacao]
,	[ID_Bordero]
,	[ID_Pag_Conta_Agrupado]
,	[ID_Pag_Conta_Origem]
,	[titulo_imposto]
,	[id_nota_fiscal]
,	[SerieNF]
,	[id_tp_pgto_elet]
,	[NumeroNoCliente]
,	[ArqRemProc]
,	[cod_retorno]  
From (
	   Select *
	   ,	Rw = Row_Number() Over ( Partition by Id_Empresa, cod_clifor, serie, NumeroTitulo, Parcela, DataEmissao, DataVencimento Order By id_tipodoc Desc)
	   From #LayoutTabela
	 ) SubQuery
Where Rw = 1
And Not Exists (
    Select 1
    From Pagamentos_Contas c
    Where SubQuery.cod_empresa	= c.cod_empresa	 
    And SubQuery.cod_clifor		= c.cod_clifor   
    And SubQuery.serie			= c.serie 		 collate sql_latin1_general_cp1_ci_ai
    And SubQuery.NumeroTitulo	= c.numerotitulo collate sql_latin1_general_cp1_ci_ai
    And SubQuery.parcela		= c.parcela	     collate sql_latin1_general_cp1_ci_ai
)

--> Dropa Tabelas Temporárias da Procedure
Begin 
	Drop Table If Exists #BaseContasPagarMBM
	Drop Table If Exists #Tb_Aux_TpPag
	Drop Table If Exists #ParcelasCTE
	Drop Table If Exists #ParcelasNumeradas
	Drop Table If Exists #LayoutTabela
End

End;