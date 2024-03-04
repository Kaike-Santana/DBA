
-- Programador: Kaike Natan
-- Data: 26-07-2023
-- Descriçâo: Transforma as Propostas E Seu Valores Em Colunas Em Vez De Linhas.

drop table if exists #MalaDireta
select * 
into #MalaDireta
from openquery([10.251.1.36],'
select distinct 
     cgcpf_dev
,    nome_dev
,    idcon_con
,    contr_con
,    nosso_pro
,    linha_pro
,    dtcad_pro
,    vlcor_pro
,    idpar_pde
,    vlent_pde
,    idpes_pro
,    nome_pes
from       nectar.dbo.tb_propost      with( nolock )
inner join nectar.dbo.tb_propdet      with( nolock ) on idpro_pro = idpro_pde
inner join nectar.dbo.tb_contrato     with( nolock ) on idcon_pro = idcon_con
inner join nectar.dbo.tb_devedor      with( nolock ) on iddev_dev = iddev_con
left  join nectar.dbo.tb_pessoal		with( nolock ) on idpes_pro = idpes_pes
where idplo_pro in (''5634'',''5636'')
and idemp_con = 17
and cgcpf_dev = ''00151745064''
')

drop table if exists #pvt
select *
, rw = row_number() over ( partition by cgcpf_dev order by cgcpf_dev)
into #pvt
from #maladireta


declare @vpropostas nvarchar(max) = stuff((select distinct ', ' + quotename(idpar_pde) from #pvt for xml path('')), 1, 2, ''); -- adiciona colchetes e remove a primeira vírgula
declare @vcols nvarchar(max) = @vpropostas; -- mantém @vcols igual a @vpropostas
declare @dynamicpivotquery nvarchar(max);

set @dynamicpivotquery = N'
SELECT 
     cgcpf_dev,
     nome_dev,
     idcon_con,
     contr_con,
     nosso_pro,
     linha_pro,
     dtcad_pro,
     vlcor_pro,
     idpes_pro,
     nome_pes,
	 ' + @vCols + N' -- Inclui as colunas dinâmicas
FROM
(
    SELECT 
        cgcpf_dev,
        nome_dev,
        idcon_con,
        contr_con,
        nosso_pro,
        linha_pro,
        dtcad_pro,
        vlcor_pro,
        idpes_pro,
        vlent_pde, 
        nome_pes,
        idpar_pde -- Inclui a coluna idpar_pde na subconsulta
    FROM #pvt
) AS dColuna
PIVOT
(
    MAX(vlent_pde) -- Realiza a agregação dos valores de vlent_pde
    FOR idpar_pde IN (' + @vCols + N') -- Lista de colunas para o PIVOT
) AS dPivot;';


EXEC sp_executesql @DynamicPivotQuery;