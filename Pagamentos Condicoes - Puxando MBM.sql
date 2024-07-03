
drop table if exists #consolidado 
select *
into #consolidado
from openquery([mbm_poliresinas],'
select *
from cond_pagamento
')

union all

select *
from openquery([mbm_polirex],'
select *
from cond_pagamento
')

union all

select *
from openquery([mbm_rubberon],'
select *
from cond_pagamento
')

union all

select *
from openquery([mbm_nortebag],'
select *
from cond_pagamento
')

union all

select *
from openquery([mbm_mg_polimeros],'
select *
from cond_pagamento
')

select *
from #consolidado
where cod_condpagamento = 'PG01'

-- Step 1: Calcular a frequência de cada descrição dentro de cada cod_condpagamento
WITH FrequencyCTE AS (
    SELECT 
        cod_condpagamento,
        descricao,
        COUNT(*) AS freq
    FROM 
        #consolidado
    GROUP BY 
        cod_condpagamento, descricao
),

-- Step 2: Usar ROW_NUMBER para priorizar a descrição mais frequente
RankedCTE AS (
    SELECT 
        c.*,
        ROW_NUMBER() OVER (
            PARTITION BY c.cod_condpagamento 
            ORDER BY f.freq DESC, LEN(c.descricao) DESC, c.descricao DESC
        ) AS rw
    FROM 
        #consolidado c
    JOIN 
        FrequencyCTE f ON c.cod_condpagamento = f.cod_condpagamento AND c.descricao = f.descricao
)

-- Step 3: Selecionar as linhas prioritárias para não serem deletadas
, PriorityCTE AS (
    SELECT *
    FROM RankedCTE
    WHERE rw = 1
)

UPDATE pc
SET pc.calculo_vencto = pcte.utiliza_parcela
FROM pagamentos_condicoes pc
JOIN PriorityCTE pcte ON pc.cod_condpagamento = pcte.cod_condpagamento collate sql_latin1_general_cp1_ci_ai

update pagamentos_condicoes
set calculo_vencto =  case 
						  when calculo_vencto = 'P' then 'X'
						  when calculo_vencto = 'N' then 'P'
						  else 'S'
					  end

select *
from pagamentos_condicoes
where cod_condpagamento = 'PG01'


p = percentual, vira x no thesys

n = n de parcelas, vira p no thesys

s = nenhum


INSERT INTO [dbo].[Pagamentos_Condicoes]
           ([cod_condpagamento]
           ,[descricao]
           ,[parcelas]
           ,[ativo]
           ,[vencto_sabado]
           ,[vencto_domingo]
           ,[vencto_feriado]
           ,[vencto_segunda]
           ,[vencto_terca]
           ,[vencto_quarta]
           ,[vencto_quinta]
           ,[vencto_sexta]
           ,[tipo_data]
           ,[bloquear_pedidovenda]
           ,[antecipar_pagamento]
           ,[valor_antecipacao]
           ,[tipo_vencto]
           ,[considerar_venctofixo]
           ,[dia_venctofixo]
           ,[prorrogaantecipa_venctofixo]
           ,[calculo_vencto]
           ,[prazo_dias_primeira_parcela]
           ,[intervalo_dias_demais_parcelas]
           ,[FormaPgtoID]
           ,[FormaPgtoCodigo]
           ,[auxiliar_string1]
           ,[auxiliar_string2]
           ,[vendas]
           ,[compras]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device]
           ,[id_forma_pgto_nfe])