

SELECT *
FROM Natureza_Operacao_Tipos
WHERE descricao_tiponatureza = 'SERVIÇOS'


SELECT *
FROM TRIBUTACAO 
WHERE cod_tributacao = 'TB99'

SELECT *
FROM Natureza_Operacao
WHERE id_tiponatureza = 27 --> SERVIÇO


UPDATE Natureza_Operacao
SET id_tributacao  = 102
,	cod_tributacao = 'TB99'
WHERE id_tiponatureza = 27