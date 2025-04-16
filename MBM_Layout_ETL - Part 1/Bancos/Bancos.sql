
Use Thesys_Homologacao
Go

Drop Table If Exists #BancosMBM
Select *
Into #BancosMBM
From OpenQuery([Mbm_Polirex],'
Select *
From Banco')


Drop Table If Exists #Uniq
Select *
Into #Uniq
From (
Select *
,	Rw = Row_Number() Over ( Partition By Cod_Banco Order By Dt_Change Desc)
From #BancosMBM
)SubQuery
Where Rw = 1


Insert Into [dbo].[Bancos]
           ([cod_banco]
           ,[descricao]
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
	[cod_banco]		=  Cod_Banco
,	[descricao]		=  Descricao	
,	[incl_data]		=  GetDate()	
,	[incl_user]		=  'ksantana'	
,	[incl_device]	=	'PC/10.1.0.123'
,	[modi_data]		=	Null
,	[modi_user]		=	Null
,	[modi_device]	=	Null
,	[excl_data]		=	Null
,	[excl_user]		=	Null
,	[excl_device]	=	Null
From #BancosMBM Fato
Where Not Exists (
				  Select *
				  From Bancos Dim
				  Where Dim.cod_banco = Fato.cod_banco Collate latin1_general_ci_ai
				 )