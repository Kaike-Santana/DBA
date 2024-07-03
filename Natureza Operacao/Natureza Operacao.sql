
USE THESYS_HOMOLOGACAO
GO

--> Base MBM Natureza Da Operacao Da Poliresinas
drop table if exists #BaseNatOperacao
select 'POLIRESINAS' AS EMPRESA
,	*
into #BaseNatOperacao
from openquery([mbm_polirex],'
select nat_operacao.*
,	tipodocto.descricao as descricao_tipodocto
from nat_operacao
left join tipodocto on tipodocto.cod_tipodocto = nat_operacao.cod_tipodocto
')

/* 02/07 parte para incluir a mensagem do corpo da NF
select id_mensagem
from #BaseNatOperacao
where cod_natoperacao = '5925-001'

select id_empresa_grupo, id_mensagem, cod_mensagem, cod_msgcorponf
from Natureza_Operacao
where id_NaturezaOperacao = 1360
where cod_natoperacao = '5925-001'
where cod_mensagem is null


begin tran

update fato
set cod_msgcorponf	=	dim.cod_msgcorponf

from Natureza_Operacao fato
join #BaseNatOperacao  dim on dim.cod_natoperacao = fato.cod_natoperacao collate latin1_general_ci_ai 
where fato.id_empresa_grupo = 179

rollback

begin tran

update Natureza_Operacao
set id_mensagem		=	dim.id_mensagem

from Natureza_Operacao fato
join Mensagem		   dim on dim.cod_mensagem = fato.cod_mensagem and dim.id_empresa_grupo = 51123
where fato.id_empresa_grupo = 51123

commit
*/

alter table #BaseNatOperacao  alter column pis_natoperbccredito    varchar(20)
alter table #BaseNatOperacao  alter column cofins_natoperbccredito varchar(20)
alter table #BaseNatOperacao  alter column ipi_codtributacao       varchar(20)

Update #BaseNatOperacao
set pis_natoperbccredito	= Dim.[CÓDIGO]
,	cofins_natoperbccredito	= Dim.[CÓDIGO]

from #BaseNatOperacao Fato
Join Tb_DexPara_PisNatOpCredito Dim On Dim.Pis_CodTrib = Fato.pis_natoperbccredito collate latin1_general_ci_ai 


--> 
Update #BaseNatOperacao
set ipi_codtributacao	= Dim.[CÓDIGO]

from #BaseNatOperacao Fato
Join tb_DexPara_IpiCodTrib Dim On trim(Dim.Ipi_CodTrib) collate latin1_general_ci_ai  = Fato.ipi_codtributacao collate latin1_general_ci_ai 


--> Dexpara Do Código De Tributacao
drop table if exists #Cod_Tributacao
select *
into #Cod_Tributacao
from Tabela_Padrao
where cod_tabelapadrao = 'iss_codigo_tributacao'

Create Nonclustered Index Sku_Cod On  #Cod_Tributacao (codigo)

--> Dexpara Do Código De Documentos Fiscais
drop table if exists #Cod_Doc_Fiscal
select *
into #Cod_Doc_Fiscal
from Tabela_Padrao
where cod_tabelapadrao = 'documentos_fiscais_icms'

Create Nonclustered Index Sku_Cod On #Cod_Doc_Fiscal (codigo)

--> Dexpara Do Código De Documentos Fiscais
drop table if exists #Cod_PisCofins
select *
into #Cod_PisCofins
from Tabela_Padrao
where cod_tabelapadrao = 'piscofins_cst'

Create Nonclustered Index Sku_Cod On #Cod_PisCofins (codigo)

--> Dexpara Do Código De Documentos Fiscais
drop table if exists #Cod_DocFiscais
select *
into #Cod_DocFiscais
from Tabela_Padrao
where cod_tabelapadrao = 'documentos_fiscais_icms'

Create Nonclustered Index Sku_Cod On #Cod_DocFiscais (codigo)

--> Dexpara Do Código Operacao Base Crédito
drop table if exists #Cod_OpBaseCredito
select *
into #Cod_OpBaseCredito
from Tabela_Padrao
where cod_tabelapadrao = 'nat_operacao_base_credito'

Create Nonclustered Index Sku_Cod On #Cod_OpBaseCredito (codigo)

--> Dexpara Do Código De Documentos Fiscais
drop table if exists #Cod_RecDes
select *
into #Cod_RecDes
from Tabela_Padrao
where cod_tabelapadrao = 'codigo_recolhimento_des'

Create Nonclustered Index Sku_Cod On #Cod_RecDes (codigo)

--> Dexpara Do Código De IPI CST
drop table if exists #Cod_IpiCst
select *
into #Cod_IpiCst
from Tabela_Padrao
where cod_tabelapadrao = 'ipi_cst'

Create Nonclustered Index Sku_Cod On #Cod_IpiCst (codigo)

--> Dexpara Do Código Nfe Finalidade
drop table if exists #Cod_NfeFinalidade
select *
into #Cod_NfeFinalidade
from Tabela_Padrao
where cod_tabelapadrao = 'nfe_finalidade'

Create Nonclustered Index Sku_Cod On #Cod_NfeFinalidade (codigo)



INSERT INTO [THESYS_HOMOLOGACAO]..[Natureza_Operacao]
           ([id_SetupNaturezaOperacao]
           ,[id_empresa]		
           ,[id_empresa_grupo]
           ,[empresa]
           ,[cod_natoperacao]
           ,[id_tiponatureza]
           ,[cod_tiponatureza]
           ,[descricao]
           ,[id_tributacao]
           ,[cod_tributacao]
           ,[id_serie]
           ,[descricao_serie]
           ,[venda]
           ,[compra]
           ,[devolucao]
           ,[remessa]
           ,[retorno]
           ,[controla_terceiro]
           ,[calcula_piscofinsclass]
           ,[id_tipodocumento]
           ,[id_mensagem]
           ,[cod_mensagem]
           ,[id_cfop]
           ,[cfop]
           ,[gera_duplicata]
           ,[desc_nota]
           ,[entrada_saida]
           ,[tributacao]
           ,[baixa_estoque]
           ,[gera_obrig_fiscais]
           ,[pis]
           ,[gera_integr_contabil]
           ,[ir_retidofonte]
           ,[cofins]
           ,[iss_retidofonte]
           ,[cc_frete]
           ,[inss_retidofonte]
           ,[cc_seguro]
           ,[cc_outrasdesp]
           ,[frete_incidebaseipi]
           ,[outras_incidebaseipi]
           ,[icms_tipobase]
           ,[tipo_incidebase_icms]
           ,[icms_incidebase_icms]
           ,[frete_incidebase_icms]
           ,[desc_zonafranca]
           ,[aliq_iss]
           ,[seguro_incidebase_icms]
           ,[desp_incidebase_icms]
           ,[ativo]
           ,[icms_recuperavel]
           ,[ipi_tipobase]
           ,[calculo_custo]
           ,[ipi_codtributacao]
           ,[ipi_perc_reducao]
           ,[pis_retidofonte]
           ,[seguro_incidebaseipi]
           ,[ipi_incidebase_icms]
           ,[cofins_retidofonte]
           ,[ipi_recuperavel]
           ,[pis_codtributacao]
           ,[pis_recuperavel]
           ,[cofins_codtributacao]
           ,[cofins_recuperavel]
           ,[aliq_inss]
           ,[iss_perc_reducao]
           ,[aliq_csll]
           ,[cod_msgcorponf]
           ,[substituicao_tributaria]
           ,[csll_retidofonte]
           ,[tipo_msgsubstituicao]
           ,[calcular_icms]
           ,[modelo_fiscal]
           ,[tipo_movtoestoque]
           ,[perc_recuperavelipi]
           ,[destino_reducaoipi]
           ,[zona_franca]
           ,[especie]
           ,[gerar_lanctoproduto]
           ,[ii_incidebase_ipi]
           ,[ii_incidebase_icms]
           ,[cofins_incidebase_icms]
           ,[pis_incidebase_icms]
           ,[add_icmstotalnf]
           ,[gerarnf_operatriangular]
           ,[cod_natopertriang]
           ,[aliq_ir]
           ,[utilizar_msgtributacao]
           ,[utilizar_msgclassfiscal]
           ,[frete_incidebase_pis]
           ,[frete_incidebase_cofins]
           ,[seguro_incidebase_pis]
           ,[seguro_incidebase_cofins]
           ,[outras_incidebase_pis]
           ,[outras_incidebase_cofins]
           ,[cod_recolhimentodes]
           ,[destacar_ipinf]
           ,[add_icmssubtotalnf]
           ,[gerar_comissao]
           ,[ir_valminimo]
           ,[add_icmssubtotaldup]
           ,[destacar_icmssubnf]
           ,[naoconsiderar_iiporitem]
           ,[tipo_aliqicmssubst]
           ,[aliq_icms_subst]
           ,[ler_icmssubndest]
           ,[inss_perc_reducao]
           ,[iss_codtributacao]
           ,[id_iss_codtributacao]
           ,[nfe_finalidade]
           ,[diminuir_icmsopicmsst]
           ,[pis_natoperbccredito]
           ,[cofins_natoperbccredito]
           ,[fci_resolucao13_2012]
           ,[lei_transparencia]
           ,[perc_adic_cofins_imp]
           ,[cod_pis_retido]
           ,[cod_cofins_retido]
           ,[cod_csll_retido]
           ,[cod_irrf_retido]
           ,[cod_inss_retido]
           ,[ipi_nao_aproveitavel]
           ,[pis_cofins_sobre_vladuaneiro]
           ,[perc_base_icms_subst]
           ,[exportar_zfm]
           ,[motdesicms]
           ,[ipi_enquadramento]
           ,[destacar_cest]
           ,[cod_tipopedcompra]
           ,[cod_tipopedvenda]
           ,[bcst_dimalqicmsop_addalqicmsst]
           ,[id_acumuladorfiscal]
           ,[cod_espdoctodominio]
           ,[cod_acumuladordominio]
           ,[nfe_destacarunidadeexp]
           ,[ii_embutidovaloritem]
           ,[considerar_impostodev]
           ,[fcpicms_tipobase]
           ,[tributacao_fcpicms]
           ,[cod_tributacaofcpicms]
           ,[piscofins_classfiscal]
           ,[frete_incidezonafranca]
           ,[icmssub_calculobasedupla]
           ,[modbc_icmsst]
           ,[deduzir_icmsbasepis]
           ,[deduzir_icmsbasecofins]
           ,[gera_gruporastromedxml]
           ,[gera_grprastromedindpres0]
           ,[gera_grprastromedindpres1]
           ,[gera_grprastromedindpres4]
           ,[gera_grprastromedindpres5]
           ,[gera_grprastromedindpres9]
           ,[id_documentos_fiscais_tabela_padrao]
           ,[id_pis_codtributacao_tabela_padrao]
           ,[id_documentos_fiscais_icms_tabela_padrao]
           ,[id_cofins_codtributacao_tabela_padrao]
           ,[id_pis_nat_operacao_base_credito]
           ,[id_cofins_nat_operacao_base_credito]
           ,[id_codigo_recolhimento_des_tabela_padrao]
           ,[id_ipi_codigo_tributacao]
           ,[id_nfe_finalidade_tab_padrao]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device]
           ,[icms_modBC]
           ,[icms_modBCST]
           ,[icms_desoneracao_zona_franca]
           ,[icms_desoneracao_desconto_perc]
           ,[icms_desoneracao_desconto_perc_aplicacao]
           ,[icms_desoneracao_motivo]
           ,[icms_desoneracao_deduzir_valor_total_nf])

		   Empresas_Grupos

