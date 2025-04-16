
USE [THESYS_DEV]
GO

INSERT INTO [dbo].[Frete_Tabelas]
           ([id_armazem]
           ,[id_clifor]
           ,[id_uf]
           ,[id_cidade]
           ,[faixa_inicial]
           ,[faixa_final]
           ,[preco]
           ,[id_tp_veiculo]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device]
           ,[id_moeda])
SELECT 
	[id_armazem]	 =  Estoque_Armazens.id_armazem
,	[id_clifor]		 =  CLIFOR.cod_clifor
,	[id_uf]			 =  UFS.CODIGO
,	[id_cidade]		 =  Cidades.CODIGO
,	[faixa_inicial]	 =  FATO.FAIXA_INICIAL
,	[faixa_final]	 =  FATO.FAIXA_FINAL
,	[preco]			 =  FATO.PRECO
,	[id_tp_veiculo]	 =  IIF(VEICULO = 'CARRETA', 2233, 2234)
,	[incl_data]		 =  GETDATE()
,	[incl_user]		 =  'ksantana'
,	[incl_device]	 =  'PC/10.1.0.123'
,	[modi_data]		 =  NULL
,	[modi_user]		 =  NULL
,	[modi_device]	 =  NULL
,	[excl_data]		 =  NULL
,	[excl_user]		 =  NULL
,	[excl_device]	 =  NULL
,	[id_moeda]		 =  2
FROM THESYS_DEV..TXT FATO 
JOIN Estoque_Armazens ON Estoque_Armazens.descricao = FATO.ORIGEM_DO_ARMAZEM
JOIN CLIFOR			  ON CLIFOR.cnpj				= FATO.CNPJ_TRANSP 
JOIN UFS			  ON UFS.UF					    = FATO.UF
LEFT JOIN Cidades	  ON Cidades.DESCRICAO		    = FATO.CIDADE_ENTREGA 
					  AND FATO.UF = Cidades.UF



SELECT *
, RW = ROW_NUMBER() OVER ( PARTITION BY DESCRICAO ORDER BY DESCRICAO DESC)
FROM Cidades

SELECT *
FROM Tabela_Padrao
WHERE cod_tabelapadrao = 'TIPO_VEICULOS'