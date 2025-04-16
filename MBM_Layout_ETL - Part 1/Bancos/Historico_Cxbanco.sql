
Use Thesys_Dev
Go

Create Procedure Prc_Etl_Historico_Cxbanco_MBM As

Begin

Drop Table If Exists #BaseMBM
Select *
Into #BaseMBM
From OpenQuery([Mbm_PoliResinas],'
Select 
  histor_cxbanco.cod_historcxbanco, 
  histor_cxbanco.descricao, 
  cast(histor_cxbanco.mensagem as varchar(3000)) as mensagem, 
  histor_cxbanco.ativo, 
  histor_cxbanco.tipo, 
  histor_cxbanco.motivo_bloqueio, 
  histor_cxbanco.tipo_documento, 
  histor_cxbanco.dt_change, 
  histor_cxbanco.gerar_lanc_aut_tes, 
  histor_cxbanco.cod_natrecdesp ,
  histor_cxbancopcontas.cod_planocontas,
  histor_cxbancopcontascc.cod_centrocusto
From histor_cxbanco
Left Join histor_cxbancopcontas   On  (histor_cxbancopcontas.cod_historcxbanco   = histor_cxbanco.cod_historcxbanco       )
Left Join histor_cxbancopcontascc On  (histor_cxbancopcontascc.cod_historcxbanco = histor_cxbancopcontas.cod_historcxbanco)
								  And (histor_cxbancopcontascc.cod_empresa		 = histor_cxbancopcontas.cod_empresa	  )
								  And (histor_cxbancopcontascc.cod_planocontas	 = histor_cxbancopcontas.cod_planocontas  )
')

Union All

Select *
From OpenQuery([Mbm_Rubberon],'
Select 
  histor_cxbanco.cod_historcxbanco, 
  histor_cxbanco.descricao, 
  cast(histor_cxbanco.mensagem as varchar(3000)) as mensagem, 
  histor_cxbanco.ativo, 
  histor_cxbanco.tipo, 
  histor_cxbanco.motivo_bloqueio, 
  histor_cxbanco.tipo_documento, 
  histor_cxbanco.dt_change, 
  histor_cxbanco.gerar_lanc_aut_tes, 
  histor_cxbanco.cod_natrecdesp ,
  histor_cxbancopcontas.cod_planocontas,
  histor_cxbancopcontascc.cod_centrocusto
From histor_cxbanco
Left Join histor_cxbancopcontas   On  (histor_cxbancopcontas.cod_historcxbanco   = histor_cxbanco.cod_historcxbanco       )
Left Join histor_cxbancopcontascc On  (histor_cxbancopcontascc.cod_historcxbanco = histor_cxbancopcontas.cod_historcxbanco)
								  And (histor_cxbancopcontascc.cod_empresa		 = histor_cxbancopcontas.cod_empresa	  )
								  And (histor_cxbancopcontascc.cod_planocontas	 = histor_cxbancopcontas.cod_planocontas  )
')

Union All

Select *
From OpenQuery([Mbm_PoliRex],'
Select 
  histor_cxbanco.cod_historcxbanco, 
  histor_cxbanco.descricao, 
  cast(histor_cxbanco.mensagem as varchar(3000)) as mensagem, 
  histor_cxbanco.ativo, 
  histor_cxbanco.tipo, 
  histor_cxbanco.motivo_bloqueio, 
  histor_cxbanco.tipo_documento, 
  histor_cxbanco.dt_change, 
  histor_cxbanco.gerar_lanc_aut_tes, 
  histor_cxbanco.cod_natrecdesp ,
  histor_cxbancopcontas.cod_planocontas,
  histor_cxbancopcontascc.cod_centrocusto
From histor_cxbanco
Left Join histor_cxbancopcontas   On  (histor_cxbancopcontas.cod_historcxbanco   = histor_cxbanco.cod_historcxbanco       )
Left Join histor_cxbancopcontascc On  (histor_cxbancopcontascc.cod_historcxbanco = histor_cxbancopcontas.cod_historcxbanco)
								  And (histor_cxbancopcontascc.cod_empresa		 = histor_cxbancopcontas.cod_empresa	  )
								  And (histor_cxbancopcontascc.cod_planocontas	 = histor_cxbancopcontas.cod_planocontas  )
')

Union All

Select *
From OpenQuery([Mbm_Mg_Polimeros],'
Select 
  histor_cxbanco.cod_historcxbanco, 
  histor_cxbanco.descricao, 
  cast(histor_cxbanco.mensagem as varchar(3000)) as mensagem, 
  histor_cxbanco.ativo, 
  histor_cxbanco.tipo, 
  histor_cxbanco.motivo_bloqueio, 
  histor_cxbanco.tipo_documento, 
  histor_cxbanco.dt_change, 
  histor_cxbanco.gerar_lanc_aut_tes, 
  histor_cxbanco.cod_natrecdesp ,
  histor_cxbancopcontas.cod_planocontas,
  histor_cxbancopcontascc.cod_centrocusto
From histor_cxbanco
Left Join histor_cxbancopcontas   On  (histor_cxbancopcontas.cod_historcxbanco   = histor_cxbanco.cod_historcxbanco       )
Left Join histor_cxbancopcontascc On  (histor_cxbancopcontascc.cod_historcxbanco = histor_cxbancopcontas.cod_historcxbanco)
								  And (histor_cxbancopcontascc.cod_empresa		 = histor_cxbancopcontas.cod_empresa	  )
								  And (histor_cxbancopcontascc.cod_planocontas	 = histor_cxbancopcontas.cod_planocontas  )
')

Union All

Select *
From OpenQuery([Mbm_NorteBag],'
Select 
  histor_cxbanco.cod_historcxbanco, 
  histor_cxbanco.descricao, 
  cast(histor_cxbanco.mensagem as varchar(3000)) as mensagem, 
  histor_cxbanco.ativo, 
  histor_cxbanco.tipo, 
  histor_cxbanco.motivo_bloqueio, 
  histor_cxbanco.tipo_documento, 
  histor_cxbanco.dt_change, 
  histor_cxbanco.gerar_lanc_aut_tes, 
  histor_cxbanco.cod_natrecdesp ,
  histor_cxbancopcontas.cod_planocontas,
  histor_cxbancopcontascc.cod_centrocusto
From histor_cxbanco
Left Join histor_cxbancopcontas   On  (histor_cxbancopcontas.cod_historcxbanco   = histor_cxbanco.cod_historcxbanco       )
Left Join histor_cxbancopcontascc On  (histor_cxbancopcontascc.cod_historcxbanco = histor_cxbancopcontas.cod_historcxbanco)
								  And (histor_cxbancopcontascc.cod_empresa		 = histor_cxbancopcontas.cod_empresa	  )
								  And (histor_cxbancopcontascc.cod_planocontas	 = histor_cxbancopcontas.cod_planocontas  )
')


Drop Table If Exists #Uniq
Select *
Into #Uniq
From (
	   Select *
	   ,	Rw = Row_Number() Over ( Partition By Cod_HistorCxBanco, Tipo Order By Dt_Change Desc)
	   From #BaseMBM
	 ) SubQuery
Where Rw = 1


Insert Into [dbo].[Historico_Cxbanco]
           ([cod_historcxbanco]
           ,[descricao]
           ,[mensagem]
           ,[ativo]
           ,[tipo]
           ,[gerar_lanc_aut]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device]
           ,[id_centro_custo]
           ,[id_plano])
Select 
	[cod_historcxbanco] = Fato.[cod_historcxbanco]
,	[descricao]			= Fato.[descricao]
,	[mensagem]			= Fato.[mensagem]
,	[ativo]				= Fato.[ativo]
,	[tipo]				= Fato.Tipo
,	[gerar_lanc_aut]	= Fato.[gerar_lanc_aut_tes]
,	[incl_data]			= GetDate()
,	[incl_user]			= 'ksantana'
,	[incl_device]		= 'PC/10.1.0.123'
,	[modi_data]			= Null
,	[modi_user]			= Null
,	[modi_device]		= Null
,	[excl_data]			= Null
,	[excl_user]			= Null
,	[excl_device]		= Null
,	[id_centro_custo]	= Centro_Custo.id_centro_custo
,	[id_plano]			= Plano_Contas.id_plano
From #Uniq Fato
Left Join Centro_Custo On  Centro_Custo.cod_centrocusto = Fato.cod_centrocusto Collate latin1_general_ci_ai
Left Join Plano_Contas On  Plano_Contas.cod_planocontas = Fato.cod_planocontas Collate latin1_general_ci_ai
					   And Plano_Contas.tipo            = Fato.Tipo            Collate latin1_general_ci_ai
Where Not Exists (
				  Select *
				  From Historico_Cxbanco Dim
				  Where Dim.Cod_HistorCxBanco = Fato.Cod_HistorCxBanco Collate latin1_general_ci_ai
				  And   Dim.Tipo			  = Fato.Tipo              Collate latin1_general_ci_ai
				 )

Declare @InsertedRows Int = @@RowCount;

-- Imprime o número de linhas inseridas
Print ('Número de linhas inseridas: ' + Cast(@InsertedRows As Varchar))


End;