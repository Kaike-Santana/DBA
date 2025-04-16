
Use Thesys_Homologacao
Go

drop table if exists #consolidado 
select *
into #consolidado
from openquery([mbm_polirex],'
select *
from cond_pagamento
')


p = percentual, vira x no thesys

n = n de parcelas, vira p no thesys

s = nenhum


Drop Table If Exists #Aux_FormPagament
Select *
Into #Aux_FormPagament
From tabela_padrao
Where cod_tabelapadrao = 'Forma_De_Pagamento'

Drop Table If Exists #Final
Select *
Into #Final
From (
Select *
,	Rw = Row_Number() Over ( Partition By Cod_CondPagamento Order By Dt_Change Desc)
From #consolidado
)SubQuery
Where Rw = 1


Insert Into [dbo].[Pagamentos_Condicoes]
           ([cod_condpagamento]
           ,[descricao]
           ,[parcelas]
           ,[ativo]
           ,[vencto_sabado]
           ,[vencto_domingo]
           ,[vencto_feriado]
           ,[vencto_segunda]
           ,[vencto_terca]
           ,[vencto_quarta]
           ,[vencto_quinta]
           ,[vencto_sexta]
           ,[tipo_data]
           ,[bloquear_pedidovenda]
           ,[antecipar_pagamento]
           ,[valor_antecipacao]
           ,[tipo_vencto]
           ,[considerar_venctofixo]
           ,[dia_venctofixo]
           ,[prorrogaantecipa_venctofixo]
           ,[calculo_vencto]
           ,[prazo_dias_primeira_parcela]
           ,[intervalo_dias_demais_parcelas]
           ,[FormaPgtoID]
           ,[FormaPgtoCodigo]
           ,[auxiliar_string1]
           ,[auxiliar_string2]
           ,[vendas]
           ,[compras]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device]
           ,[id_forma_pgto_nfe])

Select 
	[cod_condpagamento]					= fato.cod_condpagamento
,	[descricao]							= fato.descricao
,	[parcelas]							= fato.parcelas
,	[ativo]								= fato.ativo
,	[vencto_sabado]						= fato.vencto_sabado
,	[vencto_domingo]					= fato.[vencto_domingo]
,	[vencto_feriado]					= fato.[vencto_feriado]
,	[vencto_segunda]					= fato.[vencto_segunda]		
,	[vencto_terca]						= fato.[vencto_terca]
,	[vencto_quarta]						= fato.[vencto_quarta]
,	[vencto_quinta]						= fato.[vencto_quinta]
,	[vencto_sexta]						= fato.[vencto_sexta]
,	[tipo_data]							= fato.[tipo_data]
,	[bloquear_pedidovenda]				= fato.[bloquear_pedidovenda]
,	[antecipar_pagamento]				= fato.[antecipar_pagamento]
,	[valor_antecipacao]					= fato.[valor_antecipacao]
,	[tipo_vencto]						= fato.[tipo_vencto]
,	[considerar_venctofixo]				= fato.[considerar_venctofixo]
,	[dia_venctofixo]					= fato.[dia_venctofixo]
,	[prorrogaantecipa_venctofixo]		= fato.[prorrogaantecipa_venctofixo]
,	[calculo_vencto]					= fato.[calculo_vencto]
,	[prazo_dias_primeira_parcela]		= Null
,	[intervalo_dias_demais_parcelas]	= Null
,	[FormaPgtoID]						= #Aux_FormPagament.id_tabela_padrao
,	[FormaPgtoCodigo]					= Fato.Cod_FormasPagto
,	[auxiliar_string1]					= Fato.[auxiliar_string1]
,	[auxiliar_string2]					= Fato.[auxiliar_string2]
,	[vendas]							= 'N'
,	[compras]							= 'N'
,	[incl_data]							= GetDate()
,	[incl_user]							= 'ksantana'
,	[incl_device]						= Null
,	[modi_data]							= Null
,	[modi_user]							= Null
,	[modi_device]						= Null
,	[excl_data]							= Null
,	[excl_user]							= Null
,	[excl_device]						= Null
,	[id_forma_pgto_nfe]					= Null
From #Final Fato
Left Join #Aux_FormPagament On #Aux_FormPagament.codigo = fato.Cod_FormasPagto Collate latin1_general_ci_ai 
Where Not Exists (
				  Select *
				  From Pagamentos_Condicoes Dim
				  Where Dim.cod_condpagamento = Fato.cod_condpagamento Collate latin1_general_ci_ai 
				  And   Dim.descricao         = Fato.descricao		   Collate latin1_general_ci_ai 
				 )	

/*
--> Update Para Atualizar o Flag 
With Cte_Nat_CondPagamento As (
	Select Distinct Id_condpagamento
	,	Compra = Case 
					When entrada_saida = 'E' And Year(Dt_Emissao) = 2024 And Coalesce(id_pedido_compra,'') != '' Then 'S'
					Else 'N'
				 End
	,	Venda =  Case
				    When entrada_saida = 'S' And Year(Dt_Emissao) = 2024 And Coalesce(id_pedido_venda,'')  != '' Then 'S'
				    Else 'N'
		         End
	From Notas_Fiscais	
	Where Year(Dt_Emissao) = 2024
	And (
		    Coalesce(id_pedido_compra,'') != ''
		 Or Coalesce(id_pedido_venda ,'') != ''
		)
	And id_condpagamento Is Not Null
	Order By Id_condpagamento
) 

Update Fato
Set Vendas	= Dim.Venda
,	Compras = Dim.Compra

From Pagamentos_Condicoes  Fato
Join Cte_Nat_CondPagamento Dim  On Dim.id_condpagamento = Fato.id_pagamento_condicao
*/

--> Valida Se Ha Cod de ConPagamento Duplicado.
Select id_pagamento_condicao, cod_condpagamento, descricao, parcelas, ativo, incl_data
From  (
		Select *
		,	Rw = Row_Number () Over ( Partition By Cod_CondPagamento Order By Incl_Data Asc)
		From Pagamentos_Condicoes
	  )SubQuery
Where Rw > 1