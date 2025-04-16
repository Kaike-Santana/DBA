
Use Thesys_Homologacao
Go

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* Programador: Kaike Natan									                                    */
/* Versao     : Data: 08/08/2024																*/
/* Descricao  : Script de ETL da Base Bancos Movimentacoes Plano Contas do MBM Para o Thesys	*/
/*																								*/
/*	Alteracao                                                                                   */
/*        2. Programador: 													 Data: __/__/____	*/		
/*           Descricao  : 																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	Create Procedure Prc_Etl_Bancos_MovimentacoesPContas_MBM As 
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Consolida a Base de Bancos Movimentacoes(Plano Contas) das 5 Empresas do MBM		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #BaseMBM 
Select *
,	Pk	       = Trim(Cod_Banco) + Trim(Nro_Agencia) + Trim(Nro_Conta) + Trim(AaaaMm) + Trim(Cod_Lancamento) + Trim(Cod_Empresa) + Trim(Cod_PlanoContas)
,	Fk_Bv      = Trim(Cod_Banco) + Trim(Nro_Agencia) + Trim(Nro_Conta) + Trim(AaaaMm) + Trim(Cod_Lancamento)
Into #BaseMBM
From OpenQuery([Mbm_PoliResinas],'
Select 
  Lancto_PlanoContas.cod_banco, 
  Lancto_PlanoContas.nro_agencia, 
  Lancto_PlanoContas.nro_conta, 
  Lancto_PlanoContas.cod_planocontas, 
  Plano_Contas.Tipo,
  Lancto_PlanoContas.aaaamm, 
  Lancto_PlanoContas.valor, 
  Lancto_PlanoContas.cod_empresa, 
  Lancto_PlanoContas.cod_lancamento
From Lancto_PlanoContas
Left Join Plano_Contas On  (Plano_Contas.Cod_Empresa	 = Lancto_PlanoContas.Cod_Empresa	 )
					   And (Plano_Contas.Cod_PlanoContas = Lancto_PlanoContas.Cod_PlanoContas)

')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Insere Apenas o Incremental na Tabela Fisica: Bancos_Movimentacoes_PContas		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Insert Into [dbo].[Bancos_Movimentacoes_PContas] --alter table [Bancos_Movimentacoes_PContas] add Pk Varchar (60)
           ([id_bancos_mov]
           ,[id_plano]
           ,[id_empresa]
           ,[percentual]
           ,[valor]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device]
		   ,[Pk])

Select 
	[id_bancos_mov] = Bv.Id_Bancos_Mov
,	[id_plano]		= Pl.Id_Plano
,	[id_empresa]	= Em.Id_Empresa
,	[percentual]	= Null
,	[valor]		    = Fato.Valor
,	[incl_data]		= GetDate()
,	[incl_user]		= 'ksantana'
,	[incl_device]	= 'PC/10.1.0.123'
,	[modi_data]		= Null
,	[modi_user]		= Null
,	[modi_device]	= Null
,	[excl_data]		= Null
,	[excl_user]		= Null
,	[excl_device]	= Null
,	[Pk]			= Fato.Pk
From #BaseMBM Fato
Inner Join Bancos_Movimentacoes As Bv On  Bv.Pk				 = Fato.Fk_Bv			Collate Latin1_General_Ci_Ai  
Left  Join Plano_Contas			As Pl On  Pl.Cod_PlanoContas = Fato.Cod_PlanoContas Collate Latin1_General_Ci_Ai  
									  And Pl.Tipo			 = Fato.Tipo		    Collate Latin1_General_Ci_Ai 
Inner Join Empresas				As Em On  Em.Codigo_Antigo   = Fato.Cod_Empresa		Collate Latin1_General_Ci_Ai  
Where Not Exists (
				  Select *
				  From Bancos_Movimentacoes_PContas Dim
				  Where Dim.Pk = Fato.Pk Collate Latin1_General_Ci_Ai 
				 )