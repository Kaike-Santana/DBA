

CREATE OR ALTER PROCEDURE AtualizarPagamentosCondicoes
AS
BEGIN
    SET NOCOUNT ON;

    -- Atualizar a tabela Pagamentos_Condicoes
    UPDATE pc
    SET 
        pc.parcelas = sub.parcela_count,
        pc.prazo_dias_primeira_parcela = sub.min_prazo,
        pc.intervalo_dias_demais_parcelas = sub.intervalo_dias_demais
    FROM 
        Pagamentos_Condicoes pc
    JOIN 
        (
            SELECT 
                pcp.id_pagamento_condicao,
                COUNT(*) AS parcela_count,
                
                -- Definir prazo_dias_primeira_parcela como o menor prazo
                MIN(pcp.prazo) AS min_prazo,

                -- Calcular o intervalo_dias_demais_parcelas como a diferença entre o menor prazo e a segunda parcela
                CASE
                    WHEN COUNT(*) < 2 THEN 0  -- Se houver menos de 2 parcelas, definir como 0
                    ELSE COALESCE(
                        (SELECT prazo 
                         FROM Pagamentos_Condicoes_Parcelas pcp2
                         WHERE pcp2.id_pagamento_condicao = pcp.id_pagamento_condicao
                         ORDER BY prazo
                         OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY
                        ) - MIN(pcp.prazo),
                        0
                    )
                END AS intervalo_dias_demais
            FROM 
                Pagamentos_Condicoes_Parcelas pcp
            GROUP BY 
                pcp.id_pagamento_condicao
        ) AS sub
    ON 
        pc.id_pagamento_condicao = sub.id_pagamento_condicao
	where convert(date,pc.incl_data) = '2025-02-01' --> mudar para o dia do seu insert
END;
GO


--Exec AtualizarPagamentosCondicoes

Drop Procedure AtualizarPagamentosCondicoes