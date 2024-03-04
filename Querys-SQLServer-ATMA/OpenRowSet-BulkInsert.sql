
USE PLANNING
GO

--PROGRAMADOR: KAIKE NATAN
--DATA: 2023-08-07 
--DESCRICAO PROCESSO: GERA MAILING LAYOUT UNICO DO AD

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: CRIA TABELA NO LAYOUT ADEQUADO DE CADA COLUNA										*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS TB_BASE_MAILINGAD_20230731 
CREATE TABLE TB_BASE_MAILINGAD_20230731 (
	[CPF] [varchar](11) NOT NULL,
	[PRODUTO] [varchar](255) NULL,
	[VL_LCNO_PRTO_FNRO] [varchar](255) NULL,
	[Valor] [money] NULL,
	[NUM_APOLICE] [varchar](255) NULL,
	[CARTAO] [varchar](50) NULL,
	[PRODUTOS] [varchar](50) NULL,
	[MARGEM] [varchar](50) NULL,
	[codcli] [varchar](255) NULL,
	[flg_order] [varchar](255) NULL,
	[CodCorporativo] [varchar](255) NULL,
	[DescricaoCampanha] [varchar](255) NULL,
	[NumDDD] [varchar](20) NULL,
	[NumTel] [varchar](20) NULL,
	[NomCli] [varchar](255) NOT NULL,
	[DAT_NASCIMENTO] [varchar](12) NULL,
	[NovoRegistro] [varchar](255) NULL);
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: IMPORTA BASE DA CLIENTE DEPOIS DO ETL DA TABELA									*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
INSERT INTO TB_BASE_MAILINGAD_20230731
SELECT *
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
'Excel 12.0 Xml;HDR=YES;Database=\\polaris\NectarServices\Administrativo\Mailing_AD\Base_Mailing_20230731.xlsx',
'SELECT * FROM [Help_Seguros$]');
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: SOBE O DExPARA DE PRODUTOS PARA O BANCO DE DADOS									*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS TB_DEPARA_MAILING_AD
SELECT *
INTO TB_DEPARA_MAILING_AD
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
'Excel 12.0 Xml;HDR=YES;Database=\\polaris\NectarServices\Administrativo\Mailing_AD\Seguros DE x PARA.xlsx',
'SELECT * FROM [Planilha1$]');
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: VERIFICA SE TEM CPF SEM TELEFONES NA BASE											*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
SELECT *
FROM TB_BASE_MAILINGAD_20230731
WHERE NumTel IS NULL 
OR	  NumTel = '0'
OR	  NumTel = ''
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: ATUALIZA OS PRODUTOS DE ACORDO COM O DExPARA										*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
UPDATE TB_BASE_MAILINGAD_20230731
SET PRODUTO	= Y.DEXPARA

FROM TB_BASE_MAILINGAD_20230731 X
JOIN TB_DEPARA_MAILING_AD		Y ON Y.ENVIADO = X.PRODUTO
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: ATUALIZA OS PRODUTOS DE ACORDO COM O DExPARA										*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #BASE
SELECT *
INTO #BASE
FROM TB_BASE_MAILINGAD_20230731
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: ADICIONAR PARA FAZER A CONCATENAÇÂO DINAMICA										*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	ALTER TABLE #BASE
	ADD NovaColuna VARCHAR(MAX);
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: ATUALIZAR A NOVA COLUNA COM A CONCATENAÇÃO DOS VALORES							*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
UPDATE t1
SET t1.NovaColuna = (
					 SELECT STRING_AGG(CONCAT(t2.PRODUTO, '&', REPLACE(CONVERT(VARCHAR, t2.Valor), ',', '.'), '#'), '') WITHIN GROUP (ORDER BY t2.PRODUTO)
                     FROM #BASE t2
                     WHERE t2.CPF = t1.CPF
                     GROUP BY t2.CPF
					)
