
Use Thesys_Dev
Go

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* Programador: Kaike Natan																		*/
/* Versao     : Data: 22/08/2024																*/
/* Descricao  : Script De ETL Da Tabela Clifor Bancos do MBM Para o TheSys						*/
/*																								*/
/* Alteracao																					*/
/*        2. Programador:                                                  Data: __/__/____		*/        
/*           Descricao  :																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	Create Procedure Prc_ETL_Clifor_Bancos_MBM As
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Base Analitica Com os Bancos dos CLifors do MBM									*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Begin;
	Set NoCount On;

Drop Table If Exists #CliforBanco
Select *
,	Pk = Trim(Cnpj_Cpf) + Trim(Cod_Banco) + Trim(Nro_Agencia) + Trim(Nro_Conta)
Into #CliforBanco
From OpenQuery([Mbm_PoliResinas],'
Select 
  ContaBancaria_Cheques.Cnpj_Cpf, 
  ContaBancaria_Cheques.Cod_Banco, 
  ContaBancaria_Cheques.Nro_Agencia, 
  ContaBancaria_Cheques.Nro_Conta, 
  ContaBancaria_Cheques.Nome,  
  ContaBancaria_Cheques.Pessoa, 
  ContaBancaria_Cheques.Digito_VerifAgencia, 
  ContaBancaria_Cheques.Digito_Verificador, 
  ContaBancaria_Cheques.Dt_Change, 
  Clifor.Razao,
  Clifor.Cgc_Cpf
From ContaBancaria_Cheques
Join Clifor On (Clifor.Cod_Clifor = ContaBancaria_Cheques.Cod_Clifor)')

Union All

Select *
,	Pk = Trim(Cnpj_Cpf) + Trim(Cod_Banco) + Trim(Nro_Agencia) + Trim(Nro_Conta)
From OpenQuery([Mbm_Rubberon],'
Select 
  ContaBancaria_Cheques.Cnpj_Cpf, 
  ContaBancaria_Cheques.Cod_Banco, 
  ContaBancaria_Cheques.Nro_Agencia, 
  ContaBancaria_Cheques.Nro_Conta, 
  ContaBancaria_Cheques.Nome,  
  ContaBancaria_Cheques.Pessoa, 
  ContaBancaria_Cheques.Digito_VerifAgencia, 
  ContaBancaria_Cheques.Digito_Verificador, 
  ContaBancaria_Cheques.Dt_Change, 
  Clifor.Razao,
  Clifor.Cgc_Cpf
From ContaBancaria_Cheques
Join Clifor On (Clifor.Cod_Clifor = ContaBancaria_Cheques.Cod_Clifor)')

Union All

Select *
,	Pk = Trim(Cnpj_Cpf) + Trim(Cod_Banco) + Trim(Nro_Agencia) + Trim(Nro_Conta)
From OpenQuery([Mbm_Mg_Polimeros],'
Select 
  ContaBancaria_Cheques.Cnpj_Cpf, 
  ContaBancaria_Cheques.Cod_Banco, 
  ContaBancaria_Cheques.Nro_Agencia, 
  ContaBancaria_Cheques.Nro_Conta, 
  ContaBancaria_Cheques.Nome,  
  ContaBancaria_Cheques.Pessoa, 
  ContaBancaria_Cheques.Digito_VerifAgencia, 
  ContaBancaria_Cheques.Digito_Verificador, 
  ContaBancaria_Cheques.Dt_Change, 
  Clifor.Razao,
  Clifor.Cgc_Cpf
From ContaBancaria_Cheques
Join Clifor On (Clifor.Cod_Clifor = ContaBancaria_Cheques.Cod_Clifor)')

Union All

Select *
,	Pk = Trim(Cnpj_Cpf) + Trim(Cod_Banco) + Trim(Nro_Agencia) + Trim(Nro_Conta)
From OpenQuery([Mbm_Polirex],'
Select 
  ContaBancaria_Cheques.Cnpj_Cpf, 
  ContaBancaria_Cheques.Cod_Banco, 
  ContaBancaria_Cheques.Nro_Agencia, 
  ContaBancaria_Cheques.Nro_Conta, 
  ContaBancaria_Cheques.Nome,  
  ContaBancaria_Cheques.Pessoa, 
  ContaBancaria_Cheques.Digito_VerifAgencia, 
  ContaBancaria_Cheques.Digito_Verificador, 
  ContaBancaria_Cheques.Dt_Change, 
  Clifor.Razao,
  Clifor.Cgc_Cpf
From ContaBancaria_Cheques
Join Clifor On (Clifor.Cod_Clifor = ContaBancaria_Cheques.Cod_Clifor)')

Union All

Select *
,	Pk = Trim(Cnpj_Cpf) + Trim(Cod_Banco) + Trim(Nro_Agencia) + Trim(Nro_Conta)
From OpenQuery([Mbm_NorteBag],'
Select 
  ContaBancaria_Cheques.Cnpj_Cpf, 
  ContaBancaria_Cheques.Cod_Banco, 
  ContaBancaria_Cheques.Nro_Agencia, 
  ContaBancaria_Cheques.Nro_Conta, 
  ContaBancaria_Cheques.Nome,  
  ContaBancaria_Cheques.Pessoa, 
  ContaBancaria_Cheques.Digito_VerifAgencia, 
  ContaBancaria_Cheques.Digito_Verificador, 
  ContaBancaria_Cheques.Dt_Change, 
  Clifor.Razao,
  Clifor.Cgc_Cpf
From ContaBancaria_Cheques
Join Clifor On (Clifor.Cod_Clifor = ContaBancaria_Cheques.Cod_Clifor)')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Garante a Integridade dos Dados de Acordo Com a Pk do MBM							*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #Uniq
Select *
Into #Uniq
From (
	   Select *
	   ,	Rw = Row_Number() Over ( Partition By Pk Order By Pk Desc)
	   From #CliforBanco
	 )SubQuery
Where Rw = 1
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Deixa Só os Clifor Nacionais														*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #Nacional
Select *
Into #Nacional
From #Uniq
Where Cnpj_Cpf Not In ('00.000.000/0000-00','000.000.000-00')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Deixa Só os Clifor Internacionais													*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #Exterior
Select *
Into #Exterior
From #Uniq
Where Cnpj_Cpf In ('00.000.000/0000-00','000.000.000-00')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Insere Apenas os Dados Incrementais na Tabela Fisica do Thesys					*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Insert Into [Dbo].[CliFor_Bancos]
           (
		    [id_banco]
           ,[id_clifor]
           ,[cod_banco]
           ,[num_agencia]
           ,[num_conta]
           ,[nome]
           ,[pessoa]
           ,[cnpj]
           ,[cpf]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device]
           ,[dv_conta]
           ,[dv_agencia]
		   ,[Pk]
		   )

Select 
	[id_banco]    = Bancos.Id_Banco
,	[id_clifor]	  = Clifor.Cod_Clifor
,	[cod_banco]	  = Trim(Fato.Cod_Banco)
,	[num_agencia] = Trim(Fato.Nro_Agencia) 
,	[num_conta]	  = Trim(Fato.Nro_Conta)
,	[nome]		  = Fato.Nome
,	[pessoa]	  = Fato.Pessoa
,	[cnpj]		  = Iif(Fato.Pessoa = 'j', Fato.Cgc_Cpf, Null)
,	[cpf]		  = Iif(Fato.Pessoa = 'F', Fato.Cgc_Cpf, Null)
,	[incl_data]	  = GetDate()
,	[incl_user]	  = 'ksantana'
,	[incl_device] = 'PC/10.1.0.123'
,	[modi_data]	  = Null
,	[modi_user]	  = Null
,	[modi_device] = Null
,	[excl_data]	  = Null
,	[excl_user]	  = Null
,	[excl_device] = Null
,	[dv_conta]	  = Fato.Digito_Verificador
,	[dv_agencia]  = Fato.Digito_VerifAgencia
,	[Pk]		  = Fato.Pk
From #Nacional Fato
Inner Join Bancos   On  Bancos.Cod_Banco			   = Fato.Cod_Banco Collate Latin1_General_Ci_Ai
Inner Join Clifor	On  Isnull(Clifor.Cnpj,Clifor.Cpf) = Fato.Cgc_Cpf   Collate Latin1_General_Ci_Ai 
					And Isnull(Clifor.Cnpj,Clifor.Cpf) Not In ('00.000.000/0000-00','000.000.000-00')
Where Not Exists (
				  Select *
				  From CliFor_Bancos Dim 
				  Where Dim.Pk = Fato.Pk Collate Latin1_General_Ci_Ai 
				 )
Union All

Select 
	[id_banco]    = Bancos.Id_Banco
,	[id_clifor]	  = Clifor.Cod_Clifor
,	[cod_banco]	  = Trim(Fato.Cod_Banco)
,	[num_agencia] = Trim(Fato.Nro_Agencia) 
,	[num_conta]	  = Trim(Fato.Nro_Conta)
,	[nome]		  = Fato.Nome
,	[pessoa]	  = Fato.Pessoa
,	[cnpj]		  = Iif(Fato.Pessoa = 'j', Fato.Cgc_Cpf, Null)
,	[cpf]		  = Iif(Fato.Pessoa = 'F', Fato.Cgc_Cpf, Null)
,	[incl_data]	  = GetDate()
,	[incl_user]	  = 'ksantana'
,	[incl_device] = 'PC/10.1.0.123'
,	[modi_data]	  = Null
,	[modi_user]	  = Null
,	[modi_device] = Null
,	[excl_data]	  = Null
,	[excl_user]	  = Null
,	[excl_device] = Null
,	[dv_conta]	  = Fato.Digito_Verificador
,	[dv_agencia]  = Fato.Digito_VerifAgencia
,	[Pk]		  = Fato.Pk
From #Nacional Fato
Inner Join Bancos   On  Bancos.Cod_Banco			   = Fato.Cod_Banco Collate Latin1_General_Ci_Ai
Inner Join Clifor	On  Isnull(Clifor.Cnpj,Clifor.Cpf) = Fato.Cgc_Cpf   Collate Latin1_General_Ci_Ai 
					And Clifor.Razao				   = Fato.Razao		Collate Latin1_General_Ci_Ai 
					And Isnull(Clifor.Cnpj,Clifor.Cpf) In ('00.000.000/0000-00','000.000.000-00')
Where Not Exists (
				  Select *
				  From CliFor_Bancos Dim 
				  Where Dim.Pk = Fato.Pk Collate Latin1_General_Ci_Ai 
				 )
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Dropa as Tabelas Temporarias Da Procedure											*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Begin
   Drop Table If Exists #CliforBanco
   Drop Table If Exists #Uniq
   Drop Table If Exists #Nacional
   Drop Table If Exists #Exterior
End

End;