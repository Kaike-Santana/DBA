
ALTER TRIGGER [dbo].[trigger_check_estoque]
ON [dbo].[Estoque_Movimentos]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @novo_saldo         FLOAT;
    DECLARE @id_mov             INT;
    DECLARE @id_item            INT;
    DECLARE @descricao_item     VARCHAR(100);
    DECLARE @cod_item           VARCHAR(50);
    DECLARE @lote               VARCHAR(10);
    DECLARE @lote_fornec        VARCHAR(10);
    DECLARE @id_deposito        INT;
    DECLARE @movimenta_estoque  CHAR(1);
    DECLARE @erro               VARCHAR(8000);
    DECLARE @tipo_operacao      VARCHAR(10);
    DECLARE @mensagem_erro      VARCHAR(8000);

    ----------------------------------------------------------------------------
    -- 1) Detectar se é INSERT, UPDATE ou DELETE
    ----------------------------------------------------------------------------
    SET @tipo_operacao =
    CASE 
        WHEN EXISTS(SELECT 1 FROM inserted)     AND EXISTS(SELECT 1 FROM deleted)     THEN 'UPDATE'
        WHEN EXISTS(SELECT 1 FROM inserted)     AND NOT EXISTS(SELECT 1 FROM deleted) THEN 'INSERT'
        WHEN NOT EXISTS(SELECT 1 FROM inserted) AND EXISTS(SELECT 1 FROM deleted)     THEN 'DELETE'
    END;

    ----------------------------------------------------------------------------
    -- 2) Definir cursor com base no tipo de operação
    ----------------------------------------------------------------------------
    IF @tipo_operacao = 'DELETE'
    BEGIN
        -- Para DELETE, os dados estão em "deleted"
        DECLARE CursorMov CURSOR FOR
            SELECT d.id_mov, d.id_item, d.lote, d.lote_fornec, d.id_deposito, d.movimenta_estoque,
                   it.descricao AS descricao_item, it.codigo AS cod_item
            FROM deleted d
            JOIN Itens it ON d.id_item = it.id_item;
    END
    ELSE
    BEGIN
        -- Para INSERT ou UPDATE, os dados estão em "inserted"
        DECLARE CursorMov CURSOR FOR
            SELECT i.id_mov, i.id_item, i.lote, i.lote_fornec, i.id_deposito, i.movimenta_estoque,
                   it.descricao AS descricao_item, it.codigo AS cod_item
            FROM inserted i
            JOIN Itens it ON i.id_item = it.id_item;
    END;

    ----------------------------------------------------------------------------
    -- 3) Percorrer cada linha afetada
    ----------------------------------------------------------------------------
    OPEN CursorMov;

    FETCH NEXT FROM CursorMov 
        INTO @id_mov, @id_item, @lote, @lote_fornec, @id_deposito, @movimenta_estoque, @descricao_item, @cod_item;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Monta mensagem de erro / auditoria
        SET @erro =   'ID_ITEM:'      + CONVERT(VARCHAR(10), @id_item)
                    + ' LOTE:'        + ISNULL(@lote, '')
                    + ' LOTE_FORNEC:' + ISNULL(@lote_fornec, '')
                    + ' ID_DEPOSITO:' + CONVERT(VARCHAR(10), @id_deposito)
                    + ' DESCR_ITEM:'  + ISNULL(@descricao_item, '')
                    + ' COD_ITEM:'    + ISNULL(@cod_item, '');

        ----------------------------------------------------------------------------
        -- 4) Regra de estoque (se movimenta_estoque = 'S')
        ----------------------------------------------------------------------------
        IF @movimenta_estoque = 'S'
        BEGIN
            BEGIN TRY
                -- Exemplo de chamada da função de saldo
                SELECT @novo_saldo = dbo.fnSaldoEstoqueAnalitico(e.id_item, e.id_deposito,
                                                                 e.id_localizacao, e.lote, e.lote_fornec,
                                                                 e.movimenta_estoqterceiro,
                                                                 e.dt_fabricacaolote, e.validade)
                FROM Estoque_Movimentos e
                WHERE e.id_mov = @id_mov;

                IF @novo_saldo < 0
                BEGIN
                    SET @mensagem_erro = 'Erro de saldo negativo. ' + @erro;
                    RAISERROR (@mensagem_erro, 16, 1);
                    ROLLBACK TRANSACTION;
                    RETURN;
                END
            END TRY
            BEGIN CATCH
                SET @mensagem_erro = ERROR_MESSAGE() + ' | ' + @erro;
                RAISERROR (@mensagem_erro, 16, 1);
                ROLLBACK TRANSACTION;
                RETURN;
            END CATCH
        END

        ----------------------------------------------------------------------------
        -- 5) Auditoria (exemplo) - grava a operação (INSERT, UPDATE ou DELETE)
        ----------------------------------------------------------------------------
        INSERT INTO dbo.Auditoria_Estoque_Movimentos
            (id_mov, id_item, lote, lote_fornec, id_deposito, tipo_operacao, erro)
        VALUES
            (@id_mov, @id_item, @lote, @lote_fornec, @id_deposito, @tipo_operacao, @erro);

        ----------------------------------------------------------------------------
        FETCH NEXT FROM CursorMov 
            INTO @id_mov, @id_item, @lote, @lote_fornec, @id_deposito, @movimenta_estoque, @descricao_item, @cod_item;
    END;

    CLOSE CursorMov;
    DEALLOCATE CursorMov;
END;