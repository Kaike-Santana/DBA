
ALTER FUNCTION [dbo].[fnCalcularCustoUnitario]
(
    @id_nota_fiscal_item INT
)
RETURNS TABLE
AS
RETURN
(
SELECT tnf.Custo_Unitario as CustoUnitario
     , tnf.TOTAL_IMPOSTOS as CustoTotal
FROM Notas_Fiscais_Itens nfi
    CROSS APPLY (
   SELECT
 (case when (ISNULL(icms_valor, 0)     + ISNULL(pis_valor, 0)   + ISNULL(cofins_valor, 0) + ISNULL(ipi_valor, 0)) >0 
  then (Isnull(valor_produtos,0) + ISNULL(valor_frete, 0) + ISNULL(valor_seguro, 0) + ISNULL(valor_outras_despesas, 0) + ISNULL(ipi_valor, 0)) - ISNULL(valor_desconto, 0) - 
       (ISNULL(icms_valor, 0)    + ISNULL(pis_valor, 0)   + ISNULL(cofins_valor, 0) + ISNULL(ipi_valor, 0)) 
  else 0 
   end) as TOTAL_IMPOSTOS
--Cálculo: TOTAL DOS IMPOSTOS / soma dos total de todos os produtos * (total do produto corrente / quantidade do produto corrente)
,( ( (case when (ISNULL(icms_valor, 0)     + ISNULL(pis_valor, 0)   + ISNULL(cofins_valor, 0) + ISNULL(ipi_valor, 0)) >0 
     then  ((Isnull(valor_produtos,0) + ISNULL(valor_frete, 0) + ISNULL(valor_seguro, 0) + ISNULL(valor_outras_despesas, 0) + ISNULL(ipi_valor, 0)) - ISNULL(valor_desconto, 0)) - 
         (ISNULL(icms_valor, 0)    + ISNULL(pis_valor, 0)   + ISNULL(cofins_valor, 0) + ISNULL(ipi_valor, 0)) 
     else 0 
    end) / NULLIF((select sum(valor_produtos) from Notas_Fiscais_Itens where id_nota_fiscal = nfi.id_nota_fiscal), 0)  
    )    * (select (valor_produtos / NULLIF(quantidade, 0)) from Notas_Fiscais_Itens where id_nota_fiscal_item = nfi.id_nota_fiscal_item)   
 ) as Custo_Unitario  

   FROM Notas_Fiscais     
   WHERE id_nota_fiscal = nfi.id_nota_fiscal
    ) AS tnf
WHERE id_nota_fiscal_item = @id_nota_fiscal_item
);


Notas_Fiscais_Itens

select top 10 calculo_custo
from natureza_operacao

estoque_movimentos

SELECT 
	CustoUnitario
,	CustoTotal 
FROM dbo.fnCalcularCustoUnitario(23428)

select *
from Estoque_Movimentos
where id_nfi = 23428

6.622935
select 
	id_nota_fiscal
,	id_nota_fiscal_item
,	id_item
,	id_natureza_operacao
,	custo_unitario
from Notas_Fiscais_Itens 
where id_nota_fiscal = 104953

select *
from Notas_Fiscais 
where id_nota_fiscal = 104865

begin tran
UPDATE nfi
SELECT *
--SET nfi.Custo_Unitario = tnf.Custo_Unitario
FROM Notas_Fiscais_Itens nfi
    CROSS APPLY (
   SELECT
 (case when (ISNULL(icms_valor, 0)     + ISNULL(pis_valor, 0)   + ISNULL(cofins_valor, 0) + ISNULL(ipi_valor, 0)) >0 
  then (Isnull(valor_produtos,0) + ISNULL(valor_frete, 0) + ISNULL(valor_seguro, 0) + ISNULL(valor_outras_despesas, 0) + ISNULL(ipi_valor, 0)) - ISNULL(valor_desconto, 0) - 
       (ISNULL(icms_valor, 0)    + ISNULL(pis_valor, 0)   + ISNULL(cofins_valor, 0) + ISNULL(ipi_valor, 0)) 
  else 0 
   end) as TOTAL_IMPOSTOS
--Cálculo: TOTAL DOS IMPOSTOS / soma dos total de todos os produtos * (total do produto corrente / quantidade do produto corrente)
,( ( (case when (ISNULL(icms_valor, 0)     + ISNULL(pis_valor, 0)   + ISNULL(cofins_valor, 0) + ISNULL(ipi_valor, 0)) >0 
     then  ((Isnull(valor_produtos,0) + ISNULL(valor_frete, 0) + ISNULL(valor_seguro, 0) + ISNULL(valor_outras_despesas, 0) + ISNULL(ipi_valor, 0)) - ISNULL(valor_desconto, 0)) - 
         (ISNULL(icms_valor, 0)    + ISNULL(pis_valor, 0)   + ISNULL(cofins_valor, 0) + ISNULL(ipi_valor, 0)) 
     else 0 
    end) / (select sum(valor_produtos)           from Notas_Fiscais_Itens where id_nota_fiscal      = nfi.id_nota_fiscal)  
    )    * (select (valor_produtos / quantidade) from Notas_Fiscais_Itens where id_nota_fiscal_item = nfi.id_nota_fiscal_item)   
 ) as Custo_Unitario  

   FROM Notas_Fiscais     
   WHERE id_nota_fiscal = nfi.id_nota_fiscal
    ) AS tnf
    --WHERE id_nota_fiscal_item = 23428
