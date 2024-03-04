-- Substitua 'SeuBancoDeDados' pelo nome do seu banco de dados
USE DW_Discador;

-- Consulta para obter informações sobre os arquivos de dados
SELECT 
    name AS NomeDoArquivo,
    physical_name AS CaminhoDoArquivo,
    size/128.0 AS TamanhoMB,
    type_desc AS Tipo
FROM sys.master_files
WHERE database_id = DB_ID('DW_Discador');

-- Substitua 'SeuBancoDeDados' pelo nome do seu banco de dados
-- Substitua 'NomeDoArquivoDeDados' pelo nome do seu arquivo de dados
-- Substitua '150000' pelo tamanho desejado em megabytes

USE DW_Discador;

-- Execute o Shrink para um arquivo de dados específico
DBCC SHRINKFILE('DW_Discador', 130000);
