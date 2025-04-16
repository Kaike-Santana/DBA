
Use Thesys_Producao
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
Drop Table If Exists #BaseItensPoliresinas
Select 
	'Polirex' AS EMPRESA
,	*
Into #BaseItensPoliresinas
From OpenQuery([Mbm_Polirex],'
select distinct
 fato.cod_item,
 fato.cod_clifor,
 fato.cod_servicorf,
 fato.cod_subgrupoestoque,
 dim_2.descricao as descricao_subgrupoestoque,
 fato.cod_moeda,
 fato.cod_grade,
 fato.cod_tributacao,
 fato.cod_grupoestoque,
 dim.descricao as descricao_grupoestoque,
 dim.item_venda as item_venda_grupoestoque,
 dim.item_producao as item_producao_grupoestoque,
 dim.item_compraprodutivo as item_compraprodutivo_grupoestoque,
 dim.item_compranaoprodutivo as item_compranaoprodutivo_grupoestoque,
 dim.codtp_tipoproduto as codtp_tipoproduto_grupoestoque,
 dim.codigo_dominio as codigo_dominio_grupoestoque,
 dim.descricao_dominio as descricao_dominio_grupoestoque,
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
left join (
			select
			    s1.cod_subgrupoestoque,
			    s1.descricao,
			    s1.dt_change
			from subgrupo_estoque s1
			where s1.dt_change = (
								  select max(s2.dt_change) from subgrupo_estoque s2 where s2.cod_subgrupoestoque = s1.cod_subgrupoestoque
								 )
		  ) dim_2 on dim_2.cod_subgrupoestoque = fato.cod_subgrupoestoque
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
Drop Table If Exists #pre_faltantes
Select *
Into #pre_faltantes
From #BaseItensPoliresinas Fato --> Quando For Inserir na Itens Empresas, Rodar Só Daqui Para Cima
Where Not Exists (
				  Select *
				  From Itens Dim
				  Where Fato.Codigo collate latin1_general_ci_ai = Dim.Descricao
			     )
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Faz o RowNumber Retirando os Valores Duplicados									*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop table if exists #faltantes
Select *
Into #faltantes
From (
		Select *
		,	rw = row_number () over ( partition by cod_item order by cod_item desc)
		From #pre_faltantes
     ) SubQuery
Where rw = 1
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Garante que os codigo do excel, realmente sejam o do MBM							*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Update fato
Set CodFc_Old				= dim.Cod_FmComercial
,	Cod_GrupoEstoque_Old	= dim.cod_grupoestoque
,	Cod_SubGrupo_Old		= dim.cod_subgrupoestoque

From Thesys_Homologacao..BaseItensAtivos_NovosNomes_Polirex fato
Join #faltantes			dim  on dim.codigo = fato.CodigoItem Collate latin1_general_ci_ai	
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Dropa Coluna de Flag Do RowNumber													*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #ItensFinal 
Select 
	fato.* 
,	NovoCodGrupoEstoque   = Isnull(Dim.CodNovo_Grupoestoque , Fato.Cod_GrupoEstoque			)
,	NovoNomeGrupoEstoque  = Isnull(Dim.NomeNovo_Grupoestoque, Fato.Descricao_GrupoEstoque	)
,	NovoCodSubGrupo		  = Isnull(Dim.CodNovo_SubGrupo,	  Fato.Cod_SubGrupoEstoque		)
,	NovoNomeSubGrupo	  = Isnull(Dim.NomeNovo_SubGrupo,	  Fato.Descricao_SubGrupoEstoque)
,	NovoCodFC			  = Isnull(Dim.CodNovo_FC,			  Fato.Cod_FmComercial			)
,	NovoNomeFC			  = Isnull(Dim.NomeNovo_FC,			  Fato.Descricao_FmComercial	)
Into #ItensFinal
From #faltantes Fato
Left Join Thesys_Homologacao..BaseItensAtivos_NovosNomes_Polirex Dim On  Dim.Cod_GrupoEstoque_Old = Fato.Cod_GrupoEstoque     Collate latin1_general_ci_ai
																	 And Dim.CodigoItem			  = Fato.Codigo				  Collate latin1_general_ci_ai
																	 And Dim.Cod_SubGrupo_Old	  = Fato.Cod_SubGrupoEstoque  Collate latin1_general_ci_ai
																	 And Dim.CodFC_Old			  = Fato.Cod_FmComercial	  Collate latin1_general_ci_ai										 
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: OLHA SEMPRE JUNTO A PLANILHA DO LUAN O NOME CERTO, E DAR UPDATE AQUI, CASO TENHA ALGO FORA*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
update #ItensFinal
set NovoNomeGrupoEstoque = 'ATIVO IMOB. - MAQ. E EQUIP.'
where NovoNomeGrupoEstoque = 'ATIVO IMOB - MAQ E EQUIP'

update #ItensFinal
set NovoNomeGrupoEstoque = 'MATERIAL DE CONSUMO'
where NovoNomeGrupoEstoque = 'MATERIAL USO/CONSUMO'

update #ItensFinal
set NovoNomeGrupoEstoque = 'ATIVO IMOB. - VEICULOS'
where NovoNomeGrupoEstoque = 'ATIVO IMOB - VEICULOS'


update #ItensFinal
set NovoNomeGrupoEstoque = 'ATIVO IMOB - EQUIP INFORMATI'
where NovoNomeGrupoEstoque = 'ATIVO IMOB. - EQUIP. INFORMATI'

update #ItensFinal
set NovoNomeGrupoEstoque = 'SERVICOS - CURSOS E TREINAMENTO'
where NovoNomeGrupoEstoque = 'SERVICOS - CURSOS E TREINAMENT'

update #ItensFinal
set NovoNomeGrupoEstoque = 'SERVICOS - CONSULTORIA INFORMATICA'
where NovoNomeGrupoEstoque IN ('SERVICOS - CONSULTORIA INFORMA','SERVICOS - CONSULTORIA INFOR.')


update #ItensFinal
set NovoNomeSubGrupo = 'ATIVO IMOB. - EQUIP. INFORMATI'
where NovoNomeSubGrupo = 'ATIVO IMOB - EQUIP INFORMATI'

update #ItensFinal
set NovoNomeSubGrupo = 'SERVICOS - CONSULTORIA INFORMATICA'
where NovoNomeSubGrupo IN ('SERVICOS - CONSULTORIA INFORMA','SERVICOS - CONSULTORIA INFOR.')

update #ItensFinal
set NovoNomeSubGrupo = 'MATERIA-PRIMA'
where NovoNomeSubGrupo IN ('MATERIA PRIMA')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Dropa Coluna de Flag Do RowNumber													*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
drop table if exists #GrupoUnique 
select distinct 
	NovoCodGrupoEstoque
,	NovoNomeGrupoEstoque
into #GrupoUnique
from #ItensFinal
where NovoCodGrupoEstoque != '100' --> 100 MATERIAL DE CONSUMO Duplicado, tem que ser o 07000009

Drop Table If Exists #GrupoEstoque
Select *
into #GrupoEstoque
from openquery([Mbm_Polirex],'
select *
from grupo_estoque fato
--where exists (
--			   select *
--			   from item dim
--			   where dim.cod_grupoestoque = fato.cod_grupoestoque
--			   --and dim.ativo = ''S''
--			 )
')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Consolida Grupo de Estoque da Poliresinas do MBM									*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Insert Into [dbo].[Grupos_Estoque]
           ([codigo]
           ,[descricao]
           ,[item_venda]
           ,[item_producao]
           ,[item_compraprodutivo]
           ,[item_compranaoprodutivo]
           ,[id_tipo_produto]
           ,[codigo_no_dominio]
           ,[descricao_dominio]
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
	NovoCodGrupoEstoque			
,	NovoNomeGrupoEstoque	    
,	item_venda					=   #GrupoEstoque.item_venda					
,	item_producao				=   #GrupoEstoque.item_producao			
,	item_compraprodutivo		=   #GrupoEstoque.item_compraprodutivo	
,	item_compranaoprodutivo		=   #GrupoEstoque.item_compranaoprodutivo
,	id_tipo_produto				=	Tipos_Produtos.id_tipo_produto
,	codigo_dominio				=	#GrupoEstoque.codigo_dominio		
,	descricao_dominio			=	#GrupoEstoque.descricao_dominio	
,	incl_data					=	getdate()
,	incl_user					=	'ksantana'
,	incl_device					=	null
,	modi_data					=	null
,	modi_user					=	null
,	modi_device					=	null
,	excl_data					=	null
,	excl_user					=	null
,	excl_device					=	null
From #GrupoUnique Fato
Inner Join #GrupoEstoque  on #GrupoEstoque.cod_grupoestoque     = fato.NovoCodGrupoEstoque        collate latin1_general_ci_ai
Left  Join Tipos_Produtos On Convert(int,Tipos_Produtos.Codigo)	= #GrupoEstoque.codtp_tipoproduto collate latin1_general_ci_ai
Where (
		Not Exists (
				    Select *
				    From Grupos_Estoque Dim
				    Where Dim.Descricao = Fato.NovoNomeGrupoEstoque
				   )
		and Not Exists (
						Select *
						From Grupos_Estoque Dim_2
						Where Dim_2.codigo = fato.NovoCodGrupoEstoque
					  )

		)
Order By NovoNomeGrupoEstoque Asc
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Atualiza a Tabela GruposEstoque_PlanoContas Baseado Nos Grupo de Estoque			*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #GP_PlanContas
Select *
Into #GP_PlanContas
From OpenQuery([Mbm_Polirex],'
Select 
	GrupoEstoque_ContaContabil.*
,	Grupo_Estoque.descricao as Descr_GrupoEstoque
,	Plano_Contas.tipo
From GrupoEstoque_ContaContabil
Join Grupo_Estoque On Grupo_Estoque.cod_grupoestoque = GrupoEstoque_ContaContabil.cod_grupoestoque
Join Plano_Contas  On Plano_Contas.cod_planocontas   = GrupoEstoque_ContaContabil.cod_contacontabil
')

Insert Into [dbo].[GruposEstoque_PlanoContas]
           ([id_empresa]
           ,[id_grupoestoque]
           ,[id_plano_contas]
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
	[id_empresa]	  
,	[id_grupoestoque] 
,	[id_plano_contas] 
,	[incl_data]		  
,	[incl_user]		  
,	[incl_device]	  
,	[modi_data]		  
,	[modi_user]		  
,	[modi_device]	  
,	[excl_data]		  
,	[excl_user]		  
,	[excl_device]	  
From (
		Select 
			[id_empresa]	  = Empresas.Id_Empresa
		,	[id_grupoestoque] = Grupos_Estoque.id_grupo_estoque
		,	[id_plano_contas] = Plano_Contas.id_plano
		,	[incl_data]		  = GetDate()
		,	[incl_user]		  =	'ksantana'
		,	[incl_device]	  = 'PC/10.1.0.123'
		,	[modi_data]		  = Null
		,	[modi_user]		  = Null
		,	[modi_device]	  = Null
		,	[excl_data]		  = Null
		,	[excl_user]		  = Null
		,	[excl_device]	  = Null
		From #GP_PlanContas Fato
		Inner Join Grupos_Estoque On  Grupos_Estoque.descricao	   = Fato.Descr_GrupoEstoque  Collate latin1_general_ci_ai
		--Inner Join Grupos_Estoque On  Grupos_Estoque.codigo		   = Fato.cod_grupoestoque    Collate latin1_general_ci_ai
		Left  Join Empresas	      On  Empresas.Codigo_Antigo	   = Fato.Cod_Empresa	      Collate latin1_general_ci_ai
		Left  Join Plano_Contas   On  Plano_Contas.cod_planocontas = Fato.Cod_ContaContabil   Collate latin1_general_ci_ai
						          And Plano_Contas.Tipo			   = Fato.Tipo				  Collate latin1_general_ci_ai
	 )SubQuery
Where Not Exists (
			      Select *
				  From GruposEstoque_PlanoContas Dim 
				  Where Dim.id_empresa      = SubQuery.id_empresa
				  And   Dim.id_plano_contas = SubQuery.id_plano_contas
				 )

--> Validar se Nao tem Duplicidade
with cte_PlaGrupoEstoque as (
select *
,	rw = row_number() over (partition by id_empresa, id_grupoestoque, id_plano_contas order by incl_data asc) 
from GruposEstoque_PlanoContas
)

Delete from GruposEstoque_PlanoContas
where id_grupoestoque_planocontas in (
select id_grupoestoque_planocontas
from cte_PlaGrupoEstoque
where rw > 1
)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Consolida Grupo de Estoque da Poliresinas do MBM									*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
drop table if exists #SubGrupoEstoque
Select *
into #SubGrupoEstoque
from openquery([mbm_polirex],'
select *
from subgrupo_estoque fato
--where exists (
--			   select *
--			   from item dim
--			   where dim.cod_subgrupoestoque = fato.cod_subgrupoestoque
--			   --and dim.ativo = ''S''
--			 )
')


drop table if exists #SubGrupoUnique
select distinct
	NovoNomeGrupoEstoque
,	NovoCodGrupoEstoque
,	NovoCodSubGrupo
,	NovoNomeSubGrupo
into #SubGrupoUnique
from #ItensFinal
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Consolida Grupo de Estoque da Poliresinas do MBM									*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Insert Into [dbo].[Subgrupos_Estoque](
								  	  [id_grupo_estoque]
									 ,[codigo]
									 ,[descricao]
									 ,[ativo]
									 ,[dt_bloqueio]
									 ,[motivo_bloqueio]
									 ,[seq_exibicao]
									 ,[auxiliar_string1]
									 ,[incl_data]
									 ,[incl_user]
									 ,[incl_device]
									 ,[modi_data]
									 ,[modi_user]
									 ,[modi_device]
									 ,[excl_data]
									 ,[excl_user]
									 ,[excl_device]
								     )
Select 
	[id_grupo_estoque]	
,	[codigo]		    
,	[descricao]			
,	[ativo]				
,	[dt_bloqueio]		
,	[motivo_bloqueio]	
,	[seq_exibicao]		
,	[auxiliar_string1]	
,	[incl_data]			
,	[incl_user]			
,	[incl_device]		
,	[modi_data]			
,	[modi_user]			
,	[modi_device]		
,	[excl_data]			
,	[excl_user]			
,	[excl_device]		
From (
		select 
			[id_grupo_estoque]	=  Grupos_Estoque.id_grupo_estoque
		--,   fato.NovoNomeGrupoEstoque
		--,	fato.NovoCodGrupoEstoque
		,	[codigo]		    =  NovoCodSubGrupo
		,	[descricao]			=  NovoNomeSubGrupo
		,	[ativo]				=  'S'
		,	[dt_bloqueio]		=  Null
		,	[motivo_bloqueio]	=  Null
		,	[seq_exibicao]		=  0
		,	[auxiliar_string1]	=  Null
		,	[incl_data]			=  GetDate()
		,	[incl_user]			= 'ksantana'
		,	[incl_device]		=  Null
		,	[modi_data]			=  Null
		,	[modi_user]			=  Null
		,	[modi_device]		=  Null
		,	[excl_data]			=  Null
		,	[excl_user]			=  Null
		,	[excl_device]		=  Null
		,	rw					=  row_number() over (partition by Grupos_Estoque.id_grupo_estoque, Fato.NovoNomeSubGrupo  Order by Fato.NovoNomeSubGrupo Desc)
		from #SubGrupoUnique Fato
		--join #SubGrupoEstoque On  #SubGrupoEstoque.cod_grupoestoque    = #SubGrupoUnique.cod_grupoestoque
		--					  And #SubGrupoEstoque.cod_subgrupoestoque = #SubGrupoUnique.cod_subgrupoestoque
		left join Grupos_Estoque   On Grupos_Estoque.descricao = fato.NovoNomeGrupoEstoque
	 )SubQuery
Where Rw = 1
And not exists (
				 Select *
				 From Subgrupos_Estoque Dim
				 Where SubQuery.descricao = Dim.descricao collate latin1_general_ci_ai
			   )
And Codigo Is Not Null
order by SubQuery.descricao asc
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Consolida Grupo de Estoque da Poliresinas do MBM									*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
drop table if exists #FamiliaComercial
Select *
into #FamiliaComercial
from openquery([mbm_polirex],'
select *
from Familia_Comercial fato
where exists (
			   select *
			   from item dim
			   where dim.cod_fmcomercial = fato.cod_fmcomercial
			   --and dim.ativo = ''S''
			 )
')

drop table if exists #FmComercialUnique
select distinct
--	NovoCodFC
	NovoNomeFC
into #FmComercialUnique
from #ItensFinal
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Consolida Grupo de Estoque da Poliresinas do MBM									*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Insert Into [dbo].[Familia_Comercial](
									   [descricao]
									  ,[incl_data]
									  ,[incl_user]
									  ,[incl_device]
									  ,[modi_data]
									  ,[modi_user]
									  ,[modi_device]
									  ,[excl_data]
									  ,[excl_user]
									  ,[excl_device]
									  )
Select 
	NovoNomeFC
,	incl_data   = getdate()
,	incl_user   = 'ksantana'
,	incl_device = 'PC/10.1.0.123'
,	modi_data   = null
,	modi_user   = null
,	modi_device = null
,	excl_data   = null
,	excl_user   = null
,	excl_device = null
From #FmComercialUnique Fato
Where Not Exists (
				  Select *
				  From Familia_Comercial Dim
				  Where Dim.descricao = Fato.NovoNomeFC
				 )
Order By NovoNomeFC Asc
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Layout da Familia Industrial														*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
drop table if exists #FamiliaIndustrial
Select *
into #FamiliaIndustrial
from openquery([mbm_polirex],'
select *
From Familia_Industrial
')


Insert Into [dbo].[Familia_Industrial]
           ([codigo]
           ,[descricao]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device]
           ,[id_unid_negocio])

Select 
	[codigo]		  = Cod_FmIndustrial
,	[descricao]		  = Descricao
,	[incl_data]		  = GetDate()
,	[incl_user]		  = 'ksantana'
,	[incl_device]	  = 'PC/10.1.0.123'
,	[modi_data]		  = Null
,	[modi_user]		  =	Null
,	[modi_device]	  =	Null
,	[excl_data]		  =	Null
,	[excl_user]		  =	Null
,	[excl_device]	  =	Null
,	[id_unid_negocio] = Case
							 When Descricao Like 'Com.%'	Then 1 --> Tabela (Unidades_Negocio)
							 When Descricao Like 'Dis.%'	Then 2
							 When Descricao Like 'Str.%'	Then 3
							 When Descricao Like 'Qui.%'	Then 4
							 When Descricao Like 'Raf.%'	Then 5
							 When Descricao Like 'Rot.%'	Then 6
							 When Descricao Like 'Tub.%'	Then 7
							 When Descricao Like 'Dis.Ps%'	Then 8
							 When Descricao Like 'Cos%'		Then 9
							 Else Null
						End
From #FamiliaIndustrial Fato
Where Not Exists (
				  Select *
				  From Familia_Industrial Dim
				  Where Dim.Descricao = Fato.Descricao collate latin1_general_ci_ai
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
/* Descricao: Dimensao Tipo Controle De Pe a													*/
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
/* Descricao: Dimensao Tipo Da Mercadoria Para Preencher a Tabela Itens_Empresas				*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
drop table if exists #tp_origem_mercadoria
select *
into #tp_origem_mercadoria
from tabela_padrao
where cod_tabelapadrao = 'origem_mercadoria'
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Deixa a Base De Itens Do MBM No Layout Da Tabela De Itens Do Thesys				*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #Tb_Aux_Grupo_e_SG
select fato.*
,	   DescricaoGE = Dim.descricao
Into #Tb_Aux_Grupo_e_SG
from Subgrupos_Estoque Fato
Left Join Grupos_Estoque Dim On Dim.id_grupo_estoque = Fato.id_grupo_estoque
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Consolida Grupo e SubGrupo em Uma Tabela s  para colocar condicao no join com MBM */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Conferir o Id dos Tipo de ControlaLote se Condiz com o Abaixo						*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
select *
from Tabela_Padrao
where cod_tabelapadrao = 'TIPO_CONTROLE_LOTE'
--
--1851	TIPO_CONTROLE_LOTE	A	CONTROLA LOTE AUTOMATICO	
--1850	TIPO_CONTROLE_LOTE	M	CONTROLA LOTE MANUAL 	   	
--1852	TIPO_CONTROLE_LOTE	N	NÃO CONTROLA LOTE	

--> voltar aqui depois de verificar os ID vazios e descomnetaro insert e rodar

Alter Table itens Add Rw Int 
Alter Table itens Drop Column Rw 


Drop table If Exists #LayoutItensThesys
insert into itens
Select *
Into #LayoutItensThesys
From (
Select 
	--> id , incremental,
		--fato.cod_item,
		--#Tb_Aux_Grupo_e_SG.DescricaoGE,
		--NovoNomeGrupoEstoque,
		--#Tb_Aux_Grupo_e_SG.descricao as descricao_subgrpo,
		--NovoNomeSubGrupo,
	Trim(fato.codigo) codigo , 
		--fato.cod_subGrupoEstoque,
		--fato.descricao_subgrupoestoque,
		--fato.NovoCodSubGrupo,
		--fato.NovoNomeSubGrupo,
	Coalesce(#Tb_Aux_Grupo_e_SG.id_subgrupo_estoque, Subgrupos_Estoque.id_subgrupo_estoque) as id_subgrupo_estoque,  /*= tb mbm (subgrupo estoque) */
	Isnull(Coalesce(#Tb_Aux_Grupo_e_SG.id_grupo_estoque, Grupos_Estoque.id_grupo_estoque),39)          as id_grupo_estoque,
		--fato.cod_GrupoEstoque,
		--fato.descricao_grupoestoque,
		--fato.NovoCodGrupoEstoque,
		--fato.NovoNomeGrupoEstoque,
		--fato.descricao_fmcomercial,
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
	Iif(#tp_controle_lote.Id_Tabela_padrao In (1850,1851), 'S', 'N') as controla_lote,
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
	dias_validade = prazo_validade,
	rw = row_number() over ( partition by Trim(fato.codigo) Order By Trim(fato.codigo) Desc)
--Into #LayoutItensThesys
From #ItensFinal Fato
Left Join #Tb_Aux_Grupo_e_SG	On  #Tb_Aux_Grupo_e_SG.descricao   = Isnull(Fato.NovoNomeSubGrupo,Fato.Descricao_SubGrupoEstoque ) Collate latin1_general_ci_ai 
								And #Tb_Aux_Grupo_e_SG.DescricaoGE = Isnull(Fato.NovoNomeGrupoEstoque,Fato.Descricao_GrupoEstoque) Collate latin1_general_ci_ai 
Left Join Grupos_Estoque 
								On Grupos_Estoque.descricao = Fato.NovoNomeGrupoEstoque
								And #Tb_Aux_Grupo_e_SG.id_grupo_estoque Is Null
Left Join Subgrupos_Estoque 
								On  Subgrupos_Estoque.descricao			= Fato.NovoNomeSubGrupo
								--And Subgrupos_Estoque.id_grupo_estoque  = Grupos_Estoque.id_grupo_estoque
								And #Tb_Aux_Grupo_e_SG.id_subgrupo_estoque Is Null
--Left Join Subgrupos_Estoque	On  Subgrupos_Estoque.descricao	   = Fato.Descricao_SubgrupoEstoque Collate latin1_general_ci_ai 
--Left Join Grupos_Estoque		On  Grupos_Estoque.descricao	   = Fato.Descricao_GrupoEstoque    Collate latin1_general_ci_ai
Left Join Familia_Comercial		On  Familia_Comercial.descricao	   = Fato.NovoNomeFC			    Collate latin1_general_ci_ai
Left Join Unidades				On  Unidades.Codigo				   = Fato.Cod_Unidade				Collate latin1_general_ci_ai
Left Join Class_Fiscal			On  Class_Fiscal.Cod_ClassFiscal   = Fato.Cod_ClassFiscal		    Collate latin1_general_ci_ai
Left Join #tp_controle_lote		On  #tp_controle_lote.Codigo	   = Fato.tipo_controlelote			Collate latin1_general_ci_ai
Left Join #tp_controle_peca		On  #tp_controle_peca.Codigo	   = Fato.tipo_controlepeca			Collate latin1_general_ci_ai
Left Join #tp_tipo_generos		On  #tp_tipo_generos.Codigo		   = Fato.codtp_genero				Collate latin1_general_ci_ai
Left Join #tp_tipo_ObtenComp	On  #tp_tipo_ObtenComp.Codigo	   = Fato.tipo_tempoobtencaocom		Collate latin1_general_ci_ai
Left Join #tp_tipo_ObtenProd	On  #tp_tipo_ObtenProd.Codigo	   = Fato.tipo_tempoobtencaopro		Collate latin1_general_ci_ai
Left Join #tp_tipo_ClCusto		On  #tp_tipo_ClCusto.Codigo		   = Fato.tipo_custo		
)SubQuery
Where Rw = 1
--and exists (
--			select *
--			from itens dim
--			where dim.codigo = SubQuery.codigo Collate latin1_general_ci_ai
--		   )
--and id_grupo_estoque is null -- 1 validacao
--and id_subgrupo_estoque is Null
--and cod_subGrupoEstoque Is Not Null

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Update para dar nos itens para controlar lote o que   manual e automatico			*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

--> VIRA ALGUNS ID_GRUPO E SUBGRUPO VAZIOS, NA VERDADE J  PODE TER NA TABELA, POR M COM UM NOME DIFERENTE APENAS NA DESCRICAO, EX.
--> MERCADORIA PARA REVENDA IMPORT E NA TABELA DO THESYS   O NOME COMPLETO, DAR UM SELECT NO QUE FOR NULL E DEPOIS UPDATE PARA SUBIR OS ID, DESSES CASOS.

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Pega Na Base Os Id Que S o Vazios	Para Verificar Se   Vazio No MBM Ou No Thesys  	*/
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

/*
Verificar Se Esses Codigos Vazios N o Tem Descricoes Parecidas No Thesys, se tiver da Update Na Tabela Padronizar
*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Valida se Realmente na Base do MBM N o tem Grupo Estoque							*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #Layout_GrupoEstoque
Select Distinct
	Cod_GrupoEstoque			=	Cod_GrupoEstoque
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
Into #Layout_GrupoEstoque
From (
		Select 
			Empresa
		,	Codigo_Item = codigo
		,	Cod_GrupoEstoque       = NovoCodGrupoEstoque
		,	Descricao_GrupoEstoque = NovoNomeGrupoEstoque
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
		From #ItensFinal BaseMBM
		Where Exists (
					  select *
					  from #IdVazios BaseFaltandoId
					  where BaseMBM.codigo = BaseFaltandoId.Codigo
					  and BaseFaltandoId.id_grupo_estoque is null
					 )
	 )SubQuery
--Left Join Grupos_Estoque On Grupos_Estoque.Descricao collate latin1_general_ci_ai = SubQuery.Descricao_GrupoEstoque
Where SubQuery.Descricao_GrupoEstoque Is Not Null
And Not Exists (
				 Select *
				 From Grupos_Estoque Dim
				 Where Dim.descricao collate latin1_general_ci_ai = SubQuery.Descricao_GrupoEstoque
			   )
--> Quando For Rodar Essa Parte Verificar Se N tem Casos Com Descricao Vazia Na Grupos_Estoque, Se Tiver Precisa Cadastras No Thesys.

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: N o Tendo Nenhuma Descricao Que Atenda no Thesys, Descomentar e Inserir			*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Insert Into [dbo].[Grupos_Estoque](
								    [codigo]
								   ,[descricao]
								   ,[item_venda]
								   ,[item_producao]
								   ,[item_compraprodutivo]
								   ,[item_compranaoprodutivo]
								   ,[id_tipo_produto]
								   ,[codigo_no_dominio]
								   ,[descricao_dominio]
								   ,[incl_data]
								   ,[incl_user]
								   ,[incl_device]
								   ,[modi_data]
								   ,[modi_user]
								   ,[modi_device]
								   ,[excl_data]
								   ,[excl_user]
								   ,[excl_device]
								  )
Select *
From #Layout_GrupoEstoque

select *
from Grupos_Estoque
order by descricao desc

/* Dar Update Caso Tenha na #Faltantes Casos Tenha Grupo de Estoque que se Pare a com a Base Do thesys */

-- update #faltantes

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Valida Se Realmente Na Base Do MBM N o tem SubGrupo								*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #Layout_SubGrupoEstoque
Select Distinct
	id_grupo_estoque = Grupos_Estoque.Id_Grupo_Estoque
,	NovoCodSubGrupo
,	NovoNomeSubGrupo
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
Into #Layout_SubGrupoEstoque
From (
			Select 
			Empresa
		,	Codigo_Item = codigo
		,	Cod_GrupoEstoque       = NovoCodGrupoEstoque
		,	Descricao_GrupoEstoque = NovoNomeGrupoEstoque
		,	ativo
		,	NovoCodSubGrupo 
		,	NovoNomeSubGrupo  
		,	NovoCodFC
		,	NovoNomeFC      
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
		From #ItensFinal BaseMBM
		where exists (
					  select *
					  from #IdVazios BaseFaltandoId
					  where BaseMBM.codigo = BaseFaltandoId.Codigo
					  and BaseFaltandoId.id_subgrupo_estoque is null
					 )
	 )SubQuery
Left Join Grupos_Estoque On Grupos_Estoque.Descricao collate latin1_general_ci_ai = SubQuery.Descricao_GrupoEstoque
Where(
	     SubQuery.NovoCodSubGrupo  Is Not Null 
	  Or SubQuery.NovoNomeSubGrupo Is Not Null
	 )
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: N o Tendo Nenhuma Descricao Que Atenda no Thesys, Descomentar e Inserir			*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Insert Into [dbo].[Subgrupos_Estoque](
										 [id_grupo_estoque]
										,[codigo]
										,[descricao]
										,[ativo]
										,[dt_bloqueio]
										,[motivo_bloqueio]
										,[seq_exibicao]
										,[auxiliar_string1]
										,[incl_data]
										,[incl_user]
										,[incl_device]
										,[modi_data]
										,[modi_user]
										,[modi_device]
										,[excl_data]
										,[excl_user]
										,[excl_device]
									   )

Select *
From #Layout_SubGrupoEstoque

select *
from Subgrupos_Estoque
order by descricao desc

-- Verificar Se N o Tem Descricao Parecida Ja Na Tabela Do TheSys e Dar Update, Se N o Tiver Inserir. 

/*
update #faltantes
set	Descricao_SubgrupoEstoque	= 'MERCADORIA REVENDA NACIONAL'
where Descricao_SubgrupoEstoque = 'MERCADORIA PARA REVENDA NACION'


update #faltantes
set	Descricao_SubgrupoEstoque	= 'MERCADORIA REVENDA IMPORTADO'
where Descricao_SubgrupoEstoque = 'MERCADORIA PARA REVENDA IMPORT'

*/


/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Valida se Realmente na Base do MBM N o tem Familia Comercial e Ja Popula Tabela	*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #LayoutFamiliaComercial
Select Distinct
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
--Into #LayoutFamiliaComercial
From (
		Select 
			Empresa
		,	Codigo_Item = codigo
		,	Cod_GrupoEstoque       = NovoCodGrupoEstoque
		,	Descricao_GrupoEstoque = NovoNomeGrupoEstoque
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
		From #ItensFinal BaseMBM
		Where exists (
					  Select *
					  From #IdVazios BaseFaltandoId
					  Where BaseMBM.codigo = BaseFaltandoId.Codigo
					  And BaseFaltandoId.id_Familia_Comercial is Null
					 )
	 ) SubQuery
--> 2 Validacao Para caso algo seja inserido na Apica  o Durante o Insert da Query 
Where SubQuery.Descricao_fmcomercial Is Not Null
And Not Exists (
				Select *
				From Familia_Comercial
				Where SubQuery.Descricao_fmcomercial = Familia_Comercial.Descricao Collate latin1_general_ci_ai
			   )
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: N o Tendo Nenhuma Descricao Que Atenda no Thesys, Descomentar e Inserir			*/
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
Select *
From #LayoutFamiliaComercial

select *
from Familia_Comercial
order by descricao desc

/* Dar Update Caso Tenha na #Faltantes Casos Tenha Grupo de Estoque que se Pare a com a Base Do thesys */

-- update #faltantes
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Valida se na Base do MBM N o tem Cod da Class Fiscal e Ja Popula Tabela Thesys	*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #LayoutClassFiscal
Select Distinct
	Cod_ClassFiscal
,	Ipi_ClassFiscal
,	id_mensagem = Null
--,	descricao_cod_classfiscal
--,	cod_mensagem_ClassFiscal
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
Into #LayoutClassFiscal
From (
		Select 
			Empresa
		,	Ipi_ClassFiscal
		,	ativo_ClassFiscal
		,	descricao_ClassFiscal
		,	cod_mensagem_ClassFiscal
		,	Codigo_Item = codigo
		,	Cod_GrupoEstoque       = NovoCodGrupoEstoque
		,	Descricao_GrupoEstoque = NovoNomeGrupoEstoque
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
		From #ItensFinal BaseMBM
		Where Exists (
					  Select *
					  From #IdVazios BaseFaltandoId
					  Where BaseMBM.codigo = BaseFaltandoId.Codigo
					  and BaseFaltandoId.Id_ClassFisc is null
					 )    
	 )SubQuery
Where SubQuery.Cod_ClassFiscal Is Not Null
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: N o Tendo Nenhuma Descricao Que Atenda no Thesys, Descomentar e Inserir			*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Insert Into [dbo].[Class_Fiscal](
								  [cod_classfiscal]
								 ,[ipi]
								 ,[id_mensagem]
								 ,[descricao_simplificada]
								 ,[ativo]
								 ,[incl_data]
								 ,[incl_user]
								 ,[incl_device]
								 ,[modi_data]
								 ,[modi_user]
								 ,[modi_device]
								 ,[excl_data]
								 ,[excl_user]
								 ,[excl_device]
								 ,[descricao_completa]
								 ,[neces_lic_imp_comp]
								 ,[carga_perigosa]
								 ,[id_classe_cargaperigosa_tab_padrao]
								 ,[classe_cargaperigosa]
								 ,[id_subclasse_cargaperigosa_tab_padrao]
								 ,[subclasse_cargaperigosa]
								 ,[Venda]
							    )
Select *
,	venda = 'N'
From #LayoutClassFiscal

select *
from Class_Fiscal
order by descricao desc

/* Dar Update Caso Tenha na #Faltantes Casos Tenha Grupo de Estoque que se Pare a com a Base Do thesys */

-- update #faltantes
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Valida se na Base do MBM N o tem Cod da Unidade e Ja Popula Tabela No Thesys		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #LayoutUnidades
Select Distinct
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
Into #LayoutUnidades
From (
		Select 
			Empresa
		,	Descricao_Cod_Unidade
		,	Casas_Dec_Cod_Unidade
		,	Codigo_Item = codigo
		,	Cod_GrupoEstoque       = NovoCodGrupoEstoque
		,	Descricao_GrupoEstoque = NovoNomeGrupoEstoque
		,	Cod_SubgrupoEstoque 
		,	Descricao_SubgrupoEstoque  
		,	Cod_fmcomercial
		,	Descricao_fmcomercial      
		,	Cod_Unidade		
		,	Cod_ClassFiscal	
		,	Descricao_Cod_ClassFiscal
		,	item_venda_grupoestoque
		,	item_producao_grupoestoque
		,	item_compraprodutivo_grupoestoque
		,	item_compranaoprodutivo_grupoestoque
		,	codtp_tipoproduto_grupoestoque
		,	codigo_dominio_grupoestoque
		,	descricao_dominio_grupoestoque
		From #ItensFinal BaseMBM
		where exists (
					  select *
					  from #IdVazios BaseFaltandoId
					  where BaseMBM.codigo = BaseFaltandoId.Codigo
					  and BaseFaltandoId.id_Unidade is null
					 ) 
	 )SubQuery
Where SubQuery.Cod_Unidade Is Not Null
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: N o Tendo Nenhuma Descricao Que Atenda no Thesys, Descomentar e Inserir			*/
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

Select *
From #LayoutUnidades

select *
from Unidades
order by descricao desc
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Separa Apenas 1 Id_Item Por Codigo Para N o Duplicar Na Itens Empresas			*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Insert Into Itens_Empresas
Select *
From (
Select 
	Id_Item					= Max(Itens.Id_Item)
,	Id_Empresa_Grupo		= (Select Id_Empresa_Grupo From Empresas_Grupos Where Nome = 'POLIREX') --> Mudar Aqui Para a Empresa Que Estiver Fazendo!
,	Id_Origem_Merc			= #tp_origem_mercadoria.id_tabela_padrao
,	Id_Familia_Industrial	= familia_industrial.id_familia_industrial
,	Cod_Antigo				= Trim(Fato.Codigo)
,	Cod_Reduzido_Antigo		= Trim(Fato.Cod_Item)
,	incl_data				= getdate()
,	incl_user				= 'ksantana'
,	incl_device				= 'PC'
,	modi_data				= null
,	modi_user				= null
,	modi_device				= null
,	excl_data				= null
,	excl_user				= null
,	excl_device				= null
,	Id_Estoque_Bloqueado	= null
,	Id_Estoque_Local		= null
,	Id_empresa_local		= Null
From #faltantes Fato
Join Itens					    On Itens.codigo collate latin1_general_ci_ai				 = Fato.codigo   --> conferir n de linhas pq causa do join
Left Join #tp_origem_mercadoria On #tp_origem_mercadoria.Codigo collate latin1_general_ci_ai = Fato.Origem_Mercadoria
left Join familia_industrial    On familia_industrial.Descricao collate latin1_general_ci_ai = Fato.Descricao_Fmindustrial
Group By 
	#tp_origem_mercadoria.id_tabela_padrao
,	familia_industrial.id_familia_industrial
,	Trim(Fato.Codigo)
,	Trim(Fato.Cod_Item)
)SubQuery
Where Not Exists (
				  Select *
				  From Itens_Empresas Dim
				  Where Dim.Cod_Reduzido_Antigo = SubQuery.Cod_Reduzido_Antigo collate latin1_general_ci_ai
				  And   Dim.Id_Empresa_Grupo    = SubQuery.Id_Empresa_Grupo
				 )


with cte_duplicate as (
select *
,	rw = row_number() over ( partition by id_empresa_grupo, cod_reduzido_antigo order by id_item asc)
from Itens_Empresas
where id_empresa_grupo = 179
)


delete from Itens_Empresas
where id_item_empresa in (
select id_item_empresa
from cte_duplicate
where rw > 1
)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Separa Para Preencher a Itens Conv Unidades										*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop table if exists #Pre_ItensConvUnidades
Select *
Into #Pre_ItensConvUnidades
From (
	  Select *
	  , rw_2 = row_number() over ( partition by cod_item, cod_item_unidade order by cod_item desc)
	  From #faltantes Fato
	  --Where Fato.controla_estoque = 's'
	  --And Fato.ativo = 's'
	 )SubQuery
Where rw_2 = 1
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Separa Para Preencher a Itens Conv Unidades										*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
--thesys_dev..Itens_Conv_Unidades
insert into Itens_Conv_Unidades
Select 
	Id_Item					
,	Id_Unidade				
,	Id_Unidade_Conversao	
,	Fator_Conversao			
,	Operacao									
,	Qtd_Estoque				
,	Qtd_Estoque_Convertida  
,	Cod_Unidade			    
,	incl_data				
,	incl_user				
,	incl_device				
,	modi_data				
,	modi_user				
,	modi_device				
,	excl_data				
,	excl_user				
,	excl_device				
From (
Select 
--	fato.descricao
--	fato.Cod_Unidade
--,	fato.Cod_Item_Unidade
	Id_Item					= Itens.Id_Item
,	Id_Unidade				= Unidades.id_unidade
,	Id_Unidade_Conversao	= Isnull(Un_2.id_unidade,Unidades.id_unidade)
,	Fator_Conversao			= Fato.fator_item_unidade
,	Operacao				= Case 
								  When Fato.operador_item_unidade = 'D' Then '/' 
								  When Fato.operador_item_unidade = 'M' Then '*' 
								  Else Fato.operador_item_unidade
							  End
,	Qtd_Estoque				= null --Fato.Qtd_Atual_Estoq_Saldo Ver Com o Marcos
,	Qtd_Estoque_Convertida  = null -- Ver Com o Marcos
,	Cod_Unidade			    = Fato.Cod_Unidade
,	incl_data				= getdate()
,	incl_user				= 'ksantana'
,	incl_device				= 'PC'
,	modi_data				= null
,	modi_user				= null
,	modi_device				= null
,	excl_data				= null
,	excl_user				= null
,	excl_device				= null
--,	Id_Estoque_Bloqueado	= null
--,	Id_Estoque_Local		= null
From #Pre_ItensConvUnidades Fato
Join Itens					 On Itens.codigo 	 = Fato.Codigo										collate latin1_general_ci_ai    --> conferir n de linhas pq causa do join
Left Join Unidades			 On Unidades.Codigo  = Fato.Cod_Unidade									collate latin1_general_ci_as 
Left Join Unidades as Un_2   On Un_2.Codigo 	 = Isnull(Fato.Cod_Item_Unidade,Fato.Cod_Unidade)	collate latin1_general_ci_as 
)SubQuery
Where Not Exists (
				  Select *
				  From Itens_Conv_Unidades Dim
				  Where Dim.id_item    = SubQuery.Id_Item
				 )
order by SubQuery.Id_Item desc


--> Nao Pode Existir Casos o Id_Unidade e Id_Unidade_Conversao Sejam Iguais
DELETE 
FROM Itens_Conv_Unidades
WHERE id_unidade = id_unidade_conversao

select *
from (
select 
	id_item
,	codigo
,	descricao
,	dt_inclusao
,	id_unid_negocio
,	rw = row_number() over ( partition by codigo order by dt_inclusao asc) 
from itens
where id_unid_negocio is null --> retira os Itens da IMAGRAF
)SubQuery
where Rw > 1 


-- Passo 1: Identificar os itens duplicados com um ROW_NUMBER para diferenciar cada instância
WITH Duplicados AS (
    SELECT 
        id_item,
        codigo,
        descricao,
        dt_inclusao,
        id_unid_negocio,
        rw = ROW_NUMBER() OVER (PARTITION BY codigo ORDER BY dt_inclusao ASC)
    FROM itens
    WHERE id_unid_negocio IS NULL
)

-- Passo 2: Gerar novos códigos únicos para os duplicados (com rw > 1) adicionando um sufixo
, NovosCodigos AS (
    SELECT 
        id_item,
        codigo,
        descricao,
        dt_inclusao,
        id_unid_negocio,
        rw,
        novo_codigo = CASE 
                         WHEN rw > 1 THEN CONCAT(codigo, '_', 3)
                         ELSE codigo 
                      END
    FROM Duplicados
    WHERE rw > 1
)


--select * from NovosCodigos
-- Passo 3: Atualizar a tabela 'itens' com os novos códigos para duplicados
UPDATE i
SET i.codigo = nc.novo_codigo
FROM itens i
INNER JOIN NovosCodigos nc ON i.id_item = nc.id_item;



--> Valida Se Nao Existe Id_Item Igual Para o Mesmo Id_Empresa_Grupo Com Orige_Merc Diferente
WITH CTE_ItemGrupo AS (
    SELECT 
        *,
        Rw = ROW_NUMBER() OVER (
            PARTITION BY Id_Item, Id_Empresa_Grupo 
            ORDER BY Id_Origem_Merc
        )
    FROM itens_empresas
    WHERE id_empresa_grupo = 14144
)
SELECT *
FROM CTE_ItemGrupo
WHERE Rw > 1; -- Pega apenas os registros com múltiplas origens para o mesmo item/grupo


--> Constraint Que Ja foi Criada, Apenas de Ex.
/*
CREATE UNIQUE INDEX UQ_IdItem_EmpresaGrupo
ON itens_empresas (Id_Item, Id_Empresa_Grupo, Id_Origem_Merc)
WHERE Id_Empresa_Estoque_Local IS NULL
*/