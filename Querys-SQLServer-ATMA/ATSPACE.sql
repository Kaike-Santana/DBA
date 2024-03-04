
USE DATA_SCIENCE
GO

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* PROGRAMADOR: KAIKE NATAN										                                */
/* VERSAO     : DATA: 27/02/2023																*/
/* DESCRICAO  : RESPONSÁVEL POR ATUALIZAR A TABELA DO PROJETO ATSPACE							*/
/*																								*/
/*	ALTERACAO                                                                                   */
/*        2. PROGRAMADOR:													 DATA: __/__/____	*/		
/*           DESCRICAO  :																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	 CREATE PROCEDURE PRC_DS_ATUALIZA_ATSPACE AS
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
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: FAZ O ETL DOS DADOS DIRETOS DO FIREBIRD											*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/ 
DROP TABLE IF EXISTS #SS
SELECT *
INTO #SS
FROM OPENQUERY([FIREBIRD SS],'
SELECT
  Codfunc
, Nome
, CPF
,case
    when Departamento in (''AMBEV'',''Ambev'')                                                               then ''AMBEV''
    when Departamento in (''SOLFACIL'',''SOL FACIL'')                                                        then ''SOLFACIL''
    when Departamento in (''CAEDU'',''Caedu'')                                                               then ''CAEDU''
    when Departamento in (''DIGITAL'',''digital'')                                                           then ''DIGITAL''
    when Departamento in (''METALFRIO'',''METAL FRIO'',''SAC'')                                              then ''METALFRIO''
    when Departamento in (''ORIGINAL'',''ORGINAL'',''original'',''ORIGINALÇ'',''ORIGNAL'')                   then ''ORIGINAL''
    when Departamento in (''PICPAY'',''PIC PAY'',''PICPPAY'')                                                then ''PICPAY''
    when Departamento in (''PRAVALER'',''PRA VALER'')                                                        then ''PRAVALER''
    when Departamento in (''PREVENTIVO'',''Preventivo'')                                                     then ''PREVENTIVO''
    when Departamento in (''RENNER'',''renner'')                                                             then ''RENNER''
    when Departamento in (''RIACHELO'',''riachuelo'',''RIACHUELO'',''RIACHUELO CURTO'',''RIACHUELO LONGO'')  then ''RIACHUELO''
    when Departamento in (''TEXA'',''Texa'')																 then ''TEXA''
    when Departamento in (''VELOE'')																		 then ''VELOE''
    when Departamento in (''VITAMINA'')																		 then ''VITAMINA''
    else Departamento end  as Departamento
, replace(cast(dtadmit as date),''.'',''/'')   as DT_ADM
, case when DtResc is null then null when DtResc is not null then replace(cast(DtResc as date),''.'',''/'') end as DT_DEM
, hollpad   as TP_Contrato
, cencust
, entradam  as Hora_entrada
, salatual
, saidat    as Hora_saida
, horasmes  as Carga_Horaria
, abrev
FROM FUNCIO')
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
FROM #SS