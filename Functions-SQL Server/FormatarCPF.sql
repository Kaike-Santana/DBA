
--Programdor: Kaike Natan
--Descricao: Funcao Para Formatar CPF, usado principalmente no ETL da Tabela Clifor vinda do MBM
--Data: 2024-06-26
--Version: 1.0

CREATE FUNCTION dbo.FormatarCPF (@CPF VARCHAR(11))
RETURNS VARCHAR(14)
AS
BEGIN
    DECLARE @Resultado VARCHAR(14);

    -- Remove caracteres não numéricos
    SET @CPF = REPLACE(REPLACE(REPLACE(@CPF, '-', ''), '.', ''), ' ', '');

    -- Adiciona a formatação de CPF
    SET @Resultado = STUFF(STUFF(STUFF(@CPF, 4, 0, '.'), 8, 0, '.'), 12, 0, '-');

    RETURN @Resultado;
END;
GO