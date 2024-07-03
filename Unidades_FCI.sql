
DROP TABLE [THESYS_HOMOLOGACAO].[dbo].[Unidades_FCI]
SELECT 
	   [id_unidade_fci]
      ,[abreviatura]
      ,[descricao]
INTO [THESYS_HOMOLOGACAO].[dbo].[Unidades_FCI]
FROM [THESYS_DEV].[dbo].[Unidades_FCI]
