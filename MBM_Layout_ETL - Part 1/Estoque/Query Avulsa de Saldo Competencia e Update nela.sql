
USE [THESYS_PRODUCAO]
GO

INSERT INTO [dbo].[Estoque_Movimentos]
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
           ,[codigo_DCR]
           ,[mov_fisico]
           ,[tipo_lanc_prod]
           ,[id_carga]
           ,[custo_unitario]
           ,[Pk])
 
Select 
	[id_empresa]				= 4	  --> Poli
,	[id_clifor]					= 1600  --> Vetta
,	[id_deposito]				= 6	--? --> 4	MP TERCEIROS
,	[id_tipo_mov]				= 30    --> RIND	RET. MERC. INDUST..
,	[id_natoperacao]			= Null
,	[situacao]					= 'A'
,	[dt_transacao]				= convert(date,getdate() -8)
,	[hora_transacao]			= convert(time,getdate())
,	[entrada_saida]				= 'S'
,	[dt_fabricacaolote]			= Null
,	[id_localizacao]			= Null
,	[id_nf]						= Null
,	[id_nfi]					= Null
,	[id_item]					= Dim.id_item
,	[id_pedidocompra]			= Null
,	[id_pedcompraitem]			= Null
,	[id_pedidovenda]			= Null
,	[id_pedvendaitem]			= Null
,	[documento]					= Null --Fato.NF 
,	[lote]						= Fato.Nro_Lote
,	[validade]					= Null
,	[peso]						= SUM(CAST(Fato.Qtd_Proporcional AS DECIMAL(15,6)))
,	[peso_bruto]				= SUM(CAST(Fato.Qtd_Proporcional AS DECIMAL(15,6)))
,	[custo_medio]				= Null
,	[preco_venda]				= Null
,	[preco_movimento]			= Null
,	[somente_valor]				= 'N'
,	[custo_kardex]				= Null
,	[custo_kardexatualizado]	= Null
,	[custo_standard]			= Null
,	[quantidade]				= SUM(CAST(Fato.Qtd_Proporcional AS DECIMAL(15,3))) --Sum(Convert(Numeric(15,6),Fato.Qtd_Proporcional))
,	[qtd_rejeitada]				= Null
,	[movimenta_estoque]			= 'N'
,	[movimenta_estoqterceiro]	= 'S'
,	[lote_fornec]				= Fato.Lote_Vetta
,	[cod_fci]					= Null
,	[usuario_cancelou]			= Null
,	[dt_cancelado]				= Null
,	[motivo_cancelou]			= Null
,	[atualiza_demanda]			= Null
,	[exportar_spedblocok]		= Null
,	[texto_livre]				= Null
,	[incl_data]					= getdate() -8
,	[incl_user]					= 'Ajust RIND'
,	[incl_device]				= Null
,	[modi_data]					= Null
,	[modi_user]					= Null
,	[modi_device]				= Null
,	[excl_data]					= Null
,	[excl_user]					= Null
,	[excl_device]				= Null
,	[id_mov_pai]				= Null
,	[id_item_original]			= Null
,	[id_op]						= Null
,	[codigo_DCR]				= Null
,	[mov_fisico]				= 'N'
,	[tipo_lanc_prod]			= Null
,	[id_carga]					= Null
,	[custo_unitario]			= Null
,	[Pk]						= Null
From Tabela_Vetta_RETIND Fato
Join Itens				 Dim  On (Dim.Codigo = Fato.Código_do_Item)	
Group By 
Dim.id_item,
--Fato.NF, 
Fato.Nro_Lote,
Fato.Lote_Vetta

select *
from estoque_movimentos 
where id_mov = 57074

drop table Tabela_Vetta_RETIND

SELECT SUM(CONVERT(NUMERIC(15,6),QTD_PROPORCIONAL))
FROM Tabela_Vetta_RETIND


select * 
from Estoque_Movimentos 
where lote = '115356' 
and id_mov = 56659

REFERENCES THESYS_PRODUCAO.dbo.Estoque_Tipos_Mov (id_tipo_mov)

Select 
	dim.id_clifor
,	fato.*
From Estoque_Movimentos Fato
Join Notas_Fiscais		Dim  On (Dim.Id_Nota_Fiscal = Fato.Id_Nf) 
Where Fato.Dt_Transacao >= '2024-10-02'
And Fato.id_tipo_mov In (Select id_tipo_mov From Estoque_Tipos_Mov Where tipo_mov_cod = 'NFE' And tipo_mov_descr = 'NF ENTRADA')
And	Fato.Id_Clifor Is Null

begin tran
update fato
set id_clifor = dim.id_clifor

From Estoque_Movimentos Fato
Join Notas_Fiscais		Dim  On (Dim.Id_Nota_Fiscal = Fato.Id_Nf) 
Where Fato.Dt_Transacao >= '2024-10-02'
And Fato.id_tipo_mov In (Select id_tipo_mov From Estoque_Tipos_Mov Where tipo_mov_cod = 'NFE' And tipo_mov_descr = 'NF ENTRADA')
And	Fato.Id_Clifor Is Null

commit






WITH CTE_ITENS_EXCEL_NERE AS (
	SELECT ID_ITEM, CODIGO 
	FROM ITENS FATO
	WHERE CODIGO IN (
	 '030009'
	,'030135'
	,'100050'
	,'100208'
	,'10118'
	,'10198'
	,'10199'
	,'10200'
	,'10201'
	,'10202'
	,'10203'
	,'10204'
	,'10205'
	,'10206'
	,'10207'
	,'10208'
	,'10209'
	,'10210'
	,'10211'
	,'10212'
	,'10213'
	,'10214'
	,'10215'
	,'10216'
	,'10217'
	,'10219'
	,'10220'
	,'10223'
	,'10224'
	,'10225'
	,'10226'
	,'10227'
	,'10228'
	,'10229'
	,'10230'
	,'10231'
	,'10232'
	,'10233'
	,'10235'
	,'10236'
	,'10237'
	,'10238'
	,'10239'
	,'10240'
	,'10250'
	,'10251'
	,'10252'
	,'10253'
	,'10254'
	,'10255'
	,'10257'
	,'10258'
	,'10259'
	,'10260'
	,'10261'
	,'10262'
	,'10263'
	,'10264'
	,'441'
	,'530'
	,'532'
	)
	)

