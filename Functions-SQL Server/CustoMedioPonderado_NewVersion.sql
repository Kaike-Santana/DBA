
Create Or Alter Function Dbo.fnCustoMedioPonderado
(
	@Id_Empresa      Int,
    @Id_Item         Int,
    @Periodo_Inicial Date,
    @Periodo_Final   Date,
	@Id_Deposito     Int = Null -- Parâmetro Opcional
)
Returns Table
As
Return
(
    
With Movimentos_Unidos As (
    Select 
        Id_Mov          = Fato.Id_Mov,
        Dt_Transacao    = Fato.Dt_Transacao,
        Documento       = Fato.Documento,
        Tipo_Mov_Cod    = Dim.Tipo_Mov_Cod,    
        Tipo_Mov_Descr  = Dim.Tipo_Mov_Descr,
        Quantidade      = Fato.Quantidade,
        Entrada_Saida   = Fato.Entrada_Saida,
        Custo_Unitario  = Fato.Custo_Unitario
    From Estoque_Movimentos Fato
    Left Join Estoque_Tipos_Mov Dim On Dim.id_Tipo_Mov = Fato.id_Tipo_Mov
    Where Id_Empresa = @Id_Empresa
    And   Dt_Transacao BetWeen @Periodo_Inicial And @Periodo_Final
    And   Id_Item = @Id_Item
    And   Situacao = 'A' 
    And   Movimenta_Estoque = 'S'
    And (
           @Id_Deposito Is Null 
        Or Id_Deposito = @Id_Deposito
        )  --> Filtro Condicional
    
    Union All

    Select 
        0                                 As Id_Mov,
        Replace(AnoMes + '-01','/','-')    As Dt_Transacao,
        'Saldo Inicial'                    As Documento,
        Null                               As Tipo_Mov_Cod,    
        Null                               As Tipo_Mov_Descr,    
        Saldo_Qtd_Final                    As Quantidade,
        'E'                                As Entrada_Saida,
        Custo_Medio                        As Custo_Unitario
    From Estoque_Saldo_Competencia
    Where Id_Empresa = @Id_Empresa
    And   Id_Item = @Id_Item
    And   AnoMes = Format(DateAdd(Month, -1, @Periodo_Inicial), 'yyyy/MM')
    And (
           @Id_Deposito Is Null 
        Or Id_Estoque_Deposito = @Id_Deposito
        )  --> Filtro Condicional
),

Movimento_Calculado As (
	Select 
        Id_Mov,
        Dt_Transacao,
        Documento,
        Tipo_Mov_Cod,    
        Tipo_Mov_Descr,
        Quantidade,
        Entrada_Saida,
        Custo_Unitario,
        Quantidade_Sinal = Case 
                                 When Entrada_Saida = 'E' Then Quantidade
                                 Else -Quantidade
                              End,
        Valor_Mov		    = Case 
								 When Entrada_Saida = 'E' Then (Quantidade * Custo_Unitario)
								 Else -(Quantidade * Custo_Unitario)
							  End,
        Saldo_Quantidade	= Sum(
								  Case 
								    When Entrada_Saida = 'E' Then Quantidade
								    Else -Quantidade
								  End
								 ) 
							      Over (Order By Dt_Transacao, Id_Mov Rows Unbounded Preceding),
        Saldo_Valor			= Sum(
								  Case 
								    When Entrada_Saida = 'E' Then (Quantidade * Custo_Unitario)
								    Else -(Quantidade * Custo_Unitario)
								  End
								 ) 
								  Over (Order By Dt_Transacao, Id_Mov Rows Unbounded Preceding)
    From Movimentos_Unidos
), 

Calculo_Kpi As (
   Select *
,	Custo_Medio = Case 
					When Saldo_Quantidade > 0 Then (Saldo_Valor / Saldo_Quantidade)
					Else 0
				  End 
From Movimento_Calculado 

),
 Cte_Grupos As (
    Select *,
           Sum(Case When Entrada_Saida = 'E' Then 1 Else 0 End) 
           Over (Order By Dt_Transacao, Id_Mov) As Grupo
    From Calculo_Kpi
),

 Cte_Rank As (
    Select *,
           Max(Case When Entrada_Saida = 'E' Then Custo_Medio End) 
           Over (Partition By Grupo Order By Dt_Transacao, Id_Mov 
                 Rows BetWeen Unbounded Preceding And Current Row) As Ultimo_Custo_Medio_E
    From Cte_Grupos
),
 Cte_NewCustoUnitario As (
	Select 
	    Id_Mov,
	    Dt_Transacao,
	    Documento,
	    Tipo_Mov_Cod,    
	    Tipo_Mov_Descr,
	    Quantidade,
	    Entrada_Saida,
	    Custo_Unitario = Case 
	                        When Entrada_Saida = 'S' And Custo_Unitario = 0 Then Ultimo_Custo_Medio_E
	                        Else Custo_Unitario
	                     End,
	    Quantidade_Sinal,
	    Valor_Mov, 
	    Saldo_Quantidade,
	    Saldo_Valor,
	    Custo_Medio
	From CTE_Rank
),
 Cte_NewValorMov As (
	Select 
	    Id_Mov,
	    Dt_Transacao,
	    Documento,
	    Tipo_Mov_Cod,    
	    Tipo_Mov_Descr,
	    Quantidade,
	    Entrada_Saida,
	    Custo_Unitario, 
	    Quantidade_Sinal,
	    Valor_Mov = Iif(Entrada_Saida = 'S', -Abs((Custo_Unitario * Quantidade)), Valor_Mov),
	    Saldo_Quantidade,
	    Saldo_Valor ,
	    Custo_Medio
	From Cte_NewCustoUnitario
),
 Cte_CustoSaldo As (
	Select 
	    Id_Mov,
	    Dt_Transacao,
	    Documento,
	    Tipo_Mov_Cod,    
	    Tipo_Mov_Descr,
	    Quantidade,
	    Entrada_Saida,
	    Custo_Unitario, 
	    Quantidade_Sinal,
	    Valor_Mov, 
	    Saldo_Quantidade,
	    Saldo_Valor = Iif(Entrada_Saida = 'S', (Saldo_Valor + Valor_Mov), Saldo_Valor),
	    Custo_Medio 
	From Cte_NewValorMov 
)
	Select 
	    Id_Mov,
	    Dt_Transacao,
	    Documento,
	    Tipo_Mov_Cod,    
	    Tipo_Mov_Descr,
	    Quantidade,
	    Entrada_Saida,
	    Custo_Unitario, 
	    Quantidade_Sinal,
	    Valor_Mov, 
	    Saldo_Quantidade,
	    Saldo_Valor ,
	    Custo_Medio = Iif(Entrada_Saida = 'S', (Saldo_Valor / Saldo_Quantidade), Custo_Medio)
	From Cte_CustoSaldo 
)

--Drop Table Teste
Select * 
--Into Teste
From Dbo.fnCustoMedioPonderado(
							     4           --> Id da Empresa Desejada
							   , 443         --> Id_Item
							   ,'2024-08-01' --> DataInicial
							   ,'2024-08-31' --> DataFinal
							   ,7			 --> Parâmetro Opcional. Se Especificado, Realiza o Filtro Pelo Id do Depósito. Caso Não Seja Informado, Retorna Dados de Todos os Depósitos.
							  );
select *
,	teste = Iif(Entrada_Saida = 'S', -Abs((Custo_Unitario * Quantidade)), Valor_Mov)
from teste
where id_mov = 44962