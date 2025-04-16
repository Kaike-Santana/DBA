
use THESYS_HOMOLOGACAO
go

Drop Table If Exists #BaseEstMovimentos
Select *
Into #BaseEstMovimentos
From OpenQuery([mbm_poliresinas],'
select 
	e.*
,	clifor.cgc_cpf
from estoq_movto e 
left join clifor on clifor.cod_clifor = e.cod_clifor
where exists (
			  select cod_item 
			  from item i 
			  where controla_estoque =''S''
			  and tipo_produto = ''P'' 
			  and i.cod_item = e.cod_item
			 )
')

Insert Into [dbo].[estoque_movimentos]
           ([id_empresa]
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
		   ,[id_carga])
		   -- 38.812
Select 
	[id_empresa]			=	Empresas.id_empresa
,	[id_clifor]				=	CliFor.cod_clifor
,	[id_deposito]			=   estoque_deposito.id_estoque_deposito
,	[id_tipo_mov]			=   Estoque_Tipos_Mov.id_tipo_mov
,	[id_natoperacao]		=	Natureza_Operacao.id_NaturezaOperacao
,	fato.[situacao]
,	fato.[dt_transacao]
,	fato.[hora_transacao]
,	fato.[entrada_saida]
,	fato.[dt_fabricacaolote]
,	[id_localizacao]		=	Estoque_Local.id_estoque_local
,	[id_nf]					=	null --> dados virao da aplicação, n do MBM
,	[id_nfi]				=	null --> dados virao da aplicação, n do MBM
,	[id_item]				=	Itens_Empresas.id_item
,	[id_pedidocompra]		=   null
,	[id_pedcompraitem]		=   null
,	[id_pedidovenda]		=   null
,	[id_pedvendaitem]		=   null
,	[documento]				=   nro_documento
,	[lote]					=   nro_lote
,	[validade]
,	[peso]
,	[peso_bruto]
,	[custo_medio]
,	[preco_venda]
,	[preco_movimento]
,	[somente_valor]
,	[custo_kardex]
,	[custo_kardexatualizado]
,	[custo_standard]
,	[quantidade]			=	qtd_transacao
,	[qtd_rejeitada]
,	[movimenta_estoque]
,	[movimenta_estoqterceiro]
,	[lote_fornec]
,	[cod_fci]
,	[usuario_cancelou]
,	[dt_cancelado]
,	[motivo_cancelou]
,	[atualiza_demanda]
,	[exportar_spedblocok]
,	[texto_livre]
,	[incl_data]				=	getdate()
,	[incl_user]				=   'ksantana'
,	[incl_device]			=	null
,	[modi_data]				=	null
,	[modi_user]				=	null
,	[modi_device]			=	null
,	[excl_data]				=	null
,	[excl_user]				=	null
,	[excl_device]			=	null
,	[id_mov_pai]			=	cod_similarpai --> Validar depois quand for de outra empresa se realmente é esse campo ou se sobe como null
,	[id_item_original]		=   null
,	[id_op]					=	null --> dps vira da aplicação, tabela: produção Ordens
,	[codigo_dcr]			=   null
,	[mov_fisico]			=   'N'
,	[tipo_lanc_prod]		=	null
,	id_carga				=	null --> dps vira da aplicação, tabela: Estoque_carga_ret_ind
From #BaseEstMovimentos Fato
Left join Empresas		    on Empresas.codigo_antigo							  = fato.cod_empresa				 collate latin1_general_ci_ai
Left join CliFor		    on Dbo.Fn_Limpa_NoNum(Isnull(CliFor.Cnpj,Clifor.Cpf)) = Dbo.Fn_Limpa_NoNum(fato.cgc_cpf) collate latin1_general_ci_ai
Left join estoque_deposito  on estoque_deposito.cod_deposito					  = fato.cod_deposito				 collate latin1_general_ci_ai
Left join Estoque_Tipos_Mov on Estoque_Tipos_Mov.tipo_mov_cod					  = fato.tipo_transacao				 collate latin1_general_ci_ai
Left join Natureza_Operacao on Natureza_Operacao.cod_natoperacao				  = fato.cod_natoperacao			 collate latin1_general_ci_ai and Natureza_Operacao.id_empresa_grupo = 1584 --> Mudar Para Empresa Desejada
Left join Estoque_local		on Estoque_local.cod_localizacao					  = fato.cod_localizacao			 collate latin1_general_ci_ai
Left join Itens_Empresas	on Itens_Empresas.cod_reduzido_antigo				  = fato.cod_item					 collate latin1_general_ci_ai and Itens_Empresas.id_empresa_grupo = 1584 --> PoliResinas, Mudar Para Empresa Desejada
--left join #ItensEmpUniq		on #ItensEmpUniq.cod_reduzido_antigo  = fato.cod_item		 collate latin1_general_ci_ai and #ItensEmpUniq.id_empresa_grupo = 1584 --> PoliResinas, Mudar Para Empresa Desejada

--> Para Quando Havia Dados Duplicados!

--drop table if exists #ItensEmpUniq
--select *
--into #ItensEmpUniq
--from (
--select 
--	id_item
--,	cod_reduzido_antigo
--,	id_empresa_grupo
--,	rw = row_number() over( partition by cod_reduzido_antigo, id_empresa_grupo  order by cod_reduzido_antigo desc)
--from Itens_Empresas
--) SubQuery
--where rw = 1

--quando cruca com itens_empresas, duplica, pq 1 item pode ter mais de um grupo ou subgrupo.


--> Consulta Para Verificar se há códigos que existam na tabela Estoque_Tipos_Mov
select distinct tipo_transacao
from #BaseEstMovimentos f
where not exists (select *
				  from Estoque_Tipos_Mov d
				  where f.tipo_transacao collate latin1_general_ci_ai = d.tipo_mov_cod
				 )
--> Layout Para Inserir os Dados, Caso tenha
--INSERT INTO Estoque_Tipos_Mov
--    (tipo_mov_cod, tipo_mov_descr, ativo, incl_data, incl_user, incl_device, modi_data, modi_user, modi_device, excl_data, excl_user, excl_device, entrada_saida)
--VALUES
--    ('ALO', 'APROVISIONAMENTO LOCAL', 'S', GETDATE(), 'ksantana', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'E'),
--    ('CAN', 'CANCELAMENTO', 'S', GETDATE(), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'S'),
--    ('DIV', 'DEVOLUCAO VENDA', 'S', GETDATE(), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'S'),
--    ('INV', 'INVENTARIO', 'S', GETDATE(), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'E'),
--    ('IVV', 'INVENTARIO DE VERIFICACAO', 'S', GETDATE(), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'E');