FROM #BASE t1;
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: ATUALIZAR A NOVA COLUNA COM A CONCATENAÇÃO DOS VALORES							*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #BASE_FINAL
SELECT *
,	RW = ROW_NUMBER() OVER ( PARTITION BY CPF ORDER BY VALOR DESC)
INTO #BASE_FINAL
FROM #BASE
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: ATUALIZAR A NOVA COLUNA COM A CONCATENAÇÃO DOS VALORES							*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	DELETE FROM #BASE_FINAL WHERE RW > 1
	ALTER TABLE #BASE_FINAL DROP COLUMN RW
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: CRIA TABELA NA ESTRUTURA NO DO MAILING LAYOUT UNICO								*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #LAYOUT_UNICO
CREATE TABLE #LAYOUT_UNICO(
	[DATA_DE_IMPORTACAO_MAILLING] [varchar](1000) NULL,
	[HORA_DA_INCLUSAO_MAILING] [varchar](1000) NULL,
	[IDSRV] [varchar](1000) NULL,
	[IDEMP] [varchar](1000) NULL,
	[EMPRESA] [varchar](1000) NULL,
	[IDCAR] [varchar](1000) NULL,
	[CARTEIRA] [varchar](1000) NULL,
	[IDDEV] [varchar](1000) NULL,
	[NOME_CLIENTE] [varchar](1000) NOT NULL,
	[CPF] [varchar](1000) NOT NULL,
	[ID_CONTRATO] [varchar](1000) NULL,
	[CONTRATO] [varchar](1000) NULL,
	[DIAS_ATRASO] [varchar](1000) NULL,
	[SEGMENTACAO] [varchar](1000) NULL,
	[SITUACAO] [varchar](1000) NULL,
	[DATA_DE_INCLUSAO] [varchar](1000) NULL,
	[DATA_DE_DEVOLUCAO] [varchar](1000) NULL,
	[ENQUADRAMENTO] [varchar](1000) NULL,
	[CLASSE] [varchar](1000) NULL,
	[MERCADORIA] [varchar](1000) NULL,
	[VALOR_PRINCIPAL] [varchar](1000) NULL,
	[VALOR_ATUALIZADO] [varchar](1000) NULL,
	[REFERENCIA] [varchar](1000) NULL,
	[BANDEIRA] [varchar](1000) NULL,
	[LOJA_AGENCIA] [varchar](1000) NULL,
	[PROFISSAO] [varchar](1000) NULL,
	[TIPO_DE_PESSOA] [varchar](1000) NULL,
	[SCORE] [varchar](1000) NULL,
	[PONTUACAO_SCORE] [varchar](1000) NULL,
	[SCORE_CREDOR] [varchar](1000) NULL,
	[COMPORTAMENTO][varchar](1000) NULL,
	[PROBABILIDADE] [varchar](1000) NULL,
	[DDD1] [varchar](1000) NULL,
	[TELEFONE1] [varchar](1000) NULL,
	[STATUS1] [varchar](1000) NULL,
	[PREFERENCIAL1] [varchar](1000) NULL,
	[DATA_ATUALIZACAO1] [varchar](1000) NULL,
	[QUALIFICACAO1] [varchar](1000) NULL,
	[ORIGEM1] [varchar](1000) NULL,
	[TIPO1] [varchar](1000) NULL,
	[DDD2]  [varchar](1000) NULL,
	[TELEFONE2] [varchar](1000) NULL,
	[STATUS2] [varchar](1000) NULL,
	[PREFERENCIAL2] [varchar](1000) NULL,
	[DATA_ATUALIZACAO2] [varchar](1000) NULL,
	[QUALIFICACAO2] [varchar](1000) NULL,
	[ORIGEM2] [varchar](1000) NULL,
	[TIPO2] [varchar](1000) NULL,
	[DDD3] [varchar](1000) NULL,
	[TELEFONE3] [varchar](1000) NULL,
	[STATUS3] [varchar](1000) NULL,
	[PREFERENCIAL3] [varchar](1000) NULL,
	[DATA_ATUALIZACAO3] [varchar](1000) NULL,
	[QUALIFICACAO3] [varchar](1000) NULL,
	[ORIGEM3] [varchar](1000) NULL,
	[TIPO3] [varchar](1000) NULL,
	[DDD4] [varchar](1000) NULL,
	[TELEFONE4] [varchar](1000) NULL,
	[STATUS4] [varchar](1000) NULL,
	[PREFERENCIAL4] [varchar](1000) NULL,
	[DATA_ATUALIZACAO4] [varchar](1000) NULL,
	[QUALIFICACAO4] [varchar](1000) NULL,
	[ORIGEM4] [varchar](1000) NULL,
	[TIPO4] [varchar](1000) NULL,
	[DDD5] [varchar](1000) NULL,
	[TELEFONE5] [varchar](1000) NULL,
	[STATUS5] [varchar](1000) NULL,
	[PREFERENCIAL5] [varchar](1000) NULL,
	[DATA_ATUALIZACAO5] [varchar](1000) NULL,
	[QUALIFICACAO5] [varchar](1000) NULL,
	[ORIGEM5] [varchar](1000) NULL,
	[TIPO5] [varchar](1000) NULL,
	[DDD6] [varchar](1000) NULL,
	[TELEFONE6] [varchar](1000) NULL,
	[STATUS6] [varchar](1000) NULL,
	[PREFERENCIAL6] [varchar](1000) NULL,
	[DATA_ATUALIZACAO6] [varchar](1000) NULL,
	[QUALIFICACAO6] [varchar](1000) NULL,
	[ORIGEM6] [varchar](1000) NULL,
	[TIPO6] [varchar](1000) NULL,
	[DDD7] [varchar](1000) NULL,
	[TELEFONE7] [varchar](1000) NULL,
	[STATUS7] [varchar](1000) NULL,
	[PREFERENCIAL7] [varchar](1000) NULL,
	[DATA_ATUALIZACAO7] [varchar](1000) NULL,
	[QUALIFICACAO7] [varchar](1000) NULL,
	[ORIGEM7] [varchar](1000) NULL,
	[TIPO7] [varchar](1000) NULL,
	[DDD8] [varchar](1000) NULL,
	[TELEFONE8] [varchar](1000) NULL,
	[STATUS8] [varchar](1000) NULL,
	[PREFERENCIAL8] [varchar](1000) NULL,
	[DATA_ATUALIZACAO8] [varchar](1000) NULL,
	[QUALIFICACAO8] [varchar](1000) NULL,
	[ORIGEM8] [varchar](1000) NULL,
	[TIPO8] [varchar](1000) NULL,
	[DDD9] [varchar](1000) NULL,
	[TELEFONE9] [varchar](1000) NULL,
	[STATUS9][varchar](1000) NULL,
	[PREFERENCIAL9][varchar](1000) NULL,
	[DATA_ATUALIZACAO9] [varchar](1000) NULL,
	[QUALIFICACAO9]		[varchar](1000) NULL,
	[ORIGEM9] [varchar](1000) NULL,
	[TIPO9] [varchar](1000) NULL,
	[DDD10] [varchar](1000) NULL,
	[TELEFONE10][varchar](1000) NULL,
	[STATUS10] [varchar](1000) NULL,
	[PREFERENCIAL10] [varchar](1000) NULL,
	[DATA_ATUALIZACAO10] [varchar](1000) NULL,
	[QUALIFICACAO10] [varchar](1000) NULL,
	[ORIGEM10] [varchar](1000) NULL,
	[TIPO10] [varchar](1000) NULL,
	[DDD11] [varchar](1000) NULL,
	[TELEFONE11] [varchar](1000) NULL,
	[STATUS11][varchar](1000) NULL,
	[PREFERENCIAL11] [varchar](1000) NULL,
	[DATA_ATUALIZACAO11] [varchar](1000) NULL,
	[QUALIFICACAO11] [varchar](1000) NULL,
	[ORIGEM11] [varchar](1000) NULL,
	[TIPO11]   [varchar](1000) NULL,
	[DDD12]    [varchar](1000) NULL,
	[TELEFONE12] [varchar](1000) NULL,
	[STATUS12]   [varchar](1000) NULL,
	[PREFERENCIAL12]	 [varchar](1000) NULL,
	[DATA_ATUALIZACAO12] [varchar](1000) NULL,
	[QUALIFICACAO12]	 [varchar](1000) NULL,
	[ORIGEM12] [varchar](1000) NULL,
	[TIPO12]   [varchar](1000) NULL,
	[DDD13]    [varchar](1000) NULL,
	[TELEFONE13] [varchar](1000) NULL,
	[STATUS13]	 [varchar](1000) NULL,
	[PREFERENCIAL13] [varchar](1000) NULL,
	[DATA_ATUALIZACAO13] [varchar](1000) NULL,
	[QUALIFICACAO13] [varchar](1000) NULL,
	[ORIGEM13] [varchar](1000) NULL,
	[TIPO13] [varchar](1000) NULL,
	[DDD14]  [varchar](1000) NULL,
	[TELEFONE14] [varchar](1000) NULL,
	[STATUS14] [varchar](1000) NULL,
	[PREFERENCIAL14] [varchar](1000) NULL,
	[DATA_ATUALIZACAO14] [varchar](1000) NULL,
	[QUALIFICACAO14] [varchar](1000) NULL,
	[ORIGEM14]	 [varchar](1000) NULL,
	[TIPO14]	 [varchar](1000) NULL,
	[DDD15]		 [varchar](1000) NULL,
	[TELEFONE15] [varchar](1000) NULL,
	[STATUS15] [varchar](1000) NULL,
	[PREFERENCIAL15] [varchar](1000) NULL,
	[DATA_ATUALIZACAO15] [varchar](1000) NULL,
	[QUALIFICACAO15] [varchar](1000) NULL,
	[ORIGEM15][varchar](1000) NULL,
	[TIPO15] [varchar](1000) NULL,
	[DDD16] [varchar](1000) NULL,
	[TELEFONE16] [varchar](1000) NULL,
	[STATUS16] [varchar](1000) NULL,
	[PREFERENCIAL16] [varchar](1000) NULL,
	[DATA_ATUALIZACAO16] [varchar](1000) NULL,
	[QUALIFICACAO16] [varchar](1000) NULL,
	[ORIGEM16] [varchar](1000) NULL,
	[TIPO16] [varchar](1000) NULL,
	[DDD17] [varchar](1000) NULL,
	[TELEFONE17] [varchar](1000) NULL,
	[STATUS17] [varchar](1000) NULL,
	[PREFERENCIAL17] [varchar](1000) NULL,
	[DATA_ATUALIZACAO17] [varchar](1000) NULL,
	[QUALIFICACAO17] [varchar](1000) NULL,
	[ORIGEM17] [varchar](1000) NULL,
	[TIPO17] [varchar](1000) NULL,
	[DDD18] [varchar](1000) NULL,
	[TELEFONE18] [varchar](1000) NULL,
	[STATUS18] [varchar](1000) NULL,
	[PREFERENCIAL18] [varchar](1000) NULL,
	[DATA_ATUALIZACAO18] [varchar](1000) NULL,
	[QUALIFICACAO18] [varchar](1000) NULL,
	[ORIGEM18] [varchar](1000) NULL,
	[TIPO18][varchar](1000) NULL,
	[DDD19] [varchar](1000) NULL,
	[TELEFONE19] [varchar](1000) NULL,
	[STATUS19] [varchar](1000) NULL,
	[PREFERENCIAL19] [varchar](1000) NULL,
	[DATA_ATUALIZACAO19] [varchar](1000) NULL,
	[QUALIFICACAO19] [varchar](1000) NULL,
	[ORIGEM19] [varchar](1000) NULL,
	[TIPO19] [varchar](1000) NULL,
	[DDD20]  [varchar](1000) NULL,
	[TELEFONE20] [varchar](1000) NULL,
	[STATUS20] [varchar](1000) NULL,
	[PREFERENCIAL20] [varchar](1000) NULL,
	[DATA_ATUALIZACAO20] [varchar](1000) NULL,
	[QUALIFICACAO20] [varchar](1000) NULL,
	[ORIGEM20] [varchar](1000) NULL,
	[TIPO20] [varchar](1000) NULL,
	[COD_BARRAS] [varchar](1000) NOT NULL,
	[DETALHAMENTO_FATURAS] [varchar](1000) NULL,
	[PERCENT_DESCONTO] [varchar](1000) NULL,
	[QNTD_PARCELAS] [varchar](1000) NULL,
	[DETALHAMENTO_DESCONTO] [varchar](1000) NULL,
	[DETALHAMENTO_PARCELAS] [varchar](1000) NULL,
	[CORINGA1] [varchar](1000) NULL,
	[CORINGA2] [varchar](1000) NULL,
	[CORINGA3] [varchar](1000) NULL,
	[CORINGA4] [varchar](1000) NULL,
	[CORINGA5] [varchar](1000) NULL,
	[CORINGA6] [varchar](1000) NULL,
	[CORINGA7] [varchar](1000) NULL,
	[CORINGA8] [varchar](1000) NULL,
	[CORINGA9] [varchar](1000) NULL,
	[CORINGA10][varchar](1000) NULL)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: CRIA TABELA NA ESTRUTURA NO DO MAILING LAYOUT UNICO								*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DECLARE @vDATA	  DATETIME		=  GETDATE()
