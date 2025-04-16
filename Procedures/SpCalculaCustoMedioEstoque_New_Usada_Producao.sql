
Use Thesys_Producao
Go

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* Programador: Kaike Natan																		*/
/* Versao     : Data: 11/10/2024																*/
/* Descricao  : Calcula o Custo Médio do Estoque de Um Item Baseado nas suas  Ùlltimas Mov		*/
/*																								*/
/* Alteracao																					*/
/*        2. Programador: Kaike Natan			                        Data: 04/12/2024		*/        
/*           Descricao  : Inclusao Mov da Tabela Estoque e Ajuste no Parametro de Filtro do Item*/
/* Alteracao																					*/
/*        3. Programador:						                        Data: __/__/____		*/        
/*           Descricao  :																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	ALTER Procedure [dbo].[SpCalculaCustoMedioEstoque]
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Caso Queira Rodar na Manualmente, Descomentar, Abaico Ex: de Como Chamar a Proc	*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
--> Execute [dbo].[SpCalculaCustoMedioEstoque] 4,'2024-10-01','2024-10-31',1425, Null, 0
--Declare 
--    @IdEmpresa Int = 4,
--    @DataInicio Date = '2024-11-01',
--    @DataFim Date = '2024-11-30',
--    @IdItem Int = 1422,
--    @IdDeposito Int = Null,
--    @ApenasUltimo Bit = 0  -- Novo parâmetro para filtrar o último movimento
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Variáveis de Parametro da Procedure												*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
    @IdEmpresa Int ,
    @DataInicio Date ,
    @DataFim Date ,
    @IdItem Int ,
    @IdDeposito Int = Null,
    @ApenasUltimo Bit = 0  -- Novo parâmetro para filtrar o último movimento
As
Begin
    Set NoCount On;
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Criação da tabela temporária para armazenar resultados intermediários				*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #TempEstoque;
Create Table #TempEstoque (
	Id_Empresa Int,
	Id_Item Int,
	id_item_original Int,
	Observacao Varchar(1000),
	Codigo_Item Varchar(50),
	Descricao_Item Varchar(200),
	Id_Mov Int,
	Dt_Transacao Datetime,
	Documento Varchar(100),
	id_nf int,
	Tipo_Mov_Cod Varchar(10),
	Tipo_Mov_Descr Varchar(100),
	Quantidade Decimal(15,3),
	Entrada_Saida Char(1),
	Custo_Unitario Decimal(18,6),
	Quantidade_Sinal Decimal(15,3),
	Valor_Mov Decimal(15,2),
	Saldo_Quantidade Decimal(15,3),
	Saldo_Valor Decimal(15,2),
	Custo_Medio Decimal(18,6),
	Sequencia Int
);
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Subquery Para Obter os Id_Item e Id_Empresa Relevantes							*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Declare @RelevantItems Table (
							    Id_Empresa Int
							  , Id_Item    Int
							 )

Insert Into @RelevantItems
Select Distinct 
	Id_Empresa
,	Id_Item
From Estoque_Saldo_Competencia
WherE Id_Empresa = @IdEmpresa
And AnoMes = Format(DateAdd(Month, -1, @DataInicio), 'yyyy/MM')
And (
	     @IdDeposito Is Null 
	  Or Id_Estoque_Deposito = @IdDeposito
	)
And (
	     @IdItem = 0 
	  Or Id_Item = @IdItem
	);
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Inclui o Que Teve Mov no Estoque e Nao Existe na Tabela Estoque_Saldo_Competencia */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
With Cte_Itens_Mov_Ausentes As (
	Select  
	   Fato.id_empresa
	,  Fato.id_item
	,  Fato.id_item_original
	,  Fato.texto_livre
	,  Dim.codigo
	,  Dim.descricao
	,  Fato.id_mov
	,  Fato.dt_transacao
	,  Fato.documento
	,  Fato.id_nf
	,  Est.tipo_mov_cod
	,  Est.tipo_mov_descr
	,  Fato.quantidade
	,  Fato.entrada_saida
	,  Fato.custo_unitario
	,  Row_Number() Over ( Partition By Fato.Id_Item Order By Fato.Dt_Transacao, Fato.Id_Mov) As Sequencia
	From Estoque_Movimentos Fato
	Join Itens Dim					 On Dim.id_item				   = Fato.id_item
	Join Estoque_Deposito EstDep	 On Estdep.id_estoque_deposito = Fato.id_deposito
	Join Grupos_Estoque Gp			 On Gp.id_grupo_estoque		   = Dim.id_grupo_estoque
	Left join Estoque_Tipos_Mov Est  On Est.id_tipo_mov			   = Fato.id_tipo_mov
	Where Fato.Dt_Transacao BetWeen @DataInicio And @DataFim
	And   Fato.Id_Empresa = @IdEmpresa
	And   Fato.Situacao = 'A' 
	And   Fato.Movimenta_Estoque = 'S'
	And   Fato.Movimenta_EstoqTerceiro = 'N'
	And   Coalesce(EstDep.somente_qtde,'N') = 'N'
	And (
		    @IdItem = 0 
		 Or Dim.Id_Item = @IdItem
	    )
	     And (@iddeposito is null or fato.id_deposito = @iddeposito)
),
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Inclui o Que Teve Mov no Estoque e Existe na Tabela Estoque_Saldo_Competencia     */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
MovimentosNumerados As (
   Select 
       Fato.Id_Empresa,
       Fato.Id_Item,
	   Fato.id_item_original,
	   Fato.texto_livre,
       Itens.codigo,
       Itens.descricao,
       Fato.Id_Mov,
       Fato.Dt_Transacao,
       Fato.Documento,
	   Fato.id_nf,
       Dim.Tipo_Mov_Cod,    
       Dim.Tipo_Mov_Descr,
       Fato.Quantidade,
       Fato.Entrada_Saida,
       Fato.Custo_Unitario,
       Row_Number() Over ( Partition By Fato.Id_Item Order By Fato.Dt_Transacao, Fato.Id_Mov) As Sequencia
       From Estoque_Movimentos Fato
       Left  Join Estoque_Tipos_Mov Dim On  Dim.id_Tipo_Mov					     = Fato.id_Tipo_Mov
       Inner Join @RelevantItems Ri		On  Ri.Id_Empresa					     = Fato.Id_Empresa 
									    And Ri.Id_Item						     = Fato.Id_Item
       Inner Join Itens					On  Itens.id_item					     = Ri.Id_Item
	   Inner Join Estoque_Deposito		On  Estoque_Deposito.Id_Estoque_Deposito = Fato.Id_Deposito
       Where Fato.Dt_Transacao BetWeen @DataInicio And @DataFim
       And Fato.Id_Empresa = @IdEmpresa
       And Fato.Situacao = 'A' 
       And Fato.Movimenta_Estoque = 'S'
	   And Fato.Movimenta_EstoqTerceiro = 'N'
	   And Coalesce(Estoque_Deposito.Somente_Qtde,'N') = 'N'
	  And (
		         @IdItem       = 0 
			  Or Itens.Id_Item = @IdItem
		    )
       And Exists (
					Select Id_Item 
					From Estoque_Saldo_Competencia Es 
					Where Es.Id_Item = Itens.Id_Item
				   )
        And (
		         @IdDeposito Is Null 
			  Or Fato.Id_Deposito = @IdDeposito
			)
)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Inclui o Que Teve Mov no Estoque e Existe na Tabela Estoque_Saldo_Competencia     */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Insert Into #TempEstoque (
					       Id_Empresa, Id_Item, id_item_original, Observacao ,Codigo_Item, Descricao_Item, Id_Mov, 
						   Dt_Transacao, Documento, id_nf, Tipo_Mov_Cod, Tipo_Mov_Descr,
						   Quantidade, Entrada_Saida, Custo_Unitario, Sequencia
						 )
