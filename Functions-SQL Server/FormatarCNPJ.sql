
--Programdor: Kaike Natan
--Descricao: Funcao Para Formatar CNPJ, usado principalmente no ETL da Tabela Clifor vinda do MBM
--Data: 2024-06-26
--Version: 1.0

CREATE FUNCTION dbo.FormatarCNPJ (@CNPJ VARCHAR(14))
RETURNS VARCHAR(18)
AS
BEGIN
    DECLARE @Resultado VARCHAR(18);

    -- Remove caracteres não numéricos
    SET @CNPJ = REPLACE(REPLACE(REPLACE(REPLACE(@CNPJ, '-', ''), '.', ''), '/', ''), ' ', '');

    -- Adiciona a formatação de CNPJ
    SET @Resultado = STUFF(STUFF(STUFF(STUFF(@CNPJ, 3, 0, '.'), 7, 0, '.'), 11, 0, '/'), 16, 0, '-');

    RETURN @Resultado;
END;
GO
