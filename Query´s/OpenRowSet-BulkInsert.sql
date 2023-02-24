



CREATE PROCEDURE PRC_DS_RETORNO_BKO_PICPAY_POSTGRESQL AS
BEGIN;

DROP TABLE IF EXISTS #base
SELECT *
INTO #base
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
'Excel 12.0 Xml;HDR=YES;Database=\\polaris\NectarServices\Administrativo\ETL PostGreSQL\Banco PicPay\tb_atendimento.xlsx',
'SELECT * FROM [Planilha1$]');

END;

