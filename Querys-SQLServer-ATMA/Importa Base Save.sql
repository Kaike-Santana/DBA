


/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* PROGRAMADOR: KAIKE NATAN									                                    */
/* VERSAO     : DATA: 18/05/2022																*/
/* DESCRICAO  : RESPONSÁVEL POR ATUALIAZAR A ÚLTIMA TABELA DA SAVE					 		    */
/*																								*/
/*	ALTERACAO                                                                                   */
/*        2. PROGRAMADOR:													 DATA: __/__/____	*/		
/*           DESCRICAO  :										 								*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
BEGIN TRANSACTION;
	DECLARE @DATA DATE = CONVERT(DATE,GETDATE()-6)	-- <-- COLOCAR A DATA DA SAVE AQUI!

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: INSERE AS INFORMAÇÔES DA ÚLTIMA SAVE NA HISTÓRICO								    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
INSERT INTO REPORTS.DBO.TB_SAVE_RIACHUELO
SELECT * FROM REPORTS.DBO.TB_SAVE_RIACHUELO_ULTIMA
GO
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: CRIA TABELA NO LAYOUT DO CLIENTE												    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #SAVE_TXT
CREATE TABLE #SAVE_TXT (
							CPF VARCHAR(MAX),
							CHAVE_CYBER VARCHAR(MAX),
							RATING VARCHAR(MAX),
							DATA_ROLAGEM VARCHAR(MAX),
							SALDO_CONTABIL VARCHAR(MAX)
					   )
GO
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: POPULA TABELA COM BASE RECEBIDA DO CLIENTE									    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
BULK INSERT #SAVE_TXT
FROM '\\nectar\NectarServices\Administrativo\Temporario\Base Save\Nosso TXT\base_save_12.05_bulk.txt'
WITH
(
FIRSTROW = 1,
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n'
)
GO
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: LAYOUT FINAL, EXPURGANDO CONTRATO COM COMEÇO 0									*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #SAVE
SELECT 
		CPF
,		CHAVE_CYBER		=	IIF(LEFT(CHAVE_CYBER,1) = 0, SUBSTRING(RTRIM(LTRIM(CHAVE_CYBER)),2,LEN(RTRIM(LTRIM(CHAVE_CYBER)))), RTRIM(LTRIM(CHAVE_CYBER)))
,		RATING
,		DATA_ROLAGEM
,		SALDO_CONTABIL
,		DATA_SAVE		=	@DATA
INTO #SAVE
FROM #SAVE_TXT
GO
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: TRUNCA E INSERE PRA DEIXAR SÓ A SAVE MAIS RECENTE									*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
TRUNCATE TABLE REPORTS.DBO.TB_SAVE_RIACHUELO_ULTIMA
INSERT INTO REPORTS.DBO.TB_SAVE_RIACHUELO_ULTIMA
SELECT * FROM #SAVE
GO
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: LAYOUT PRA MANDAR EMAIL															*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
SELECT
	DT_INFO
,	QTD			=	COUNT(NUM_CPF)
FROM REPORTS.DBO.TB_SAVE_RIACHUELO_ULTIMA
WHERE DT_INFO	=	@DATA
GROUP BY 
	DT_INFO

COMMIT TRANSACTION;