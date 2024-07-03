
USE THESYS_HOMOLOGACAO
GO

--> Tabela deXpara de um txt baseado no excel TIPODOCTO
SELECT *
into #teste
FROM (
		SELECT *
		,	RW = ROW_NUMBER() OVER ( PARTITION BY GRUPO_THESYS, DESCRICAO_MBM ORDER BY GRUPO_THESYS DESC)
		FROM Tabela_Tipo_Documentos
	 )SubQuery
WHERE RW = 1


INSERT INTO [dbo].[Tipos_Documentos]
           ([grupo]
           ,[descricao]
           ,[ativo]
           ,[diario_auxiliar]
           ,[lancto_contabil]
           ,[antecipacao]
           ,[origem]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device]
		   ,[cod_tipodocto]
		   )

select 
	[grupo]				=	grupo_thesys
,	[descricao]			=	descricao_mbm
,	[ativo]				=	ativo
,	[diario_auxiliar]	=	diario_auxiliar
,	[lancto_contabil]	=	[lancto_contabil]
,	[antecipacao]		=	[antecipacao]
,	[origem]			=	null
,	[incl_data]			=	getdate()
,	[incl_user]			=	'ksantana'
,	[incl_device]		=	'PC/10.1.0.51'
,	[modi_data]			=	null
,	[modi_user]			=	null
,	[modi_device]		=	null
,	[excl_data]			=	null
,	[excl_user]			=	null
,	[excl_device]		=	null
,	[cod_tipodocto]		=	[cod_tipodocto]
from #teste