Select 
   Id_Empresa 
,  Id_Item
,  id_item_original
,  texto_livre
,  codigo 
,  descricao 
,  Id_Mov 
,  Dt_Transacao 
,  Documento 
,  id_nf 
,  Tipo_Mov_Cod 
,  Tipo_Mov_Descr 
,  Quantidade 
,  Entrada_Saida 
,  Custo_Unitario 
,  Sequencia
From MovimentosNumerados

Union 

Select 
   Esc.Id_Empresa
,  Esc.Id_Item
,  Id_Item_Original = Null
,  Texto_Livre	    = Null
,  Itens.Codigo
,  Itens.Descricao
,  0 As Id_Mov
,  DateFromParts(Year(@DataInicio), Month(@DataInicio), 1) As Dt_Transacao
, 'Saldo Inicial' AS Documento
,  Null As Id_Nf
,  Null As Tipo_Mov_Cod  
,  Null As Tipo_Mov_Descr   
,  Esc.Saldo_Qtd_Final As Quantidade
,  'E' As Entrada_Saida
,  Esc.Custo_Medio As Custo_Unitario
,  0 As Sequencia  -- Saldo inicial sempre terá sequência 0
From Estoque_Saldo_Competencia Esc
Inner Join @RelevantItems RI On  Ri.Id_Empresa = Esc.Id_Empresa 
							 And Ri.Id_Item    = Esc.Id_Item
