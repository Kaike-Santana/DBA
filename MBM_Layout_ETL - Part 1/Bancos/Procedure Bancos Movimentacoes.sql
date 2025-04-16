

Use Thesys_Homologacao
Go

--> Programador: Kaike Natan
--> Descricao: Procedure Responsavel Por Levantar as Movimentacoes Bancaria Com Periodo de DataInicial, Final e Flag de Conciliado Dinamico
--> Data: 2024-08-13
--> Versao: 1.0

Alter Procedure sp_RelatorioBancario
    @VData_Inicial Date,
    @VData_Final   Date,
    @VConciliado   Bit
As
Begin

 Set NoCount On;

    Select 
        NomeFantasia   = Empresas.Nome,
        NomeBanco	   = Bancos.Descricao,
        Agencia		   = Bancos_Contas.Nro_Agencia,
        NroConta       = Bancos_Contas.Nro_Conta,
        NomeConta      = Bancos_Contas.Nome,
		StatusConta    = Bancos_Contas.Ativo,
        SaldoInicial   = Isnull(
								(
								 Select Sum(Valor_Sinal)
								 From Bancos_Movimentacoes As Bm
								 Where Bm.Id_Banco_Conta = Bancos_Contas.Id_Banco_Conta
								 And Bm.Dt_BomPara < @VData_Inicial
								 And (
									     @VConciliado = 0 
									  Or Bm.Conciliado = 'S'
									 )
							    )
							   ,0
							   ),
        DebitoPeriodo   = Sum(
						     Case 
						         When Bancos_Movimentacoes.Tipo = 'Debito' 
								 And  Bancos_Movimentacoes.Dt_BomPara BetWeen @VData_Inicial And @VData_Final 
						         Then Bancos_Movimentacoes.Valor_Sinal
						         Else 0 
						     End
							   ),
        CreditoPeriodo  = Sum(
							 Case 
							     When Bancos_Movimentacoes.Tipo = 'Credito' 
							     And  Bancos_Movimentacoes.Dt_BomPara BetWeen @VData_Inicial And @VData_Final
							     Then Bancos_Movimentacoes.Valor_Sinal
							     Else 0 
							 End
        ),
        SaldoFinal     = Isnull(
							    (
							     Select Sum(Valor_Sinal)
							     From Bancos_Movimentacoes As Bm
							     Where Bm.Id_Banco_Conta = Bancos_Contas.Id_Banco_Conta
							     And Bm.Dt_BomPara <= @VData_Final
							     And (
								         @VConciliado = 0 
									  Or Bm.Conciliado = 'S'
								     )
							    )
							    ,0
							   )
    From Bancos_Movimentacoes
    Join Empresas	   On (Empresas.Id_Empresa		    = Bancos_Movimentacoes.Id_Empresa	 )
    Join Bancos_Contas On (Bancos_Contas.Id_Banco_Conta = Bancos_Movimentacoes.Id_Banco_Conta)
    Join Bancos		   On (Bancos.Id_Banco				= Bancos_Contas.Id_Banco			 )
    Group By 
        Empresas.Nome,
        Bancos.Descricao,
        Bancos_Contas.Nro_Agencia,
        Bancos_Contas.Nro_Conta,
        Bancos_Contas.Nome,
        Bancos_Contas.Id_Banco_Conta,
		Bancos_Contas.Ativo;
End;


--> Exemplo de Execucao da Procedure, 3º Parametros: 

--> DataInicial, DataFinal das Transacoes Bancarias
--> 1 = Só Casos Que Sâo Conciliados, 0 = Traz Tudo

--Execute sp_RelatorioBancario '2024-07-01', '2024-07-31', 0;