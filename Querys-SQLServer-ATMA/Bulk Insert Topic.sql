


/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: CRIA TABELA NO LAYOUT DO CLIENTE												    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS BASE_TEMP
CREATE TABLE		 BASE_TEMP 
(
	DATA_ARQ VARCHAR(MAX)								null
,	IDENTIFICADOR VARCHAR(MAX)							null
,	CONTRATO VARCHAR(MAX)								null
,	SUB_CONTRATO VARCHAR(MAX)							null
,	CPF VARCHAR(MAX)									null
,	N_PARCELA VARCHAR(MAX)								null
,	IDPAG VARCHAR(MAX)									null
,	PRODUTO VARCHAR(MAX)								null
,	SUB_PORDUTO VARCHAR(MAX)							null
,	DESC_PROD VARCHAR(MAX)								null
,	DTVEN VARCHAR(MAX)									null
,	DTPAG VARCHAR(MAX)									null
,	ANOMES_VENC VARCHAR(MAX)							null
,	ANOMES_PAG VARCHAR(MAX)								null
,	DIA_PAG VARCHAR(MAX)								null
,	STATUS_PCL VARCHAR(MAX)								null
,	VLATUAL VARCHAR(MAX)								null
,	VLPAGO VARCHAR(MAX)									null
,	SIT_PARCELA VARCHAR(MAX)							null
,	SIT_FINC VARCHAR(MAX)								null
,	SIT_CON VARCHAR(MAX)								null
,	DIAS_ATR VARCHAR(MAX)								null
,	VL_PAR_ORIGINAL VARCHAR(MAX)						null
,	VERSAOCONTRATO	 VARCHAR(MAX)						null
,	DATAREGISTROOEPRACAO	 VARCHAR(MAX)				null
,	VALORJUROS	 VARCHAR(MAX)							null
,	TIPOCONTRATO	 VARCHAR(MAX)						null
,	TIPOCANALORIGEM	 VARCHAR(MAX)						null
,	DT_INICIOCONTRATO VARCHAR(MAX)						null
,	DT_FIMCONTRATO	 VARCHAR(MAX)						null
,	TAXACONTRATO	 VARCHAR(MAX)						null
,	PERIODICIDADETAXA	 VARCHAR(MAX)					null
,	VALORPARCELA	 VARCHAR(MAX)						null
,	QUANTIDADETOTALPARCELAS	 VARCHAR(MAX)				null
,	VALORATRASO VARCHAR(MAX)							null
,	TEMPOCONTRATO	 VARCHAR(MAX)						null
,	CONTRATO_ORIGEM		 VARCHAR(MAX)					null
,	DT_RNEG	 VARCHAR(MAX)								null
,	SIT_ENTRADA_PARCELA	VARCHAR(MAX)					null
,	VALOR_ENTRADA VARCHAR(MAX)							null
,	LOGIN_OPERADOR VARCHAR(MAX)							null
,	CANAL VARCHAR(MAX)									null
,	GRUPO_CANA VARCHAR(MAX)								null				
)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: POPULA TABELA COM BASE RECEBIDA DO CLIENTE									    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
BULK INSERT BASE_TEMP
FROM '\\polaris\NectarServices\Administrativo\Input_temp_base2.txt'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n')
--CODEPAGE = 'ACP'
)
GO