Inner Join Itens			 On  Itens.Id_Item = Ri.Id_Item
Inner Join Estoque_Deposito  On  Estoque_Deposito.Id_Estoque_Deposito = ESC.Id_Estoque_Deposito
Where Esc.AnoMes = Format(DateAdd(Month, -1, @DataInicio), 'yyyy/MM')
And Esc.Id_Empresa = @IdEmpresa
And Coalesce(Estoque_Deposito.Somente_Qtde,'N') = 'N'
And (
		@IdDeposito Is Null
	 Or Esc.Id_Estoque_Deposito = @IdDeposito
	)
And (
	    @IdItem       = 0 
	 Or ITENS.Id_Item = @IdItem
	)

Union 

--> Unifica as Mov Ausentes
Select *
From Cte_Itens_Mov_Ausentes
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Atualiza a Quantidade Com Sinal												    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Update #TempEstoque 
Set Quantidade_Sinal = Case 
							When Entrada_Saida = 'E' Then Quantidade 
							Else -Quantidade 
					   End
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Declaração das Variáveis Para os Cálculos Abaixo do Cursor					    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Declare @SaldoQuantidade Decimal (15,3) = 0
,		@SaldoValor Decimal (15,2) = 0
,		@CustoMedio Decimal (18,6) = 0
,		@CurrentIdEmpresa Int = 0
,		@CurrentIdItem Int = 0
,		@Id_Empresa Int
,		@Id_Item Int
,		@Id_Mov  Int
,		@Entrada_Saida Char (1)
,		@Quantidade Decimal (15,3)
,		@CustoUnitario Decimal (18,6)
,		@ValorMov Decimal (15,2)
,	    @TipoMovCod Varchar(10)
,		@Id_Item_Original Int

-- Cursor Para Percorrer os Movimentos
Declare Cur_Movimentos Cursor For
Select 
    Id_Empresa,
    Id_Item,
    Id_Mov,
    Entrada_Saida,
    Quantidade,
    Custo_Unitario,
    Tipo_Mov_Cod,
    Id_Item_Original -- Adiciona Id_Item_Original na seleção
From #TempEstoque
Order By Id_Empresa, Id_Item, Dt_Transacao, Sequencia, Id_Mov;

Open Cur_Movimentos;
Fetch Next From Cur_Movimentos Into @Id_Empresa, @Id_Item, @Id_Mov, @Entrada_Saida, @Quantidade, @CustoUnitario, @TipoMovCod, @Id_Item_Original;

While @@Fetch_Status = 0
Begin
     -- Reinicia os Valores Quando Muda a Empresa ou o Item
   If (
	      @CurrentIdEmpresa != @Id_Empresa 
	   Or @CurrentIdItem    != @Id_Item
      )
		Begin
		    Set @CurrentIdEmpresa = @Id_Empresa;
		    Set @CurrentIdItem = @Id_Item;
		    Set @SaldoQuantidade = 0;
		    Set @SaldoValor = 0;
		    Set @CustoMedio = 0;
		End;

        -- Atualiza Saldo_Quantidade
        Set @SaldoQuantidade = Round(@SaldoQuantidade + (Case When @Entrada_Saida = 'E' Then @Quantidade Else -@Quantidade End),3)

        -- Calcula Valor_Mov e atualiza Saldo_Valor
   If (
		  @Entrada_Saida = 'E'
	  )
        Begin
            Set @ValorMov   = Round(@Quantidade * @CustoUnitario,2);
            Set @SaldoValor = Round(@SaldoValor + @ValorMov,2);
        End

   Else
        Begin
            Set @ValorMov   = Round(@Quantidade * @CustoMedio,2);
            Set @SaldoValor = Round(@SaldoValor - @ValorMov,2);
        End;

        -- Calcula Novo Custo_Medio
   If (   
		  @SaldoQuantidade > 0
	  )
        Begin
            Set @CustoMedio = @SaldoValor / @SaldoQuantidade;
        End

        -- Atualiza a Tabela Temporária
        Update #TempEstoque
        Set Valor_Mov        = @ValorMov,
            Saldo_Quantidade = @SaldoQuantidade,
            Saldo_Valor      = @SaldoValor,
            Custo_Medio      = @CustoMedio
        Where Id_Empresa = @Id_Empresa 
		And   Id_Item    = @Id_Item 
		And   Id_Mov     = @Id_Mov;

        Fetch Next From Cur_Movimentos Into @Id_Empresa, @Id_Item, @Id_Mov, @Entrada_Saida, @Quantidade, @CustoUnitario, @TipoMovCod, @Id_Item_Original;
    End;

    Close Cur_Movimentos;
    Deallocate Cur_Movimentos;
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Exec a Procedure Auxiliar que Calcula o Custo Unitario Se o Item For de Transf    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Begin
	Execute Dbo.SpCalculaCustoMedioEstoque_2 4, @DataInicio, @DataFim, 0, @IdDeposito, 0
