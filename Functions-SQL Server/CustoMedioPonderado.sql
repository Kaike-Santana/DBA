
Use Thesys_Homologacao
Go

--> Programador: Kaike / Thanner
--> Data: 2024-08-23
--> Descricao: Responsável Por Fazer o Cálculo Móvel de Quantidade de Estoque, Preço Médio e Unitário de Um Determinado Item em Um Determinado Período.
--> Versao: 1.0

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
        Id_Mov,
        Dt_Transacao,
        Documento,
        Quantidade,
        Entrada_Saida,
        Custo_Unitario
    From Estoque_Movimentos
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
        0							     As Id_Mov,
        Replace(AnoMes + '-01','/','-')  As Dt_Transacao,
        'Saldo Inicial'				     As Documento,
        Saldo_Qtd_Final				     As Quantidade,
        'E'							     As Entrada_Saida,
        Custo_Medio					     As Custo_Unitario
    From Estoque_Saldo_Competencia
    Where Id_Empresa = @Id_Empresa
	And   Id_Item = @Id_Item
	And   AnoMes = Format(DateAdd(Month, -1, @Periodo_Inicial), 'yyyy/MM')
	And (
		   @Id_Deposito Is Null 
		Or Id_Estoque_Deposito = @Id_Deposito
		)  --> Filtro Condicional
)

,    Movimento_Calculado As (
	Select 
        Id_Mov,
        Dt_Transacao,
        Documento,
        Quantidade,
        Entrada_Saida,
        Custo_Unitario,
        Quantidade_Ajustada = Case 
                                 When Entrada_Saida = 'E' Then Quantidade
                                 Else -Quantidade
                              End,
        Valor_Entrada		= Case 
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
)

Select *
,	Custo_Medio = Case 
					When Saldo_Quantidade > 0 Then (Saldo_Valor / Saldo_Quantidade)
					Else 0
				  End 
,	Saldo_Total = Case 
				    When Saldo_Quantidade > 0 Then Saldo_Valor
				    Else 0
				 End  
From Movimento_Calculado 

)
--> Maneira de Chamar a Function
/*
Select * 
From Dbo.fnCustoMedioPonderado(
							     4           --> Id da Empresa Desejada
							   , 443         --> Id_Item
							   ,'2024-08-01' --> DataInicial
							   ,'2024-08-31' --> DataFinal
							   ,7			 --> Parâmetro Opcional. Se Especificado, Realiza o Filtro Pelo Id do Depósito. Caso Não Seja Informado, Retorna Dados de Todos os Depósitos.
							  );
*/