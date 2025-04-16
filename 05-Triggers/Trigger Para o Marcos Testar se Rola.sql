
Alter TRIGGER [dbo].[trigger_controle_estoque_before_delete_nf]
ON [dbo].[Notas_Fiscais]
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Declaração da variável @id_nota_fiscal
    DECLARE @id_nota_fiscal INT;

    -- Cursor para percorrer as NFs que serão excluídas
    DECLARE CursorNF CURSOR FOR
    SELECT id_nota_fiscal
    FROM deleted;

    OPEN CursorNF;

    FETCH NEXT FROM CursorNF INTO @id_nota_fiscal;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Verifica o saldo de estoque para cada item afetado pela NF
        DECLARE @id_item INT;
        DECLARE @id_deposito INT;
        DECLARE @lote VARCHAR(10);
        DECLARE @lote_fornec VARCHAR(10);
        DECLARE @novo_saldo FLOAT;

        -- Cursor para percorrer os itens da NF na tabela Estoque_Movimentos
        DECLARE CursorItens CURSOR FOR
        SELECT id_item, id_deposito, lote, lote_fornec
        FROM Estoque_Movimentos
        WHERE id_nf = @id_nota_fiscal;

        OPEN CursorItens;

        FETCH NEXT FROM CursorItens INTO @id_item, @id_deposito, @lote, @lote_fornec;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Calcula o novo saldo de estoque
            -- Adapte os parâmetros da função fnSaldoEstoqueAnalitico
            -- para sua estrutura de banco de dados
            SELECT @novo_saldo  = COALESCE(SUM(CASE 
                                    WHEN tab.entrada_saida = 'S' THEN tab.quantidade * -1 
                                    WHEN tab.entrada_saida = 'E' THEN tab.quantidade 
                                 END), 0)
    FROM Estoque_Movimentos tab
    JOIN itens i ON i.id_item = tab.id_item
    JOIN Estoque_Deposito ed ON ed.id_estoque_deposito = tab.id_deposito AND ed.id_empresa = tab.id_empresa
    JOIN Empresas E ON E.id_empresa = tab.id_empresa
    LEFT JOIN Estoque_Local el ON (el.id_estoque_local = tab.id_localizacao 
                                   AND el.id_empresa = tab.id_empresa 
                                   AND el.id_estoque_deposito = tab.id_deposito)
    WHERE situacao = 'A'
        AND movimenta_estoque = 'S'
        AND ed.id_estoque_deposito = @id_deposito
		and i.id_item = @id_item
		and tab.lote = @lote
            

			 

            -- Se o saldo for negativo, impede a exclusão e exibe mensagem de erro
            IF @novo_saldo < 0
            BEGIN
                RAISERROR ('Não é possível excluir a NF %d pois o saldo de estoque do item %d ficará negativo.', 16, 1, @id_nota_fiscal, @id_item);
                CLOSE CursorItens;
                DEALLOCATE CursorItens;
                CLOSE CursorNF;
                DEALLOCATE CursorNF;
                RETURN; -- Impede a exclusão da NF
            END

            FETCH NEXT FROM CursorItens INTO @id_item, @id_deposito, @lote, @lote_fornec;
        END

        CLOSE CursorItens;
        DEALLOCATE CursorItens;

        FETCH NEXT FROM CursorNF INTO @id_nota_fiscal;
    END

    CLOSE CursorNF;
    DEALLOCATE CursorNF;

    -- Se todas as verificações passaram, permite a exclusão das NFs
    DELETE FROM Notas_Fiscais
    WHERE id_nota_fiscal IN (SELECT id_nota_fiscal FROM deleted);
END;