,		@vEMPRESA VARCHAR(50)	= 'RIACHUELO PRODUTOS FINANCEIROS'
,		@vCARTEIRA VARCHAR(50)	= 'CANAIS-HELP SEGUROS'

--TRUNCATE TABLE #LAYOUT_UNICO
--INSERT   INTO  #LAYOUT_UNICO 
SELECT 
 [DATA_DE_IMPORTACAO_MAILLING]	= CONVERT(DATE,@vDATA) --OK
,[HORA_DA_INCLUSAO_MAILING]		= RIGHT(CONVERT(VARCHAR(26), @vDATA, 121), 12) --OK
,[IDSRV]						= ''
,[IDEMP]						= ''
,[EMPRESA]						= @vEMPRESA --OK
,[IDCAR]						= @vCARTEIRA --OK 
,[CARTEIRA]						= ''
,[IDDEV]						= ''
,[NOME_CLIENTE]					= UPPER(NOMCLI) -- OK
,[CPF]							= CPF --OK
,[ID_CONTRATO]					= codcli --OK
,[CONTRATO]						= CodCorporativo --OK
,[DIAS_ATRASO]					= flg_order --OK
,[SEGMENTACAO]					= ''
,[SITUACAO]						= ''
,[DATA_DE_INCLUSAO]				= ''
,[DATA_DE_DEVOLUCAO]			= ''
,[ENQUADRAMENTO]				= ''
,[CLASSE]						= ''
,[MERCADORIA]					= PRODUTO --OK
,[VALOR_PRINCIPAL]				= Valor --OK
,[VALOR_ATUALIZADO]				= Valor --OK
,[REFERENCIA]					= ''
,[BANDEIRA]						= ''
,[LOJA_AGENCIA]					= ''
,[PROFISSAO]					= ''
,[TIPO_DE_PESSOA]				= ''
,[SCORE]						= ''
,[PONTUACAO_SCORE]				= ''
,[SCORE_CREDOR]					= ''
,[COMPORTAMENTO]				= ''
,[PROBABILIDADE]				= ''
,[DDD1]							= NumDDD
,[TELEFONE1]					= NumDDD + NumTel
,[STATUS1]						= ''
,[PREFERENCIAL1]				= ''
,[DATA_ATUALIZACAO1]			= ''
,[QUALIFICACAO1]				= ''
,[ORIGEM1]						= ''
,[TIPO1]						= IIF(LEFT(NUMTEL,1) = '9', 'MOVEL', 'FIXO')
,[DDD2]							= ''
,[TELEFONE2]					= ''
,[STATUS2]						= ''
,[PREFERENCIAL2]				= ''
,[DATA_ATUALIZACAO2]			= ''
,[QUALIFICACAO2]				= ''
,[ORIGEM2]						= ''
,[TIPO2]						= ''
,[DDD3]							= ''
,[TELEFONE3]					= ''
,[STATUS3]						= ''
,[PREFERENCIAL3]				= ''
,[DATA_ATUALIZACAO3]			= ''
,[QUALIFICACAO3]				= ''
,[ORIGEM3]						= ''
,[TIPO3]						= ''
,[DDD4]							= ''
,[TELEFONE4]					= ''
,[STATUS4]						= ''
,[PREFERENCIAL4]				= ''
,[DATA_ATUALIZACAO4]			= ''
,[QUALIFICACAO4]				= ''
,[ORIGEM4]						= ''
,[TIPO4]						= ''
,[DDD5]							= ''
,[TELEFONE5]					= ''
,[STATUS5]						= ''
,[PREFERENCIAL5]				= ''
,[DATA_ATUALIZACAO5]			= ''
,[QUALIFICACAO5]				= ''
,[ORIGEM5]						= ''
,[TIPO5]						= ''
,[DDD6]							= ''
,[TELEFONE6]					= ''
,[STATUS6]						= ''
,[PREFERENCIAL6]				= ''
,[DATA_ATUALIZACAO6]			= ''
,[QUALIFICACAO6]				= ''
,[ORIGEM6]						= ''
,[TIPO6]						= ''
,[DDD7]							= ''
,[TELEFONE7]					= ''
,[STATUS7]						= ''
,[PREFERENCIAL7]				= ''
,[DATA_ATUALIZACAO7]			= ''
,[QUALIFICACAO7]				= ''
,[ORIGEM7]						= ''
,[TIPO7]						= ''
,[DDD8]							= ''
,[TELEFONE8]					= ''
,[STATUS8]						= ''
,[PREFERENCIAL8]				= ''
,[DATA_ATUALIZACAO8]			= ''
,[QUALIFICACAO8]				= ''
,[ORIGEM8]						= ''
,[TIPO8]						= ''
,[DDD9]							= ''
,[TELEFONE9]					= ''
,[STATUS9]						= ''
,[PREFERENCIAL9]				= ''
,[DATA_ATUALIZACAO9]			= ''
,[QUALIFICACAO9]				= ''
,[ORIGEM9]						= ''
,[TIPO9]						= ''
,[DDD10]						= ''
,[TELEFONE10]					= ''
,[STATUS10]						= ''
,[PREFERENCIAL10]				= ''
,[DATA_ATUALIZACAO10]			= ''
,[QUALIFICACAO10]				= ''
,[ORIGEM10]						= ''
,[TIPO10]						= ''
,[DDD11]						= ''
,[TELEFONE11]					= ''
,[STATUS11]						= ''
,[PREFERENCIAL11]				= ''
,[DATA_ATUALIZACAO11]			= ''
,[QUALIFICACAO11]				= ''
,[ORIGEM11]						= ''
,[TIPO11]						= ''
,[DDD12]						= ''
,[TELEFONE12]					= ''
,[STATUS12]						= ''
,[PREFERENCIAL12]				= ''
,[DATA_ATUALIZACAO12]			= ''
,[QUALIFICACAO12]				= ''
,[ORIGEM12]						= ''
,[TIPO12]						= ''
,[DDD13]						= ''
,[TELEFONE13]					= ''
,[STATUS13]						= ''
,[PREFERENCIAL13]				= ''
,[DATA_ATUALIZACAO13]			= ''
,[QUALIFICACAO13]				= ''
,[ORIGEM13]						= ''
,[TIPO13]						= ''
,[DDD14]						= ''
,[TELEFONE14]					= ''
,[STATUS14]						= ''
,[PREFERENCIAL14]				= ''
,[DATA_ATUALIZACAO14]			= ''
,[QUALIFICACAO14]				= ''
,[ORIGEM14]						= ''
,[TIPO14]						= ''
,[DDD15]						= ''
,[TELEFONE15]					= ''
,[STATUS15]						= ''
,[PREFERENCIAL15]				= ''
,[DATA_ATUALIZACAO15]			= ''
,[QUALIFICACAO15]				= ''
,[ORIGEM15]						= ''
,[TIPO15]						= ''
,[DDD16]						= ''
,[TELEFONE16]					= ''
,[STATUS16]						= ''
,[PREFERENCIAL16]				= ''
,[DATA_ATUALIZACAO16]			= ''
,[QUALIFICACAO16]				= ''
,[ORIGEM16]						= ''
,[TIPO16]						= ''
,[DDD17]						= ''
,[TELEFONE17]					= ''
,[STATUS17]						= ''
,[PREFERENCIAL17]				= ''
,[DATA_ATUALIZACAO17]			= ''
,[QUALIFICACAO17]				= ''
,[ORIGEM17]						= ''
,[TIPO17]						= ''
,[DDD18]						= ''
,[TELEFONE18]					= ''
,[STATUS18]						= ''
,[PREFERENCIAL18]				= ''
,[DATA_ATUALIZACAO18]			= ''
,[QUALIFICACAO18]				= ''
,[ORIGEM18]						= ''
,[TIPO18]						= ''
,[DDD19]						= ''
,[TELEFONE19]					= ''
,[STATUS19]						= ''
,[PREFERENCIAL19]				= ''
,[DATA_ATUALIZACAO19]			= ''
,[QUALIFICACAO19]				= ''
,[ORIGEM19]						= ''
,[TIPO19]						= ''
,[DDD20]						= ''
,[TELEFONE20]					= ''
,[STATUS20]						= ''
,[PREFERENCIAL20]				= ''
,[DATA_ATUALIZACAO20]			= ''
,[QUALIFICACAO20]				= ''
,[ORIGEM20]						= ''
,[TIPO20]						= ''
,[COD_BARRAS]					= NovaColuna
,[DETALHAMENTO_FATURAS]			= ''
,[PERCENT_DESCONTO]				= ''
,[QNTD_PARCELAS]				= ''
,[DETALHAMENTO_DESCONTO]		= ''
,[DETALHAMENTO_PARCELAS]		= ''
,[CORINGA1]						= ''
,[CORINGA2]						= ''
,[CORINGA3]						= ''
,[CORINGA4]						= ''
,[CORINGA5]						= ''
,[CORINGA6]						= ''
,[CORINGA7]						= ''
,[CORINGA8]						= ''
,[CORINGA9]						= ''
,[CORINGA10]					= ''
--INTO TB_LAYOUT_UNICO_AD_SEGURO
FROM #BASE_FINAL
WHERE(
		 NumTel IS NOT NULL 
	  OR NumTel != '0'
	  OR NumTel != ''
	 )

PLANNING.DBO.TB_LAYOUT_UNICO_AD_SEGURO