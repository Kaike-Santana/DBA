
--Programador: Kaike Natan
--Data: 25-07-2023
--Version: 1.0
--Descricao: Chama o Scrip Python Através do SQL Server Agent (Job) 

--> SolFácil
Begin

Declare @ExportDumpSolfacil Varchar(1000) = '\\atlantida\MIS\"Kaike Natan"\PYTHON\Executaveis\DumpSolFacil_csv_utf8.py'
Declare @ExportDumpRenner   Varchar(1000) = '\\atlantida\MIS\"Kaike Natan"\PYTHON\Executaveis\DumpRennerSFTP.py'
Declare @vData Date = Convert(Date,GetDate()-1) 

--If(
-- DatePart(Dw,GetDate())
--) = 2
--
--Begin
--	Set @vData = Convert(Date,GetDate()-2) 
--End

--Select @vData
If(
   Select Max(Data)
   From Reports.Dbo.Tb_Ds_Arquivo_Retorno_Solfacil With( NoLock )
) = @vData

Exec Xp_CmdShell @ExportDumpSolfacil;

Print ('Executando Script Python Da SolFácil')

End

--> Renner Dump de Acionamentos
Begin
	If(
	   Select Max(Atualizacao)
	   From Reports.Dbo.Tb_Ds_Arquivo_Retorno_Renner With( NoLock )
	) = @vData
	
	Exec Xp_CmdShell @ExportDumpRenner;
	
	Print ('Executando Script Python Da Renner')
End