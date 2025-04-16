
Use Thesys_Homologacao
Go

Drop Table If Exists #SerieMBM
Select *
Into #SerieMBM
From OpenQuery([Mbm_Polirex],'
Select *
From Serie
')


Insert Into [dbo].[Series]
           ([id_empresa]
           ,[cod_serie]
           ,[nro_nfiscal]
           ,[nro_fatura]
           ,[serie1]
           ,[nro_nfe]
           ,[nfe]
           ,[nfe_imprimelote]
           ,[path_exportacaonfe]
           ,[enviar_email_cc_nfe]
           ,[email_cc_nfe]
           ,[nfe_imprimefabricacao]
           ,[tipo_anexosemailnfce]
           ,[nfce_tipolayout]
           ,[nfe_dtentcontingencia]
           ,[nfe_motivocontingencia]
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
	[id_empresa]			 = Empresas.Id_Empresa
,	[cod_serie]				 = Fato.Cod_Serie
,	[nro_nfiscal]			 = Fato.Nro_Nfiscal
,	[nro_fatura]			 = Fato.Nro_Fatura
,	[serie1]				 = Fato.Serie1
,	[nro_nfe]				 = Fato.Nro_Nfe
,	[nfe]					 = Fato.Nfe
,	[nfe_imprimelote]		 = Fato.[nfe_imprimelote]
,	[path_exportacaonfe]	 = Fato.[path_exportacaonfe]
,	[enviar_email_cc_nfe]	 = Fato.[enviar_email_cc_nfe]
,	[email_cc_nfe]			 = Fato.[email_cc_nfe]
,	[nfe_imprimefabricacao]	 = Fato.[nfe_imprimefabricacao]
,	[tipo_anexosemailnfce]	 = Fato.[tipo_anexosemailnfce]
,	[nfce_tipolayout]		 = Fato.[nfce_tipolayout]
,	[nfe_dtentcontingencia]	 = Fato.[nfe_dtentcontingencia]
,	[nfe_motivocontingencia] = Fato.[nfe_motivocontingencia]
,	[incl_data]				 = GetDate()
,	[incl_user]				 = 'ksantana'
,	[incl_device]			 = 'PC/10.1.0.123'
,	[modi_data]				 = Null
,	[modi_user]				 = Null
,	[modi_device]			 = Null
,	[excl_data]				 = Null
,	[excl_user]				 = Null
,	[excl_device]			 = Null
From #SerieMBM Fato
Join Empresas On Empresas.Codigo_Antigo = Fato.Cod_Empresa Collate Sql_Latin1_General_Cp1_Ci_Ai 
Where Not Exists (
				  Select *
				  From Series Dim
				  Where Dim.Cod_Serie  = Fato.Cod_Serie Collate Sql_Latin1_General_Cp1_Ci_Ai 
				  And   Dim.Id_Empresa = Empresas.Id_Empresa
				 )