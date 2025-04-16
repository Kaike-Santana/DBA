 
 Use Thesys_Homologacao
 Go

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* Programador: Kaike Natan																		*/
/* Versao     : Data: 22/08/2024																*/
/* Descricao  : Script De ETL Da Tabela Clifor ChavePix do MBM Para o TheSys					*/
/*																								*/
/* Alteracao																					*/
/*        2. Programador:                                                  Data: __/__/____		*/        
/*           Descricao  :																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	Create Procedure Prc_ETL_Clifor_ChavePix_MBM As
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Base Analitica Com as Chaves Pix dos CLifors da PoliResinas						*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Begin;
	Set NoCount On;

Drop Table If Exists #BaseChavePix
Select *
,	Pk = Trim(Cod_Clifor) + Convert(Varchar(10),Sequencia)
Into #BaseChavePix
From OpenQuery([Mbm_PoliResinas],'
Select 
	Clifor_ChavePix.*
,	Clifor.Cgc_Cpf
,	Clifor.Razao
From Clifor_ChavePix
Join Clifor On (Clifor.Cod_Clifor = Clifor_ChavePix.Cod_Clifor)')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Deixa Só os Clifor Nacionais														*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #Nacional
Select *
Into #Nacional
From #BaseChavePix
Where Cgc_Cpf Not In ('00.000.000/0000-00','000.000.000-00')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Deixa Só os Clifor Internacionais													*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #Exterior
Select *
Into #Exterior
From #BaseChavePix
Where Cgc_Cpf In ('00.000.000/0000-00','000.000.000-00')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Insere Apenas os Dados Incrementais na Tabela Fisica do Thesys					*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Insert Into [Dbo].[CliFor_ChavePix] 
           (
		    [id_clifor]
           ,[id_banco]
           ,[tipo_chave]
           ,[tel_celular]
           ,[email]
           ,[cpfcnpj]
           ,[chave_aleatoria]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device]
		   ,[Pk]
		   )

Select 
	[id_clifor]		  = Clifor.Cod_Clifor
,	[id_banco]		  = Bancos.Id_Banco
,	[tipo_chave]	  = Fato.Tipo_IdentificacaoPix
,	[tel_celular]	  = Fato.Tel_Celular
,	[email]			  = Fato.Email
,	[cpfcnpj]		  = Fato.Cgc_Cpf
,	[chave_aleatoria] = Fato.Chave_Aleatoria
,	[incl_data]		  = GetDate()
,	[incl_user]		  = 'ksantana'
,	[incl_device]	  = 'PC/10.1.0.123'
,	[modi_data]		  = Null
,	[modi_user]		  = Null
,	[modi_device]	  = Null
,	[excl_data]		  = Null
,	[excl_user]		  = Null
,	[excl_device]	  = Null
,	[Pk]			  = Fato.Pk
From #Nacional Fato
Inner Join Clifor	On  Isnull(Clifor.Cnpj,Clifor.Cpf) = Fato.Cgc_Cpf   Collate Latin1_General_Ci_Ai 
					And Isnull(Clifor.Cnpj,Clifor.Cpf) Not In ('00.000.000/0000-00','000.000.000-00')
Left  Join Bancos   On  Bancos.Cod_Banco			   = Fato.Cod_Banco Collate Latin1_General_Ci_Ai 
Where Not Exists (
				  Select *
				  From CliFor_ChavePix Dim 
				  Where Dim.Pk = Fato.Pk Collate Latin1_General_Ci_Ai 
				 )
Union All

Select 
	[id_clifor]		  = Clifor.Cod_Clifor
,	[id_banco]		  = Bancos.Id_Banco
,	[tipo_chave]	  = Fato.Tipo_IdentificacaoPix
,	[tel_celular]	  = Fato.Tel_Celular
,	[email]			  = Fato.Email
,	[cpfcnpj]		  = Fato.Cgc_Cpf
,	[chave_aleatoria] = Fato.Chave_Aleatoria
,	[incl_data]		  = GetDate()
,	[incl_user]		  = 'ksantana'
,	[incl_device]	  = 'PC/10.1.0.123'
,	[modi_data]		  = Null
,	[modi_user]		  = Null
,	[modi_device]	  = Null
,	[excl_data]		  = Null
,	[excl_user]		  = Null
,	[excl_device]	  = Null
,	[Pk]			  = Fato.Pk
From #Nacional Fato
Inner Join Clifor	On  Isnull(Clifor.Cnpj,Clifor.Cpf) = Fato.Cgc_Cpf   Collate Latin1_General_Ci_Ai 
					And Isnull(Clifor.Cnpj,Clifor.Cpf) In ('00.000.000/0000-00','000.000.000-00')
					And Clifor.Razao				   = Fato.Razao     Collate Latin1_General_Ci_Ai 
Left  Join Bancos   On  Bancos.Cod_Banco			   = Fato.Cod_Banco Collate Latin1_General_Ci_Ai
Where Not Exists (
				  Select *
				  From CliFor_ChavePix Dim 
				  Where Dim.Pk = Fato.Pk Collate Latin1_General_Ci_Ai 
				 )
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Dropa as Tabelas Temporarias Da Procedure											*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Begin
   Drop Table If Exists #BaseChavePix
   Drop Table If Exists #Nacional
   Drop Table If Exists #Exterior
End

End;