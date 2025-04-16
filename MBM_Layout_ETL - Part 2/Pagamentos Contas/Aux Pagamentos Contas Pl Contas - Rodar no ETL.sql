

drop table if exists #2Pl_Por_IdPag
Select *
--Into #2Pl_Por_IdPag
From (
		Select *
		,	Rw = Row_Number() Over (Partition By Id_Pag_Conta, Id_Plano Order By Id_RateioPcontas Asc) 
		From Pagamentos_Contas_RateioPContas
	 )SubQuery
Where 1=1
--and Pk Is Not Null
and rw > 1


-- 1) CTE para identificar duplicados e calcular a soma
With CteDup AS
(
    Select
          PK                 
        , Id_Pag_Conta
        , Id_Centro_Custo
        , RateioValor
        -- Ordene a "ordem" dos duplicados pela coluna que faça sentido (ex.: PK ou Id_RateioCCusto)
        , Rn		 = Row_Number()     Over (Partition By Id_Pag_Conta, Id_Centro_Custo Order By PK)
        , TotalValor = Sum(RateioValor) Over (Partition By Id_Pag_Conta, Id_Centro_Custo)
    From Pagamentos_Contas_RateioCC
)
-- 2) Primeiro, ATUALIZAMOS somente o registro "principal" (Rn=1) com a soma total
UPdate T
   Set T.RateioValor = CteDup.TotalValor
  From Pagamentos_Contas_RateioCC As T
 Inner Join CteDup 
         On T.PK = CteDup.PK
 Where CteDup.Rn = 1  -- apenas a "primeira" linha de cada grupo

-- 3) Em seguida, EXCLUÍMOS os demais duplicados (Rn>1)
DELETE T
  FROM Pagamentos_Contas_RateioCC AS T
 INNER JOIN CteDup 
         ON T.PK = CteDup.PK
 WHERE CteDup.Rn > 1;