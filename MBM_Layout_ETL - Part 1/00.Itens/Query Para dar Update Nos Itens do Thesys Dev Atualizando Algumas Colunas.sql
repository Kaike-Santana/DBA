
Use Thesys_Dev
Go

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Consolida Base De Itens Do MBM													*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #BaseItensPoliresinas
Select 
	'RUBBERON' AS EMPRESA
,	*
Into #BaseItensPoliresinas
From OpenQuery([MBM_nortebag],'
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
 fato.cod_unidade2,
 fato.cod_unidadecompra,
 fato.cod_unidadevenda,

 dim_9.qtd_atual as qtd_atual_estoq_saldo,

 dim_8.cod_unidade as cod_item_unidade,
 dim_8.fator as fator_item_unidade,
 dim_8.operador as operador_item_unidade,

 dim_5.cod_unidade as cod_unidade_tb_unidade,
 dim_5.descricao as descricao_cod_unidade,
 dim_5.casas_dec as casas_dec_cod_unidade,

 fato.cod_fmindustrial,
 dim_7.descricao as descricao_fmindustrial,

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
join grupo_estoque			  dim   on dim.cod_grupoestoque      = fato.cod_grupoestoque
left join subgrupo_estoque    dim_2 on dim_2.cod_subgrupoestoque = fato.cod_subgrupoestoque
left join grupo_estoque       dim_3 on dim_3.cod_grupoestoque    = fato.cod_grupoestoque
left join familia_comercial   dim_4 on dim_4.cod_fmcomercial     = fato.cod_fmcomercial
left join class_fiscal 	      dim_6 on dim_6.cod_classfiscal     = fato.cod_classfiscal
left join familia_industrial  dim_7 on dim_7.cod_fmindustrial    = fato.cod_fmindustrial
left join item_unidade        dim_8 on dim_8.cod_item			 = fato.cod_item

left join unidade 			  dim_5 on dim_5.cod_unidade         = fato.cod_unidade
left join estoq_saldo		  dim_9 on dim_9.cod_item            = fato.cod_item
')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Seleciona Da Base Do MBM Apenas Os Itens Que N o Existem No Thesys				*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop table if exists #faltantes
select *
into #faltantes
from (
Select 
	*
,	rw = Row_Number() Over ( partition by cod_item order by dt_inclusao desc)
From #BaseItensPoliresinas 
)sb
where rw = 1
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Seleciona Da Base Do MBM Apenas Os Itens Que N o Existem No Thesys				*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #Itens_Rubberon
Select 
	Itens.*
,	Itens_Empresas.id_empresa_grupo
,	Itens_Empresas.cod_reduzido_antigo
Into #Itens_Rubberon
From Itens
Left Join 
	 Itens_Empresas On  Itens_Empresas.id_item = Itens.id_item
Where Itens_Empresas.id_empresa_grupo = 4399


drop table if exists #pre_update
select 
	fato.*
,	descricao_fmcomercial_MBM   = Dim.descricao_fmcomercial
,	descricao_fmindustrial_MBM	= Dim.descricao_fmindustrial
,	codigo_MBM					= Dim.codigo
,	Descricao_MBM				= Dim.Descricao
,	Controla_Lote_MBM			= Dim.Controla_Lote
,	Controla_Estoque_MBM		= Dim.Controla_Estoque
,	Cod_ClassFiscal_MBM			= Dim.Cod_ClassFiscal
,	Tipo_Produto_MBM			= Dim.Tipo_Produto
,	Controlado_MBM				= Dim.Controlado
,	comprado_fabricado_MBM		= Dim.comprado_fabricado
into #pre_update
from #Itens_Rubberon Fato
left Join #faltantes Dim On Dim.cod_item = Fato.cod_reduzido_antigo Collate Latin1_General_Ci_Ai


drop table if exists #update
select 
	fato.*
,	id_familia_comercial_new  = Familia_Comercial.id_familia_comercial
,	id_familia_industrial_new = Familia_Industrial.id_familia_industrial
,	id_clasfisc_new			  = Class_Fiscal.id_clasfisc
into #update
from #pre_update fato
left join Familia_Comercial  on Familia_Comercial.descricao  = fato.descricao_fmcomercial_MBM  Collate Latin1_General_Ci_Ai
left join Familia_Industrial on Familia_Industrial.descricao = fato.descricao_fmindustrial_MBM Collate Latin1_General_Ci_Ai
left join Class_Fiscal		 on Class_Fiscal.cod_classfiscal = fato.Cod_ClassFiscal_MBM		   Collate Latin1_General_Ci_Ai


begin tran

Update Fato
set id_familia_comercial = Isnull(Dim.id_familia_comercial_new,Dim.id_familia_comercial)
,	codigo			     = Dim.codigo_MBM
,	descricao			 = Dim.Descricao_MBM
,	controla_lote		 = Dim.Controla_Lote_MBM
,	controla_estoque	 = Dim.Controla_Estoque_MBM
,	comprado_fabricado   = Dim.comprado_fabricado_MBM
,	id_clasfisc			 = Dim.id_clasfisc_new
,	tipo_produto		 = Dim.Tipo_Produto_MBM
from Itens Fato
Join #update Dim On Dim.id_item = Fato.id_item --Collate Latin1_General_Ci_Ai

commit