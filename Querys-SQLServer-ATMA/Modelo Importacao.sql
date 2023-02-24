----------------------------------------------------------------- EXPORTA BCP PARA A PASTA -----------------------------------------------------------------

SET LANGUAGE 'BRAZILIAN'

DECLARE @DATA VARCHAR(10)				   =	(SELECT REPLACE(CONVERT(VARCHAR(10),GETDATE(),103),'/','')) 
DECLARE @HORA VARCHAR (3)				   =	 CONCAT (LEFT(CONVERT (TIME,GETDATE()),2),'H')
DECLARE @NOMENCLATURA_DISPARO VARCHAR(MAX) =	'DUMP_PRA_VALER_'+@DATA+'_'+@HORA+'.csv'
DECLARE @BCP NVARCHAR(4000)

SET @BCP = ' master..xp_cmdshell ''bcp " SELECT * FROM ##BCP " queryout "\\polaris\NectarServices\Administrativo\Temporario\PraValer\Dump"\'+@NOMENCLATURA_DISPARO+' -c -T '''
EXEC SP_EXECUTESQL @BCP

/*
-- Utilizando queryout, pode-se exportar o resultado de uma query
EXEC master.dbo.xp_cmdshell 'bcp "SELECT * FROM ##FINAL" queryout "\\polaris\NectarServices\Administrativo\Temporario\PraValer\Dump.csv" -c -T'

-- Utilizando out, pode-se exportar um objeto
EXEC master.dbo.xp_cmdshell 'bcp [Data_science].[dbo].[teste] out "C:\Users\kaike.santana.csv" -c -T'
*/


INSERT INTO  #teste
EXEC MASTER..XP_CMDSHELL
			'DIR /B "\\polaris\NectarServices\Administrativo\Temporario\PraValer\teste.txt'

			drop table #teste
			create table #teste (
									carro varchar(max)
								)