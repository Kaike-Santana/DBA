

-- Defina a descrição do item que deseja normalizar
--DECLARE @Descricao VARCHAR(200) = 'ACESSORIO MASCARA/RESPIRADOR VALVULA EXALACAO MASCARA FACIAL INTEIRA 6800 7583 3M';

-- Variável para armazenar o Id_Item a ser mantido
DECLARE @Id_Item_Manter INT;

-- Cria uma tabela temporária para armazenar os Id_Item duplicados

DROP TABLE IF EXISTS #ItensDuplicados;
CREATE TABLE #ItensDuplicados (
    Id_Item INT NOT NULL
);

-- Identifica o Id_Item com o menor valor (a ser mantido) e insere os duplicados na tabela temporária
WITH ItensDuplicados AS (
    SELECT 
        MIN(Id_Item) AS Id_Item_Manter -- Id_Item a ser mantido
		, ID_ITEM
    FROM
        Itens
    WHERE
        id_unid_negocio IS NULL
        AND Descricao In (
'AVENTAL SEGURANCA MAT PVC COR PT/LJ DIM 1X1,20M FORRO PVC CA 34421' ,
'AVENTAL SEGURANCA MAT PVC COR PT/LJ DIM 1X1,20M FORRO PVC CA 36665' ,
'AVENTAL SEGURANCA MAT PVC COR PT/LJ DIM 1X1,20M FORRO PVC CA28303'	 ,
'AVENTAL SEGURANCA MAT PVC COR PT/LJ DIM 1X1,20M FORRO PVC CA34421'	 ,
'AVENTAL SEGURANCA MAT PVC COR PT/LJ DIM 1X1,20M FORRO PVC CA36665'	 ,
'AVENTAL SEGURANCA MAT RASPS COR CZ DIM 1X1,20M FORRO PVC CA 10511'	 ,
'AVENTAL SEGURANCA MAT RASPS COR CZ DIM 1X1,20M FORRO PVC CA 16030'	 ,
'AVENTAL SEGURANCA MAT RASPS COR CZ DIM 1X1,20M FORRO PVC CA 19224'	 ,
'AVENTAL SEGURANCA MAT RASPS COR CZ DIM 1X1,20M FORRO PVC CA10511'	 ,
'AVENTAL SEGURANCA MAT RASPS COR CZ DIM 1X1,20M FORRO PVC CA16030'	 ,
'AVENTAL SEGURANCA MAT RASPS COR CZ DIM 1X1,20M FORRO PVC CA19224'
		)
	GROUP BY ID_ITEM
)
INSERT INTO #ItensDuplicados (Id_Item)
SELECT Id_Item_Manter
FROM ItensDuplicados
--WHERE Id_Item <> Id_Item_Manter;

-- Define o Id_Item a ser mantido
SELECT @Id_Item_Manter = MIN(Id_Item) FROM #ItensDuplicados;

PRINT @Id_Item_Manter

