
USE THESYS_PRODUCAO
GO

SELECT *
FROM Estoque_Movimentos
WHERE ID_MOV = 57092


INSERT INTO ESTOQUE_MOVIMENTOS (
     id_empresa, id_clifor, id_deposito, id_tipo_mov, id_natoperacao, 
    situacao, dt_transacao, hora_transacao, entrada_saida, dt_fabricacaolote, 
    id_localizacao, id_nf, id_nfi, id_item, id_pedidocompra, id_pedcompraitem, 
    id_pedidovenda, id_pedvendaitem, documento, lote, validade, peso, peso_bruto, 
    custo_medio, preco_venda, preco_movimento, somente_valor, custo_kardex, 
    custo_kardexatualizado, custo_standard, quantidade, qtd_rejeitada, 
    movimenta_estoque, movimenta_estoqterceiro, lote_fornec, cod_fci, 
    usuario_cancelou, dt_cancelado, motivo_cancelou, atualiza_demanda, 
    exportar_spedblocok, texto_livre, incl_data, incl_user, incl_device, 
    modi_data, modi_user, modi_device, excl_data, excl_user, excl_device, 
    id_mov_pai, id_item_original, id_op, codigo_DCR, mov_fisico, tipo_lanc_prod, 
    id_carga, custo_unitario
) VALUES (
     4, 1600, 6, 30, NULL, 'A', '2024-10-08', '09:51:10.0000000', 'S', NULL, 
    NULL, NULL, NULL, 433, NULL, NULL, NULL, NULL, 302, 115039, NULL, 0.0000, 
    0.0000, NULL, NULL, NULL, 'N', NULL, NULL, NULL, 83.705, 0.000000, 'N', 
    'S', 263037, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2024-10-08 09:51:10.840', 
    'deni.lovo', 'PC/10.4.1.2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
    557, NULL, 'N', NULL, 15, 0.000000
);