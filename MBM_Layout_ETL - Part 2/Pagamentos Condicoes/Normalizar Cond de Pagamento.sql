
USE THESYS_HOMOLOGACAO
GO

SELECT 
	id_pagamento_condicao
,	cod_condpagamento
,	descricao
,	parcelas
,	ativo
,	prazo_dias_primeira_parcela
,	intervalo_dias_demais_parcelas
,	RW = ROW_NUMBER () OVER ( PARTITION BY PARCELAS, prazo_dias_primeira_parcela, intervalo_dias_demais_parcelas ORDER BY INCL_DATA DESC)
FROM Pagamentos_Condicoes
WHERE (
			parcelas IS NOT NULL
		OR  prazo_dias_primeira_parcela IS NOT NULL
		OR  intervalo_dias_demais_parcelas IS NOT NULL
	  )