
USE DATA_SCIENCE
GO

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* PROGRAMADOR: KAIKE NATAN										                                */
/* VERSAO     : DATA: 08/08/2022																*/
/* DESCRICAO  : RESPONSÁVEL POR ATUALIZAR A TABELA DO PROJETO ATSPACE							*/
/*																								*/
/*	ALTERACAO                                                                                   */
/*        2. PROGRAMADOR: KAIKE NATAN										DATA: 13/02/2023	*/		
/*           DESCRICAO : INCLUSÃO DE 3 COLUNAS (ID SUPERSOFT, COD EMPRESA E TIPO CONTRATO		*/
/*	ALTERACAO                                                                                   */
/*        3. PROGRAMADOR:													 DATA: __/__/____	*/		
/*           DESCRICAO  :																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: CRIA TABELA NO LAYOUT SOLICITADO													*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/ 
DROP TABLE IF EXISTS DATA_SCIENCE.DBO.TB_DS_ATSPACE_ATMA
CREATE TABLE		 DATA_SCIENCE.DBO.TB_DS_ATSPACE_ATMA (
ID  INT ,
NOME VARCHAR(MAX) NOT NULL,
CPF VARCHAR(14) NOT NULL,
DEPARTAMENTO VARCHAR(MAX) NULL,
DT_ADM DATE NULL,
DT_DEM DATE NULL,
TP_CONTRATO VARCHAR(MAX) NULL,
CENCUST VARCHAR(MAX) NULL,
HORA_ENTRADA VARCHAR(MAX) NULL,
HORA_SAIDA VARCHAR(MAX) NULL,
CARGA_MES VARCHAR(MAX) NULL,
COD_EMP INT NULL,
EMPRESA VARCHAR(MAX) NULL,
TIPO_CON VARCHAR(MAX) NULL
);
GO
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: FAZ O ETL DAS INFORMAÇÕES E INSERE NA TABELA CRIADA ACIMA							*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/ 
INSERT INTO DATA_SCIENCE.DBO.TB_DS_ATSPACE_ATMA
SELECT 
	CODFUNC
,	NOME
,	CPF				=	REPLACE(REPLACE(CPF,'-',''),'.','')
,	DEPARTAMENTO
,	DT_ADM			=	CONVERT(DATE,DT_ADM)
,	DT_DEM			=	CONVERT(DATE,DT_DEM)
,	TP_CONTRATO
,	CENCUST
,	HORA_ENTRADA	=	RIGHT(HORA_ENTRADA,5)
,	HORA_SAIDA		=	RIGHT(HORA_SAIDA  ,5)
,	CARGA_HORARIA	=	LEFT(CARGA_HORARIA,3)
,	COD_EMP			=	IIF(ABREV = 'ATMA', 0, 1)
,	EMPRESA			=	ABREV
,	TIPO_CON		=	IIF(ABREV = 'ATMA', 'CLT', 'ESTAGIO')
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
'Excel 12.0 Xml;HDR=YES;Database=\\polaris\NectarServices\Administrativo\Output\ATSPACE\ATSPACE.xlsx',
'SELECT * FROM [Planilha1$]')