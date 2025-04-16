
Use TheSys_Homologacao
Go

--> Demanda (Cond da Mg e Polirex Que Nao Tem Forma de Pagto)

--> Cond de Pagamento da Mg_Polimeros e Polirex
Drop Table If Exists #CondPag_Mbm_Mg
Select *
Into #CondPag_Mbm_Mg
From OpenQuery([Mbm_Mg_Polimeros],'
Select *
From Cond_Pagamento')

Union All

Select *
From OpenQuery([Mbm_Polirex],'
Select *
From Cond_Pagamento')

Drop Table If Exists #CondUniq
Select *
Into #CondUniq
From (
	  Select *
	  ,	Rw = Row_Number () Over ( Partition By Descricao Order By Descricao)
	  From #CondPag_Mbm_Mg
	 )SubQuery
Where Rw = 1


--> Filtra Só o Que é da Mg e Que Nao Possui Forma de Pagamento
Select *
From Pagamentos_Condicoes Fato
Where Exists (
			  Select *
			  From #CondUniq Dim
			  Where Dim.Descricao = Fato.Descricao Collate Latin1_General_Ci_Ai
			 )
And Coalesce(FormaPgtoID,'') = '' 
And Exists (
			Select *
			From Notas_Fiscais Nf
			Where Nf.Id_CondPagamento = Fato.Id_Pagamento_Condicao
			And Nf.Dt_Emissao >= '2023-01-01'
		   )
Order By descricao desc



select *
from Tabela_Padrao
where cod_tabelapadrao = 'FORMA_DE_PAGAMENTO'


--> Colocar Aqui os Id Que Nao Tem Forma de Pagamento
/*
Update Pagamentos_Condicoes
Set FormaPgtoID = 2639
Where id_pagamento_condicao = 27
*/