---DELETE FROM ESTOQUE_SALDO_COMPETENCIA
---WHERE ID_ITEM IN (
---SELECT ID_ITEM 
---FROM CTE_ITENS_EXCEL_NERE
---)

SELECT FATO.ID_ITEM, ITENS.CODIGO, CAST(REPLACE(CONVERT(VARCHAR(20), CAST(ROUND(Saldo_Qtd_Final, 2) AS DECIMAL(18,2))), '.', ',') AS VARCHAR(20)) AS Sales_Custo_Final
FROM ESTOQUE_SALDO_COMPETENCIA FATO
JOIN ITENS ON ITENS.ID_ITEM = FATO.ID_ITEM 
WHERE NOT EXISTS (
				  SELECT *
				  FROM CTE_ITENS_EXCEL_NERE DIM
				  WHERE DIM.ID_ITEM = FATO.ID_ITEM
				 )

SELECT 
	EMPRESAS.CODIGO_ANTIGO AS Emp
,	FATO.ANOMES
,	ESTOQUE_DEPOSITO.DESCRICAO AS DEPOSITO
,	GRUPOS_ESTOQUE.DESCRICAO
,	ITENS.CODIGO
,	ITENS.DESCRICAO as Descricao_do_Item
,	UNIDADES.CODIGO AS Unid
,	CAST(REPLACE(CONVERT(VARCHAR(20), CAST(ROUND(FATO.SALDO_QTD_INICIAL  ,2) AS DECIMAL(18,2))), '.', ',') AS VARCHAR(20)) AS SALDO_QTD_INICIAL  
,	CAST(REPLACE(CONVERT(VARCHAR(20), CAST(ROUND(FATO.SALDO_QTD_FINAL    ,2) AS DECIMAL(18,2))), '.', ',') AS VARCHAR(20)) AS SALDO_QTD_FINAL    
,	CAST(REPLACE(CONVERT(VARCHAR(20), CAST(ROUND(FATO.SALDO_CUSTO_INICIAL,2) AS DECIMAL(18,2))), '.', ',') AS VARCHAR(20)) AS SALDO_CUSTO_INICIAL
,	CAST(REPLACE(CONVERT(VARCHAR(20), CAST(ROUND(FATO.SALDO_CUSTO_FINAL  ,2) AS DECIMAL(18,2))), '.', ',') AS VARCHAR(20)) AS SALDO_CUSTO_FINAL  
,	CAST(REPLACE(CONVERT(VARCHAR(20), CAST(ROUND(FATO.CUSTO_MEDIO		 ,2) AS DECIMAL(18,2))), '.', ',') AS VARCHAR(20)) AS CUSTO_MEDIO		 
,	EMPRESAS.DESCRICAO AS "FANTASIA/CNPJ DA EMPRESA"
,	ESTOQUE_ARMAZENS.DESCRICAO AS ARMAZEM
,	FAMILIA_INDUSTRIAL.DESCRICAO
FROM ESTOQUE_SALDO_COMPETENCIA FATO
JOIN EMPRESAS				 ON  EMPRESAS.ID_EMPRESA					  = FATO.ID_EMPRESA
JOIN ESTOQUE_DEPOSITO		 ON  ESTOQUE_DEPOSITO.ID_ESTOQUE_DEPOSITO	  = FATO.ID_ESTOQUE_DEPOSITO
JOIN ESTOQUE_ARMAZENS		 ON  ESTOQUE_ARMAZENS.ID_ARMAZEM			  = ESTOQUE_DEPOSITO.ID_ARMAZEM
JOIN ITENS					 ON  ITENS.ID_ITEM							  = FATO.ID_ITEM
JOIN GRUPOS_ESTOQUE			 ON  GRUPOS_ESTOQUE.ID_GRUPO_ESTOQUE		  = ITENS.ID_GRUPO_ESTOQUE
JOIN UNIDADES				 ON  UNIDADES.ID_UNIDADE					  = ITENS.ID_UNIDADE
JOIN ITENS_EMPRESAS			 ON  ITENS_EMPRESAS.ID_ITEM					  = FATO.ID_ITEM 
							 AND ITENS_EMPRESAS.ID_EMPRESA_GRUPO		  = EMPRESAS.ID_EMPRESA_GRUPO
LEFT JOIN FAMILIA_INDUSTRIAL ON  FAMILIA_INDUSTRIAL.ID_FAMILIA_INDUSTRIAL = ITENS_EMPRESAS.ID_FAMILIA_INDUSTRIAL
ORDER BY ITENS.CODIGO DESC


SELECT *
FROM ESTOQUE_MOVIMENTOS
WHERE ID_ITEM = 443
AND DT_TRANSACAO BETWEEN '2024-09-01' AND '2024-09-30' 

SELECT *
FROM ITENS
WHERE CODIGO = '030124'


SELECT *
FROM ESTOQUE_SALDO_COMPETENCIA
WHERE ID_ITEM = 443

UPDATE ESTOQUE_SALDO_COMPETENCIA
SET SALDO_QTD_FINAL   = 147699.999455
,	SALDO_CUSTO_FINAL = 908078.70
WHERE ID_ITEM = 443