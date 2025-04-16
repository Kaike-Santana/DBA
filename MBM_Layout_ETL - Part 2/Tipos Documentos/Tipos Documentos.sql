
Use Thesys_Homologacao
Go

Drop Table If Exists #BaseDocs 
Select *
Into #BaseDocs
From OpenQuery([Mbm_Polirex],'
Select *
From TipoDocto')


Drop Table If Exists #Final
Select *
Into #Final
From (
		Select *
		,	Rw = Row_Number () Over ( Partition By Cod_TipoDocto Order By Dt_Change Desc)
		From #BaseDocs
	 )SubQuery
Where Rw = 1


Insert Into [dbo].[Tipos_Documentos]
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
           ,[cod_tipodocto])
Select Distinct
	[grupo]			=	case
							when descricao = 'ADTO A S�CIOS'				  then 'ANTECIPA��ES'
							when descricao = 'ARRENDAMENTO MERCANTIL FINANC.' then 'ANTECIPA��ES'	-->
							when descricao = 'AUTO DE INFRA��O ESTADUAL'	  then 'JUROS E MULTAS'
							when descricao = 'BANCO CITIBANK EXTERIOR'		  then 'ANTECIPA��ES'	-->
							when descricao = 'EMPRESTIMO BRADESCO EXTERIOR'	  then 'ANTECIPA��ES'	-->
							when descricao = 'ISS S/ SERV PJ ADM'			  then 'IMPOSTOS E TAXAS'
							when descricao = 'ISS S/ SERV PJ VENDAS'		  then 'IMPOSTOS E TAXAS'
							when descricao = 'JUROS S/ CESS�O DE CR�DITO'	  then 'IMPOSTOS E TAXAS'
							when descricao = 'JUROS S/ ARRENDAM. MERCANTIL'	  then 'IMPOSTOS E TAXAS'
							when descricao = 'GFD (FGTS RESCIS�RIO)'		  then 'IMPOSTOS E TAXAS'
							when descricao = 'TRANSF. ENTRE CONTAS'			  then 'TRANSFERENCIA'
						end

,	[descricao]
,	[ativo] = 'S'
,	[diario_auxiliar]
,	[lancto_contabil]
,	[antecipacao]
,	[origem]		= '[AI] Apura��o de Impostos;[MN] Manual;[NF] Notas Fiscais;[OB] Opera��es Banc�rias;[PI] Processo de Importa��o;[SP] Solicita��o de Pagamento'
,	[incl_data]		= GetDate()
,	[incl_user]		= 'ksantana'
,	[incl_device]	= Null
,	[modi_data]		= Null
,	[modi_user]		= Null
,	[modi_device]	= Null
,	[excl_data]		= Null
,	[excl_user]		= Null
,	[excl_device]	= Null
,	[cod_tipodocto]
From #Final fato
Where Not Exists (
				  Select *
				  From Tipos_Documentos dim
				  Where dim.descricao = fato.descricao Collate latin1_general_ci_ai
				 )