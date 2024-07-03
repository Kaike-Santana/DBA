 
 use THESYS_DEV
 go
 
--Familia_Comercial	 
	

drop table if exists #teste
select *
into #teste
from (
		select *
		,	rw = row_number() over ( partition by descricao order by descricao desc)
		from Familia_Comercial
	 )SubQuery
where rw = 1

--> Sempre Rodar Com Order By Pois Pode Ter Nomes Parecidos Que o RowNumber N Pega
select *
from #teste
order by descricao desc


insert into THESYS_HOMOLOGACAO..Familia_Comercial
SELECT 
       [descricao]
      ,[incl_data]
      ,[incl_user]
      ,[incl_device]
      ,[modi_data]
      ,[modi_user]
      ,[modi_device]
      ,[excl_data]
      ,[excl_user]
      ,[excl_device]
  FROM #teste
  where descricao != 'MATERIA PRIMA'
