INSERT INTO [dbo].[Itens]
           ([codigo]
           ,[id_subgrupo_estoque]
           ,[id_grupo_estoque]
           ,[id_familia_comercial]
           ,[id_unidade]
           ,[cod_unidade2]
           ,[descricao]
           ,[preco_reposicao]
           ,[desc_nfiscal]
           ,[peso_bruto]
           ,[custo_reposicao]
           ,[peso_liquido]
           ,[custo_medio]
           ,[ativo]
           ,[custo_standard]
           ,[dt_inclusao]
           ,[controla_lote]
           ,[controla_estoque]
           ,[comprado_fabricado]
           ,[item_debitodireto]
           ,[id_clasfisc]
           ,[tipo_produto]
           ,[path_foto]
           ,[versao_operacao]
           ,[codtp_servicolc]
           ,[garantia]
           ,[descricao_completa]
           ,[regime_pis_cofins]
           ,[fci_produto_importado]
           ,[fci_gera_fci]
           ,[dt_envio_integracao]
           ,[majorar_perc_cofins_imp]
           ,[cod_itemgradeinfo]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device]
           ,[id_tp_contlote]
           ,[id_tp_contpeca]
           ,[id_tp_genero]
           ,[id_tp_tempoobtcom]
           ,[id_tp_tempoobtpro]
           ,[id_tp_custo]
           ,[obs_pedido_compra]
           ,[obs_op]
           ,[obs_pedido_venda]
           ,[obs_nf]
           ,[id_unid_negocio]
           ,[modulo_flexao]
           ,[cas]
           ,[fluidez]
           ,[densidade]
           ,[uso_resina]
           ,[descricao_ncm_suframa]
           ,[aplicacao_PPB]
           ,[id_pais_origem]
           ,[qtd_por_conteiner]
           ,[id_familia_pcp]
           ,[controla_validade]
           ,[dias_validade])

--> MG

--VALUES ('CFOP3102', NULL, NULL, 2792, NULL, NULL, 'COMPL ICMS IMPOR 18% ICMS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
--VALUES ('CFOP6102', NULL, NULL, 2792, NULL, NULL, 'COMPLEMENTO DE IMPOSTO 8%', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)

--> RUBBERON

--VALUES ('CFOP3551', NULL, NULL, 2792, NULL, NULL, 'IMPORT. COMP ATIVO IMOBILIZADO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
--VALUES ('CFOP5102', NULL, NULL, 2792, NULL, NULL, 'COMPLEMENTO IMPOSTOS 18%', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
--VALUES ('CFOP6102', NULL, NULL, 2792, NULL, NULL, 'COMPLEMENTO IMPOSTOS IPI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
--VALUES ('CFOP6152', NULL, NULL, 2792, NULL, NULL, 'COMPLEMENTO IMPOSTOS 4%', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)

--> NORTEBAG
--VALUES ('CFOP5101', NULL, NULL, 2792, NULL, NULL, 'COMPLEMENTO IMPOSTOS 3,50%', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)

--> POLIRESINAS

--VALUES ('CFOP5101', NULL, NULL, 2792, NULL, NULL, 'COMPLEMENTO_ICMS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
--VALUES ('CFOP5102', NULL, NULL, 2792, NULL, NULL, 'COMPLEMENTO_ICMS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
--VALUES ('CFOP6101', NULL, NULL, 2792, NULL, NULL, 'COMPLEMENTO_ICMS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)


-->  FAMILIA COMERCIAL 2792 NÃO UTILIZAR