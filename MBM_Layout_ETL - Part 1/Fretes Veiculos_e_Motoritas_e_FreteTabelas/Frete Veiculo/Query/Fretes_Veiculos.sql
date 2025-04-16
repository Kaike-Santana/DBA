
USE [THESYS_DEV]
GO

INSERT INTO [dbo].[frete_veiculos]
           ([tipo]
           ,[descricao]
           ,[marca]
           ,[modelo]
           ,[ano_fabricacao]
           ,[ano_modelo]
           ,[placa_cavalo_truck]
           ,[placa_carreta]
           ,[observacoes]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device])

Select 
	[tipo]					= veiculo
,	[descricao]				= descricao
,	[marca]					= marca
,	[modelo]				= modelo
,	[ano_fabricacao]		= ano_fabricacao
,	[ano_modelo]			= IIF(ano_modelo = 0, '20' + RIGHT(TRIM(ano_original), 2), ano_modelo)
,	[placa_cavalo_truck]	= PLACA
,	[placa_carreta]			= NULL
,	[observacoes]			= NULL
,	[incl_data]				= GETDATE()
,	[incl_user]				= 'ksantana'
,	[incl_device]			= 'PC/10.1.0.123'
,	[modi_data]				= NULL
,	[modi_user]				= NULL
,	[modi_device]			= NULL
,	[excl_data]				= NULL
,	[excl_user]				= NULL
,	[excl_device]			= NULL
FROM (
SELECT 
    QUANT, 
    veiculo, 
    Descricao, 
    MARCA, 
    modelo, 
    PLACA, 
    CHASSI, 
    RENAVAM,
    ANO AS ano_original,
    CASE 
        WHEN CHARINDEX('/', ANO) > 0 THEN 
            CASE 
                WHEN LEN(LEFT(ANO, CHARINDEX('/', ANO) - 1)) = 2 THEN '20' + LEFT(ANO, CHARINDEX('/', ANO) - 1)
                ELSE LEFT(ANO, CHARINDEX('/', ANO) - 1)
            END
        ELSE ANO
    END AS ano_fabricacao,
    CASE 
        WHEN CHARINDEX('/', ANO) > 0 THEN 
            CASE 
                WHEN LEN(RIGHT(ANO, LEN(ANO) - CHARINDEX('/', ANO))) = 2 THEN '20' + RIGHT(ANO, 2)
                ELSE RIGHT(ANO, LEN(ANO) - CHARINDEX('/', ANO))
            END
        ELSE ANO
    END AS ano_modelo,
    COR, 
    MOTORISTA
FROM aux_frete_veiculo
WHERE VEICULO != 'CARRETA'
)SUBQUERY