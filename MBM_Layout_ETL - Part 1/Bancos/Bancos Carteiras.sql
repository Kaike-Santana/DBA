
Use Thesys_Dev
Go

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* Programador: Kaike Natan																		*/
/* Versao     : Data: 22/07/2024																*/
/* Descricao  : Script De ETL Da Tabela Banco Tipo Carteira do MBM								*/
/*																								*/
/* Alteracao																					*/
/*        2. Programador:                                                  Data: __/__/____		*/        
/*           Descricao  :																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Consolida Base Das 5 empresas Para Popular a Tabela Bancos Tipo Carteira			*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #BancosCarteira
Select 
	Empresa = 'PoliResinas'
,	* 
Into #BancosCarteira
From OpenQuery([Mbm_Poliresinas],'
Select *
From Banco_TipoCarteira 
')

Union All

Select 
	Empresa = 'Rubberon'
,	* 
From OpenQuery([Mbm_Rubberon],'
Select *
From Banco_TipoCarteira 
')

Union All

Select 
	Empresa = 'Mg_Polimeros'
,	* 
From OpenQuery([Mbm_Mg_Polimeros],'
Select *
From Banco_TipoCarteira 
')

Union All

Select 
	Empresa = 'Polirex'
,	* 
From OpenQuery([Mbm_Polirex],'
Select *
From Banco_TipoCarteira 
')

Union All

Select 
	Empresa = 'Nortebag'
,	* 
From OpenQuery([Mbm_Nortebag],'
Select *
From Banco_TipoCarteira 
')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Tabela Auxiliar Com os Estados e Suas Respectivas Regioes							*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #Final
Select *
Into #Final
From (
	  Select *
	  ,	rw = row_number () over ( partition by cod_banco, cod_tipocarteira order by Len(descricao) desc)
	  From #BancosCarteira
	 )SubQuery
Where Rw = 1
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Tabela Auxiliar Com os Estados e Suas Respectivas Regioes							*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/	
--CREATE TABLE Bancos_Carteiras (
--    id_banco_carteira INT IDENTITY(1,1) PRIMARY KEY,
--    cod_banco CHAR(3) Not NULL,
--    cod_tipocarteira VARCHAR(50) Not null,
--    descricao VARCHAR(255),
--    codigo_nobanco VARCHAR(50),
--    gerar_nossonumero CHAR(1),
--    gerar_dv CHAR(1),
--    variacao_carteira TINYINT,
--    tipo_carteira TINYINT,
--    caracteristica_carteira TINYINT,
--	[incl_data] [datetime] NULL,
--	[incl_user] [varchar](10) NULL,
--	[incl_device] [varchar](30) NULL,
--	[modi_data] [datetime] NULL,
--	[modi_user] [varchar](10) NULL,
--	[modi_device] [varchar](30) NULL,
--	[excl_data] [datetime] NULL,
--	[excl_user] [varchar](10) NULL,
--	[excl_device] [varchar](30) NULL,
--);
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Tabela Auxiliar Com os Estados e Suas Respectivas Regioes							*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/	
Insert Into [dbo].[Bancos_Carteiras]
           ([cod_banco]
           ,[cod_tipocarteira]
           ,[descricao]
           ,[codigo_nobanco]
           ,[gerar_nossonumero]
           ,[gerar_dv]
           ,[variacao_carteira]
           ,[tipo_carteira]
           ,[caracteristica_carteira]
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
	[cod_banco]
,	[cod_tipocarteira]
,	[descricao]
,	[codigo_nobanco]
,	[gerar_nossonumero]
,	[gerar_dv]
,	[variacao_carteira]
,	[tipo_carteira]
,	[caracteristica_carteira]
,	[incl_data]		=  GetDate()
,	[incl_user]		= 'ksantana'
,	[incl_device]   = 'PC/10.1.0.123'
,	[modi_data]		= Null
,	[modi_user]		= Null
,	[modi_device]	= Null
,	[excl_data]		= Null
,	[excl_user]		= Null
,	[excl_device]	= Null
From #BancosCarteira