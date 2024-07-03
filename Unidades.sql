 
 use THESYS_DEV
 go
  		 
-- Unidades	 

drop table if exists #teste
select *
into #teste
from (
		select *
		,	rw = row_number() over ( partition by codigo, descricao order by codigo desc)
		from Unidades
	 )SubQuery
where rw = 1


select *
from #teste
order by descricao desc

insert into THESYS_HOMOLOGACAO..Unidades
SELECT 
       [codigo]
      ,[descricao]
      ,[incl_data]
      ,[incl_user]
      ,[incl_device]
      ,[modi_data]
      ,[modi_user]
      ,[modi_device]
      ,[excl_data]
      ,[excl_user]
      ,[excl_device]
      ,[cod_un_export]
      ,[casas_dec]
  FROM #teste