where EXISTS (
    SELECT 1 
    FROM natureza_operacao no
    WHERE no.calculo_custo = 'S'
    AND no.id_NaturezaOperacao = nfi.id_natureza_operacao
)

commit


SELECT *
FROM Notas_Fiscais_Itens
WHERE id_nota_fiscal = 104953


UPDATE em
SET em.Custo_Unitario = nfi.Custo_Unitario
FROM Estoque_Movimentos em
INNER JOIN Notas_Fiscais Nf        ON Nf.id_nota_fiscal		 = em.id_nf
INNER JOIN Notas_Fiscais_Itens nfi ON em.id_nfi				 = nfi.id_nota_fiscal_item
INNER JOIN natureza_operacao no	   ON no.id_NaturezaOperacao = nfi.id_natureza_operacao
WHERE no.calculo_custo = 'S'
AND em.dt_transacao BETWEEN '2024-08-01' AND '2024-08-26'
and Nf.tipo_emissao = 'T'
and Nf.entrada_saida = 'E'


--> 1 Step

select 
	Notas_Fiscais_Itens.quantidade
,	Notas_Fiscais_Itens.valor_unitario
,	Notas_Fiscais_Itens.valor_produtos
,	Notas_Fiscais.tipo_emissao
,   Notas_Fiscais.entrada_saida
,	nro_nfiscal
,	dt
from Notas_Fiscais_Itens
join Notas_Fiscais On Notas_Fiscais.id_nota_fiscal = Notas_Fiscais_Itens.id_nota_fiscal
where Notas_Fiscais_Itens.valor_produtos <= 0
and   Notas_Fiscais.tipo_emissao = 'T'
and   Notas_Fiscais.entrada_saida = 'E'


begin tran
Update Notas_Fiscais_Itens
set valor_produtos = Cast((quantidade * valor_unitario) as Numeric(15,6))
from Notas_Fiscais_Itens
join Notas_Fiscais On Notas_Fiscais.id_nota_fiscal = Notas_Fiscais_Itens.id_nota_fiscal
where Notas_Fiscais_Itens.valor_produtos <= 0
and   Notas_Fiscais.tipo_emissao = 'T'
and   Notas_Fiscais.entrada_saida = 'E'

select  33.520000 * 10108.789976 

select  10108.789976 / 33.520000 

commit


BEGIN TRAN
UPDATE nfi
SET nfi.Custo_Unitario = tnf.Custo_Unitario
--select *
FROM Notas_Fiscais_Itens nfi
CROSS APPLY (
    SELECT
        CASE 
            WHEN (ISNULL(icms_valor, 0) + ISNULL(pis_valor, 0) + ISNULL(cofins_valor, 0) + ISNULL(ipi_valor, 0)) > 0 THEN 
                (ISNULL(valor_produtos, 0) + ISNULL(valor_frete, 0) + ISNULL(valor_seguro, 0) + ISNULL(valor_outras_despesas, 0) + ISNULL(ipi_valor, 0)) 
                - ISNULL(valor_desconto, 0) 
                - (ISNULL(icms_valor, 0) + ISNULL(pis_valor, 0) + ISNULL(cofins_valor, 0) + ISNULL(ipi_valor, 0))
            ELSE 0 
        END / NULLIF(quantidade, 0) AS TOTAL_IMPOSTOS,
        CASE 
            WHEN (ISNULL(icms_valor, 0) + ISNULL(pis_valor, 0) + ISNULL(cofins_valor, 0) + ISNULL(ipi_valor, 0)) > 0 THEN 
                (
                    ((ISNULL(valor_produtos, 0) + ISNULL(valor_frete, 0) + ISNULL(valor_seguro, 0) + ISNULL(valor_outras_despesas, 0) + ISNULL(ipi_valor, 0)) 
                    - ISNULL(valor_desconto, 0)) 
                    - (ISNULL(icms_valor, 0) + ISNULL(pis_valor, 0) + ISNULL(cofins_valor, 0) + ISNULL(ipi_valor, 0))
                ) / NULLIF((SELECT SUM(valor_produtos) FROM Notas_Fiscais_Itens WHERE id_nota_fiscal = nfi.id_nota_fiscal), 0)
            ELSE 0 
        END * (valor_produtos / NULLIF(quantidade, 0)) AS Custo_Unitario
    FROM Notas_Fiscais nf
    WHERE nf.id_nota_fiscal = nfi.id_nota_fiscal
	and nf.dt_recebimento between '2024-08-01' and '2024-08-26'
) AS tnf
--WHERE id_nota_fiscal_item = 23428
WHERE EXISTS (
    SELECT 1 
    FROM natureza_operacao no
    WHERE no.calculo_custo = 'S'
    AND no.id_NaturezaOperacao = nfi.id_natureza_operacao
);

commit