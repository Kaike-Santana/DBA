 
 -- Programador: Kaike Natan
 -- Data: 2024-09-02
 -- Descricao: Consultas Para Comprar a Volumetria das Principais Tabelas do MBM X Thesys Homologacao
 -- Version: 1.0


--> Pedidos de Compras
 Execute Valida_PedidosCompras_MBM_X_Thesys
 Go

--> Pedidos de Vendas
 Execute Valida_PedidoVenda_MBM_X_Thesys
 Go

--> Notas Fiscais (Entrada e Saida)
 Execute Dbo.Valida_Notas_Fiscais_MBM_X_TheSys
 Go

--> Contas a Receber
 Execute Dbo.Valida_Contas_a_Receber_MBM_X_TheSys
 Go

--> Contas a Pagar
 Execute Dbo.Valida_Contas_a_Pagar_MBM_X_TheSys
 Go

--> Estoque
 Execute Dbo.Valida_Estoque_MBM_X_TheSys
 Go