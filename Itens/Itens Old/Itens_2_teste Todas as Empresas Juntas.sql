
Use Thesys_Dev
Go

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* PROGRAMADOR: KAIKE NATAN									                                    */
/* VERSAO     : DATA: 07/05/2024																*/
/* DESCRICAO  : CONSOLIDA A BASE DE ITENS DO MBM E POPULAR O DIFERENCIAL NO THESYS ITENS		*/
/*																								*/
/*	ALTERACAO                                                                                   */
/*        2. PROGRAMADOR: 													 DATA: __/__/____	*/		
/*           DESCRICAO  : 																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Consolida Base De Itens Do MBM													*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #BASE_ITENS_MBM
SELECT 
	'POLIMEROS' AS EMPRESA
,	*
INTO #BASE_ITENS_MBM
FROM OPENQUERY([MBM_MG_POLIMEROS],'
select 
 fato.cod_item,
 fato.cod_clifor,
 fato.cod_servicorf,
 fato.cod_subgrupoestoque,
 dim_2.descricao as descricao_subgrupoestoque,
 fato.cod_moeda,
 fato.cod_grade,
 fato.cod_tributacao,
 fato.cod_grupoestoque,
 dim_3.descricao as descricao_grupoestoque,
 dim_3.item_venda as item_venda_grupoestoque,
 dim_3.item_producao as item_producao_grupoestoque,
 dim_3.item_compraprodutivo as item_compraprodutivo_grupoestoque,
 dim_3.item_compranaoprodutivo as item_compranaoprodutivo_grupoestoque,
 dim_3.codtp_tipoproduto as codtp_tipoproduto_grupoestoque,
 dim_3.codigo_dominio as codigo_dominio_grupoestoque,
 dim_3.descricao_dominio as descricao_dominio_grupoestoque,
 fato.cod_fmcomercial,
 dim_4.descricao as descricao_fmcomercial,
 fato.cod_unidade,
 dim_5.descricao as descricao_cod_unidade,
 dim_5.casas_dec as casas_dec_cod_unidade,
 fato.cod_fmindustrial,
 fato.cod_unidade2,
 fato.cod_unidadecompra,
 fato.cod_unidadevenda,
 fato.fornec_default,
 fato.codigo,
 fato.cod_tabelaprazo,
 fato.descricao,
 fato.preco_reposicao,
 fato.desc_nfiscal,
 fato.desc_cupom,
 fato.unidade_cupom,
 null as narrativa,
 fato.peso_bruto,
 fato.custo_reposicao,
 fato.peso_liquido,
 fato.preco_venda,
 fato.custo_medio,
 fato.dt_altprecovenda,
 fato.ativo,
 fato.preco_promocao,
 fato.custo_standard,
 fato.dt_inclusao,
 fato.qtd_seguranca,
 fato.dt_atualizacao,
 fato.controla_lote,
 fato.dt_ultimacontagem,
 fato.qtd_lotemincompra,
 fato.qtd_maxima,
 fato.controla_estoque,
 fato.qtd_loteminproducao,
 fato.comprado_fabricado,
 fato.item_debitodireto,
 fato.lt_multiplo_compra,
 fato.cod_classfiscal,
 dim_6.descricao as descricao_cod_classfiscal,
 dim_6.ipi as Ipi_ClassFiscal,
 dim_6.cod_mensagem as cod_mensagem_ClassFiscal,
 dim_6.descricao as descricao_ClassFiscal,
 dim_6.ativo as ativo_ClassFiscal,
 fato.lt_multiplo_producao,
 fato.tipo_produto,
 fato.controlado,
 fato.composto,
 fato.motivo_bloqueio,
 fato.aceita_desconto,
 fato.path_foto,
 fato.descto_maximo,
 fato.marg_lucroideal,
 fato.dt_iniciopromocao,
 fato.dt_terminopromocao,
 fato.promocao_atualizademanda,
 fato.dt_bloqueio,
 fato.prender_cqrecebimento,
 fato.prender_cqproducao,
 fato.tmp_preco_venda,
 fato.tmp_preco_promocao,
 fato.tmp_dt_iniciopromocao,
 fato.tmp_dt_terminopromocao,
 fato.tmp_aceita_desconto,
 fato.tmp_descto_maximo,
 fato.tmp_promocao_atualizademanda,
 fato.tmp_alterado,
 fato.tmp_codtabelaprazo,
 fato.altura,
 fato.largura,
 fato.dimensao,
 fato.comprimento,
 fato.volume_m3,
 fato.gramatura,
 fato.qtd_folhas,
 fato.formato,
 fato.concentracao,
 fato.aplicacao,
 fato.nro_ultimapeca,
 fato.perc_distribuicao,
 fato.perc_perdas,
 fato.perc_adm,
 fato.perc_vendas,
 fato.versao_operacao,
 fato.dt_ultcotacao,
 fato.preco_ultcotacao,
 fato.tipo_custo,
 fato.fornec_ultcotacao,
 fato.imprimir_narrativapc,
 fato.imprimir_narrativapv,
 fato.imprimir_narrativarom,
 fato.custo_calculado,
 fato.imprimir_narrativaop,
 fato.preco_vendasugerido,
 fato.tempo_obtencaoideal,
 fato.tipo_controlelote,
 fato.controla_validade,
 fato.prazo_validade,
 fato.tipo_controlepeca,
 fato.curva_abc,
 fato.saldo_negativo,
 fato.fator_quantidade2,
 fato.desenho,
 fato.rev_desenho,
 fato.dt_revdesenho,
 fato.dnf_fator_01,
 fato.dnf_fator_02,
 fato.dnf_fator_03,
 fato.dnf_codespecie,
 fato.dnf_codproduto1,
 fato.dnf_codproduto2,
 fato.dnf_un_padrao,
 fato.dnf_un_est1,
 fato.dnf_un_est2,
 fato.dnf_capacidade,
 fato.dnf_comb_solvente,
 fato.dnf_sefaz,
 fato.dnf_codgrupo,
 fato.gera_manga,
 fato.prazo_entrega,
 fato.auxiliar_string1,
 fato.auxiliar_string2,
 fato.imprimir_narrativanf,
 fato.sittributaria,
 fato.auxiliar_float1,
 fato.auxiliar_float2,
 fato.dt_change,
 fato.tipo_aliqipi,
 fato.valor_ipifixo,
 fato.tipo_tempoobtencaocom,
 fato.tipo_tempoobtencaopro,
 fato.tempo_obtencaoidealpro,
 fato.sanfona,
 fato.face,
 fato.narrativa_op,
 fato.modelo,
 fato.calcular_volumeauto,
 fato.codtp_anp,
 fato.codtp_sefaz,
 fato.codtp_servicolc,
 fato.codtp_genero,
 fato.garantia_adicional,
 fato.garantia,
 fato.qtd_segurancadias,
 fato.codtp_packing,
 fato.descricao_completa,
 fato.codtp_energiatelecom_cf,
 fato.descricao_web,
 fato.link_video,
 fato.qtd_embalagem,
 fato.diametro,
 fato.auxiliar_string3,
 fato.regime_pis_cofins,
 fato.fci_produto_importado,
 fato.fci_gera_fci,
 fato.pontos,
 fato.dt_atualizacao_integracao,
 fato.dt_envio_integracao,
 fato.majorar_perc_cofins_imp,
 fato.origem_integracao,
 fato.cod_item_emmegi,
 fato.sourcecode,
 fato.cod_nbs,
 fato.gerar_umloteporunidade,
 fato.cod_cest,
 fato.cod_itemgradeinfo,
 fato.origem_mercadoria,
 fato.lt_multiplo_venda,
 fato.qtd_loteminvenda,
 fato.considerar_componenteopc,
 fato.tipo_estimativacarga,
 fato.valor_estimativacarga,
 fato.controla_fabricacao,
 fato.id_confirm8,
 fato.spa_contem,
 fato.cod_tabelaprecodefault,
 fato.qtd_lotemintransf,
 fato.lt_multiplo_transf,
 fato.cod_sisterceiro,
 fato.preco_medio,
 fato.farmaceutico,
 fato.anvisa_registro,
 fato.anvisa_isento,
 fato.anvisa_motivoisencao,
 fato.status,
 fato.cod_interno,
 fato.cod_tabelapadraoreg
from item fato
join grupo_estoque			dim   on dim.cod_grupoestoque      = fato.cod_grupoestoque
left join subgrupo_estoque  dim_2 on dim_2.cod_subgrupoestoque = fato.cod_subgrupoestoque
left join grupo_estoque     dim_3 on dim_3.cod_grupoestoque    = fato.cod_grupoestoque
left join familia_comercial dim_4 on dim_4.cod_fmcomercial     = fato.cod_fmcomercial
left join unidade 			dim_5 on dim_5.cod_unidade         = fato.cod_unidade
left join class_fiscal 	    dim_6 on dim_6.cod_classfiscal     = fato.cod_classfiscal

/*where dim.codtp_tipoproduto in (''0'',''1'',''2'',''3'',''4'',''5'',''6'')*/

