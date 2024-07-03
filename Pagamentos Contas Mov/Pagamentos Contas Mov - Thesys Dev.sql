
Use Thesys_Dev
Go

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* Programador: Kaike Natan																		*/
/* Versao     : Data: 07/06/2024																*/
/* Descricao  : Script De ETL Da Tabela De Pagamentos Contas Movimentacao Do MBM Para o Thesys	*/
/*																								*/
/* ALTERACAO																					*/
/*        2. Programador:                                                  Data: __/__/____		*/        
/*           Descricao  :																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	Alter Procedure Prc_Etl_Pagamentos_Contas_Movimentacoes_MBM As
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Base MBM de Contas a Pagar Movimentacao da PoliResinas							*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Begin;
drop table if exists #BaseCPMovimentacao
select *
into #BaseCPMovimentacao
from openquery([mbm_poliresinas],'
select 
	cpmovi.*
,	plano_contas.descricao as descricao_cc_db
,	pc_2.descricao		   as descricao_cc_cr
from cpmovi
left join plano_contas      on plano_contas.cod_planocontas = cpmovi.cod_contacontabildb
left join plano_contas pc_2 on pc_2.cod_planocontas		    = cpmovi.cod_contacontabilcr
')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Deixa Nº Parcelas e CodClifor No Layout do MBM									*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
drop table if exists #PagContas
select 
	Pagamentos_Contas.*
,   case 
		when charindex('/', parcela) > 0 then left(parcela, charindex('/', parcela) - 1) 
		else parcela
    end as nparcela
,	CliFor.cod_antigo
into #PagContas
from Pagamentos_Contas 
left join clifor on CliFor.cod_clifor = Pagamentos_Contas.cod_clifor
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Update Para Deixar Coluna Serie No Layout do MBM									*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	Update #PagContas
	Set serie = iif(serie = '*', '', serie)

-- Adiciona a nova coluna 'PK' como NULL
ALTER TABLE Pagamentos_Contas_Mov
ADD PK varchar(50) NULL;
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Insere Só os Dados Diferenciais na Tabela											*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Insert Into [dbo].[Pagamentos_Contas_Mov]
           (
		    [ID_Empresa]
           ,[ID_Pag_Conta]
           ,[Seq_Mov]
           ,[ID_Evento]
           ,[ID_Contabilizacao_Financeira]
           ,[ID_Historico_Padrao]
           ,[ID_Usuario]
           ,[ID_ContaDebito]
           ,[ID_ContaCredito]
           ,[DataMov]
           ,[DataContabil]
           ,[Valor]
           ,[Juros]
           ,[Desconto]
           ,[DescricaoMovimento]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device]
           ,[dt_cancelado_estornado]
           ,[usuario_cancelou_estornou]
           ,[Motivo_cancelou_estornou]
           ,[id_bordero]
		   ,[Pk]
		   )
Select 
	[ID_Empresa]					=	Empresas.ID_EMPRESA
,	[ID_Pag_Conta]					=	#PagContas.ID_Pag_Conta 
,	[Seq_Mov]						=	sequencia
,	[ID_Evento]						=	Eventos_Titulos.id_evento
,	[ID_Contabilizacao_Financeira]	=	Cf.id_contabilizacao_financeira --> Seja Preenchida no SoftWare
,	[ID_Historico_Padrao]			=	null --> Ver Depois com o Thanner
,	[ID_Usuario]					=	Usuarios.codigo
,	[ID_ContaDebito]				=	Plano_Contas.id_plano
,	[ID_ContaCredito]				=	PC_2.id_plano
,	[DataMov]						=	convert(datetime,fato.dt_movimento)
,	[DataContabil]					=	convert(date,fato.dt_contabil)
,	[Valor]							=	convert(numeric(16,2),fato.valor)
,	[Juros]							=	fato.Juros
,	[Desconto]						=	fato.descto
,	[DescricaoMovimento]			=	fato.movimento
,	[incl_data]						=	getdate()
,	[incl_user]						=	'ksantana'
,	[incl_device]					=	'PC/10.1.0.154'
,	[modi_data]						=	null
,	[modi_user]						=	null
,	[modi_device]					=	null
,	[excl_data]						=	null
,	[excl_user]						=	null
,	[excl_device]					=	null
,	[dt_cancelado_estornado]		=	convert(date,dt_cancelado)
,	[usuario_cancelou_estornou]		=	Usuarios.codigo
,	[Motivo_cancelou_estornou]		=	fato.motivo_cancelou
,	[id_bordero]					=	null --> Seja Preenchida no SoftWare
,	Pk								=	trim(fato.cod_empresa) + trim(Fato.cod_clifor) + trim(Fato.serie) + trim(fato.nro_titulo) + trim(Fato.parcela)	
From #BaseCPMovimentacao Fato
Left Join Empresas						 On  Empresas.codigo_antigo		  = Fato.cod_empresa		  collate sql_latin1_general_cp1_ci_ai
Left Join #PagContas					 On  #PagContas.cod_empresa		  = Fato.cod_empresa		  collate sql_latin1_general_cp1_ci_ai
										 And #PagContas.cod_antigo		  = Fato.cod_clifor			  collate sql_latin1_general_cp1_ci_ai
										 And #PagContas.serie			  = Fato.serie				  collate sql_latin1_general_cp1_ci_ai
										 And #PagContas.NumeroTitulo	  = Fato.nro_titulo			  collate sql_latin1_general_cp1_ci_ai
										 And #PagContas.nparcela		  = Fato.parcela			  collate sql_latin1_general_cp1_ci_ai
Left Join Eventos_Titulos				 On  Eventos_Titulos.cod_evento	  = Fato.cod_evento			  collate sql_latin1_general_cp1_ci_ai
Left Join Contabilizacoes_Financeiras Cf On  Cf.cod_evento				  = Fato.cod_evento			  collate sql_latin1_general_cp1_ci_ai
										 And Cf.cod_serie				  = Fato.serie				  collate sql_latin1_general_cp1_ci_ai
										 And Cf.cod_portador			  = Fato.cod_portador		  collate sql_latin1_general_cp1_ci_ai
										 And Cf.cod_tipocontacr			  = Fato.cod_contacontabilcr  collate sql_latin1_general_cp1_ci_ai
										 And Cf.cod_tipocontadb			  = Fato.cod_contacontabildb  collate sql_latin1_general_cp1_ci_ai
Left Join Usuarios						 On  Usuarios.login				  = Fato.cod_usuario		  collate sql_latin1_general_cp1_ci_ai 
Left Join Plano_Contas					 On  Plano_Contas.cod_planocontas = Fato.cod_contacontabildb  collate sql_latin1_general_cp1_ci_ai 
										 And Plano_Contas.descricao		  =	Fato.descricao_cc_db      and Plano_Contas.tipo = 'D'
Left join Plano_Contas As PC_2			 On  PC_2.cod_planocontas		  = Fato.cod_contacontabilcr  collate sql_latin1_general_cp1_ci_ai 
										 And PC_2.descricao				  =	Fato.descricao_cc_cr      and PC_2.tipo = 'C'
Where Exists (
			   Select 1
			   From #PagContas Dim
			   Where Fato.cod_empresa	= Dim.cod_empresa	 
			   And   Fato.cod_clifor	= Dim.cod_antigo   collate sql_latin1_general_cp1_ci_ai
			   And   Fato.serie			= Dim.serie 	   collate sql_latin1_general_cp1_ci_ai
			   And   Fato.nro_titulo	= Dim.numerotitulo collate sql_latin1_general_cp1_ci_ai
			   And   Fato.parcela		= Dim.nparcela	   collate sql_latin1_general_cp1_ci_ai
			 )
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Calcula a Soma Dos Valores Pagos Na Tabela De Movimentacao						*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #ValorPagoMov
Select 
    pc.cod_empresa,
    pc.cod_antigo,
    pc.serie,
    pc.numerotitulo,
    pc.nparcela,
    sum(bcm.valor) as somavalor
Into #ValorPagoMov
From #basecpmovimentacao bcm
Left Join #pagcontas pc
    On pc.cod_empresa	= bcm.cod_empresa	collate sql_latin1_general_cp1_ci_ai
    And pc.cod_antigo	= bcm.cod_clifor	collate sql_latin1_general_cp1_ci_ai
    And pc.serie		= bcm.serie			collate sql_latin1_general_cp1_ci_ai
    And pc.numerotitulo = bcm.nro_titulo	collate sql_latin1_general_cp1_ci_ai
    And pc.nparcela		= bcm.parcela		collate sql_latin1_general_cp1_ci_ai
Group by 
    pc.cod_empresa,
    pc.cod_antigo,
    pc.serie,
    pc.numerotitulo,
    pc.nparcela
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Compara a Soma Com o Valor da Tabela PagContas e Atualiza a Coluna Situacao		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Create NonClustered Index idx_PagContas_keys On #PagContas    (ID_Pag_Conta,Cod_empresa, Cod_antigo, Serie, NumeroTitulo, Nparcela);
Create NonClustered Index idx_VlPgMov_keys   On #ValorPagoMov (Cod_empresa, Cod_antigo, Serie, NumeroTitulo, Nparcela);
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Compara a Soma Com o Valor da Tabela PagContas e Atualiza a Coluna Situacao		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Declare @batchsize    Int = 1000;
Declare @rowsaffected Int;

Set @rowsaffected   = @batchsize;

While @rowsaffected = @batchsize
Begin
    Begin Transaction;

    Update top (@batchsize) fato
    Set Situacao = iif(dim.somavalor < fato.valor, 'AB', 'PT')
    From #pagcontas    fato
    Join #valorpagomov dim 
        On  (fato.cod_empresa  = dim.cod_empresa ) 
        And (fato.cod_antigo   = dim.cod_antigo  )
        And (fato.serie        = dim.serie	     )
        And (fato.numerotitulo = dim.numerotitulo)
        And (fato.nparcela     = dim.nparcela    )
    Where fato.situacao = 'PG';

    Set @rowsaffected = @@rowcount;

    Commit Transaction;
End
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Merge Por ID Atualizando a Coluna Situacao na Tabela de Pagamentos Contas			*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Merge Into Pagamentos_Contas As Fato
Using #PagContas			 As Dim
On Fato.ID_Pag_Conta = Dim.ID_Pag_Conta
When 
Matched Then 
    Update Set 
    Fato.Situacao = Dim.Situacao;


--> Dropa Tabelas Temporárias da Procedure
Begin 
	Drop Table If Exists #BaseCPMovimentacao
	Drop Table If Exists #PagContas
	Drop Table If Exists #PagContas
	Drop Table If Exists #ValorPagoMov 
End;

End;