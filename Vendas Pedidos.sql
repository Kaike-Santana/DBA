
USE [THESYS_DEV]
GO

Drop Table If Exists #Pedido_Venda_Mbm 
Select 
	Empresa = 'RUBBERON'
,	*
Into #Pedido_Venda_Mbm
From OpenQuery([MBM_RUBBERON],'
Select 
  cod_pedidovenda, 
  pedido_venda.cod_clifor, 
  clifor.cgc_cpf,
  pedido_venda.cod_portador2, 
  pedido_venda.cod_tipopedvenda, 
  pedido_venda.cod_gerente, 
  pedido_venda.cod_portador, 
  pedido_venda.cod_orcamentista, 
  pedido_venda.cod_empresa, 
  pedido_venda.cod_prioridade, 
  pedido_venda.cod_tabelapreco, 
  pedido_venda.cod_repres, 
  pedido_venda.cod_transp, 
  pedido_venda.cod_condpagamento, 
  pedido_venda.cod_moeda, 
  pedido_venda.contato, 
  pedido_venda.cod_endcobranca, 
  pedido_venda.cod_usuario, 
  pedido_venda.cod_condpagamento2, 
  pedido_venda.redespacho, 
  Cl_2.cgc_cpf as redespacho_cnpj_cgc,
  pedido_venda.nro_pedcliente, 
  pedido_venda.dt_emissao, 
  pedido_venda.dt_solicitada_apos, 
  pedido_venda.dt_solicitada_limite, 
  pedido_venda.situacao, 
  pedido_venda.dt_validade, 
  pedido_venda.pedido_orcamento, 
  pedido_venda.aceita_ftparcial, 
  pedido_venda.dt_previsaofechamento, 
  pedido_venda.tipo_frete, 
  pedido_venda.val_frete, 
  pedido_venda.val_seguro, 
  pedido_venda.dt_aprovacao, 
  pedido_venda.quem_aprovou, 
  pedido_venda.valor_despesas, 
  pedido_venda.cod_endentrega, 
  cast(mensagem as character varying(1000)) as mensagem , 
  cast(mensagem_nf as character varying(1000)) as mensagem_nf, 
  pedido_venda.tipo_mensagemnf, 
  pedido_venda.inf_comissao, 
  pedido_venda.paga_comissao, 
  pedido_venda.liberado, 
  pedido_venda.perc_comissaofatura, 
  pedido_venda.dt_cancelou, 
  pedido_venda.perc_comissaorecebe, 
  pedido_venda.usuario_cancelou, 
  pedido_venda.cod_motcancelamento, 
  pedido_venda.motivo_cancelou, 
  pedido_venda.perc_descto, 
  pedido_venda.impresso, 
  pedido_venda.tipo_descto, 
  pedido_venda.pros_nome, 
  pedido_venda.pros_contato, 
  pedido_venda.pros_telefone, 
  pedido_venda.pros_celular, 
  pedido_venda.pros_uf, 
  pedido_venda.pros_email, 
  pedido_venda.pros_obs, 
  pedido_venda.tipo_taxamoeda, 
  pedido_venda.valor_taxamoeda, 
  pedido_venda.referencia, 
  pedido_venda.arq_descproposta, 
  pedido_venda.arq_condgeral, 
  pedido_venda.valor_bcalc_repasseicms, 
  pedido_venda.valor_repasseicms, 
  pedido_venda.valor_bcalc_zonafranca, 
  pedido_venda.valor_zonafranca, 
  pedido_venda.valor_bcalc_iss, 
  pedido_venda.valor_iss, 
  pedido_venda.exp_situacao, 
  pedido_venda.exp_data, 
  pedido_venda.exp_hora, 
  pedido_venda.dt_inclusao, 
  pedido_venda.dt_alteracao, 
  pedido_venda.cliente_geramanga, 
  pedido_venda.imp_boleto, 
  pedido_venda.codigo_palm, 
  pedido_venda.sep_status, 
  pedido_venda.sep_usuario, 
  pedido_venda.sep_dtinicio, 
  pedido_venda.sep_hsinicio, 
  pedido_venda.cod_orcamento, 
  pedido_venda.obs_proposta, 
  pedido_venda.prazo_entrega, 
  pedido_venda.dt_proximocontato, 
  pedido_venda.anotacao_followup, 
  pedido_venda.dt_envio, 
  pedido_venda.dt_change, 
  pedido_venda.status_web, 
  pedido_venda.origem, 
  pedido_venda.dt_finalizadoweb, 
  pedido_venda.dt_baixadoweb, 
  pedido_venda.recalculo_web, 
  pedido_venda.perc_comissaopedido, 
  pedido_venda.auxiliar_string1, 
  pedido_venda.auxiliar_string2, 
  pedido_venda.cod_tipofrete, 
  pedido_venda.cod_taxasucesso, 
  pedido_venda.cod_ordemseparacao, 
  pedido_venda.nro_pedidovendaint, 
  pedido_venda.email_boleto, 
  pedido_venda.dt_concluiudigitacao, 
  pedido_venda.cod_ficha, 
  pedido_venda.valor_fretepeso, 
  pedido_venda.em_analise, 
  pedido_venda.cod_usuarioanalise, 
  pedido_venda.cod_cliforoptring, 
  pedido_venda.observacao_bloqueio, 
  pedido_venda.dt_solicitacao, 
  pedido_venda.cod_projeto, 
  pedido_venda.exportado_agtl, 
  pedido_venda.ind_presenca_comprador, 
  pedido_venda.consumidor_final, 
  pedido_venda.local_dest_operacao, 
  pedido_venda.origem_integracao, 
  pedido_venda.pros_regiao, 
  pedido_venda.pros_atividade, 
  pedido_venda.pros_grpcliente, 
  pedido_venda.pros_contribuinte, 
  pedido_venda.pros_pessoa, 
  pedido_venda.pros_produtorrural, 
  pedido_venda.pros_optantesn, 
  pedido_venda.pros_cliforgradeinfo, 
  pedido_venda.cod_formaspagto, 
  pedido_venda.vendedor_interno, 
  pedido_venda.integrado_terceiro, 
  pedido_venda.cod_barrasetiquetavolume, 
  pedido_venda.cod_intermediador, 
  pedido_venda.tipo_operacaointermediador, 
  pedido_venda.rom_bloqgeracaoparcialpv, 
  pedido_venda.prazoentrega_despacho, 
  pedido_venda.valor_fretenaodestacado, 
  pedido_venda.comissao_especial, 
  pedido_venda.cod_situacaopedidovenda, 
  pedido_venda.seq_kanban, 
  pedido_venda.dt_baseparcela, 
  pedido_venda.clifor_permitefaturaparcial, 
  pedido_venda.imp_etiquetapv, 
  pedido_venda.anymarket_dtatualizacao, 
  pedido_venda.anymarket_dtfaturado, 
  pedido_venda.anymarket_dtenviado, 
  pedido_venda.anymarket_dtconcluido, 
  pedido_venda.possui_comissaoespecial, 
  pedido_venda.perc_comissaoespecial, 
  pedido_venda.rocket_ticket, 
  pedido_venda.rocket_hash, 
  pedido_venda.rocket_status, 
  pedido_venda.rocket_datasinc, 
  pedido_venda.rocket_parecer_analista_compliance, 
  pedido_venda.rocket_parecer_analista_credito, 
  pedido_venda.rocket_parecer_analista_reanalise, 
  pedido_venda.rocket_parecer_final, 
  pedido_venda.status_geracao_romaneio, 
  pedido_venda.data_entrega_orc 
From pedido_venda
Left Join Clifor		 On	Clifor.cod_clifor = pedido_venda.cod_clifor
Left Join Clifor as Cl_2 On Cl_2.cod_clifor   = pedido_venda.redespacho
')

UNION ALL

SELECT 
	EMPRESA = 'POLIRESINAS'
,	*
FROM OPENQUERY([MBM_POLIRESINAS],'
Select 
  cod_pedidovenda, 
  pedido_venda.cod_clifor, 
  clifor.cgc_cpf,
  pedido_venda.cod_portador2, 
  pedido_venda.cod_tipopedvenda, 
  pedido_venda.cod_gerente, 
  pedido_venda.cod_portador, 
  pedido_venda.cod_orcamentista, 
  pedido_venda.cod_empresa, 
  pedido_venda.cod_prioridade, 
  pedido_venda.cod_tabelapreco, 
  pedido_venda.cod_repres, 
  pedido_venda.cod_transp, 
  pedido_venda.cod_condpagamento, 
  pedido_venda.cod_moeda, 
  pedido_venda.contato, 
  pedido_venda.cod_endcobranca, 
  pedido_venda.cod_usuario, 
  pedido_venda.cod_condpagamento2, 
  pedido_venda.redespacho, 
  Cl_2.cgc_cpf as redespacho_cnpj_cgc,
  pedido_venda.nro_pedcliente, 
  pedido_venda.dt_emissao, 
  pedido_venda.dt_solicitada_apos, 
  pedido_venda.dt_solicitada_limite, 
  pedido_venda.situacao, 
  pedido_venda.dt_validade, 
  pedido_venda.pedido_orcamento, 
  pedido_venda.aceita_ftparcial, 
  pedido_venda.dt_previsaofechamento, 
  pedido_venda.tipo_frete, 
  pedido_venda.val_frete, 
  pedido_venda.val_seguro, 
  pedido_venda.dt_aprovacao, 
  pedido_venda.quem_aprovou, 
  pedido_venda.valor_despesas, 
  pedido_venda.cod_endentrega, 
  cast(mensagem as character varying(1000)) as mensagem , 
  cast(mensagem_nf as character varying(1000)) as mensagem_nf, 
  pedido_venda.tipo_mensagemnf, 
  pedido_venda.inf_comissao, 
  pedido_venda.paga_comissao, 
  pedido_venda.liberado, 
  pedido_venda.perc_comissaofatura, 
  pedido_venda.dt_cancelou, 
  pedido_venda.perc_comissaorecebe, 
  pedido_venda.usuario_cancelou, 
  pedido_venda.cod_motcancelamento, 
  pedido_venda.motivo_cancelou, 
  pedido_venda.perc_descto, 
  pedido_venda.impresso, 
  pedido_venda.tipo_descto, 
  pedido_venda.pros_nome, 
  pedido_venda.pros_contato, 
  pedido_venda.pros_telefone, 
  pedido_venda.pros_celular, 
  pedido_venda.pros_uf, 
  pedido_venda.pros_email, 
  pedido_venda.pros_obs, 
  pedido_venda.tipo_taxamoeda, 
  pedido_venda.valor_taxamoeda, 
  pedido_venda.referencia, 
  pedido_venda.arq_descproposta, 
  pedido_venda.arq_condgeral, 
  pedido_venda.valor_bcalc_repasseicms, 
  pedido_venda.valor_repasseicms, 
  pedido_venda.valor_bcalc_zonafranca, 
  pedido_venda.valor_zonafranca, 
  pedido_venda.valor_bcalc_iss, 
  pedido_venda.valor_iss, 
  pedido_venda.exp_situacao, 
  pedido_venda.exp_data, 
  pedido_venda.exp_hora, 
  pedido_venda.dt_inclusao, 
  pedido_venda.dt_alteracao, 
  pedido_venda.cliente_geramanga, 
  pedido_venda.imp_boleto, 
  pedido_venda.codigo_palm, 
  pedido_venda.sep_status, 
  pedido_venda.sep_usuario, 
  pedido_venda.sep_dtinicio, 
  pedido_venda.sep_hsinicio, 
  pedido_venda.cod_orcamento, 
  pedido_venda.obs_proposta, 
  pedido_venda.prazo_entrega, 
  pedido_venda.dt_proximocontato, 
  pedido_venda.anotacao_followup, 
  pedido_venda.dt_envio, 
  pedido_venda.dt_change, 
  pedido_venda.status_web, 
  pedido_venda.origem, 
  pedido_venda.dt_finalizadoweb, 
  pedido_venda.dt_baixadoweb, 
  pedido_venda.recalculo_web, 
  pedido_venda.perc_comissaopedido, 
  pedido_venda.auxiliar_string1, 
  pedido_venda.auxiliar_string2, 
  pedido_venda.cod_tipofrete, 
  pedido_venda.cod_taxasucesso, 
  pedido_venda.cod_ordemseparacao, 
  pedido_venda.nro_pedidovendaint, 
  pedido_venda.email_boleto, 
  pedido_venda.dt_concluiudigitacao, 
  pedido_venda.cod_ficha, 
  pedido_venda.valor_fretepeso, 
  pedido_venda.em_analise, 
  pedido_venda.cod_usuarioanalise, 
  pedido_venda.cod_cliforoptring, 
  pedido_venda.observacao_bloqueio, 
  pedido_venda.dt_solicitacao, 
  pedido_venda.cod_projeto, 
  pedido_venda.exportado_agtl, 
  pedido_venda.ind_presenca_comprador, 
  pedido_venda.consumidor_final, 
  pedido_venda.local_dest_operacao, 
  pedido_venda.origem_integracao, 
  pedido_venda.pros_regiao, 
  pedido_venda.pros_atividade, 
  pedido_venda.pros_grpcliente, 
  pedido_venda.pros_contribuinte, 
  pedido_venda.pros_pessoa, 
  pedido_venda.pros_produtorrural, 
  pedido_venda.pros_optantesn, 
  pedido_venda.pros_cliforgradeinfo, 
  pedido_venda.cod_formaspagto, 
  pedido_venda.vendedor_interno, 
  pedido_venda.integrado_terceiro, 
  pedido_venda.cod_barrasetiquetavolume, 
  pedido_venda.cod_intermediador, 
  pedido_venda.tipo_operacaointermediador, 
  pedido_venda.rom_bloqgeracaoparcialpv, 
  pedido_venda.prazoentrega_despacho, 
  pedido_venda.valor_fretenaodestacado, 
  pedido_venda.comissao_especial, 
  pedido_venda.cod_situacaopedidovenda, 
  pedido_venda.seq_kanban, 
  pedido_venda.dt_baseparcela, 
  pedido_venda.clifor_permitefaturaparcial, 
  pedido_venda.imp_etiquetapv, 
  pedido_venda.anymarket_dtatualizacao, 
  pedido_venda.anymarket_dtfaturado, 
  pedido_venda.anymarket_dtenviado, 
  pedido_venda.anymarket_dtconcluido, 
  pedido_venda.possui_comissaoespecial, 
  pedido_venda.perc_comissaoespecial, 
  pedido_venda.rocket_ticket, 
  pedido_venda.rocket_hash, 
  pedido_venda.rocket_status, 
  pedido_venda.rocket_datasinc, 
  pedido_venda.rocket_parecer_analista_compliance, 
  pedido_venda.rocket_parecer_analista_credito, 
  pedido_venda.rocket_parecer_analista_reanalise, 
  pedido_venda.rocket_parecer_final, 
  pedido_venda.status_geracao_romaneio, 
  pedido_venda.data_entrega_orc 
From pedido_venda
Left Join Clifor		 On	Clifor.cod_clifor = pedido_venda.cod_clifor
Left Join Clifor as Cl_2 On Cl_2.cod_clifor   = pedido_venda.redespacho
')

UNION ALL

SELECT 
	EMPRESA = 'NORTEBAG'
,	*
FROM OPENQUERY([MBM_NORTEBAG],'
Select 
  cod_pedidovenda, 
  pedido_venda.cod_clifor, 
  clifor.cgc_cpf,
  pedido_venda.cod_portador2, 
  pedido_venda.cod_tipopedvenda, 
  pedido_venda.cod_gerente, 
  pedido_venda.cod_portador, 
  pedido_venda.cod_orcamentista, 
  pedido_venda.cod_empresa, 
  pedido_venda.cod_prioridade, 
  pedido_venda.cod_tabelapreco, 
  pedido_venda.cod_repres, 
  pedido_venda.cod_transp, 
  pedido_venda.cod_condpagamento, 
  pedido_venda.cod_moeda, 
  pedido_venda.contato, 
  pedido_venda.cod_endcobranca, 
  pedido_venda.cod_usuario, 
  pedido_venda.cod_condpagamento2, 
  pedido_venda.redespacho, 
  Cl_2.cgc_cpf as redespacho_cnpj_cgc,
  pedido_venda.nro_pedcliente, 
  pedido_venda.dt_emissao, 
  pedido_venda.dt_solicitada_apos, 
  pedido_venda.dt_solicitada_limite, 
  pedido_venda.situacao, 
  pedido_venda.dt_validade, 
  pedido_venda.pedido_orcamento, 
  pedido_venda.aceita_ftparcial, 
  pedido_venda.dt_previsaofechamento, 
  pedido_venda.tipo_frete, 
  pedido_venda.val_frete, 
  pedido_venda.val_seguro, 
  pedido_venda.dt_aprovacao, 
  pedido_venda.quem_aprovou, 
  pedido_venda.valor_despesas, 
  pedido_venda.cod_endentrega, 
  cast(mensagem as character varying(1000)) as mensagem , 
  cast(mensagem_nf as character varying(1000)) as mensagem_nf, 
  pedido_venda.tipo_mensagemnf, 
  pedido_venda.inf_comissao, 
  pedido_venda.paga_comissao, 
  pedido_venda.liberado, 
  pedido_venda.perc_comissaofatura, 
  pedido_venda.dt_cancelou, 
  pedido_venda.perc_comissaorecebe, 
  pedido_venda.usuario_cancelou, 
  pedido_venda.cod_motcancelamento, 
  pedido_venda.motivo_cancelou, 
  pedido_venda.perc_descto, 
  pedido_venda.impresso, 
  pedido_venda.tipo_descto, 
  pedido_venda.pros_nome, 
  pedido_venda.pros_contato, 
  pedido_venda.pros_telefone, 
  pedido_venda.pros_celular, 
  pedido_venda.pros_uf, 
  pedido_venda.pros_email, 
  pedido_venda.pros_obs, 
  pedido_venda.tipo_taxamoeda, 
  pedido_venda.valor_taxamoeda, 
  pedido_venda.referencia, 
  pedido_venda.arq_descproposta, 
  pedido_venda.arq_condgeral, 
  pedido_venda.valor_bcalc_repasseicms, 
  pedido_venda.valor_repasseicms, 
  pedido_venda.valor_bcalc_zonafranca, 
  pedido_venda.valor_zonafranca, 
  pedido_venda.valor_bcalc_iss, 
  pedido_venda.valor_iss, 
  pedido_venda.exp_situacao, 
  pedido_venda.exp_data, 
  pedido_venda.exp_hora, 
  pedido_venda.dt_inclusao, 
  pedido_venda.dt_alteracao, 
  pedido_venda.cliente_geramanga, 
  pedido_venda.imp_boleto, 
  pedido_venda.codigo_palm, 
  pedido_venda.sep_status, 
  pedido_venda.sep_usuario, 
  pedido_venda.sep_dtinicio, 
  pedido_venda.sep_hsinicio, 
  pedido_venda.cod_orcamento, 
  pedido_venda.obs_proposta, 
  pedido_venda.prazo_entrega, 
  pedido_venda.dt_proximocontato, 
  pedido_venda.anotacao_followup, 
  pedido_venda.dt_envio, 
  pedido_venda.dt_change, 
  pedido_venda.status_web, 
  pedido_venda.origem, 
  pedido_venda.dt_finalizadoweb, 
  pedido_venda.dt_baixadoweb, 
  pedido_venda.recalculo_web, 
  pedido_venda.perc_comissaopedido, 
  pedido_venda.auxiliar_string1, 
  pedido_venda.auxiliar_string2, 
  pedido_venda.cod_tipofrete, 
  pedido_venda.cod_taxasucesso, 
  pedido_venda.cod_ordemseparacao, 
  pedido_venda.nro_pedidovendaint, 
  pedido_venda.email_boleto, 
  pedido_venda.dt_concluiudigitacao, 
  pedido_venda.cod_ficha, 
  pedido_venda.valor_fretepeso, 
  pedido_venda.em_analise, 
  pedido_venda.cod_usuarioanalise, 
  pedido_venda.cod_cliforoptring, 
  pedido_venda.observacao_bloqueio, 
  pedido_venda.dt_solicitacao, 
  pedido_venda.cod_projeto, 
  pedido_venda.exportado_agtl, 
  pedido_venda.ind_presenca_comprador, 
  pedido_venda.consumidor_final, 
  pedido_venda.local_dest_operacao, 
  pedido_venda.origem_integracao, 
  pedido_venda.pros_regiao, 
  pedido_venda.pros_atividade, 
  pedido_venda.pros_grpcliente, 
  pedido_venda.pros_contribuinte, 
  pedido_venda.pros_pessoa, 
  pedido_venda.pros_produtorrural, 
  pedido_venda.pros_optantesn, 
  pedido_venda.pros_cliforgradeinfo, 
  pedido_venda.cod_formaspagto, 
  pedido_venda.vendedor_interno, 
  pedido_venda.integrado_terceiro, 
  pedido_venda.cod_barrasetiquetavolume, 
  pedido_venda.cod_intermediador, 
  pedido_venda.tipo_operacaointermediador, 
  pedido_venda.rom_bloqgeracaoparcialpv, 
  pedido_venda.prazoentrega_despacho, 
  pedido_venda.valor_fretenaodestacado, 
  pedido_venda.comissao_especial, 
  pedido_venda.cod_situacaopedidovenda, 
  pedido_venda.seq_kanban, 
  pedido_venda.dt_baseparcela, 
  pedido_venda.clifor_permitefaturaparcial, 
  pedido_venda.imp_etiquetapv, 
  pedido_venda.anymarket_dtatualizacao, 
  pedido_venda.anymarket_dtfaturado, 
  pedido_venda.anymarket_dtenviado, 
  pedido_venda.anymarket_dtconcluido, 
  pedido_venda.possui_comissaoespecial, 
  pedido_venda.perc_comissaoespecial, 
  pedido_venda.rocket_ticket, 
  pedido_venda.rocket_hash, 
  pedido_venda.rocket_status, 
  pedido_venda.rocket_datasinc, 
  pedido_venda.rocket_parecer_analista_compliance, 
  pedido_venda.rocket_parecer_analista_credito, 
  pedido_venda.rocket_parecer_analista_reanalise, 
  pedido_venda.rocket_parecer_final, 
  pedido_venda.status_geracao_romaneio, 
  pedido_venda.data_entrega_orc 
From pedido_venda
Left Join Clifor		 On	Clifor.cod_clifor = pedido_venda.cod_clifor
Left Join Clifor as Cl_2 On Cl_2.cod_clifor   = pedido_venda.redespacho
')

UNION ALL

SELECT 
	EMPRESA = 'MG_POLIMEROS'
,	*
FROM OPENQUERY([MBM_MG_POLIMEROS],'
Select 
  cod_pedidovenda, 
  pedido_venda.cod_clifor, 
  clifor.cgc_cpf,
  pedido_venda.cod_portador2, 
  pedido_venda.cod_tipopedvenda, 
  pedido_venda.cod_gerente, 
  pedido_venda.cod_portador, 
  pedido_venda.cod_orcamentista, 
  pedido_venda.cod_empresa, 
  pedido_venda.cod_prioridade, 
  pedido_venda.cod_tabelapreco, 
  pedido_venda.cod_repres, 
  pedido_venda.cod_transp, 
  pedido_venda.cod_condpagamento, 
  pedido_venda.cod_moeda, 
  pedido_venda.contato, 
  pedido_venda.cod_endcobranca, 
  pedido_venda.cod_usuario, 
  pedido_venda.cod_condpagamento2, 
  pedido_venda.redespacho, 
  Cl_2.cgc_cpf as redespacho_cnpj_cgc,
  pedido_venda.nro_pedcliente, 
  pedido_venda.dt_emissao, 
  pedido_venda.dt_solicitada_apos, 
  pedido_venda.dt_solicitada_limite, 
  pedido_venda.situacao, 
  pedido_venda.dt_validade, 
  pedido_venda.pedido_orcamento, 
  pedido_venda.aceita_ftparcial, 
  pedido_venda.dt_previsaofechamento, 
  pedido_venda.tipo_frete, 
  pedido_venda.val_frete, 
  pedido_venda.val_seguro, 
  pedido_venda.dt_aprovacao, 
  pedido_venda.quem_aprovou, 
  pedido_venda.valor_despesas, 
  pedido_venda.cod_endentrega, 
  cast(mensagem as character varying(1000))    as mensagem , 
  cast(mensagem_nf as character varying(1000)) as mensagem_nf, 
  pedido_venda.tipo_mensagemnf, 
  pedido_venda.inf_comissao, 
  pedido_venda.paga_comissao, 
  pedido_venda.liberado, 
  pedido_venda.perc_comissaofatura, 
  pedido_venda.dt_cancelou, 
  pedido_venda.perc_comissaorecebe, 
  pedido_venda.usuario_cancelou, 
  pedido_venda.cod_motcancelamento, 
  pedido_venda.motivo_cancelou, 
  pedido_venda.perc_descto, 
  pedido_venda.impresso, 
  pedido_venda.tipo_descto, 
  pedido_venda.pros_nome, 
  pedido_venda.pros_contato, 
  pedido_venda.pros_telefone, 
  pedido_venda.pros_celular, 
  pedido_venda.pros_uf, 
  pedido_venda.pros_email, 
  pedido_venda.pros_obs, 
  pedido_venda.tipo_taxamoeda, 
  pedido_venda.valor_taxamoeda, 
  pedido_venda.referencia, 
  pedido_venda.arq_descproposta, 
  pedido_venda.arq_condgeral, 
  pedido_venda.valor_bcalc_repasseicms, 
  pedido_venda.valor_repasseicms, 
  pedido_venda.valor_bcalc_zonafranca, 
  pedido_venda.valor_zonafranca, 
  pedido_venda.valor_bcalc_iss, 
  pedido_venda.valor_iss, 
  pedido_venda.exp_situacao, 
  pedido_venda.exp_data, 
  pedido_venda.exp_hora, 
  pedido_venda.dt_inclusao, 
  pedido_venda.dt_alteracao, 
  pedido_venda.cliente_geramanga, 
  pedido_venda.imp_boleto, 
  pedido_venda.codigo_palm, 
  pedido_venda.sep_status, 
  pedido_venda.sep_usuario, 
  pedido_venda.sep_dtinicio, 
  pedido_venda.sep_hsinicio, 
  pedido_venda.cod_orcamento, 
  pedido_venda.obs_proposta, 
  pedido_venda.prazo_entrega, 
  pedido_venda.dt_proximocontato, 
  pedido_venda.anotacao_followup, 
  pedido_venda.dt_envio, 
  pedido_venda.dt_change, 
  pedido_venda.status_web, 
  pedido_venda.origem, 
  pedido_venda.dt_finalizadoweb, 
  pedido_venda.dt_baixadoweb, 
  pedido_venda.recalculo_web, 
  pedido_venda.perc_comissaopedido, 
  pedido_venda.auxiliar_string1, 
  pedido_venda.auxiliar_string2, 
  pedido_venda.cod_tipofrete, 
  pedido_venda.cod_taxasucesso, 
  pedido_venda.cod_ordemseparacao, 
  pedido_venda.nro_pedidovendaint, 
  pedido_venda.email_boleto, 
  pedido_venda.dt_concluiudigitacao, 
  pedido_venda.cod_ficha, 
  pedido_venda.valor_fretepeso, 
  pedido_venda.em_analise, 
  pedido_venda.cod_usuarioanalise, 
  pedido_venda.cod_cliforoptring, 
  pedido_venda.observacao_bloqueio, 
  pedido_venda.dt_solicitacao, 
  pedido_venda.cod_projeto, 
  pedido_venda.exportado_agtl, 
  pedido_venda.ind_presenca_comprador, 
  pedido_venda.consumidor_final, 
  pedido_venda.local_dest_operacao, 
  pedido_venda.origem_integracao, 
  pedido_venda.pros_regiao, 
  pedido_venda.pros_atividade, 
  pedido_venda.pros_grpcliente, 
  pedido_venda.pros_contribuinte, 
  pedido_venda.pros_pessoa, 
  pedido_venda.pros_produtorrural, 
  pedido_venda.pros_optantesn, 
  pedido_venda.pros_cliforgradeinfo, 
  pedido_venda.cod_formaspagto, 
  pedido_venda.vendedor_interno, 
  pedido_venda.integrado_terceiro, 
  pedido_venda.cod_barrasetiquetavolume, 
  pedido_venda.cod_intermediador, 
  pedido_venda.tipo_operacaointermediador, 
  pedido_venda.rom_bloqgeracaoparcialpv, 
  pedido_venda.prazoentrega_despacho, 
  pedido_venda.valor_fretenaodestacado, 
  pedido_venda.comissao_especial, 
  pedido_venda.cod_situacaopedidovenda, 
  pedido_venda.seq_kanban, 
  pedido_venda.dt_baseparcela, 
  pedido_venda.clifor_permitefaturaparcial, 
  pedido_venda.imp_etiquetapv, 
  pedido_venda.anymarket_dtatualizacao, 
  pedido_venda.anymarket_dtfaturado, 
  pedido_venda.anymarket_dtenviado, 
  pedido_venda.anymarket_dtconcluido, 
  pedido_venda.possui_comissaoespecial, 
  pedido_venda.perc_comissaoespecial, 
  pedido_venda.rocket_ticket, 
  pedido_venda.rocket_hash, 
  pedido_venda.rocket_status, 
  pedido_venda.rocket_datasinc, 
  pedido_venda.rocket_parecer_analista_compliance, 
  pedido_venda.rocket_parecer_analista_credito, 
  pedido_venda.rocket_parecer_analista_reanalise, 
  pedido_venda.rocket_parecer_final, 
  pedido_venda.status_geracao_romaneio, 
  pedido_venda.data_entrega_orc 
From pedido_venda
Left Join Clifor		 On	Clifor.cod_clifor = pedido_venda.cod_clifor
Left Join Clifor as Cl_2 On Cl_2.cod_clifor   = pedido_venda.redespacho
')

UNION ALL

SELECT 
	EMPRESA = 'POLIREX'
,	*
FROM OPENQUERY([MBM_POLIREX],'
Select 
  cod_pedidovenda, 
  pedido_venda.cod_clifor, 
  clifor.cgc_cpf,
  pedido_venda.cod_portador2, 
  pedido_venda.cod_tipopedvenda, 
  pedido_venda.cod_gerente, 
  pedido_venda.cod_portador, 
  pedido_venda.cod_orcamentista, 
  pedido_venda.cod_empresa, 
  pedido_venda.cod_prioridade, 
  pedido_venda.cod_tabelapreco, 
  pedido_venda.cod_repres, 
  pedido_venda.cod_transp, 
  pedido_venda.cod_condpagamento, 
  pedido_venda.cod_moeda, 
  pedido_venda.contato, 
  pedido_venda.cod_endcobranca, 
  pedido_venda.cod_usuario, 
  pedido_venda.cod_condpagamento2, 
  pedido_venda.redespacho, 
  Cl_2.cgc_cpf as redespacho_cnpj_cgc,
  pedido_venda.nro_pedcliente, 
  pedido_venda.dt_emissao, 
  pedido_venda.dt_solicitada_apos, 
  pedido_venda.dt_solicitada_limite, 
  pedido_venda.situacao, 
  pedido_venda.dt_validade, 
  pedido_venda.pedido_orcamento, 
  pedido_venda.aceita_ftparcial, 
  pedido_venda.dt_previsaofechamento, 
  pedido_venda.tipo_frete, 
  pedido_venda.val_frete, 
  pedido_venda.val_seguro, 
  pedido_venda.dt_aprovacao, 
  pedido_venda.quem_aprovou, 
  pedido_venda.valor_despesas, 
  pedido_venda.cod_endentrega, 
  cast(mensagem as character varying(1000))    as mensagem , 
  cast(mensagem_nf as character varying(1000)) as mensagem_nf, 
  pedido_venda.tipo_mensagemnf, 
  pedido_venda.inf_comissao, 
  pedido_venda.paga_comissao, 
  pedido_venda.liberado, 
  pedido_venda.perc_comissaofatura, 
  pedido_venda.dt_cancelou, 
  pedido_venda.perc_comissaorecebe, 
  pedido_venda.usuario_cancelou, 
  pedido_venda.cod_motcancelamento, 
  pedido_venda.motivo_cancelou, 
  pedido_venda.perc_descto, 
  pedido_venda.impresso, 
  pedido_venda.tipo_descto, 
  pedido_venda.pros_nome, 
  pedido_venda.pros_contato, 
  pedido_venda.pros_telefone, 
  pedido_venda.pros_celular, 
  pedido_venda.pros_uf, 
  pedido_venda.pros_email, 
  pedido_venda.pros_obs, 
  pedido_venda.tipo_taxamoeda, 
  pedido_venda.valor_taxamoeda, 
  pedido_venda.referencia, 
  pedido_venda.arq_descproposta, 
  pedido_venda.arq_condgeral, 
  pedido_venda.valor_bcalc_repasseicms, 
  pedido_venda.valor_repasseicms, 
  pedido_venda.valor_bcalc_zonafranca, 
  pedido_venda.valor_zonafranca, 
  pedido_venda.valor_bcalc_iss, 
  pedido_venda.valor_iss, 
  pedido_venda.exp_situacao, 
  pedido_venda.exp_data, 
  pedido_venda.exp_hora, 
  pedido_venda.dt_inclusao, 
  pedido_venda.dt_alteracao, 
  pedido_venda.cliente_geramanga, 
  pedido_venda.imp_boleto, 
  pedido_venda.codigo_palm, 
  pedido_venda.sep_status, 
  pedido_venda.sep_usuario, 
  pedido_venda.sep_dtinicio, 
  pedido_venda.sep_hsinicio, 
  pedido_venda.cod_orcamento, 
  pedido_venda.obs_proposta, 
  pedido_venda.prazo_entrega, 
  pedido_venda.dt_proximocontato, 
  pedido_venda.anotacao_followup, 
  pedido_venda.dt_envio, 
  pedido_venda.dt_change, 
  pedido_venda.status_web, 
  pedido_venda.origem, 
  pedido_venda.dt_finalizadoweb, 
  pedido_venda.dt_baixadoweb, 
  pedido_venda.recalculo_web, 
  pedido_venda.perc_comissaopedido, 
  pedido_venda.auxiliar_string1, 
  pedido_venda.auxiliar_string2, 
  pedido_venda.cod_tipofrete, 
  pedido_venda.cod_taxasucesso, 
  pedido_venda.cod_ordemseparacao, 
  pedido_venda.nro_pedidovendaint, 
  pedido_venda.email_boleto, 
  pedido_venda.dt_concluiudigitacao, 
  pedido_venda.cod_ficha, 
  pedido_venda.valor_fretepeso, 
  pedido_venda.em_analise, 
  pedido_venda.cod_usuarioanalise, 
  pedido_venda.cod_cliforoptring, 
  pedido_venda.observacao_bloqueio, 
  pedido_venda.dt_solicitacao, 
  pedido_venda.cod_projeto, 
  pedido_venda.exportado_agtl, 
  pedido_venda.ind_presenca_comprador, 
  pedido_venda.consumidor_final, 
  pedido_venda.local_dest_operacao, 
  pedido_venda.origem_integracao, 
  pedido_venda.pros_regiao, 
  pedido_venda.pros_atividade, 
  pedido_venda.pros_grpcliente, 
  pedido_venda.pros_contribuinte, 
  pedido_venda.pros_pessoa, 
  pedido_venda.pros_produtorrural, 
  pedido_venda.pros_optantesn, 
  pedido_venda.pros_cliforgradeinfo, 
  pedido_venda.cod_formaspagto, 
  pedido_venda.vendedor_interno, 
  pedido_venda.integrado_terceiro, 
  pedido_venda.cod_barrasetiquetavolume, 
  pedido_venda.cod_intermediador, 
  pedido_venda.tipo_operacaointermediador, 
  pedido_venda.rom_bloqgeracaoparcialpv, 
  pedido_venda.prazoentrega_despacho, 
  pedido_venda.valor_fretenaodestacado, 
  pedido_venda.comissao_especial, 
  pedido_venda.cod_situacaopedidovenda, 
  pedido_venda.seq_kanban, 
  pedido_venda.dt_baseparcela, 
  pedido_venda.clifor_permitefaturaparcial, 
  pedido_venda.imp_etiquetapv, 
  pedido_venda.anymarket_dtatualizacao, 
  pedido_venda.anymarket_dtfaturado, 
  pedido_venda.anymarket_dtenviado, 
  pedido_venda.anymarket_dtconcluido, 
  pedido_venda.possui_comissaoespecial, 
  pedido_venda.perc_comissaoespecial, 
  pedido_venda.rocket_ticket, 
  pedido_venda.rocket_hash, 
  pedido_venda.rocket_status, 
  pedido_venda.rocket_datasinc, 
  pedido_venda.rocket_parecer_analista_compliance, 
  pedido_venda.rocket_parecer_analista_credito, 
  pedido_venda.rocket_parecer_analista_reanalise, 
  pedido_venda.rocket_parecer_final, 
  pedido_venda.status_geracao_romaneio, 
  pedido_venda.data_entrega_orc 
From pedido_venda
Left Join Clifor		 On	Clifor.cod_clifor = pedido_venda.cod_clifor
Left Join Clifor as Cl_2 On Cl_2.cod_clifor   = pedido_venda.redespacho
')


Drop Table If Exists #Aux_LocalDestino
SELECT *INTO #Aux_LocalDestinoFROM TABELA_PADRAOWHERE COD_TABELAPADRAO = 'LOCAL_DESTINO_OPERACAO'

Drop Table If Exists #Aux_OpIntermediador
select *into #Aux_OpIntermediadorfrom Tabela_Padraowhere cod_tabelapadrao = 'OPERACAO_INTERMEDIADOR'

drop table if exists #Aux_PreComprador
select *into #Aux_PreCompradorfrom Tabela_Padraowhere cod_tabelapadrao = 'PRESENCA_COMPRADOR'

Drop Table If Exists #AuxFormPag
select *into #AuxFormPagfrom Tabela_Padraowhere cod_tabelapadrao = 'FORMA_DE_PAGAMENTO'


Drop Table If Exists #Pedido_Venda_S_Ex
Select *
,	StatusDoc = Case
					 When Situacao = 'A' Then 'EM ABERTO'
					 When Situacao = 'C' Then 'CANCELADO'
					 When Situacao = 'T' Then 'FATURADO TOTAL'
					 Else Situacao
				End

Into #Pedido_Venda_S_Ex
From #PEDIDO_VENDA_MBM
Where CGC_CPF != '00.000.000/0000-00'

Alter Table Vendas_Pedidos Add  Pk varchar(20)


Insert Into [dbo].[Vendas_Pedidos]
           ([nro_pedido]
           ,[id_empresa]
           ,[id_empresa_grupo]
           ,[id_cliente]
           ,[id_tipo_pedido]
           ,[id_condicao_pagamento]
           ,[id_transportadora]
           ,[id_representante]
           ,[id_moeda]
           ,[id_clifor_contato]
           ,[id_redespacho]
           ,[id_tipofrete]
           ,[id_aprovador]
           ,[StatusId]
           ,[cod_portador]
           ,[pedido_cliente]
           ,[dt_emissao]
           ,[dt_faturamento]
           ,[dt_entrega]
           ,[pedido_orcamento]
           ,[dt_aprovacao]
           ,[quem_aprovou]
           ,[mensagem]
           ,[mensagem_nf]
           ,[impresso]
           ,[cod_cliforoptring]
           ,[ind_presenca_comprador]
           ,[consumidor_final]
           ,[cod_formaspagto]
           ,[tipo_operacaointermediador]
           ,[dt_baseparcela]
           ,[obs]
           ,[qtd_volumes_nf]
           ,[id_tabela_padrao_local_destino_operacao]
           ,[id_tabela_padrao_tipo_op_intermediador]
           ,[id_tabela_padrao_presenca_comprador]
           ,[id_tabela_padrao_forma_pagamento]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device]
		   ,[Pk])
Select										
	[nro_pedido]							 
,	[id_empresa]							 
,	[id_empresa_grupo]						 
,	[id_cliente]							 
,	[id_tipo_pedido]						 
,	[id_condicao_pagamento]					 
,	[id_transportadora]						 
,	[id_representante]						 
,	[id_moeda]								 
,	[id_clifor_contato]						 
,	[id_redespacho]							 
,	[id_tipofrete]							 
,	[id_aprovador]							 
,	[StatusId]								 
,	[cod_portador]							 
,	[pedido_cliente]						 
,	[dt_emissao]							 
,	[dt_faturamento]						 
,	[dt_entrega]							 
,	[pedido_orcamento]						 
,	[dt_aprovacao]							 
,	[quem_aprovou]							 
,	[mensagem]								 
,	[mensagem_nf]							 
,	[impresso]								 
,	[cod_cliforoptring]						 
,	[ind_presenca_comprador]				 
,	[consumidor_final]						 
,	[cod_formaspagto]						 
,	[tipo_operacaointermediador]			 
,	[dt_baseparcela]						 
,	[obs]									 
,	[qtd_volumes_nf]						 
,	[id_tabela_padrao_local_destino_operacao]
,	[id_tabela_padrao_tipo_op_intermediador] 
,	[id_tabela_padrao_presenca_comprador]	 
,	[id_tabela_padrao_forma_pagamento]		 
,	[incl_data]								 
,	[incl_user]								 
,	[incl_device]							 
,	[modi_data]								 
,	[modi_user]								 
,	[modi_device]							 
,	[excl_data]								 
,	[excl_user]								 
,	[excl_device]							 
,	Pk										 
From (
Select											
	[nro_pedido]							  =  Null	--> Gerado no TheSys	
,	[id_empresa]							  =  Empresas.Id_Empresa
,	[id_empresa_grupo]						  =  Null
,	[id_cliente]							  =  Clifor.cod_clifor
,	[id_tipo_pedido]						  =  Vendas_Tipos_Pedido.id_vendas_tipos_pedido
,	[id_condicao_pagamento]					  =  Pagamentos_Condicoes.id_pagamento_condicao
,	[id_transportadora]						  =  Clifor.cod_clifor
,	[id_representante]						  =  Clifor.id_reprvend 
,	[id_moeda]								  =  Moedas.id_moeda
,	[id_clifor_contato]						  =  CliFor_Contatos.id_clifor_contatos
,	[id_redespacho]							  =  Cl_2.cod_clifor
,	[id_tipofrete]							  =  tipos_frete.id_tipo_frete
,	[id_aprovador]							  =  Usuarios.codigo
,	[StatusId]								  =  Status_Docs.StatusID
,	[cod_portador]							  =  fato.cod_portador
,	[pedido_cliente]						  =  Fato.nro_pedcliente
,	[dt_emissao]							  =  Fato.dt_emissao
,	[dt_faturamento]						  =  Fato.Dt_PrevisaoFechamento
,	[dt_entrega]							  =  Fato.dt_solicitada_limite
,	[pedido_orcamento]						  =  Fato.pedido_orcamento
,	[dt_aprovacao]							  =  Fato.dt_aprovacao
,	[quem_aprovou]							  =  Fato.quem_aprovou
,	[mensagem]								  =  Fato.Mensagem
,	[mensagem_nf]							  =  Fato.Mensagem_Nf
,	[impresso]								  =  Fato.Impresso
,	[cod_cliforoptring]						  =  Fato.[cod_cliforoptring]			 
,	[ind_presenca_comprador]				  =  Fato.[ind_presenca_comprador]	 
,	[consumidor_final]						  =  Fato.[consumidor_final]			 
,	[cod_formaspagto]						  =  Fato.[cod_formaspagto]			 
,	[tipo_operacaointermediador]			  =  Fato.[tipo_operacaointermediador] 
,	[dt_baseparcela]						  =  Fato.[dt_baseparcela]			 
,	[obs]									  =  Null						 
,	[qtd_volumes_nf]						  =  Null			 
,	[id_tabela_padrao_local_destino_operacao] =  #Aux_LocalDestino.id_tabela_padrao
,	[id_tabela_padrao_tipo_op_intermediador]  =  #Aux_OpIntermediador.id_tabela_padrao
,	[id_tabela_padrao_presenca_comprador]	  =  #Aux_PreComprador.id_tabela_padrao
,	[id_tabela_padrao_forma_pagamento]		  =  #AuxFormPag.id_tabela_padrao
,	[incl_data]								  =  GetDate()
,	[incl_user]								  =  'ksantana'
,	[incl_device]							  =  Null
,	[modi_data]								  =  Null
,	[modi_user]								  =  Null
,	[modi_device]							  =  Null
,	[excl_data]								  =  Null
,	[excl_user]								  =  Null
,	[excl_device]							  =  Null
,	Pk										  =  Trim(Cod_Empresa) + Trim(Cod_PedidoVenda)
,	Rw										  =  Row_Number() Over ( Partition by Trim(Cod_Empresa) + Trim(Cod_PedidoVenda) Order By Trim(Cod_Empresa) + Trim(Cod_PedidoVenda) Desc)
From #PedidO_VendA_S_Ex Fato /* 40.142 */	  
Left Join Empresas			   On  Empresas.Codigo_Antigo							  = Fato.Cod_Empresa							 Collate latin1_general_ci_ai 
Left Join Clifor			   On  Dbo.Fn_Limpa_NoNum(Isnull(clifor.cnpj,Clifor.cpf)) = Dbo.Fn_Limpa_NoNum(Fato.cgc_cpf)			 Collate latin1_general_ci_ai 
Left Join Vendas_Tipos_Pedido  On  Vendas_Tipos_Pedido.cod_tipovenda				  = Fato.cod_tipopedvenda						 Collate latin1_general_ci_ai 
Left Join Pagamentos_Condicoes On  Pagamentos_Condicoes.cod_condpagamento			  = Fato.cod_condpagamento						 Collate latin1_general_ci_ai 
Left Join Moedas			   On  Moedas.cod_moeda								      = Fato.cod_moeda								 Collate latin1_general_ci_ai 
Left Join CliFor_Contatos	   On  CliFor_Contatos.cod_antigo					      = Fato.cod_clifor								 Collate latin1_general_ci_ai 
							   And CliFor_Contatos.id_empresa_grupo					  = Empresas.Id_Empresa_Grupo 					 
							   And Empresas.Codigo_Antigo							  = Fato.Cod_Empresa							 Collate latin1_general_ci_ai 
Left Join Clifor aS Cl_2	   On  Dbo.Fn_Limpa_NoNum(Isnull(Cl_2.cnpj,Cl_2.cpf))     = Dbo.Fn_Limpa_NoNum(Fato.redespacho_cnpj_cgc) Collate latin1_general_ci_ai
Left Join tipos_frete		   On  tipos_frete.cod_frete							  = Fato.Cod_TipoFrete							 Collate latin1_general_ci_ai
Left Join Usuarios			   On  Usuarios.Login									  = Fato.cod_usuario							 Collate latin1_general_ci_ai
Left Join Status_Docs		   On  Status_Docs.StatusDescricao						  = Fato.StatusDoc								 Collate latin1_general_ci_ai
							   And Status_Docs.StatusGrupo = 'Vendas_Pedidos'
Left Join #Aux_LocalDestino    On  #Aux_LocalDestino.codigo							  = Fato.Local_Dest_Operacao					 Collate latin1_general_ci_ai
Left Join #Aux_OpIntermediador On  Left(#Aux_OpIntermediador.codigo,1)				  = Fato.Tipo_OperacaoIntermediador				 Collate latin1_general_ci_ai
Left Join #Aux_PreComprador	   On  #Aux_PreComprador.codigo							  = Fato.ind_presenca_comprador					 Collate latin1_general_ci_ai
Left Join #AuxFormPag		   On  #AuxFormPag.codigo								  = Fato.cod_formaspagto						 Collate latin1_general_ci_ai
) SubQuery
Where SubQuery.Rw = 1