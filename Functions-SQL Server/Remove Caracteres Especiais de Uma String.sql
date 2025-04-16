
Use Thesys_Producao
Go

--> Programador: Kaike Santana
--> Descricao: Valida Tem Casos no CP Com Saldo = 0 e a Situacao Nao Seja Pago Total
--> Data: 2024-12-03
--> Versao: 1.0

Create Function Dbo.Fn_RemoveSpecialChars(@Texto nvarchar(4000))
Returns Nvarchar(4000)
As
Begin
    While Patindex('%[^a-za-z0-9 ]%', @Texto) > 0
    Begin
        Set @Texto = Stuff(@Texto, Patindex('%[^a-za-z0-9 ]%', @Texto), 1, '');
    End
    Return @Texto;
End

--> Example How To Call The Function 
/*
	Select Dbo.Fn_RemoveSpecialChars('Este (texto) * contém! caracteres?? especiais') AS TextoLimpo;
*/