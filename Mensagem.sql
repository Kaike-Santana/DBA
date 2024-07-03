
DROP TABLE IF EXISTS #CONSOLIDADO 
SELECT 
	EMPRESA = 'RUBBERON'
,	*
INTO #CONSOLIDADO
FROM OPENQUERY([MBM_RUBBERON],'
Select 
  cod_mensagem, 
  cast(mensagem as character varying(2000)) as mensagem , 
  descricao, 
  dt_change, 
  sped_gerareg0450, 
  sped_processoreferenciado, 
  sped_docarrecadacao, 
  sped_docfiscalreferenciado, 
  sped_cupomfiscalreferenciado, 
  sped_0450observacao, 
  sped_gerareg0460, 
  sped_0460observacao 
From mensagem
')

UNION ALL

SELECT 
	EMPRESA = 'POLIRESINAS'
,	*
FROM OPENQUERY([MBM_POLIRESINAS],'
Select 
  cod_mensagem, 
  cast(mensagem as character varying(2000)) as mensagem , 
  descricao, 
  dt_change, 
  sped_gerareg0450, 
  sped_processoreferenciado, 
  sped_docarrecadacao, 
  sped_docfiscalreferenciado, 
  sped_cupomfiscalreferenciado, 
  sped_0450observacao, 
  sped_gerareg0460, 
  sped_0460observacao 
From mensagem
')

UNION ALL

SELECT 
	EMPRESA = 'NORTEBAG'
,	*
FROM OPENQUERY([MBM_NORTEBAG],'
Select 
  cod_mensagem, 
  cast(mensagem as character varying(2000)) as mensagem , 
  descricao, 
  dt_change, 
  sped_gerareg0450, 
  sped_processoreferenciado, 
  sped_docarrecadacao, 
  sped_docfiscalreferenciado, 
  sped_cupomfiscalreferenciado, 
  sped_0450observacao, 
  sped_gerareg0460, 
  sped_0460observacao 
From mensagem
')

UNION ALL

SELECT 
	EMPRESA = 'MG_POLIMEROS'
,	*
FROM OPENQUERY([MBM_MG_POLIMEROS],'
Select 
  cod_mensagem, 
  cast(mensagem as character varying(2000)) as mensagem , 
  descricao, 
  dt_change, 
  sped_gerareg0450, 
  sped_processoreferenciado, 
  sped_docarrecadacao, 
  sped_docfiscalreferenciado, 
  sped_cupomfiscalreferenciado, 
  sped_0450observacao, 
  sped_gerareg0460, 
  sped_0460observacao 
From mensagem
')

UNION ALL

SELECT 
	EMPRESA = 'POLIREX'
,	*
FROM OPENQUERY([MBM_POLIREX],'
Select 
  cod_mensagem, 
  cast(mensagem as character varying(2000)) as mensagem , 
  descricao, 
  dt_change, 
  sped_gerareg0450, 
  sped_processoreferenciado, 
  sped_docarrecadacao, 
  sped_docfiscalreferenciado, 
  sped_cupomfiscalreferenciado, 
  sped_0450observacao, 
  sped_gerareg0460, 
  sped_0460observacao 
From mensagem
')


INSERT INTO [dbo].[Mensagem]
           ([id_empresa_grupo]
           ,[cod_mensagem]
           ,[mensagem]
           ,[descricao]
           ,[dt_change]
           ,[sped_gerareg0450]
           ,[sped_processoreferenciado]
           ,[sped_docarrecadacao]
           ,[sped_docfiscalreferenciado]
           ,[sped_cupomfiscalreferenciado]
           ,[sped_0450observacao]
           ,[sped_gerareg0460]
           ,[sped_0460observacao]
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
	[id_empresa_grupo]			   = 179
,	[cod_mensagem]				   
,	[mensagem]					   
,	[descricao]					   
,	[dt_change]					   
,	[sped_gerareg0450]			  
,	[sped_processoreferenciado]	  
,	[sped_docarrecadacao]		   
,	[sped_docfiscalreferenciado]    
,	[sped_cupomfiscalreferenciado]  
,	[sped_0450observacao]		    
,	[sped_gerareg0460]			    
,	[sped_0460observacao]		    
,	[incl_data]					   = GetDate()
,	[incl_user]					   = 'ksantana'
,	[incl_device]				   = 'PC/10.1.0.123'
,	[modi_data]					   = null
,	[modi_user]					   = null
,	[modi_device]				   = null
,	[excl_data]					   = null
,	[excl_user]					   = null
,	[excl_device]				   = null
From #Consolidado fato
where EMPRESA = 'POLIREX' --> ir trocando as empresas!
and not exists (
			    select *
				from Mensagem dim
				where dim.cod_mensagem = fato.cod_mensagem collate latin1_general_ci_ai 
				and dim.id_empresa_grupo = 179 
			   )
/*
empresas_grupos

179		POLIREX
999		THESYS COMPANY
1584	POLI RESINAS
4399	NORTEBAG
9641	RUBBERON
14144	MG POLIMEROS
51123	CLOROETIL
*/