-- Verifica se há itens duplicados
IF EXISTS (SELECT 1 FROM #ItensDuplicados)
BEGIN
    -- Inicia uma transação para garantir a integridade dos dados
    BEGIN TRANSACTION;

    -- Declara variáveis para o loop
    DECLARE @NomeTabela SYSNAME;
    DECLARE @NomeColuna SYSNAME;
    DECLARE @SQL NVARCHAR(MAX);

    -- Cursor para iterar sobre as tabelas referenciadas
    DECLARE TabelasCursor CURSOR FOR
        SELECT NomeTabela, NomeColuna
        FROM (
            VALUES
                ('Compras_Cotacoes', 'Id_Item'),
                ('Compras_Importacoes_ConteineresXItens', 'Id_Item'),
                ('Compras_Importacoes_Itens', 'Id_Item'),
                ('Compras_Pedidos_Itens', 'Id_Item'),
                ('Estoque_Movimentos', 'Id_Item'),
                ('Estoque_Saldo_Competencia', 'Id_Item'),
                ('Itens_Conv_Unidades', 'Id_Item'),
                ('Itens_Empresas', 'Id_Item'),
                ('Itens_Fornec', 'Id_Item'),
                ('Itens_Preco_Industrializacao', 'Id_Item'),
                ('Natureza_Operacao_Setup_Compras', 'Id_Item'),
                ('Natureza_Operacao_Setup_Vendas', 'Id_Item'),
                ('Notas_Fiscais_Itens', 'Id_Item'),
                ('Notas_Fiscais_Itens_Rastro', 'Id_Item'),
                ('producao_estruturas', 'Id_Item'),
                ('producao_estruturas_componentes', 'Id_Item'),
                ('producao_ordens', 'Id_Item'),
                ('SETUP', 'Id_Item'),
                ('SimuladorCalculoImpostos', 'Id_Item'),
                ('Tarifario_Armadores', 'Id_Item'),
                ('Tarifario_Outros', 'Id_Item'),
                ('Tarifario_Portos', 'Id_Item'),
                ('Tarifario_Transportadores', 'Id_Item'),
                ('Terminais_Alfandegados', 'Id_Item'),
                ('Vendas_Historico_An_Cred', 'Id_Item'),
                ('Vendas_Pedidos_Itens', 'Id_Item')
                --('Vendas_Trocas_Itens', 'Id_Item')
        ) T (NomeTabela, NomeColuna);

    OPEN TabelasCursor;
    FETCH NEXT FROM TabelasCursor INTO @NomeTabela, @NomeColuna;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Monta o comando SQL dinamicamente para cada tabela
        SET @SQL = N'
            UPDATE T
            SET ' + QUOTENAME(@NomeColuna) + ' = @Id_Item_Manter
            FROM ' + QUOTENAME(@NomeTabela) + ' T
            WHERE ' + QUOTENAME(@NomeColuna) + ' IN (SELECT Id_Item FROM #ItensDuplicados);
        ';

        -- Imprime o comando SQL antes de executá-lo
        PRINT @SQL;

        -- Executa o comando SQL
        EXEC sp_executesql @SQL, N'@Id_Item_Manter INT', @Id_Item_Manter;

        FETCH NEXT FROM TabelasCursor INTO @NomeTabela, @NomeColuna;
    END

    CLOSE TabelasCursor;
    DEALLOCATE TabelasCursor;

    -- Exclui os itens duplicados das tabelas relacionadas
    -- Tabelas relacionadas diretamente com Itens
    Delete From Compras_Cotacoes					  WHERE Id_Item	In (Select Max(Id_Item) From #ItensDuplicados);
    Delete From Compras_Importacoes_ConteineresXItens WHERE Id_Item	In (Select Max(Id_Item) From #ItensDuplicados);
	Delete From Compras_Importacoes_Itens			  WHERE Id_Item	In (Select Max(Id_Item) From #ItensDuplicados);
	Delete From Compras_Pedidos_Itens				  WHERE Id_Item	In (Select Max(Id_Item) From #ItensDuplicados);
	Delete From Estoque_Saldo_Competencia			  WHERE Id_Item	In (Select Max(Id_Item) From #ItensDuplicados);
	Delete From Itens_Conv_Unidades					  WHERE Id_Item	In (Select Max(Id_Item) From #ItensDuplicados);
	Delete From Itens_Empresas						  WHERE Id_Item	In (Select Max(Id_Item) From #ItensDuplicados);
	Delete From Itens_Fornec						  WHERE Id_Item	In (Select Max(Id_Item) From #ItensDuplicados);
	Delete From Itens_Preco_Industrializacao		  WHERE Id_Item	In (Select Max(Id_Item) From #ItensDuplicados);
	Delete From Natureza_Operacao_Setup_Compras		  WHERE Id_Item	In (Select Max(Id_Item) From #ItensDuplicados);
	Delete From Natureza_Operacao_Setup_Vendas		  WHERE Id_Item	In (Select Max(Id_Item) From #ItensDuplicados);
	Delete From Notas_Fiscais_Itens					  WHERE Id_Item	In (Select Max(Id_Item) From #ItensDuplicados);
	Delete From Notas_Fiscais_Itens_Rastro			  WHERE Id_Item	In (Select Max(Id_Item) From #ItensDuplicados);
	Delete From producao_estruturas					  WHERE Id_Item	In (Select Max(Id_Item) From #ItensDuplicados);
	Delete From producao_estruturas_componentes		  WHERE Id_Item	In (Select Max(Id_Item) From #ItensDuplicados);
	Delete From producao_ordens						  WHERE Id_Item	In (Select Max(Id_Item) From #ItensDuplicados);
	Delete From SETUP								  WHERE Id_Item	In (Select Max(Id_Item) From #ItensDuplicados);
	Delete From SimuladorCalculoImpostos			  WHERE Id_Item	In (Select Max(Id_Item) From #ItensDuplicados);
	Delete From Tarifario_Armadores					  WHERE Id_Item	In (Select Max(Id_Item) From #ItensDuplicados);
	Delete From Tarifario_Outros					  WHERE Id_Item	In (Select Max(Id_Item) From #ItensDuplicados);
	Delete From Tarifario_Portos					  WHERE Id_Item	In (Select Max(Id_Item) From #ItensDuplicados);
	Delete From Tarifario_Transportadores			  WHERE Id_Item	In (Select Max(Id_Item) From #ItensDuplicados);
	Delete From Terminais_Alfandegados				  WHERE Id_Item	In (Select Max(Id_Item) From #ItensDuplicados);
	Delete From Vendas_Historico_An_Cred			  WHERE Id_Item	In (Select Max(Id_Item) From #ItensDuplicados);
	Delete From Vendas_Pedidos_Itens				  WHERE Id_Item	In (Select Max(Id_Item) From #ItensDuplicados);
	--DELETE FROM Vendas_Trocas_Itens					  WHERE Id_Item_Nf IN (SELECT Max(Id_Item) FROM #ItensDuplicados);
	--
    ---- Exclui os itens duplicados da tabela Itens
    DELETE FROM Itens WHERE Id_Item IN (SELECT Max(Id_Item) FROM #ItensDuplicados);

    -- Confirma a transação
    COMMIT TRANSACTION;
END
	ELSE
		BEGIN
		    PRINT 'Não foram encontrados itens duplicados para a descrição especificada.';
		END


-- Exibe uma mensagem de conclusão
PRINT ('Processo de normalização concluído com sucesso.')