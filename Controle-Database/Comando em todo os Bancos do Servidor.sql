
USE Data_Science
GO

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* PROGRAMADOR: KAIKE NATAN									                                    */
/* VERSAO     : DATA: 04/03/2022																*/
/* DESCRICAO  : SCRIPT PARA EXECUTAR UM COMANDO EM TODOS OS DATABASES							*/
/*																								*/
/*	ALTERACAO                                                                                   */
/*        1. PROGRAMADOR: 													DATA: __/__/____	*/		
/*           DESCRICAO  :  																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	O COMANDO DEVE SER PASSADO EM STRING, CASO OPTE POR UMA APLICAÇÃO DE VARIOS		*/
/*				IDIOMAS ALTERAR O TIPO N'VARCHAR QUE SUPORTA ESSE TIPO DE MUNDANÇA				*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

DECLARE @Query VARCHAR(MAX) = '

CREATE PROCEDURE PRC_TESTE_KAIKE AS
IF (''?'' NOT IN (''master'', ''model'', ''msdb'', ''tempdb''))

BEGIN
PRINT (''HELOO WORD'')
END
					  '
EXEC (@Query)

