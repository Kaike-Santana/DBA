
Use Thesys_Dev
Go

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* Programador: Kaike Natan																		*/
/* Versao     : Data: 11/07/2024																*/
/* Descricao  : Script De ETL Da Tabela Pagamentos_Contas_RateioPContas do MBM Para o Thesys	*/
/*																								*/
/* Alteracao																					*/
/*        2. Programador:                                                  Data: __/__/____		*/        
/*           Descricao  :																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	Create Procedure Prc_Etl_Pagamentos_Contas_RateioPContas_MBM As
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Base MBM de Contas a Pagar da PoliResinas											*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #BasePlanContasPagar
Select *
Into #BasePlanContasPagar
From (
		Select *
		,	Pk = Trim(Cod_Empresa) + Trim(Cod_Clifor) + Trim(Serie) + Trim(Nro_Titulo) + Trim(Parcela) + Trim(Cod_PlanoContas)
		,	Fk = Trim(Cod_Empresa) + Trim(Cod_Clifor) + Trim(Serie) + Trim(Nro_Titulo) + Trim(Parcela)
		,	Rw = Row_Number() Over ( Partition By Trim(Cod_Empresa), Trim(Cod_Clifor), Trim(Serie), Trim(Nro_Titulo), Trim(Parcela), Trim(Cod_PlanoContas) Order By Cod_Empresa Desc)
		From OpenQuery([Mbm_Poliresinas],'
		Select *
		From CpPlanoContas
		')
	 )SubQuery
Where Rw = 1

Union All

Select *
From (
		Select *
		,	Pk = Trim(Cod_Empresa) + Trim(Cod_Clifor) + Trim(Serie) + Trim(Nro_Titulo) + Trim(Parcela) + Trim(Cod_PlanoContas)
		,	Fk = Trim(Cod_Empresa) + Trim(Cod_Clifor) + Trim(Serie) + Trim(Nro_Titulo) + Trim(Parcela)
		,	Rw = Row_Number() Over ( Partition By Trim(Cod_Empresa), Trim(Cod_Clifor), Trim(Serie), Trim(Nro_Titulo), Trim(Parcela), Trim(Cod_PlanoContas) Order By Cod_Empresa Desc)
		From OpenQuery([Mbm_Rubberon],'
		Select *
		From CpPlanoContas
		Where Cod_Empresa != ''001''
		')
	 )SubQuery
Where Rw = 1

Union All

Select *
From (
		Select *
		,	Pk = Trim(Cod_Empresa) + Trim(Cod_Clifor) + Trim(Serie) + Trim(Nro_Titulo) + Trim(Parcela) + Trim(Cod_PlanoContas)
		,	Fk = Trim(Cod_Empresa) + Trim(Cod_Clifor) + Trim(Serie) + Trim(Nro_Titulo) + Trim(Parcela)
		,	Rw = Row_Number() Over ( Partition By Trim(Cod_Empresa), Trim(Cod_Clifor), Trim(Serie), Trim(Nro_Titulo), Trim(Parcela), Trim(Cod_PlanoContas) Order By Cod_Empresa Desc)
		From OpenQuery([Mbm_Mg_Polimeros],'
		Select *
		From CpPlanoContas
		Where Cod_Empresa != ''300''
		')
	 )SubQuery
Where Rw = 1

Union All

Select *
From (
		Select *
		,	Pk = Trim(Cod_Empresa) + Trim(Cod_Clifor) + Trim(Serie) + Trim(Nro_Titulo) + Trim(Parcela) + Trim(Cod_PlanoContas)
		,	Fk = Trim(Cod_Empresa) + Trim(Cod_Clifor) + Trim(Serie) + Trim(Nro_Titulo) + Trim(Parcela)
		,	Rw = Row_Number() Over ( Partition By Trim(Cod_Empresa), Trim(Cod_Clifor), Trim(Serie), Trim(Nro_Titulo), Trim(Parcela), Trim(Cod_PlanoContas) Order By Cod_Empresa Desc)
		From OpenQuery([Mbm_Nortebag],'
		Select *
		From CpPlanoContas
		')
	 )SubQuery
Where Rw = 1

Union All

Select *
From (
		Select *
		,	Pk = Trim(Cod_Empresa) + Trim(Cod_Clifor) + Trim(Serie) + Trim(Nro_Titulo) + Trim(Parcela) + Trim(Cod_PlanoContas)
		,	Fk = Trim(Cod_Empresa) + Trim(Cod_Clifor) + Trim(Serie) + Trim(Nro_Titulo) + Trim(Parcela)
		,	Rw = Row_Number() Over ( Partition By Trim(Cod_Empresa), Trim(Cod_Clifor), Trim(Serie), Trim(Nro_Titulo), Trim(Parcela), Trim(Cod_PlanoContas) Order By Cod_Empresa Desc)
		From OpenQuery([Mbm_Polirex],'
		Select *
		From CpPlanoContas
		')
	 )SubQuery
Where Rw = 1
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Base MBM de Contas a Pagar da PoliResinas											*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Insert Into [dbo].[Pagamentos_Contas_RateioPContas]
           (	
			    [ID_Pag_Conta]
			,	[ID_Plano]
			,	[RateioPercentual]
			,	[RateioValor]
			,	[incl_data]
			,	[incl_user]
			,	[incl_device]
			,	[modi_data]
			,	[modi_user]
			,	[modi_device]
			,	[excl_data]
			,	[excl_user]
			,	[excl_device]
			,	[Pk]
		   )

Select 
	[ID_Pag_Conta]		= PagC.Id_Pag_Conta
,	[ID_Plano]			= PlC.Id_Plano
,	[RateioPercentual]  = Null
,	[RateioValor]		= Fato.Valor
,	[incl_data]			= GetDate()
,	[incl_user]			= 'ksantana'
,	[incl_device]	    = 'PC/10.1.0.123'
,	[modi_data]			= Null
,	[modi_user]			= Null
,	[modi_device]		= Null
,	[excl_data]			= Null
,	[excl_user]			= Null
,	[excl_device]		= Null
,	[Pk]				= Fato.Pk
From #BasePlanContasPagar Fato --> 10.150
Inner Join Pagamentos_Contas PagC On PagC.Pk			  = Fato.Fk				 Collate sql_latin1_general_cp1_ci_ai
Inner Join Plano_Contas		 PlC  On PlC.Cod_PlanoContas  = Fato.Cod_PlanoContas Collate sql_latin1_general_cp1_ci_ai
Where Not Exists (
				  Select *
				  From Pagamentos_Contas_RateioPContas Dim
				  Where Dim.Pk = Fato.Pk Collate sql_latin1_general_cp1_ci_ai
				 )