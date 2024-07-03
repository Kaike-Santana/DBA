
select *
into #temp
from (
SELECT *
,	rw = ROW_NUMBER() over( partition by codigo, descricao order by codigo desc)
FROM [THESYS_DEV].[dbo].[Acumulador_Fiscal]
) sb
where rw = 1


INSERT INTO THESYS_PRODUCAO..[Acumulador_Fiscal]
           ([codigo]
           ,[descricao]
           ,[ativo]
           ,[obs]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user])
select 
			[codigo]
           ,[descricao]
           ,[ativo]
           ,[obs]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
from #temp