
Use Thesys_Dev
Go

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* Programador: Kaike Natan									                                    */
/* Versao     : Data: 02/08/2024																*/
/* Descricao  : Script de ETL da Base de Movimentos de Estoque do MBM Para o TheSys				*/
/*																								*/
/*	Alteracao                                                                                   */
/*        2. Programador: 													 Data: __/__/____	*/		
/*           Descricao  : 																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	Create Procedure Prc_Etl_Estoque_Movimentos_MBM as 
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Consolida a Base Movimentos de Estoque das 5 Empresas do MBM						*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #BaseEstMovimentos 
Select *
,	Pk = Trim(Cod_Empresa) + Trim(Nro_Transacao)
Into #BaseEstMovimentos
From OpenQuery([Mbm_PoliResinas],'
Select 
  Estoq_Movto.nro_transacao, 
  Estoq_Movto.cod_empresa, 
  Estoq_Movto.cod_deposito,  
  Estoq_Movto.cod_natoperacao, 
  Estoq_Movto.nro_documento, 
  Estoq_Movto.cod_item, 
  Estoq_Movto.cod_clifor, 
  Clifor.cgc_cpf,
  Clifor.razao,
  Estoq_Movto.nro_pedidocompra, 
  Estoq_Movto.nro_ordemproducao, 
  Estoq_Movto.cod_serie, 
  Estoq_Movto.qtd_transacao, 
  Estoq_Movto.dt_entrada, 
  Estoq_Movto.nro_lote, 
  Estoq_Movto.validade, 
  Estoq_Movto.sequencia, 
  Estoq_Movto.custo_medio, 
  Estoq_Movto.seq_pedidocompraitem, 
  Estoq_Movto.qtd_fornec, 
  Estoq_Movto.custo_reposicao, 
  Estoq_Movto.preco_venda, 
  Estoq_Movto.preco_movimento, 
  Estoq_Movto.qtd_inventario, 
  Estoq_Movto.hora_transacao, 
  Estoq_Movto.tipo_transacao,  
  Estoq_Movto.somente_valor, 
  Estoq_Movto.qtd_rejeitada, 
  Estoq_Movto.peso_bruto, 
  Estoq_Movto.dt_cancelado, 
  Estoq_Movto.usuario_cancelou, 
  Estoq_Movto.motivo_cancelou, 
  Estoq_Movto.custo_standard, 
  Estoq_Movto.peso, 
  Estoq_Movto.dt_movimento, 
  Estoq_Movto.dt_transacao, 
  Estoq_Movto.cod_localizacao, 
  Estoq_Movto.atualiza_demanda, 
  Estoq_Movto.entrada_saida, 
  Estoq_Movto.lote_fornec, 
  Estoq_Movto.movimenta_estoque, 
  Estoq_Movto.seq_notaitem, 
  Estoq_Movto.movimenta_estoqterceiro, 
  Estoq_Movto.situacao, 
  Estoq_Movto.texto_livre, 
  Estoq_Movto.descricao,  
  Estoq_Movto.custo_kardex, 
  Estoq_Movto.custo_kardexatualizado,    
  Estoq_Movto.exportar_spedblocok, 
  Estoq_Movto.dt_fabricacaolote,
  Estoq_Movto.cod_fci, 
  Estoq_Movto.cod_similarpai
From Estoq_Movto
Left Join Clifor On Clifor.Cod_Clifor = Estoq_Movto.Cod_Clifor
')

Union All

Select *
,	Pk = Trim(Cod_Empresa) + Trim(Nro_Transacao)
From OpenQuery([mbm_rubberon],'
Select 
  Estoq_Movto.nro_transacao, 
  Estoq_Movto.cod_empresa, 
  Estoq_Movto.cod_deposito,  
  Estoq_Movto.cod_natoperacao, 
  Estoq_Movto.nro_documento, 
  Estoq_Movto.cod_item, 
  Estoq_Movto.cod_clifor, 
  Clifor.cgc_cpf,
  Clifor.razao,
  Estoq_Movto.nro_pedidocompra, 
  Estoq_Movto.nro_ordemproducao, 
  Estoq_Movto.cod_serie, 
  Estoq_Movto.qtd_transacao, 
  Estoq_Movto.dt_entrada, 
  Estoq_Movto.nro_lote, 
  Estoq_Movto.validade, 
  Estoq_Movto.sequencia, 
  Estoq_Movto.custo_medio, 
  Estoq_Movto.seq_pedidocompraitem, 
  Estoq_Movto.qtd_fornec, 
  Estoq_Movto.custo_reposicao, 
  Estoq_Movto.preco_venda, 
  Estoq_Movto.preco_movimento, 
  Estoq_Movto.qtd_inventario, 
  Estoq_Movto.hora_transacao, 
  Estoq_Movto.tipo_transacao,  
  Estoq_Movto.somente_valor, 
  Estoq_Movto.qtd_rejeitada, 
  Estoq_Movto.peso_bruto, 
  Estoq_Movto.dt_cancelado, 
  Estoq_Movto.usuario_cancelou, 
  Estoq_Movto.motivo_cancelou, 
  Estoq_Movto.custo_standard, 
  Estoq_Movto.peso, 
  Estoq_Movto.dt_movimento, 
  Estoq_Movto.dt_transacao, 
  Estoq_Movto.cod_localizacao, 
  Estoq_Movto.atualiza_demanda, 
  Estoq_Movto.entrada_saida, 
  Estoq_Movto.lote_fornec, 
  Estoq_Movto.movimenta_estoque, 
  Estoq_Movto.seq_notaitem, 
  Estoq_Movto.movimenta_estoqterceiro, 
  Estoq_Movto.situacao, 
  Estoq_Movto.texto_livre, 
  Estoq_Movto.descricao,  
  Estoq_Movto.custo_kardex, 
  Estoq_Movto.custo_kardexatualizado,    
  Estoq_Movto.exportar_spedblocok, 
  Estoq_Movto.dt_fabricacaolote,
  Estoq_Movto.cod_fci, 
  Estoq_Movto.cod_similarpai
From Estoq_Movto
Left Join Clifor On Clifor.Cod_Clifor = Estoq_Movto.Cod_Clifor
Where Estoq_Movto.Cod_Empresa != ''001''')

Union All

Select *
,	Pk = Trim(Cod_Empresa) + Trim(Nro_Transacao)
From OpenQuery([Mbm_Mg_Polimeros],'
Select 
  Estoq_Movto.nro_transacao, 
  Estoq_Movto.cod_empresa, 
  Estoq_Movto.cod_deposito,  
  Estoq_Movto.cod_natoperacao, 
  Estoq_Movto.nro_documento, 
  Estoq_Movto.cod_item, 
  Estoq_Movto.cod_clifor, 
  Clifor.cgc_cpf,
  Clifor.razao,
  Estoq_Movto.nro_pedidocompra, 
  Estoq_Movto.nro_ordemproducao, 
  Estoq_Movto.cod_serie, 
  Estoq_Movto.qtd_transacao, 
  Estoq_Movto.dt_entrada, 
  Estoq_Movto.nro_lote, 
  Estoq_Movto.validade, 
  Estoq_Movto.sequencia, 
  Estoq_Movto.custo_medio, 
  Estoq_Movto.seq_pedidocompraitem, 
  Estoq_Movto.qtd_fornec, 
  Estoq_Movto.custo_reposicao, 
  Estoq_Movto.preco_venda, 
  Estoq_Movto.preco_movimento, 
  Estoq_Movto.qtd_inventario, 
  Estoq_Movto.hora_transacao, 
  Estoq_Movto.tipo_transacao,  
  Estoq_Movto.somente_valor, 
  Estoq_Movto.qtd_rejeitada, 
  Estoq_Movto.peso_bruto, 
  Estoq_Movto.dt_cancelado, 
  Estoq_Movto.usuario_cancelou, 
  Estoq_Movto.motivo_cancelou, 
  Estoq_Movto.custo_standard, 
  Estoq_Movto.peso, 
  Estoq_Movto.dt_movimento, 
  Estoq_Movto.dt_transacao, 
  Estoq_Movto.cod_localizacao, 
  Estoq_Movto.atualiza_demanda, 
  Estoq_Movto.entrada_saida, 
  Estoq_Movto.lote_fornec, 
  Estoq_Movto.movimenta_estoque, 
  Estoq_Movto.seq_notaitem, 
  Estoq_Movto.movimenta_estoqterceiro, 
  Estoq_Movto.situacao, 
  Estoq_Movto.texto_livre, 
  Estoq_Movto.descricao,  
  Estoq_Movto.custo_kardex, 
  Estoq_Movto.custo_kardexatualizado,    
  Estoq_Movto.exportar_spedblocok, 
  Estoq_Movto.dt_fabricacaolote,
  Estoq_Movto.cod_fci, 
  Estoq_Movto.cod_similarpai
From Estoq_Movto
Left Join Clifor On Clifor.Cod_Clifor = Estoq_Movto.Cod_Clifor
Where Estoq_Movto.Cod_Empresa Not In (''001'',''300'')')

Union All

Select *
,	Pk = Trim(Cod_Empresa) + Trim(Nro_Transacao)
From OpenQuery([Mbm_Polirex],'
Select 
  Estoq_Movto.nro_transacao, 
  Estoq_Movto.cod_empresa, 
  Estoq_Movto.cod_deposito,  
  Estoq_Movto.cod_natoperacao, 
  Estoq_Movto.nro_documento, 
  Estoq_Movto.cod_item, 
  Estoq_Movto.cod_clifor, 
  Clifor.cgc_cpf,
  Clifor.razao,
  Estoq_Movto.nro_pedidocompra, 
  Estoq_Movto.nro_ordemproducao, 
  Estoq_Movto.cod_serie, 
  Estoq_Movto.qtd_transacao, 
  Estoq_Movto.dt_entrada, 
  Estoq_Movto.nro_lote, 
  Estoq_Movto.validade, 
  Estoq_Movto.sequencia, 
  Estoq_Movto.custo_medio, 
  Estoq_Movto.seq_pedidocompraitem, 
  Estoq_Movto.qtd_fornec, 
  Estoq_Movto.custo_reposicao, 
  Estoq_Movto.preco_venda, 
  Estoq_Movto.preco_movimento, 
  Estoq_Movto.qtd_inventario, 
  Estoq_Movto.hora_transacao, 
  Estoq_Movto.tipo_transacao,  
  Estoq_Movto.somente_valor, 
  Estoq_Movto.qtd_rejeitada, 
  Estoq_Movto.peso_bruto, 
  Estoq_Movto.dt_cancelado, 
  Estoq_Movto.usuario_cancelou, 
  Estoq_Movto.motivo_cancelou, 
  Estoq_Movto.custo_standard, 
  Estoq_Movto.peso, 
  Estoq_Movto.dt_movimento, 
  Estoq_Movto.dt_transacao, 
  Estoq_Movto.cod_localizacao, 
  Estoq_Movto.atualiza_demanda, 
  Estoq_Movto.entrada_saida, 
  Estoq_Movto.lote_fornec, 
  Estoq_Movto.movimenta_estoque, 
  Estoq_Movto.seq_notaitem, 
  Estoq_Movto.movimenta_estoqterceiro, 
  Estoq_Movto.situacao, 
  Estoq_Movto.texto_livre, 
  Estoq_Movto.descricao,  
  Estoq_Movto.custo_kardex, 
  Estoq_Movto.custo_kardexatualizado,    
  Estoq_Movto.exportar_spedblocok, 
  Estoq_Movto.dt_fabricacaolote,
  Estoq_Movto.cod_fci, 
  Estoq_Movto.cod_similarpai
From Estoq_Movto
Left Join Clifor On Clifor.Cod_Clifor = Estoq_Movto.Cod_Clifor
Where Estoq_Movto.Cod_Empresa != ''001''')

Union All

Select *
,	Pk = Trim(Cod_Empresa) + Trim(Nro_Transacao)
From OpenQuery([Mbm_NorteBag],'
Select 
  Estoq_Movto.nro_transacao, 
  Estoq_Movto.cod_empresa, 
  Estoq_Movto.cod_deposito,  
  Estoq_Movto.cod_natoperacao, 
  Estoq_Movto.nro_documento, 
  Estoq_Movto.cod_item, 
  Estoq_Movto.cod_clifor, 
  Clifor.cgc_cpf,
  Clifor.razao,
  Estoq_Movto.nro_pedidocompra, 
  Estoq_Movto.nro_ordemproducao, 
  Estoq_Movto.cod_serie, 
  Estoq_Movto.qtd_transacao, 
  Estoq_Movto.dt_entrada, 
  Estoq_Movto.nro_lote, 
  Estoq_Movto.validade, 
  Estoq_Movto.sequencia, 
  Estoq_Movto.custo_medio, 
  Estoq_Movto.seq_pedidocompraitem, 
  Estoq_Movto.qtd_fornec, 
  Estoq_Movto.custo_reposicao, 
  Estoq_Movto.preco_venda, 
  Estoq_Movto.preco_movimento, 
  Estoq_Movto.qtd_inventario, 
  Estoq_Movto.hora_transacao, 
  Estoq_Movto.tipo_transacao,  
  Estoq_Movto.somente_valor, 
  Estoq_Movto.qtd_rejeitada, 
  Estoq_Movto.peso_bruto, 
  Estoq_Movto.dt_cancelado, 
  Estoq_Movto.usuario_cancelou, 
  Estoq_Movto.motivo_cancelou, 
  Estoq_Movto.custo_standard, 
  Estoq_Movto.peso, 
  Estoq_Movto.dt_movimento, 
  Estoq_Movto.dt_transacao, 
  Estoq_Movto.cod_localizacao, 
  Estoq_Movto.atualiza_demanda, 
  Estoq_Movto.entrada_saida, 
  Estoq_Movto.lote_fornec, 
  Estoq_Movto.movimenta_estoque, 
  Estoq_Movto.seq_notaitem, 
  Estoq_Movto.movimenta_estoqterceiro, 
  Estoq_Movto.situacao, 
  Estoq_Movto.texto_livre, 
  Estoq_Movto.descricao,  
  Estoq_Movto.custo_kardex, 
  Estoq_Movto.custo_kardexatualizado,    
  Estoq_Movto.exportar_spedblocok, 
  Estoq_Movto.dt_fabricacaolote,
  Estoq_Movto.cod_fci, 
  Estoq_Movto.cod_similarpai
From Estoq_Movto
Left Join Clifor On Clifor.Cod_Clifor = Estoq_Movto.Cod_Clifor
Where Estoq_Movto.Cod_Empresa != ''001''')

Print (Convert(Char(20),GetDate(),20) + '| ' +  'OpenQuery da Base MBM:' + ' OK! ')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Limpa os Caracteres Especiais das Coluna de CNPJ e CPF da Base do MBM				*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Update #BaseEstMovimentos
Set Cgc_Cpf = Dbo.Fn_Limpa_NoNum(Cgc_Cpf)

Print (Convert(Char(20),GetDate(),20) + '| ' +  'Retirando Acentos das Colunas CNPJ/CPF:' + ' OK! ')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Limpa os Caracteres Especiais das Coluna de CNPJ e CPF da Tabela Clifor			*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #AuxCLifor
Select *
,	Cnpj_C = Dbo.Fn_Limpa_NoNum(Cnpj)
,	Cpf_C  = Dbo.Fn_Limpa_NoNum(Cpf)
Into #AuxCLifor
From Clifor

Print (Convert(Char(20),GetDate(),20) + '| ' +  'ETL CNPJ/CPF Clifor:' + ' OK! ')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Criacao dos Indices Compostos Para Melhor Performance no Join						*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Begin
	Create NonClustered Index idx_Fato_Cgc_Cpf  On #BaseEstMovimentos (Cgc_Cpf, Razao)
	Create NonClustered Index idx_Clifor_Cnpj_C On #AuxCLifor         (Cnpj_C, Cpf_C, Razao);
End
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Filtra da Base Apenas os Clifor´s Que Sao Nacionais								*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #Final
Select
	Empresas.Id_Empresa_Grupo
,	Empresas.Id_Empresa
,	Fato.*
,	Pk_Nf	  = Trim(Cod_Empresa) + Trim(Fato.Cod_Clifor) + Trim(Cod_Serie) + Trim(Nro_Documento)
,	Pk_Nfi	  = Trim(Cod_Empresa) + Trim(Fato.Cod_Clifor) + Trim(Cod_Serie) + Trim(Nro_Documento) + Convert(Varchar(50),Seq_NotaItem)
,	Pk_Cp	  = Trim(Cod_Empresa) + Trim(Nro_PedidoCompra)
,	Pk_Cpi	  = Trim(Cod_Empresa) + Trim(Nro_PedidoCompra) + Cast(Seq_PedidoCompraItem As Varchar(50))
,	Pk_Op     = Trim(Cod_Empresa) + Trim(Nro_OrdemProducao)
,	Id_Clifor = Clifor.Cod_Clifor
Into #Final
From #BaseEstMovimentos Fato
Join Empresas On Empresas.Codigo_Antigo = Fato.Cod_Empresa Collate latin1_general_ci_ai 
Left Join #AuxCLifor Clifor 
    On  ( Isnull(Clifor.Cnpj_C, Clifor.Cpf_C) = Fato.Cgc_Cpf Collate latin1_general_ci_ai 
    And   Fato.Cgc_Cpf Not In ('00000000000', '00000000000000')
		)

    Or  ( Clifor.Razao = Fato.Razao Collate latin1_general_ci_ai 
    And   Fato.Cgc_Cpf In ('00000000000', '00000000000000')
	    )

Print (Convert(Char(20),GetDate(),20) + '| ' +  'Inclusao do Id_Clifor na Base:' + ' OK! ')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Adiciona a Descriçâo do Item na Tabela Itens Empresas								*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #Itens_Company
Select 
	Itens_Empresas.*
,	Itens.descricao		 
Into #Itens_Company
From Itens_Empresas
Left Join Itens On Itens.Id_Item = Itens_Empresas.Id_Item

Print (Convert(Char(20),GetDate(),20) + '| ' +  'Temporaria Item Empresas:' + ' OK! ')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Garante a Integridade dos Dados de Acordo Com a PK do MBM							*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Insert Into [Dbo].[Estoque_Movimentos] 
           (
			[id_empresa]
           ,[id_clifor]
           ,[id_deposito]
           ,[id_tipo_mov]
           ,[id_natoperacao]
           ,[situacao]
           ,[dt_transacao]
           ,[hora_transacao]
           ,[entrada_saida]
           ,[dt_fabricacaolote]
           ,[id_localizacao]
           ,[id_nf]
           ,[id_nfi]
           ,[id_item]
           ,[id_pedidocompra]
           ,[id_pedcompraitem]
           ,[id_pedidovenda]
           ,[id_pedvendaitem]
           ,[documento]
           ,[lote]
           ,[validade]
           ,[peso]
           ,[peso_bruto]
           ,[custo_medio]
           ,[preco_venda]
           ,[preco_movimento]
           ,[somente_valor]
           ,[custo_kardex]
           ,[custo_kardexatualizado]
           ,[custo_standard]
           ,[quantidade]
           ,[qtd_rejeitada]
           ,[movimenta_estoque]
           ,[movimenta_estoqterceiro]
           ,[lote_fornec]
           ,[cod_fci]
           ,[usuario_cancelou]
           ,[dt_cancelado]
           ,[motivo_cancelou]
           ,[atualiza_demanda]
           ,[exportar_spedblocok]
           ,[texto_livre]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device]
           ,[id_mov_pai]
           ,[id_item_original]
           ,[id_op]
           ,[codigo_dcr]
           ,[mov_fisico]
           ,[tipo_lanc_prod]
		   ,[id_carga]
		   ,[custo_unitario]
		   ,[Pk]
		   )
Select 
	[id_empresa]			  = Fato.Id_Empresa
,	[id_clifor]				  = Fato.Id_Clifor
,	[id_deposito]			  = Estoque_Deposito.id_estoque_deposito
,	[id_tipo_mov]			  = Estoque_Tipos_Mov.id_tipo_mov
,	[id_natoperacao]		  = Natureza_Operacao.id_NaturezaOperacao
,	[situacao]				  = Fato.Situacao
,	[dt_transacao]			  = Fato.Dt_Transacao
,	[hora_transacao]		  = Fato.Hora_Transacao
,	[entrada_saida]			  = Fato.Entrada_Saida
,	[dt_fabricacaolote]		  = Fato.Dt_FabricacaoLote
,	[id_localizacao]		  = Estoque_Local.id_estoque_local
,	[id_nf]					  = Notas_Fiscais.Id_Nota_Fiscal
,	[id_nfi]				  = Notas_Fiscais_Itens.Id_Nota_Fiscal_Item
,	[id_item]				  = #Itens_Company.Id_Item 
,	[id_pedidocompra]		  = Compras_Pedidos.Id_Pedido
,	[id_pedcompraitem]		  = Compras_Pedidos_Itens.Id_Pedido_Item
,	[id_pedidovenda]		  = Null
,	[id_pedvendaitem]		  = Null
,	[documento]				  = Fato.Nro_Documento
,	[lote]					  = Fato.Nro_Lote
,	[validade]				  = Fato.Validade  
,	[peso]					  = Fato.Peso		
,	[peso_bruto]			  = Fato.Peso_Bruto
,	[custo_medio]			  = Fato.Custo_Medio
,	[preco_venda]			  = Fato.Preco_Venda
,	[preco_movimento]		  = Fato.Preco_Movimento
,	[somente_valor]			  = Fato.Somente_Valor
,	[custo_kardex]			  = Fato.Custo_Kardex
,	[custo_kardexatualizado]  = Fato.Custo_KardexAtualizado
,	[custo_standard]		  = Fato.Custo_Standard
,	[quantidade]			  = Fato.Qtd_Transacao
,	[qtd_rejeitada]			  = Fato.Qtd_Rejeitada
,	[movimenta_estoque]		  = Fato.Movimenta_Estoque
,	[movimenta_estoqterceiro] = Fato.Movimenta_EstoqTerceiro
,	[lote_fornec]			  = Fato.Lote_Fornec	
,	[cod_fci]				  = Fato.Cod_Fci	
,	[usuario_cancelou]		  = Fato.Usuario_Cancelou
,	[dt_cancelado]			  = Fato.Dt_Cancelado
,	[motivo_cancelou]		  = Fato.Motivo_Cancelou
,	[atualiza_demanda]		  = Fato.Atualiza_Demanda
,	[exportar_spedblocok]	  = Fato.Exportar_SpedBlocoK
,	[texto_livre]			  = Fato.Texto_Livre
,	[incl_data]				  =	GetDate()
,	[incl_user]				  = 'ksantana'
,	[incl_device]			  =	'PC/10.1.0.123'
,	[modi_data]				  =	Null
,	[modi_user]				  =	Null
,	[modi_device]			  =	Null
,	[excl_data]				  =	Null
,	[excl_user]				  =	Null
,	[excl_device]			  =	Null
,	[id_mov_pai]			  =	Fato.Cod_SimilarPai --> Validar depois quand for de outra empresa se realmente é esse campo ou se sobe como null
,	[id_item_original]		  = Null
,	[id_op]					  =	Producao_Ordens.Id_Producao_Ordem
,	[codigo_dcr]			  = Null
,	[mov_fisico]			  = 'N'
,	[tipo_lanc_prod]		  =	Null
,	[id_carga]				  =	Null --> dps vira da aplicação, tabela: Estoque_carga_ret_ind
,	[custo_unitario]		  = Fato.Custo_Reposicao
,	[Pk]					  = Fato.Pk
From #Final Fato 
Left  join Estoque_Deposito		 On  Estoque_Deposito.Cod_Deposito		= Fato.Cod_Deposito		 Collate latin1_general_ci_ai
								 And Estoque_Deposito.Id_Empresa		= Fato.Id_Empresa		 
Left  join Estoque_Tipos_Mov	 On  Estoque_Tipos_Mov.tipo_mov_cod		= Fato.tipo_transacao	 Collate latin1_general_ci_ai
Left  Join Natureza_Operacao	 On  Natureza_Operacao.Cod_NatOperacao  = Fato.Cod_NatOperacao	 Collate latin1_general_ci_ai 
								 And Natureza_Operacao.Id_Empresa_Grupo = Fato.Id_Empresa_Grupo	 
Left  join Estoque_local		 On  Estoque_local.Cod_Localizacao		= Fato.Cod_Localizacao	 Collate latin1_general_ci_ai
								 And Estoque_local.Id_Empresa			= Fato.Id_Empresa		 
Left  Join Notas_Fiscais		 On  Notas_Fiscais.Pk					= Fato.Pk_Nf			 Collate latin1_general_ci_ai
Left  Join Notas_Fiscais_Itens	 On  Notas_Fiscais_Itens.Pk				= Fato.Pk_Nfi			 Collate latin1_general_ci_ai
Left  Join #Itens_Company		 On  #Itens_Company.cod_reduzido_antigo = Fato.Cod_Item			 Collate latin1_general_ci_ai 
								 And #Itens_Company.id_empresa_grupo    = Fato.Id_Empresa_Grupo	 
Left  Join Compras_Pedidos		 On  Compras_Pedidos.Pk					= Fato.Pk_Cp			 Collate latin1_general_ci_ai 
Left  Join Compras_Pedidos_Itens On  Compras_Pedidos_Itens.Pk			= Fato.Pk_Cpi			 Collate latin1_general_ci_ai 
Left  Join Producao_Ordens		 On  Producao_Ordens.Pk                 = Fato.Pk_Op			 Collate latin1_general_ci_ai 
								 And Producao_Ordens.Id_Empresa         = Fato.Id_Empresa
Where Not Exists (
			      Select *
				  From Estoque_Movimentos Dim
				  Where Dim.Pk = Fato.Pk Collate latin1_general_ci_ai 
				 )

Print (Convert(Char(20),GetDate(),20) + '| ' +  'Insert na Tabela Fisica: Estoque_Movimentos:' + ' OK! ')


--> Dropa Tabelas Temporarias da Procedure
Begin
	Drop Table If Exists #BaseEstMovimentos	
	Drop Table If Exists #AuxCLifor
	Drop Table If Exists #Itens_Company
	Drop Table If Exists #Final
End

Print (Convert(Char(20),GetDate(),20) + '| ' +  'Drop Tabelas Temporarias:' + ' OK! ')


--> Consulta Para Verificar se há códigos que existam na tabela Estoque_Tipos_Mov
--select distinct tipo_transacao
--where not exists (select *
--				  from Estoque_Tipos_Mov d
--				  where f.tipo_transacao = d.tipo_mov_cod collate latin1_general_ci_ai
--				 )
--
----> Layout Para Inserir os Dados, Caso tenha
--INSERT INTO Estoque_Tipos_Mov
--    (tipo_mov_cod, tipo_mov_descr, ativo, incl_data, incl_user, incl_device, modi_data, modi_user, modi_device, excl_data, excl_user, excl_device, entrada_saida)
--VALUES
    --('ALO', 'APROVISIONAMENTO LOCAL', 'S', GETDATE(), 'ksantana', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'E'),
    --('CAN', 'CANCELAMENTO', 'S', GETDATE(), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'S'),
    --('DIV', 'DEVOLUCAO VENDA', 'S', GETDATE(), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'S'),
    --('INV', 'INVENTARIO', 'S', GETDATE(), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'E'),
    --('IVP', 'AJUSTE INV. SAÍDA', 'S', GETDATE(), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'E');