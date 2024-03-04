
 USE DATA_SCIENCE
 GO

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* PROGRAMADOR: KAIKE NATAN									                                    */
/* VERSAO     : DATA: 21/02/2022																*/
/* DESCRICAO  : RESPONSAVEL ODENTIFICAR AS QUERYS PROBLEMÁTICAS DO SERVIDOR						*/
/*																								*/
/*	ALTERACAO                                                                                   */
/*        1. PROGRAMADOR: 													DATA: __/__/____	*/		
/*           DESCRICAO  :  																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	SETA PARA QUE A CONSULTA NÃO INTERROMPA OS PROCESSOS EM EXECUÇÃO			    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	GO
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	DECLARA A VARIÁVEL DE BANCO E O COMANDO PARA XML							    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

	DECLARE @dbname SYSNAME	SET @dbname = QUOTENAME(DB_NAME());
	WITH XMLNAMESPACES (DEFAULT 'http://schemas.microsoft.com/sqlserver/2004/07/showplan')

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	IDENTIFICA AS QUERYS PROBLEMÁTICAS DO SERVIDOR								    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
SELECT
   Query			=	stmt.value('(@StatementText)[1]', 'varchar(max)') ,
   QueryPlan		=	query_plan ,
   Schema_db		=	sc.value('(.//Identifier/ColumnReference/@Schema)[1]', 'varchar(128)') , 
   TABELA			=	sc.value('(.//Identifier/ColumnReference/@Table)[1]', 'varchar(128)') , 
   COLUNA			=	sc.value('(.//Identifier/ColumnReference/@Column)[1]', 'varchar(128)') ,
   TIPO_SCAN_TB		=	CASE WHEN s.exist('.//TableScan') = 1 THEN 'TableScan' ELSE 'IndexScan' END ,
   STRING_SCALAR	=	sc.value('(@ScalarString)[1]', 'varchar(128)') 
FROM 
    sys.dm_exec_cached_plans AS cp
    CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle) AS qp
    CROSS APPLY query_plan.nodes('/ShowPlanXML/BatchSequence/Batch/Statements/StmtSimple') AS batch(stmt)
    CROSS APPLY stmt.nodes('.//RelOp[TableScan or IndexScan]') AS scan(s)
    CROSS APPLY s.nodes('.//ScalarOperator') AS scalar(sc)
WHERE
    s.exist('.//ScalarOperator[@ScalarString]!=""') = 1 
    AND sc.exist('.//Identifier/ColumnReference[@Database=sql:variable("@dbname")][@Schema!="[sys]"]') = 1
    AND sc.value('(@ScalarString)[1]', 'varchar(128)') IS NOT NULL

	