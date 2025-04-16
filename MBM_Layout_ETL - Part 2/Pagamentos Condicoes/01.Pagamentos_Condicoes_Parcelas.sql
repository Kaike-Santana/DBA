
Use Thesys_Homologacao
Go


Drop Table If Exists #Base_MBM
Select *
Into #Base_MBM
from OpenQuery([Mbm_Polirex],'
Select 
	Parcelas.*
,	Cond_Pagamento.descricao as descr_condPagamento
from Parcelas
Join Cond_Pagamento On Cond_Pagamento.cod_condpagamento = Parcelas.cod_condpagamento
')


drop table if exists #final
select *
into #final
from (
		select *
		, rw = row_number() over ( partition by cod_condpagamento, nro_parcela order by dt_change desc)
		from #Base_MBM
	 )Sb
where rw = 1


Insert Into [dbo].[Pagamentos_Condicoes_Parcelas]
           ([id_pagamento_condicao]
           ,[nro_parcela]
           ,[prazo]
           ,[percentual]
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
	[id_pagamento_condicao] 
,	[nro_parcela]			
,	[prazo]					
,	[percentual]			
,	[incl_data]				
,	[incl_user]				
,	[incl_device]			
,	[modi_data]				
,	[modi_user]				
,	[modi_device]			
,	[excl_data]				
,	[excl_user]				
,	[excl_device]			
From (
		Select 
			[id_pagamento_condicao] = Dim.id_pagamento_condicao
		,	[nro_parcela]			= Fato.Nro_Parcela
		,	[prazo]					= Fato.Prazo
		,	[percentual]			= Fato.Percentual
		,	[incl_data]				= GetDate()
		,	[incl_user]				= 'ksantana'
		,	[incl_device]			= Null
		,	[modi_data]				= Null
		,	[modi_user]				= Null
		,	[modi_device]			= Null
		,	[excl_data]				= Null
		,	[excl_user]				= Null
		,	[excl_device]			= Null
		From #final Fato
		inner Join Pagamentos_Condicoes Dim On  Dim.Cod_CondPagamento = Fato.Cod_CondPagamento   Collate latin1_general_ci_ai
										    And Dim.descricao         = Fato.descr_condPagamento Collate latin1_general_ci_ai
	 )SubQuery
Where Not Exists (
				   Select *
				   From Pagamentos_Condicoes_Parcelas Dim
				   Where Dim.id_pagamento_condicao = SubQuery.id_pagamento_condicao
				   And   Dim.nro_parcela		   = SubQuery.nro_parcela
				 )