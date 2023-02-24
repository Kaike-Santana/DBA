
USE DATA_SCIENCE
GO

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* PROGRAMADOR: KAIKE NATAN										                                */
/* VERSAO     : DATA: 08/08/2022																*/
/* DESCRICAO  : RESPONSÁVEL POR ATUALIZAR A TABELA DE OPERADORES DO SUPERSOFT					*/
/*																								*/
/*	ALTERACAO                                                                                   */
/*        2. PROGRAMADOR:													 DATA: __/__/____	*/		
/*           DESCRICAO  :																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: TRAZ AS INFORMAÇÕES DO CALLFLEX													*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/ 
DROP TABLE IF EXISTS #CALLFLEX
SELECT
	CPF
,	NOME
,	[USER]	 [USUARIO]
INTO #CALLFLEX
FROM OPENQUERY(
[10.251.2.18],
'select distinct
cpf,
nome,
user
from replica_atmspbb1.agents

union

select distinct
cpf,
nome,
user
from replica_atmsp2b1.agents

union

select distinct
cpf,
nome,
user
from replica_atmsp3b1.agents

union

select distinct
cpf,
nome,
user
from replica_atmsp3b1.agents')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: OPENROWSET COM AS INFORMAÇÕES DO SUPERSOFT ATUALIZADO								*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #TMP_OPERADOR
SELECT *
INTO #TMP_OPERADOR
FROM OPENROWSET('MICROSOFT.ACE.OLEDB.12.0',
'EXCEL 12.0 XML;HDR=YES;DATABASE=\\polaris\NectarServices\Administrativo\Output\TB_OPERADORES\Operadores.xlsx'
,'SELECT *
FROM [PLANILHA1$]');
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: TRAZ O IDPES DO NECTAR E O ID DA CALLFLEX											*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #TMP
SELECT 
 T.[NOME]
,ISNULL(P.USUAR_PES,T.CPF) [CPF]
,T.SETOR
,T.ADMISSAO
,T.ATIVO
,T.DEMISSAO
,CASE
	WHEN C.CPF = OH.CPF THEN 'HOME OFFICE'
	ELSE 'PRESENCIAL'
 END [REGIME]
,T.CONTRATO
,CARGO
,ENTRADA		=	LEFT(CAST(T.ENTRADA AS TIME),8)
,SAIDA			=	LEFT(CAST(T.SAIDA   AS TIME),8)
,P.IDPES_PES[IDPES]
,C.USUARIO[USUARIOCALLFLEX] 
INTO #TMP
FROM #TMP_OPERADOR T
LEFT JOIN [10.251.1.36].NECTAR.DBO.TB_PESSOAL P ON P.USUAR_PES = T.CPF
LEFT JOIN #CALLFLEX C ON C.CPF = T.CPF
LEFT JOIN DATA_SCIENCE..OPERADORESHOME OH ON OH.CPF = T.CPF
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: TRUNCA E INSERE AS INFORMAÇÕES DA TABELA											*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
TRUNCATE TABLE DATA_SCIENCE..OPERADORES
INSERT INTO    DATA_SCIENCE..OPERADORES
SELECT 
 CAST(GETDATE() AS DATE) DT_ATUALIZACAO
,NOME	
,CPF	
,SETOR	
,ADMISSAO	
,ATIVO	
,DEMISSAO	
,REGIME	
,CONTRATO	
,CARGO	
,ENTRADA
,SAIDA	 
,IDPES	
,USUARIOCALLFLEX
FROM #TMP
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: FLEGA DUPLICADOS DO SUPERSOFT														*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #TESTE
SELECT *
,	RW	=	ROW_NUMBER() OVER( PARTITION BY CPF ORDER BY ADMISSAO DESC)
INTO #TESTE
FROM OPERADORES
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: DELETEA DUPLICADOS E DROPA COLUNA DE FLAG											*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DELETE FROM #TESTE WHERE RW > 1
ALTER TABLE #TESTE DROP COLUMN RW
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: INSERE OS DADOS TRATADOS NA TABELA												*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
TRUNCATE TABLE OPERADORES
INSERT INTO    OPERADORES
SELECT * FROM  #TESTE