End
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Após Rodar a Segunda Procedure Atualiza o Valor na Base Principal				    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Update Te
Set Te.Custo_Unitario	= Te2.Custo_Unitario,
    Te.Quantidade_Sinal = Te2.Quantidade_Sinal,
    Te.Valor_Mov		= Te2.Valor_Mov,
    Te.Saldo_Quantidade = Te2.Saldo_Quantidade,
    Te.Saldo_Valor		= Te2.Saldo_Valor,
    Te.Custo_Medio		= Te2.Custo_Medio
FROM #TempEstoque Te
Join TempEstoque_2 Te2 On  (Te.Id_Item   = Te2.Id_Item  ) --> Relaciona pelo Id_Item_Original
					   And (Te.Sequencia = Te2.Sequencia)
Where Te2.Id_Item != Te2.Id_Item_Original;				  --> Garante que só atualiza itens com Id_Item diferente do original
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Resultado Final Exibido Pela Procedure, Com Parametro de Apenas o Ult Mov ou Nao	*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
If (
     @ApenasUltimo = 1
   )

-- Traz Apenas o Ùlltimo Movimento Com a Maior Sequência de Cada Item
	Begin
		;With UltimosMovimentos As (
	        Select
	            Id_Empresa,
	            Id_Item,
	            Max(Sequencia) As MaxSequencia
	        From #TempEstoque
	        GrouP By Id_Empresa, Id_Item
	       )
	        Select 
	            te.Id_Empresa,
	            te.Id_Item,
				te.id_item_original,
				te.Observacao,
	            te.Codigo_Item,
	            te.Descricao_Item,
	            te.Dt_Transacao,
	            te.Documento,
				te.id_nf,
	            te.Tipo_Mov_Cod,    
	            te.Tipo_Mov_Descr,
	            te.Quantidade,
	            te.Entrada_Saida,
	            Iif(te.Entrada_Saida = 'S', te.Custo_Medio, te.Custo_Unitario) As Custo_Unitario,
	            te.Quantidade_Sinal,
	            te.Valor_Mov,
	            te.Saldo_Quantidade,
	            te.Saldo_Valor,
	            te.Custo_Medio,
	            te.Sequencia
	        From #TempEstoque te
	        Inner Join UltimosMovimentos Um On  Te.Id_Empresa = Um.Id_Empresa 
											And Te.Id_Item	  = Um.Id_Item
											And Te.Sequencia  = Um.MaxSequencia
			Order By Id_Empresa, Descricao_Item, Sequencia, Dt_Transacao, Id_Mov;
	End

Else
	Begin
	 -- Traz Todas as Movimentações
	        Select 
	            te.Id_Empresa,
	            te.Id_Item,
				te.id_item_original,
				te.Observacao,
	            te.Codigo_Item,
	            te.Descricao_Item,
	            te.Dt_Transacao,
	            te.Documento,
				te.id_nf,
	            te.Tipo_Mov_Cod,    
	            te.Tipo_Mov_Descr,
	            te.Quantidade,
	            te.Entrada_Saida,
	            te.Custo_Unitario,
	            te.Quantidade_Sinal,
	            te.Valor_Mov,
	            te.Saldo_Quantidade,
	            te.Saldo_Valor,
	            te.Custo_Medio,
	            te.Sequencia
	        From #TempEstoque te
			Order By Id_Empresa, Descricao_Item, Sequencia, Dt_Transacao, Id_Mov;
	End

End