--> Verificar qual o ID da Empresa no Where na tabela Empresas do Homologacao Para Colocar o ID Certo no Select.
select 
	  [Id_SetupNaturezaOperacao]  = Nt.Id_NatOp_Setup_Compras
,	  [id_empresa]				  = (select Id_Empresa from empresas where nome = 'POLI RESINAS') --> Se a Empresa Tiver mais de um ID, deixar NULL
,	  [id_empresa_grupo]		  = (select Id_Empresa_Grupo from Empresas_Grupos where nome = 'POLI RESINAS') --> Mudar aqui para empresa que estver atualizando 
,	  [empresa]					  = (select nome from Empresas_Grupos where nome = 'POLI RESINAS') --> Mudar aqui para empresa que estver atualizando 
,	  [cod_natoperacao]
,	  [id_tiponatureza]			  = Natureza_Operacao_tipos.id_tiponatureza
,	  fato.[cod_tiponatureza]
,	  fato.[descricao]
,	  [id_tributacao]			  = tributacao.id_tributacao
,	  fato.[cod_tributacao]
,	  [id_serie]				  = series.id_serie_conta
,	  [descricao_serie]			  = fato.cod_serie
,	  [venda]					  = case when fato.descricao like 'ven%'	then 'S' else 'N' end
,	  [compra]					  = case when fato.descricao like 'com%'	then 'S' else 'N' end
,	  [devolucao]				  = case when fato.descricao like 'dev%'	then 'S' else 'N' end
,	  [remessa]					  = case when fato.descricao like 'rem%'	then 'S' else 'N' end
,	  [retorno]					  = case when fato.descricao like 'ret%'	then 'S' else 'N' end
,	  [controla_terceiro]		  = case when fato.descricao like 'terce%'  then 'S' else 'N' end
,	  [calcula_piscofinsclass]    = Isnull(fato.piscofins_classfiscal,'N')
,	  [id_tipodocumento]		  = Tipos_Documentos.id_tipodoc
,	  [id_mensagem]			      = mensagem.id_mensagem
,	  [cod_mensagem]			  = fato.cod_msgcorponf --> antes era cod_mensagem, thanner pediu para mudar.
,	  [id_cfop]					  = cfop.id_cfop
,	  [cfop]					  = replace(fato.cfo,'.','')
,	  [gera_duplicata]
,	  [desc_nota]
,	  fato.[entrada_saida]
,	  [tributacao]
,	  [baixa_estoque]
,	  [gera_obrig_fiscais]
,	  [pis]
,	  [gera_integr_contabil]
,	  [ir_retidofonte]
,	  [cofins]
,	  [iss_retidofonte]
,	  [cc_frete]
,	  [inss_retidofonte]
,	  [cc_seguro]
,	  [cc_outrasdesp]
,	  [frete_incidebaseipi]
,	  [outras_incidebaseipi]
,	  [icms_tipobase]
,	  [tipo_incidebase_icms]
,	  [icms_incidebase_icms]
,	  [frete_incidebase_icms]
,	  [desc_zonafranca]
,	  [aliq_iss]
,	  [seguro_incidebase_icms]
,	  [desp_incidebase_icms]
,	  fato.[ativo]
,	  [icms_recuperavel]
,	  [ipi_tipobase]
,	  [calculo_custo]
,	  [ipi_codtributacao]
,	  [ipi_perc_reducao]
,	  [pis_retidofonte]
,	  [seguro_incidebaseipi]
,	  [ipi_incidebase_icms]
,	  [cofins_retidofonte]
,	  [ipi_recuperavel]
,	  [pis_codtributacao]	 = #Cod_PisCofins.codigo
,	  [pis_recuperavel]
,	  [cofins_codtributacao] = #Cod_PisCofins.codigo
,	  [cofins_recuperavel]
,	  [aliq_inss]
,	  [iss_perc_reducao]
,	  [aliq_csll]
,	  [cod_msgcorponf]
,	  [substituicao_tributaria]
,	  [csll_retidofonte]
,	  [tipo_msgsubstituicao]
,	  [calcular_icms]
,	  [modelo_fiscal]
,	  [tipo_movtoestoque]
,	  [perc_recuperavelipi]
,	  [destino_reducaoipi]
,	  [zona_franca]
,	  [especie]
,	  [gerar_lanctoproduto]
,	  [ii_incidebase_ipi]
,	  [ii_incidebase_icms]
,	  [cofins_incidebase_icms]
,	  [pis_incidebase_icms]
,	  [add_icmstotalnf]
,	  [gerarnf_operatriangular]
,	  [cod_natopertriang]
,	  [aliq_ir]
,	  [utilizar_msgtributacao]
,	  [utilizar_msgclassfiscal]
,	  [frete_incidebase_pis]
,	  [frete_incidebase_cofins]
,	  [seguro_incidebase_pis]
,	  [seguro_incidebase_cofins]
,	  [outras_incidebase_pis]
,	  [outras_incidebase_cofins]
,	  [cod_recolhimentodes]
,	  [destacar_ipinf]
,	  [add_icmssubtotalnf]
,	  [gerar_comissao]
,	  [ir_valminimo]
,	  [add_icmssubtotaldup]
,	  [destacar_icmssubnf]
,	  [naoconsiderar_iiporitem]
,	  [tipo_aliqicmssubst]
,	  [aliq_icms_subst]
,	  [ler_icmssubndest]
,	  [inss_perc_reducao]
,	  [iss_codtributacao]
,	  [id_iss_codtributacao]	=	#Cod_Tributacao.id_tabela_padrao
,	  [nfe_finalidade]
,	  [diminuir_icmsopicmsst]
,	  [pis_natoperbccredito]
,	  [cofins_natoperbccredito]
,	  [fci_resolucao13_2012]
,	  [lei_transparencia]
,	  [perc_adic_cofins_imp]
,	  [cod_pis_retido]
,	  [cod_cofins_retido]
,	  [cod_csll_retido]
,	  [cod_irrf_retido]
,	  [cod_inss_retido]
,	  [ipi_nao_aproveitavel]
,	  [pis_cofins_sobre_vladuaneiro]
,	  [perc_base_icms_subst]
,	  [exportar_zfm]
,	  [motdesicms]
,	  [ipi_enquadramento]
,	  [destacar_cest]
,	  [cod_tipopedcompra]
,	  [cod_tipopedvenda]
,	  [bcst_dimalqicmsop_addalqicmsst]
,	  [id_acumuladorfiscal] = Acumulador_Fiscal.id_acumulador
,	  [cod_espdoctodominio]
,	  [cod_acumuladordominio]
,	  [nfe_destacarunidadeexp]
,	  [ii_embutidovaloritem]
,	  [considerar_impostodev]
,	  [fcpicms_tipobase]
,	  [tributacao_fcpicms]
,	  [cod_tributacaofcpicms]
,	  [piscofins_classfiscal]
,	  [frete_incidezonafranca]
,	  [icmssub_calculobasedupla]
,	  [modbc_icmsst]
,	  [deduzir_icmsbasepis]
,	  [deduzir_icmsbasecofins]
,	  [gera_gruporastromedxml]
,	  [gera_grprastromedindpres0]
,	  [gera_grprastromedindpres1]
,	  [gera_grprastromedindpres4]
,	  [gera_grprastromedindpres5]
,	  [gera_grprastromedindpres9]
,	  [id_documentos_fiscais_tabela_padrao]		 = null
,	  [id_pis_codtributacao_tabela_padrao]		 = #Cod_PisCofins.id_tabela_padrao
,	  [id_documentos_fiscais_icms_tabela_padrao] = #Cod_Doc_Fiscal.id_tabela_padrao
,	  [id_cofins_codtributacao_tabela_padrao]	 = #Cod_PisCofins.id_tabela_padrao
,	  [id_pis_nat_operacao_base_credito]		 = #Cod_OpBaseCredito.id_tabela_padrao
,	  [id_cofins_nat_operacao_base_credito]		 = #Cod_OpBaseCredito.id_tabela_padrao
,	  [id_codigo_recolhimento_des_tabela_padrao] = #Cod_RecDes.id_tabela_padrao
,	  [id_ipi_codigo_tributacao]			     = #Cod_IpiCst.id_tabela_padrao
,	  [id_nfe_finalidade_tab_padrao]			 = #Cod_NfeFinalidade.id_tabela_padrao
,	  [incl_data]								 = getdate()
,	  [incl_user]								 = 'ksantana'
,	  [incl_device]								 = null
,	  [modi_data]								 = null
,	  [modi_user]								 = null
,	  [modi_device]								 = null
,	  [excl_data]								 = null
,	  [excl_user]								 = null
,	  [excl_device]								 = null
,	  [icms_modBC]								 = null
,	  [icms_modBCST]							 = null
,	  [icms_desoneracao_zona_franca]			 = null
,	  [icms_desoneracao_desconto_perc]			 = null
,	  [icms_desoneracao_desconto_perc_aplicacao] = null
,	  [icms_desoneracao_motivo]					 = null
,	  [icms_desoneracao_deduzir_valor_total_nf]	 = null
from #BaseNatOperacao Fato
Left Join Natureza_Operacao_Setup_Compras Nt on nt.Cod_NaturezaOperacao				     = fato.Cod_NatOperacao			collate latin1_general_ci_ai And Nt.Id_Empresa_Grupo = 1584
Left Join Natureza_Operacao_tipos            on Natureza_Operacao_tipos.cod_tiponatureza = fato.cod_tiponatureza		collate latin1_general_ci_ai
Left Join Tributacao			             on Tributacao.cod_tributacao				 = fato.cod_tributacao			collate latin1_general_ci_ai
Left Join series						     on series.cod_serie					     = fato.cod_serie				collate latin1_general_ci_ai And Series.id_empresa = 4 --> Se a Empresa Tiver + 1 ID, Escolher Apenas 1
Left Join #Cod_Tributacao					 on #Cod_Tributacao.codigo                   = fato.iss_codtributacao		collate latin1_general_ci_ai
Left Join Tipos_Documentos				     on Tipos_Documentos.descricao				 = fato.descricao_tipodocto		collate latin1_general_ci_ai
Left Join Mensagem	    				     on Mensagem.cod_mensagem					 = fato.cod_mensagem			collate latin1_general_ci_ai And Mensagem.id_empresa_grupo = 1584
Left Join CFOP	    						 on CFOP.cfop					    		 = replace(fato.cfo,'.','')		collate latin1_general_ci_ai 
Left Join Acumulador_Fiscal	    			 on Acumulador_Fiscal.codigo				 = fato.cod_acumuladordominio  
Left Join #Cod_Doc_Fiscal	    			 on #Cod_Doc_Fiscal.codigo					 = fato.modelo_fiscal			collate latin1_general_ci_ai 
Left Join #Cod_PisCofins	    			 on #Cod_PisCofins.codigo					 = fato.ci_pis_cofins			collate latin1_general_ci_ai   
Left Join #Cod_OpBaseCredito	    		 on #Cod_OpBaseCredito.codigo				 = fato.pis_natoperbccredito	collate latin1_general_ci_ai  
Left Join #Cod_RecDes	    				 on #Cod_RecDes.codigo				    	 = fato.cod_recolhimentodes     collate latin1_general_ci_ai  
Left Join #Cod_IpiCst	    				 on #Cod_IpiCst.codigo				    	 = fato.ipi_codtributacao		collate latin1_general_ci_ai  
Left Join #Cod_NfeFinalidade	    		 on #Cod_NfeFinalidade.codigo				 = fato.nfe_finalidade			collate latin1_general_ci_ai