where exists(
			 select cod_item 
			 from item_notafiscal n
			 where n.cod_item = fato.cod_item
			)
')

UNION ALL

SELECT 
	'NORTEBAG' AS EMPRESA
,	*
FROM OPENQUERY([MBM_NORTEBAG],'
select 
 fato.cod_item,
 fato.cod_clifor,
 fato.cod_servicorf,
 fato.cod_subgrupoestoque,
 dim_2.descricao as descricao_subgrupoestoque,
 fato.cod_moeda,
 fato.cod_grade,
 fato.cod_tributacao,
 fato.cod_grupoestoque,
 dim_3.descricao as descricao_grupoestoque,
 dim_3.item_venda as item_venda_grupoestoque,
 dim_3.item_producao as item_producao_grupoestoque,
 dim_3.item_compraprodutivo as item_compraprodutivo_grupoestoque,
 dim_3.item_compranaoprodutivo as item_compranaoprodutivo_grupoestoque,
 dim_3.codtp_tipoproduto as codtp_tipoproduto_grupoestoque,
 dim_3.codigo_dominio as codigo_dominio_grupoestoque,
 dim_3.descricao_dominio as descricao_dominio_grupoestoque,
 fato.cod_fmcomercial,
 dim_4.descricao as descricao_fmcomercial,
 fato.cod_unidade,
 dim_5.descricao as descricao_cod_unidade,
 dim_5.casas_dec as casas_dec_cod_unidade,
 fato.cod_fmindustrial,
 fato.cod_unidade2,
 fato.cod_unidadecompra,
 fato.cod_unidadevenda,
 fato.fornec_default,
 fato.codigo,
 fato.cod_tabelaprazo,
 fato.descricao,
 fato.preco_reposicao,
 fato.desc_nfiscal,
 fato.desc_cupom,
 fato.unidade_cupom,
 null as narrativa,
 fato.peso_bruto,
 fato.custo_reposicao,
 fato.peso_liquido,
 fato.preco_venda,
 fato.custo_medio,
 fato.dt_altprecovenda,
 fato.ativo,
 fato.preco_promocao,
 fato.custo_standard,
 fato.dt_inclusao,
 fato.qtd_seguranca,
 fato.dt_atualizacao,
 fato.controla_lote,
 fato.dt_ultimacontagem,
 fato.qtd_lotemincompra,
 fato.qtd_maxima,
 fato.controla_estoque,
 fato.qtd_loteminproducao,
 fato.comprado_fabricado,
 fato.item_debitodireto,
 fato.lt_multiplo_compra,
 fato.cod_classfiscal,
 dim_6.descricao as descricao_cod_classfiscal,
 dim_6.ipi as Ipi_ClassFiscal,
 dim_6.cod_mensagem as cod_mensagem_ClassFiscal,
 dim_6.descricao as descricao_ClassFiscal,
 dim_6.ativo as ativo_ClassFiscal,
 fato.lt_multiplo_producao,
 fato.tipo_produto,
 fato.controlado,
 fato.composto,
 fato.motivo_bloqueio,
 fato.aceita_desconto,
 fato.path_foto,
 fato.descto_maximo,
 fato.marg_lucroideal,
 fato.dt_iniciopromocao,
 fato.dt_terminopromocao,
 fato.promocao_atualizademanda,
 fato.dt_bloqueio,
 fato.prender_cqrecebimento,
 fato.prender_cqproducao,
 fato.tmp_preco_venda,
 fato.tmp_preco_promocao,
 fato.tmp_dt_iniciopromocao,
 fato.tmp_dt_terminopromocao,
 fato.tmp_aceita_desconto,
 fato.tmp_descto_maximo,
 fato.tmp_promocao_atualizademanda,
 fato.tmp_alterado,
 fato.tmp_codtabelaprazo,
 fato.altura,
 fato.largura,
 fato.dimensao,
 fato.comprimento,
 fato.volume_m3,
 fato.gramatura,
 fato.qtd_folhas,
 fato.formato,
 fato.concentracao,
 fato.aplicacao,
 fato.nro_ultimapeca,
 fato.perc_distribuicao,
 fato.perc_perdas,
 fato.perc_adm,
 fato.perc_vendas,
 fato.versao_operacao,
 fato.dt_ultcotacao,
 fato.preco_ultcotacao,
 fato.tipo_custo,
 fato.fornec_ultcotacao,
 fato.imprimir_narrativapc,
 fato.imprimir_narrativapv,
 fato.imprimir_narrativarom,
 fato.custo_calculado,
 fato.imprimir_narrativaop,
 fato.preco_vendasugerido,
 fato.tempo_obtencaoideal,
 fato.tipo_controlelote,
 fato.controla_validade,
 fato.prazo_validade,
 fato.tipo_controlepeca,
 fato.curva_abc,
 fato.saldo_negativo,
 fato.fator_quantidade2,
 fato.desenho,
 fato.rev_desenho,
 fato.dt_revdesenho,
 fato.dnf_fator_01,
 fato.dnf_fator_02,
 fato.dnf_fator_03,
 fato.dnf_codespecie,
 fato.dnf_codproduto1,
 fato.dnf_codproduto2,
 fato.dnf_un_padrao,
 fato.dnf_un_est1,
 fato.dnf_un_est2,
 fato.dnf_capacidade,
 fato.dnf_comb_solvente,
 fato.dnf_sefaz,
 fato.dnf_codgrupo,
 fato.gera_manga,
 fato.prazo_entrega,
 fato.auxiliar_string1,
 fato.auxiliar_string2,
 fato.imprimir_narrativanf,
 fato.sittributaria,
 fato.auxiliar_float1,
 fato.auxiliar_float2,
 fato.dt_change,
 fato.tipo_aliqipi,
 fato.valor_ipifixo,
 fato.tipo_tempoobtencaocom,
 fato.tipo_tempoobtencaopro,
 fato.tempo_obtencaoidealpro,
 fato.sanfona,
 fato.face,
 fato.narrativa_op,
 fato.modelo,
 fato.calcular_volumeauto,
 fato.codtp_anp,
 fato.codtp_sefaz,
 fato.codtp_servicolc,
 fato.codtp_genero,
 fato.garantia_adicional,
 fato.garantia,
 fato.qtd_segurancadias,
 fato.codtp_packing,
 fato.descricao_completa,
 fato.codtp_energiatelecom_cf,
 fato.descricao_web,
 fato.link_video,
 fato.qtd_embalagem,
 fato.diametro,
 fato.auxiliar_string3,
 fato.regime_pis_cofins,
 fato.fci_produto_importado,
 fato.fci_gera_fci,
 fato.pontos,
 fato.dt_atualizacao_integracao,
 fato.dt_envio_integracao,
 fato.majorar_perc_cofins_imp,
 fato.origem_integracao,
 fato.cod_item_emmegi,
 fato.sourcecode,
 fato.cod_nbs,
 fato.gerar_umloteporunidade,
 fato.cod_cest,
 fato.cod_itemgradeinfo,
 fato.origem_mercadoria,
 fato.lt_multiplo_venda,
 fato.qtd_loteminvenda,
 fato.considerar_componenteopc,
 fato.tipo_estimativacarga,
 fato.valor_estimativacarga,
 fato.controla_fabricacao,
 fato.id_confirm8,
 fato.spa_contem,
 fato.cod_tabelaprecodefault,
 fato.qtd_lotemintransf,
 fato.lt_multiplo_transf,
 fato.cod_sisterceiro,
 fato.preco_medio,
 fato.farmaceutico,
 fato.anvisa_registro,
 fato.anvisa_isento,
 fato.anvisa_motivoisencao,
 fato.status,
 fato.cod_interno,
 fato.cod_tabelapadraoreg
from item fato
join grupo_estoque			dim   on dim.cod_grupoestoque      = fato.cod_grupoestoque
left join subgrupo_estoque  dim_2 on dim_2.cod_subgrupoestoque = fato.cod_subgrupoestoque
left join grupo_estoque     dim_3 on dim_3.cod_grupoestoque    = fato.cod_grupoestoque
left join familia_comercial dim_4 on dim_4.cod_fmcomercial     = fato.cod_fmcomercial
left join unidade 			dim_5 on dim_5.cod_unidade         = fato.cod_unidade
left join class_fiscal 	    dim_6 on dim_6.cod_classfiscal     = fato.cod_classfiscal

/*where dim.codtp_tipoproduto in (''0'',''1'',''2'',''3'',''4'',''5'',''6'')*/

where exists(
			 select cod_item 
			 from item_notafiscal n
			 where n.cod_item = fato.cod_item
			)
')

UNION ALL

SELECT 
	'POLIRESINAS' AS EMPRESA
,	*
FROM OPENQUERY([MBM_POLIRESINAS],'
select 
 fato.cod_item,
 fato.cod_clifor,
 fato.cod_servicorf,
 fato.cod_subgrupoestoque,
 dim_2.descricao as descricao_subgrupoestoque,
 fato.cod_moeda,
 fato.cod_grade,
 fato.cod_tributacao,
 fato.cod_grupoestoque,
 dim_3.descricao as descricao_grupoestoque,
 dim_3.item_venda as item_venda_grupoestoque,
 dim_3.item_producao as item_producao_grupoestoque,
 dim_3.item_compraprodutivo as item_compraprodutivo_grupoestoque,
 dim_3.item_compranaoprodutivo as item_compranaoprodutivo_grupoestoque,
 dim_3.codtp_tipoproduto as codtp_tipoproduto_grupoestoque,
 dim_3.codigo_dominio as codigo_dominio_grupoestoque,
 dim_3.descricao_dominio as descricao_dominio_grupoestoque,
 fato.cod_fmcomercial,
 dim_4.descricao as descricao_fmcomercial,
 fato.cod_unidade,
 dim_5.descricao as descricao_cod_unidade,
 dim_5.casas_dec as casas_dec_cod_unidade,
 fato.cod_fmindustrial,
 fato.cod_unidade2,
 fato.cod_unidadecompra,
 fato.cod_unidadevenda,
 fato.fornec_default,
 fato.codigo,
 fato.cod_tabelaprazo,
 fato.descricao,
 fato.preco_reposicao,
 fato.desc_nfiscal,
 fato.desc_cupom,
 fato.unidade_cupom,
 null as narrativa,
 fato.peso_bruto,
 fato.custo_reposicao,
 fato.peso_liquido,
 fato.preco_venda,
 fato.custo_medio,
 fato.dt_altprecovenda,
 fato.ativo,
 fato.preco_promocao,
 fato.custo_standard,
 fato.dt_inclusao,
 fato.qtd_seguranca,
 fato.dt_atualizacao,
 fato.controla_lote,
 fato.dt_ultimacontagem,
 fato.qtd_lotemincompra,
 fato.qtd_maxima,
 fato.controla_estoque,
 fato.qtd_loteminproducao,
 fato.comprado_fabricado,
 fato.item_debitodireto,
 fato.lt_multiplo_compra,
 fato.cod_classfiscal,
 dim_6.descricao as descricao_cod_classfiscal,
 dim_6.ipi as Ipi_ClassFiscal,
 dim_6.cod_mensagem as cod_mensagem_ClassFiscal,
 dim_6.descricao as descricao_ClassFiscal,
 dim_6.ativo as ativo_ClassFiscal,
 fato.lt_multiplo_producao,
 fato.tipo_produto,
 fato.controlado,
 fato.composto,
 fato.motivo_bloqueio,
 fato.aceita_desconto,
 fato.path_foto,
 fato.descto_maximo,
 fato.marg_lucroideal,
 fato.dt_iniciopromocao,
 fato.dt_terminopromocao,
 fato.promocao_atualizademanda,
 fato.dt_bloqueio,
 fato.prender_cqrecebimento,
 fato.prender_cqproducao,
 fato.tmp_preco_venda,
 fato.tmp_preco_promocao,
 fato.tmp_dt_iniciopromocao,
 fato.tmp_dt_terminopromocao,
 fato.tmp_aceita_desconto,
 fato.tmp_descto_maximo,
 fato.tmp_promocao_atualizademanda,
 fato.tmp_alterado,
 fato.tmp_codtabelaprazo,
 fato.altura,
 fato.largura,
 fato.dimensao,
 fato.comprimento,
 fato.volume_m3,
 fato.gramatura,
 fato.qtd_folhas,
 fato.formato,
 fato.concentracao,
 fato.aplicacao,
 fato.nro_ultimapeca,
 fato.perc_distribuicao,
 fato.perc_perdas,
 fato.perc_adm,
 fato.perc_vendas,
 fato.versao_operacao,
 fato.dt_ultcotacao,
 fato.preco_ultcotacao,
 fato.tipo_custo,
 fato.fornec_ultcotacao,
 fato.imprimir_narrativapc,
 fato.imprimir_narrativapv,
 fato.imprimir_narrativarom,
 fato.custo_calculado,
 fato.imprimir_narrativaop,
 fato.preco_vendasugerido,
 fato.tempo_obtencaoideal,
 fato.tipo_controlelote,
 fato.controla_validade,
 fato.prazo_validade,
 fato.tipo_controlepeca,
 fato.curva_abc,
 fato.saldo_negativo,
 fato.fator_quantidade2,
 fato.desenho,
 fato.rev_desenho,
 fato.dt_revdesenho,
 fato.dnf_fator_01,
 fato.dnf_fator_02,
 fato.dnf_fator_03,
 fato.dnf_codespecie,
 fato.dnf_codproduto1,
 fato.dnf_codproduto2,
 fato.dnf_un_padrao,
 fato.dnf_un_est1,
 fato.dnf_un_est2,
 fato.dnf_capacidade,
 fato.dnf_comb_solvente,
 fato.dnf_sefaz,
 fato.dnf_codgrupo,
 fato.gera_manga,
 fato.prazo_entrega,
 fato.auxiliar_string1,
 fato.auxiliar_string2,
 fato.imprimir_narrativanf,
 fato.sittributaria,
 fato.auxiliar_float1,
 fato.auxiliar_float2,
 fato.dt_change,
 fato.tipo_aliqipi,
 fato.valor_ipifixo,
 fato.tipo_tempoobtencaocom,
 fato.tipo_tempoobtencaopro,
 fato.tempo_obtencaoidealpro,
 fato.sanfona,
 fato.face,
 fato.narrativa_op,
 fato.modelo,
 fato.calcular_volumeauto,
 fato.codtp_anp,
 fato.codtp_sefaz,
 fato.codtp_servicolc,
 fato.codtp_genero,
 fato.garantia_adicional,
 fato.garantia,
 fato.qtd_segurancadias,
 fato.codtp_packing,
 fato.descricao_completa,
 fato.codtp_energiatelecom_cf,
 fato.descricao_web,
 fato.link_video,
 fato.qtd_embalagem,
 fato.diametro,
 fato.auxiliar_string3,
 fato.regime_pis_cofins,
 fato.fci_produto_importado,
 fato.fci_gera_fci,
 fato.pontos,
 fato.dt_atualizacao_integracao,
 fato.dt_envio_integracao,
 fato.majorar_perc_cofins_imp,
 fato.origem_integracao,
 fato.cod_item_emmegi,
 fato.sourcecode,
 fato.cod_nbs,
 fato.gerar_umloteporunidade,
 fato.cod_cest,
 fato.cod_itemgradeinfo,
 fato.origem_mercadoria,
 fato.lt_multiplo_venda,
 fato.qtd_loteminvenda,
 fato.considerar_componenteopc,
 fato.tipo_estimativacarga,
 fato.valor_estimativacarga,
 fato.controla_fabricacao,
 fato.id_confirm8,
 fato.spa_contem,
 fato.cod_tabelaprecodefault,
 fato.qtd_lotemintransf,
 fato.lt_multiplo_transf,
 fato.cod_sisterceiro,
 fato.preco_medio,
 fato.farmaceutico,
 fato.anvisa_registro,
 fato.anvisa_isento,
 fato.anvisa_motivoisencao,
 fato.status,
 fato.cod_interno,
 fato.cod_tabelapadraoreg
from item fato
join grupo_estoque			dim   on dim.cod_grupoestoque      = fato.cod_grupoestoque
left join subgrupo_estoque  dim_2 on dim_2.cod_subgrupoestoque = fato.cod_subgrupoestoque
left join grupo_estoque     dim_3 on dim_3.cod_grupoestoque    = fato.cod_grupoestoque
left join familia_comercial dim_4 on dim_4.cod_fmcomercial     = fato.cod_fmcomercial
left join unidade 			dim_5 on dim_5.cod_unidade         = fato.cod_unidade
left join class_fiscal 	    dim_6 on dim_6.cod_classfiscal     = fato.cod_classfiscal

/*where dim.codtp_tipoproduto in (''0'',''1'',''2'',''3'',''4'',''5'',''6'')*/

where exists(
			 select cod_item 
			 from item_notafiscal n
			 where n.cod_item = fato.cod_item
			)
')

UNION ALL

SELECT 
	'POLIREX' AS EMPRESA
,	*
FROM OPENQUERY([MBM_POLIREX],'
select 
 fato.cod_item,
 fato.cod_clifor,
 fato.cod_servicorf,
 fato.cod_subgrupoestoque,
 dim_2.descricao as descricao_subgrupoestoque,
 fato.cod_moeda,
 fato.cod_grade,
 fato.cod_tributacao,
 fato.cod_grupoestoque,
 dim_3.descricao as descricao_grupoestoque,
 dim_3.item_venda as item_venda_grupoestoque,
 dim_3.item_producao as item_producao_grupoestoque,
 dim_3.item_compraprodutivo as item_compraprodutivo_grupoestoque,
 dim_3.item_compranaoprodutivo as item_compranaoprodutivo_grupoestoque,
 dim_3.codtp_tipoproduto as codtp_tipoproduto_grupoestoque,
 dim_3.codigo_dominio as codigo_dominio_grupoestoque,
 dim_3.descricao_dominio as descricao_dominio_grupoestoque,
 fato.cod_fmcomercial,
 dim_4.descricao as descricao_fmcomercial,
 fato.cod_unidade,
 dim_5.descricao as descricao_cod_unidade,
 dim_5.casas_dec as casas_dec_cod_unidade,
 fato.cod_fmindustrial,
 fato.cod_unidade2,
 fato.cod_unidadecompra,
 fato.cod_unidadevenda,
 fato.fornec_default,
 fato.codigo,
 fato.cod_tabelaprazo,
 fato.descricao,
 fato.preco_reposicao,
 fato.desc_nfiscal,
 fato.desc_cupom,
 fato.unidade_cupom,
 null as narrativa,
 fato.peso_bruto,
 fato.custo_reposicao,
 fato.peso_liquido,
 fato.preco_venda,
 fato.custo_medio,
 fato.dt_altprecovenda,
 fato.ativo,
 fato.preco_promocao,
 fato.custo_standard,
 fato.dt_inclusao,
 fato.qtd_seguranca,
 fato.dt_atualizacao,
 fato.controla_lote,
 fato.dt_ultimacontagem,
 fato.qtd_lotemincompra,
 fato.qtd_maxima,
 fato.controla_estoque,
 fato.qtd_loteminproducao,
 fato.comprado_fabricado,
 fato.item_debitodireto,
 fato.lt_multiplo_compra,
 fato.cod_classfiscal,
 dim_6.descricao as descricao_cod_classfiscal,
 dim_6.ipi as Ipi_ClassFiscal,
 dim_6.cod_mensagem as cod_mensagem_ClassFiscal,
 dim_6.descricao as descricao_ClassFiscal,
 dim_6.ativo as ativo_ClassFiscal,
 fato.lt_multiplo_producao,
 fato.tipo_produto,
 fato.controlado,
 fato.composto,
 fato.motivo_bloqueio,
 fato.aceita_desconto,
 fato.path_foto,
 fato.descto_maximo,
 fato.marg_lucroideal,
 fato.dt_iniciopromocao,
 fato.dt_terminopromocao,
 fato.promocao_atualizademanda,
 fato.dt_bloqueio,
 fato.prender_cqrecebimento,
 fato.prender_cqproducao,
 fato.tmp_preco_venda,
 fato.tmp_preco_promocao,
 fato.tmp_dt_iniciopromocao,
 fato.tmp_dt_terminopromocao,
 fato.tmp_aceita_desconto,
 fato.tmp_descto_maximo,
 fato.tmp_promocao_atualizademanda,
 fato.tmp_alterado,
 fato.tmp_codtabelaprazo,
 fato.altura,
 fato.largura,
 fato.dimensao,
 fato.comprimento,
 fato.volume_m3,
 fato.gramatura,
 fato.qtd_folhas,
 fato.formato,
 fato.concentracao,
 fato.aplicacao,
 fato.nro_ultimapeca,
 fato.perc_distribuicao,
 fato.perc_perdas,
 fato.perc_adm,
 fato.perc_vendas,
 fato.versao_operacao,
 fato.dt_ultcotacao,
 fato.preco_ultcotacao,
 fato.tipo_custo,
 fato.fornec_ultcotacao,
 fato.imprimir_narrativapc,
 fato.imprimir_narrativapv,
 fato.imprimir_narrativarom,
 fato.custo_calculado,
 fato.imprimir_narrativaop,
 fato.preco_vendasugerido,
 fato.tempo_obtencaoideal,
 fato.tipo_controlelote,
 fato.controla_validade,
 fato.prazo_validade,
 fato.tipo_controlepeca,
 fato.curva_abc,
 fato.saldo_negativo,
 fato.fator_quantidade2,
 fato.desenho,
 fato.rev_desenho,
 fato.dt_revdesenho,
 fato.dnf_fator_01,
 fato.dnf_fator_02,
 fato.dnf_fator_03,
 fato.dnf_codespecie,
 fato.dnf_codproduto1,
 fato.dnf_codproduto2,
 fato.dnf_un_padrao,
 fato.dnf_un_est1,
 fato.dnf_un_est2,
 fato.dnf_capacidade,
 fato.dnf_comb_solvente,
 fato.dnf_sefaz,
 fato.dnf_codgrupo,
 fato.gera_manga,
 fato.prazo_entrega,
 fato.auxiliar_string1,
 fato.auxiliar_string2,
 fato.imprimir_narrativanf,
 fato.sittributaria,
 fato.auxiliar_float1,
 fato.auxiliar_float2,
 fato.dt_change,
 fato.tipo_aliqipi,
 fato.valor_ipifixo,
 fato.tipo_tempoobtencaocom,
 fato.tipo_tempoobtencaopro,
 fato.tempo_obtencaoidealpro,
 fato.sanfona,
 fato.face,
 fato.narrativa_op,
 fato.modelo,
 fato.calcular_volumeauto,
 fato.codtp_anp,
 fato.codtp_sefaz,
 fato.codtp_servicolc,
 fato.codtp_genero,
 fato.garantia_adicional,
 fato.garantia,
 fato.qtd_segurancadias,
 fato.codtp_packing,
 fato.descricao_completa,
 fato.codtp_energiatelecom_cf,
 fato.descricao_web,
 fato.link_video,
 fato.qtd_embalagem,
 fato.diametro,
 fato.auxiliar_string3,
 fato.regime_pis_cofins,
 fato.fci_produto_importado,
 fato.fci_gera_fci,
 fato.pontos,
 fato.dt_atualizacao_integracao,
 fato.dt_envio_integracao,
 fato.majorar_perc_cofins_imp,
 fato.origem_integracao,
 fato.cod_item_emmegi,
 fato.sourcecode,
 fato.cod_nbs,
 fato.gerar_umloteporunidade,
 fato.cod_cest,
 fato.cod_itemgradeinfo,
 fato.origem_mercadoria,
 fato.lt_multiplo_venda,
 fato.qtd_loteminvenda,
 fato.considerar_componenteopc,
 fato.tipo_estimativacarga,
 fato.valor_estimativacarga,
 fato.controla_fabricacao,
 fato.id_confirm8,
 fato.spa_contem,
 fato.cod_tabelaprecodefault,
 fato.qtd_lotemintransf,
 fato.lt_multiplo_transf,
 fato.cod_sisterceiro,
 fato.preco_medio,
 fato.farmaceutico,
 fato.anvisa_registro,
 fato.anvisa_isento,
 fato.anvisa_motivoisencao,
 fato.status,
 fato.cod_interno,
 fato.cod_tabelapadraoreg
from item fato
join grupo_estoque			dim   on dim.cod_grupoestoque      = fato.cod_grupoestoque
left join subgrupo_estoque  dim_2 on dim_2.cod_subgrupoestoque = fato.cod_subgrupoestoque
left join grupo_estoque     dim_3 on dim_3.cod_grupoestoque    = fato.cod_grupoestoque
left join familia_comercial dim_4 on dim_4.cod_fmcomercial     = fato.cod_fmcomercial
left join unidade 			dim_5 on dim_5.cod_unidade         = fato.cod_unidade
left join class_fiscal 	    dim_6 on dim_6.cod_classfiscal     = fato.cod_classfiscal

/*where dim.codtp_tipoproduto in (''0'',''1'',''2'',''3'',''4'',''5'',''6'')*/

where exists(
			 select cod_item 
			 from item_notafiscal n
			 where n.cod_item = fato.cod_item
			)
')

UNION ALL

SELECT 
	'RUBBERON' AS EMPRESA
,	*
FROM OPENQUERY([MBM_RUBBERON],'
select 
 fato.cod_item,
 fato.cod_clifor,
 fato.cod_servicorf,
 fato.cod_subgrupoestoque,
 dim_2.descricao as descricao_subgrupoestoque,
 fato.cod_moeda,
 fato.cod_grade,
 fato.cod_tributacao,
 fato.cod_grupoestoque,
 dim_3.descricao as descricao_grupoestoque,
 dim_3.item_venda as item_venda_grupoestoque,
 dim_3.item_producao as item_producao_grupoestoque,
 dim_3.item_compraprodutivo as item_compraprodutivo_grupoestoque,
 dim_3.item_compranaoprodutivo as item_compranaoprodutivo_grupoestoque,
 dim_3.codtp_tipoproduto as codtp_tipoproduto_grupoestoque,
 dim_3.codigo_dominio as codigo_dominio_grupoestoque,
 dim_3.descricao_dominio as descricao_dominio_grupoestoque,
 fato.cod_fmcomercial,
 dim_4.descricao as descricao_fmcomercial,
 fato.cod_unidade,
 dim_5.descricao as descricao_cod_unidade,
 dim_5.casas_dec as casas_dec_cod_unidade,
 fato.cod_fmindustrial,
 fato.cod_unidade2,
 fato.cod_unidadecompra,
 fato.cod_unidadevenda,
 fato.fornec_default,
 fato.codigo,
 fato.cod_tabelaprazo,
 fato.descricao,
 fato.preco_reposicao,
 fato.desc_nfiscal,
 fato.desc_cupom,
 fato.unidade_cupom,
 null as narrativa,
 fato.peso_bruto,
 fato.custo_reposicao,
 fato.peso_liquido,
 fato.preco_venda,
 fato.custo_medio,
 fato.dt_altprecovenda,
 fato.ativo,
 fato.preco_promocao,
 fato.custo_standard,
 fato.dt_inclusao,
 fato.qtd_seguranca,
 fato.dt_atualizacao,
 fato.controla_lote,
 fato.dt_ultimacontagem,
 fato.qtd_lotemincompra,
 fato.qtd_maxima,
 fato.controla_estoque,
 fato.qtd_loteminproducao,
 fato.comprado_fabricado,
 fato.item_debitodireto,
 fato.lt_multiplo_compra,
 fato.cod_classfiscal,
 dim_6.descricao as descricao_cod_classfiscal,
 dim_6.ipi as Ipi_ClassFiscal,
 dim_6.cod_mensagem as cod_mensagem_ClassFiscal,
 dim_6.descricao as descricao_ClassFiscal,
 dim_6.ativo as ativo_ClassFiscal,
 fato.lt_multiplo_producao,
 fato.tipo_produto,
 fato.controlado,
 fato.composto,
 fato.motivo_bloqueio,
 fato.aceita_desconto,
 fato.path_foto,
 fato.descto_maximo,
 fato.marg_lucroideal,
 fato.dt_iniciopromocao,
 fato.dt_terminopromocao,
 fato.promocao_atualizademanda,
 fato.dt_bloqueio,
 fato.prender_cqrecebimento,
 fato.prender_cqproducao,
 fato.tmp_preco_venda,
 fato.tmp_preco_promocao,
 fato.tmp_dt_iniciopromocao,
 fato.tmp_dt_terminopromocao,
 fato.tmp_aceita_desconto,
 fato.tmp_descto_maximo,
 fato.tmp_promocao_atualizademanda,
 fato.tmp_alterado,
 fato.tmp_codtabelaprazo,
 fato.altura,
 fato.largura,
 fato.dimensao,
 fato.comprimento,
 fato.volume_m3,
 fato.gramatura,
 fato.qtd_folhas,
 fato.formato,
 fato.concentracao,
 fato.aplicacao,
 fato.nro_ultimapeca,
 fato.perc_distribuicao,
 fato.perc_perdas,
 fato.perc_adm,
 fato.perc_vendas,
 fato.versao_operacao,
 fato.dt_ultcotacao,
 fato.preco_ultcotacao,
 fato.tipo_custo,
 fato.fornec_ultcotacao,
 fato.imprimir_narrativapc,
 fato.imprimir_narrativapv,
 fato.imprimir_narrativarom,
 fato.custo_calculado,
 fato.imprimir_narrativaop,
 fato.preco_vendasugerido,
 fato.tempo_obtencaoideal,
 fato.tipo_controlelote,
 fato.controla_validade,
 fato.prazo_validade,
 fato.tipo_controlepeca,
 fato.curva_abc,
 fato.saldo_negativo,
 fato.fator_quantidade2,
 fato.desenho,
 fato.rev_desenho,
 fato.dt_revdesenho,
 fato.dnf_fator_01,
 fato.dnf_fator_02,
 fato.dnf_fator_03,
 fato.dnf_codespecie,
 fato.dnf_codproduto1,
 fato.dnf_codproduto2,
 fato.dnf_un_padrao,
 fato.dnf_un_est1,
 fato.dnf_un_est2,
 fato.dnf_capacidade,
 fato.dnf_comb_solvente,
 fato.dnf_sefaz,
 fato.dnf_codgrupo,
 fato.gera_manga,
 fato.prazo_entrega,
 fato.auxiliar_string1,
 fato.auxiliar_string2,
 fato.imprimir_narrativanf,
 fato.sittributaria,
 fato.auxiliar_float1,
 fato.auxiliar_float2,
 fato.dt_change,
 fato.tipo_aliqipi,
 fato.valor_ipifixo,
 fato.tipo_tempoobtencaocom,
 fato.tipo_tempoobtencaopro,
 fato.tempo_obtencaoidealpro,
 fato.sanfona,
 fato.face,
 fato.narrativa_op,
 fato.modelo,
 fato.calcular_volumeauto,
 fato.codtp_anp,
 fato.codtp_sefaz,
 fato.codtp_servicolc,
 fato.codtp_genero,
 fato.garantia_adicional,
 fato.garantia,
 fato.qtd_segurancadias,
 fato.codtp_packing,
 fato.descricao_completa,
 fato.codtp_energiatelecom_cf,
 fato.descricao_web,
 fato.link_video,
 fato.qtd_embalagem,
 fato.diametro,
 fato.auxiliar_string3,
 fato.regime_pis_cofins,
 fato.fci_produto_importado,
 fato.fci_gera_fci,
 fato.pontos,
 fato.dt_atualizacao_integracao,
 fato.dt_envio_integracao,
 fato.majorar_perc_cofins_imp,
 fato.origem_integracao,
 fato.cod_item_emmegi,
 fato.sourcecode,
 fato.cod_nbs,
 fato.gerar_umloteporunidade,
 fato.cod_cest,
 fato.cod_itemgradeinfo,
 fato.origem_mercadoria,
 fato.lt_multiplo_venda,
 fato.qtd_loteminvenda,
 fato.considerar_componenteopc,
 fato.tipo_estimativacarga,
 fato.valor_estimativacarga,
 fato.controla_fabricacao,
 fato.id_confirm8,
 fato.spa_contem,
 fato.cod_tabelaprecodefault,
 fato.qtd_lotemintransf,
 fato.lt_multiplo_transf,
 fato.cod_sisterceiro,
 fato.preco_medio,
 fato.farmaceutico,
 fato.anvisa_registro,
 fato.anvisa_isento,
 fato.anvisa_motivoisencao,
 fato.status,
 fato.cod_interno,
 fato.cod_tabelapadraoreg
from item fato
join grupo_estoque			dim   on dim.cod_grupoestoque      = fato.cod_grupoestoque
left join subgrupo_estoque  dim_2 on dim_2.cod_subgrupoestoque = fato.cod_subgrupoestoque
left join grupo_estoque     dim_3 on dim_3.cod_grupoestoque    = fato.cod_grupoestoque
left join familia_comercial dim_4 on dim_4.cod_fmcomercial     = fato.cod_fmcomercial
left join unidade 			dim_5 on dim_5.cod_unidade         = fato.cod_unidade
left join class_fiscal 	    dim_6 on dim_6.cod_classfiscal     = fato.cod_classfiscal

/*where dim.codtp_tipoproduto in (''0'',''1'',''2'',''3'',''4'',''5'',''6'')*/

where exists(
			 select cod_item 
			 from item_notafiscal n
			 where n.cod_item = fato.cod_item
			)
')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Seleciona Da Base Do MBM Apenas Os Itens Que Nâo Existem No Thesys				*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop table if exists #faltantes
Select 
	[chave_emp_+_cod_item] = trim(empresa + cod_item collate sql_latin1_general_cp1_ci_as)
,	*
Into #faltantes
From #base_itens_mbm Fato
Where Fato.controla_estoque = 's'
And Fato.ativo = 's'
And Not Exists (
				Select *
				From Itens Dim
				Where Fato.codigo collate sql_latin1_general_cp1_ci_as = Dim.codigo
			   )
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Dimensao Tipo_Controle_Lote														*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop table if exists #tp_controle_lote
Select *
Into #tp_controle_lote
From tabela_padrao
Where cod_tabelapadrao = 'tipo_controle_lote'
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Dimensao Tipo Controle De Peça													*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop table if exists #tp_controle_peca
Select *
Into #tp_controle_peca
From tabela_padrao
Where cod_tabelapadrao = 'tipo_controle_peca'
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Dimensao Tipo De Generos															*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
drop table if exists #tp_tipo_generos
select *
into #tp_tipo_generos
from tabela_padrao
where cod_tabelapadrao = 'tipo_generos'
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Dimensao Tp_Obtencao Comprado														*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
drop table if exists #tp_tipo_ObtenComp
select *
into #tp_tipo_ObtenComp
from tabela_padrao
where cod_tabelapadrao = 'tipo_tempo_obtencao_comprado'
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Dimensao Tp_Obtencao Produzido													*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
drop table if exists #tp_tipo_ObtenProd
select *
into #tp_tipo_ObtenProd
from tabela_padrao
where cod_tabelapadrao = 'tipo_tempo_obtencao_produzido'
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Dimensao Tp_Tipo Calculo Custo													*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
drop table if exists #tp_tipo_ClCusto
select *
into #tp_tipo_ClCusto
from tabela_padrao
where cod_tabelapadrao = 'tipo_calculo_custo'
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Deixa a Base De Itens Do MBM No Layout Da Tabela De Itens Do Thesys				*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop table If Exists #LayoutItensThesys
Select 
	--> id , incremental,
	fato.codigo,
	Subgrupos_Estoque.id_subgrupo_estoque,  /*= tb mbm (subgrupo estoque) */
	Grupos_Estoque.id_grupo_estoque,		--= tb_grupo estoque mbm
    Familia_Comercial.id_familia_comercial, --= tb_familia_comercial 
    Unidades.id_unidade	,					--= tb_unidade
	cod_unidade2 = null,					-- tem dado ver com o marcos
    fato.descricao,
	fato.preco_reposicao,
	fato.desc_nfiscal,
	fato.peso_bruto,
	fato.custo_reposicao,
	fato.peso_liquido,
	fato.custo_medio,
	fato.ativo,
	fato.custo_standard,
	fato.dt_inclusao,
	fato.controla_lote,
	fato.controla_estoque,
	fato.comprado_fabricado,
	fato.item_debitodireto,
	id_classfisc = Class_Fiscal.Id_Clasfisc,
	fato.tipo_produto,
	fato.path_foto,
	fato.versao_operacao,
	fato.codtp_servicolc,
	fato.garantia,
	fato.descricao_completa,
	regime_pis_confins = null,
	fci_produto_importado = null,
	fci_gera_fci = null,
	dt_envio_integracao = null,
	majorar_perc_cofins_imp = null,
	cod_itemgradeinfo = null,
	incl_data = getdate(),
	incl_user = 'ksantana',
	incl_device = null,
	modi_data   = getdate(),
	modi_user   = 'ksantana',
	modi_device = null,
	excl_data   = null,
	excl_user   = null,
	excl_device = null,
	id_tp_controle = #tp_controle_lote.Id_Tabela_padrao,			-- (cruzar tabela padrao para trazer o dexpara)
	id_tp_contpeca = #tp_controle_peca.Id_Tabela_padrao,			-- (cruzar tabela padrao para trazer o dexpara)
	id_tp_genero   = #tp_tipo_generos.Id_Tabela_padrao,				-- (cruzar tabela padrao para trazer o dexpara)
	id_tp_tempoobcom = #tp_tipo_ObtenComp.Id_Tabela_padrao,			-- (cruzar tabela padrao para trazer o dexpara)
	id_tp_tempoobtpro = #tp_tipo_ObtenProd.Id_Tabela_padrao,		-- (cruzar tabela padrao para trazer o dexpara)
	id_tp_custo       = #tp_tipo_ClCusto.Id_Tabela_padrao,			-- (cruzar tabela padrao para trazer o dexpara)
	obs_pedido_compra = null,
	obs_op = null,
	obs_pedido_venda = null,
	obs_nf = null,
	id_unid_negocio = null,	-- tem dado ver com o marcos
	modulo_flexao = null,
	cas = null,
	fluidez = null,
	densidade = null,
	uso_resina = null,
	descricao_ncm_suframa = null,
	aplicacao_PPB = null,
	id_pais_origem = null,
	qtd_por_container = null,
	id_familia_pcp = null, -- tem dado ver com o marcos
	fato.controla_validade,
	dias_validade = prazo_validade
Into #LayoutItensThesys
From #faltantes Fato
Left Join Subgrupos_Estoque	  On Subgrupos_Estoque.descricao  = Fato.Descricao_SubgrupoEstoque  Collate sql_latin1_general_cp1_ci_as
Left Join Grupos_Estoque	  On Grupos_Estoque.descricao     = Fato.Descricao_GrupoEstoque     Collate sql_latin1_general_cp1_ci_as
Left Join Familia_Comercial	  On Familia_Comercial.descricao  = Fato.Descricao_fmcomercial      Collate sql_latin1_general_cp1_ci_as
Left Join Unidades			  On Unidades.Codigo			  = Fato.Cod_Unidade			    Collate sql_latin1_general_cp1_ci_as
Left Join Class_Fiscal		  On Class_Fiscal.Cod_ClassFiscal = Fato.Cod_ClassFiscal			Collate sql_latin1_general_cp1_ci_as
Left Join #tp_controle_lote	  On #tp_controle_lote.Codigo	  = Fato.tipo_controlelote		    Collate sql_latin1_general_cp1_ci_as
Left Join #tp_controle_peca	  On #tp_controle_peca.Codigo	  = Fato.tipo_controlepeca		    Collate sql_latin1_general_cp1_ci_as
Left Join #tp_tipo_generos	  On #tp_tipo_generos.Codigo	  = Fato.codtp_genero				Collate sql_latin1_general_cp1_ci_as
Left Join #tp_tipo_ObtenComp  On #tp_tipo_ObtenComp.Codigo	  = Fato.tipo_tempoobtencaocom	    Collate sql_latin1_general_cp1_ci_as
Left Join #tp_tipo_ObtenProd  On #tp_tipo_ObtenProd.Codigo	  = Fato.tipo_tempoobtencaopro	    Collate sql_latin1_general_cp1_ci_as
Left Join #tp_tipo_ClCusto	  On #tp_tipo_ClCusto.Codigo	  = Fato.tipo_custo				  

--Left Join Familia_Pcp		  On Familia_Pcp.Cod_ClassFiscal  = Fato.Cod_ClassFiscal			collate sql_latin1_general_cp1_ci_as
--Left Join Unidades_Negocio  On Unidades.Codigo			  = Fato.Cod_Unidade				collate sql_latin1_general_cp1_ci_as

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Pega Na Base Os Id Que São Vazios	Para Verificar Se é Vazio No MBM Ou No Thesys  	*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #IdVazios
Select *
Into #IdVazios
From #LayoutItensThesys
where id_grupo_estoque	   is null
Or    id_subgrupo_estoque  is null
Or    id_familia_comercial is null
Or    id_ClassFisc		   is null
Or    Id_Unidade		   is null
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Valida Se Realmente Na Base Do MBM Não tem SubGrupo								*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
--Insert Into [dbo].[Subgrupos_Estoque](
--										 [id_grupo_estoque]
--										,[codigo]
--										,[descricao]
--										,[ativo]
--										,[dt_bloqueio]
--										,[motivo_bloqueio]
--										,[seq_exibicao]
--										,[auxiliar_string1]
--										,[incl_data]
--										,[incl_user]
--										,[incl_device]
--										,[modi_data]
--										,[modi_user]
--										,[modi_device]
--										,[excl_data]
--										,[excl_user]
--										,[excl_device]
--									   )
Select 
	id_grupo_estoque = Grupos_Estoque.Id_Grupo_Estoque
,	Cod_SubgrupoEstoque
,	Descricao_SubgrupoEstoque
,	Ativo
,   dt_bloqueio		 = null
,	motivo_bloqueio  = null
,	seq_exibicao     = 0
,	auxiliar_string1 = null
,	incl_data        = getdate()
,	incl_user        = 'ksantana'
,	incl_device      = null
,	modi_data		 = null
,	modi_user		 = null
,	modi_device		 = null
,	excl_data		 = null
,	excl_user		 = null
,	excl_device		 = null
From (
		select 
			Empresa
		,	Codigo_Item = codigo
		,	Cod_GrupoEstoque
		,	Descricao_GrupoEstoque
		,	Cod_SubgrupoEstoque 
		,	Descricao_SubgrupoEstoque  
		,	Cod_fmcomercial
		,	Descricao_fmcomercial      
		,	Cod_Unidade		
		,	Descricao_Cod_Unidade
		,	Cod_ClassFiscal	
		,	Descricao_Cod_ClassFiscal	
		,	Ativo
		from #Faltantes BaseMBM
		where exists (
					  select *
					  from #IdVazios BaseFaltandoId
					  where BaseMBM.codigo = BaseFaltandoId.Codigo
					  and BaseFaltandoId.id_subgrupo_estoque is null
					 )
	 )SubQuery
Left Join Grupos_Estoque On Grupos_Estoque.Descricao collate sql_latin1_general_cp1_ci_as = SubQuery.Descricao_GrupoEstoque
Where(
	     SubQuery.Cod_SubgrupoEstoque		Is Not Null
	  Or SubQuery.Descricao_SubgrupoEstoque Is Not Null
	 )
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Valida se Realmente na Base do MBM Não tem Grupo Estoque							*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
--Insert Into [dbo].[Grupos_Estoque](
--								    [codigo]
--								   ,[descricao]
--								   ,[item_venda]
--								   ,[item_producao]
--								   ,[item_compraprodutivo]
--								   ,[item_compranaoprodutivo]
--								   ,[id_tipo_produto]
--								   ,[codigo_no_dominio]
--								   ,[descricao_dominio]
--								   ,[incl_data]
--								   ,[incl_user]
--								   ,[incl_device]
--								   ,[modi_data]
--								   ,[modi_user]
--								   ,[modi_device]
--								   ,[excl_data]
--								   ,[excl_user]
--								   ,[excl_device]
--								  )

Select 
	Cod_GrupoEstoque			=	Grupos_Estoque.Codigo
,	Descricao_GrupoEstoque
,	item_venda					=	item_venda_grupoestoque
,	item_producao				=	item_producao_grupoestoque
,	item_compraprodutivo		=	item_compraprodutivo_grupoestoque
,	item_compranaoprodutivo		=	item_compranaoprodutivo_grupoestoque
,	id_tipo_produto				=	codtp_tipoproduto_grupoestoque
,	codigo_no_dominio			=	codigo_dominio_grupoestoque
,	descricao_dominio			=	descricao_dominio_grupoestoque
,	incl_data					=	getdate()
,	incl_user					=	'ksantana'
,	incl_device					=	null
,	modi_data					=	null
,	modi_user					=	null
,	modi_device					=	null
,	excl_data					=	null
,	excl_user					=	null
,	excl_device					=	null
From (
		Select 
			Empresa
		,	Codigo_Item = codigo
		,	Cod_GrupoEstoque
		,	Descricao_GrupoEstoque
		,	Cod_SubgrupoEstoque 
		,	Descricao_SubgrupoEstoque  
		,	Cod_fmcomercial
		,	Descricao_fmcomercial      
		,	Cod_Unidade		
		,	Descricao_Cod_Unidade
		,	Cod_ClassFiscal	
		,	Descricao_Cod_ClassFiscal
		,	item_venda_grupoestoque
		,	item_producao_grupoestoque
		,	item_compraprodutivo_grupoestoque
		,	item_compranaoprodutivo_grupoestoque
		,	codtp_tipoproduto_grupoestoque
		,	codigo_dominio_grupoestoque
		,	descricao_dominio_grupoestoque
		From #faltantes BaseMBM
		Where Exists (
					  select *
					  from #IdVazios BaseFaltandoId
					  where BaseMBM.codigo = BaseFaltandoId.Codigo
					  and BaseFaltandoId.id_grupo_estoque is null
					 )
	 )SubQuery
Left Join Grupos_Estoque On Grupos_Estoque.Descricao collate sql_latin1_general_cp1_ci_as = SubQuery.Descricao_GrupoEstoque
Where SubQuery.Descricao_GrupoEstoque Is Not Null
--> Quando For Rodar Essa Parte Verificar Se Não tem Casos Com Descricao Vazia Na Grupos_Estoque, Se Tiver Precisa Cadastras No Thesys.

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Valida se Realmente na Base do MBM Não tem Familia Comercial e Ja Popula Tabela	*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
--Insert Into [dbo].[Familia_Comercial](
--									   [descricao]
--									  ,[incl_data]
--									  ,[incl_user]
--									  ,[incl_device]
--									  ,[modi_data]
--									  ,[modi_user]
--									  ,[modi_device]
--									  ,[excl_data]
--									  ,[excl_user]
--									  ,[excl_device]
--									  )
Select
	Descricao_fmcomercial
,	incl_data   = getdate()
,	incl_user   = 'ksantana'
,	incl_device = 'PC'
,	modi_data   = null
,	modi_user   = null
,	modi_device = null
,	excl_data   = null
,	excl_user   = null
,	excl_device = null
From (
		Select 
			Empresa
		,	Codigo_Item = codigo
		,	Cod_GrupoEstoque
		,	Descricao_GrupoEstoque
		,	Cod_SubgrupoEstoque 
		,	Descricao_SubgrupoEstoque  
		,	Cod_fmcomercial
		,	Descricao_fmcomercial      
		,	Cod_Unidade		
		,	Descricao_Cod_Unidade
		,	Cod_ClassFiscal	
		,	Descricao_Cod_ClassFiscal				
		From #faltantes BaseMBM
		Where exists (
					  Select *
					  From #IdVazios BaseFaltandoId
					  Where BaseMBM.codigo = BaseFaltandoId.Codigo
					  And BaseFaltandoId.id_Familia_Comercial is Null
					 )
	 ) SubQuery
--> 2 Validacao Para caso algo seja inserido na Apicação Durante o Insert da Query 
Where SubQuery.Descricao_fmcomercial Is Not Null
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Valida se na Base do MBM Não tem Cod da Class Fiscal e Ja Popula Tabela Thesys	*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
--Insert Into [dbo].[Class_Fiscal](
--								  [cod_classfiscal]
--								 ,[ipi]
--								 ,[id_mensagem]
--								 ,[descricao_simplificada]
--								 ,[ativo]
--								 ,[incl_data]
--								 ,[incl_user]
--								 ,[incl_device]
--								 ,[modi_data]
--								 ,[modi_user]
--								 ,[modi_device]
--								 ,[excl_data]
--								 ,[excl_user]
--								 ,[excl_device]
--								 ,[descricao_completa]
--								 ,[neces_lic_imp_comp]
--								 ,[carga_perigosa]
--								 ,[id_classe_cargaperigosa_tab_padrao]
--								 ,[classe_cargaperigosa]
--								 ,[id_subclasse_cargaperigosa_tab_padrao]
--								 ,[subclasse_cargaperigosa]
--							    )
Select 
	Cod_ClassFiscal
,	descricao_cod_classfiscal
,	Ipi_ClassFiscal
,	cod_mensagem_ClassFiscal
,	descricao_ClassFiscal
,	ativo_ClassFiscal
,	incl_data   = getdate()
,	incl_user   = 'ksantana'
,	incl_device = 'PC'
,	modi_data   = null
,	modi_user   = null
,	modi_device = null
,	excl_data   = null
,	excl_user   = null
,	excl_device = null
,	descricao_completa						= null -- Ver Com o Marcos Dps
,	neces_lic_imp_comp						= null -- Ver Com o Marcos Dps
,	carga_perigosa							= null -- Ver Com o Marcos Dps
,	id_classe_cargaperigosa_tab_padrao		= null -- Ver Com o Marcos Dps
,	classe_cargaperigosa					= null -- Ver Com o Marcos Dps
,	id_subclasse_cargaperigosa_tab_padrao	= null -- Ver Com o Marcos Dps
,	subclasse_cargaperigosa					= null -- Ver Com o Marcos Dps
From (
		Select 
			Empresa
		,	Codigo_Item = codigo
		,	Cod_GrupoEstoque
		,	Descricao_GrupoEstoque
		,	Cod_SubgrupoEstoque 
		,	Descricao_SubgrupoEstoque  
		,	Cod_fmcomercial
		,	Descricao_fmcomercial      
		,	Cod_Unidade		
		,	Descricao_Cod_Unidade
		,	Cod_ClassFiscal	
		,	Descricao_Cod_ClassFiscal	
		,	Ipi_ClassFiscal
		,	cod_mensagem_ClassFiscal
		,	descricao_ClassFiscal
		,	ativo_ClassFiscal
		From #faltantes BaseMBM
		Where Exists (
					  Select *
					  From #IdVazios BaseFaltandoId
					  Where BaseMBM.codigo = BaseFaltandoId.Codigo
					  and BaseFaltandoId.Id_ClassFisc is null
					 )    
	 )SubQuery
Where SubQuery.Cod_ClassFiscal Is Not Null
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Valida se na Base do MBM Não tem Cod da Unidade e Ja Popula Tabela No Thesys		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
--Insert Into [dbo].[Unidades](
--						 	  [codigo]
--						     ,[descricao]
--						     ,[incl_data]
--						     ,[incl_user]
--						     ,[incl_device]
--						     ,[modi_data]
--						     ,[modi_user]
--						     ,[modi_device]
--						     ,[excl_data]
--						     ,[excl_user]
--						     ,[excl_device]
--						     ,[cod_un_export]
--						     ,[casas_dec]
--						    )
Select 
	Cod_Unidade
,	Descricao_Cod_Unidade
,	incl_data     = getdate()
,	incl_user     = 'ksantana'
,	incl_device   = 'PC'
,	modi_data     = null
,	modi_user     = null
,	modi_device   = null
,	excl_data     = null
,	excl_user     = null
,	excl_device   = null
,	Cod_Un_Export = null
,	Casas_Dec_Cod_Unidade
From (
		select 
			Empresa
		,	Codigo_Item = codigo
		,	Cod_GrupoEstoque
		,	Descricao_GrupoEstoque
		,	Cod_SubgrupoEstoque 
		,	Descricao_SubgrupoEstoque  
		,	Cod_fmcomercial
		,	Descricao_fmcomercial      
		,	Cod_Unidade		
		,	Descricao_Cod_Unidade
		,	Casas_Dec_Cod_Unidade
		,	Cod_ClassFiscal	
		,	Descricao_Cod_ClassFiscal				
		from #faltantes BaseMBM
		where exists (
					  select *
					  from #IdVazios BaseFaltandoId
					  where BaseMBM.codigo = BaseFaltandoId.Codigo
					  and BaseFaltandoId.id_Unidade is null
					 ) 
	 )SubQuery
Where SubQuery.Cod_Unidade Is Not Null

--> VERIFICAR SEMPRE SE NÃO ESTA VAZIO NO MBM OS ID, PQ SE TIVER N TEM OQ FAZER, AGR SE TIVER, TEM QUE CADASTRAR NO THESYS.


select *
from Itens 
where id_subgrupo_estoque is null

select *
from Grupos_estoque

select *
from Subgrupos_Estoque

SELECT *
FROM Itens_Empresas

SELECT *
FROM Itens_Fornec

SELECT *
FROM Itens_Conv_Unidades

SELECT *
FROM Familia_Industrial

SELECT *
FROM Familia_Comercial

SELECT *
FROM UNIDADES