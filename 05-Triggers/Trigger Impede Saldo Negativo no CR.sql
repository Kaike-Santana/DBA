
Use Thesys_Homologacao
Go

--> Programador: Kaike Natan
--> Descricao: Trigger Para Impedir Que Titulos do Cr, Fiquem Com Saldo Negativo no Banco de Dados.
--> Data: 2025-03-26
--> Versao: 1.0

Create Trigger Trg_ValidaSaldoNegativo_Cr 
On Dbo.Recebimentos_Contas_Mov
After Insert
,	  Update
,	  Delete
As

Begin;
    Set NoCount On;

    -- Cria uma tabela temporária para guardar IDs únicos de contas afetadas
    Declare @ContasAfetadas Table (
								   Id_Receb_Conta Int Primary Key
								  );

    -- Insere IDs de contas afetadas por INSERT ou UPDATE
    Insert Into @ContasAfetadas (Id_Receb_Conta)

    Select Distinct Id_Receb_Conta 
	From Inserted

    Union

    Select Distinct Id_Receb_Conta 
	From Deleted;

    -- Verifica saldo das contas afetadas
    If Exists (
			    Select 1
			    From @ContasAfetadas Cr
			    Cross Apply (
				 		     Select Saldo = Dbo.FnSaldoReceberConta(
																  Cr.Id_Receb_Conta
																 ) 
				 			) As SaldoConta
			    Where SaldoConta.Saldo < 0
			  )
    Begin
        Raiserror ('Operação Cancelada. O Saldo Não Pode Ser Negativo. Contate o Suporte do Thesys!', 16, 1);
        Rollback Transaction;
        Return;
    End
End;