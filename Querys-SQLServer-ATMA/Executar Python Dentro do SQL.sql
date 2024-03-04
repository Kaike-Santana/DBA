


-- Criando o comando para executar o script .py
DECLARE @ComandoExecutarBat VARCHAR(1000) = '\\atlantida\MIS\"Kaike Natan"\PYTHON\Executaveis\DumpSolFacilSFTP.py'
EXEC xp_cmdshell @ComandoExecutarBat;