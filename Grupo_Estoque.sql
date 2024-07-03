 
 use THESYS_DEV
 go

--Grupos_Estoque	 
	

drop table if exists #teste
select *
into #teste
from (
		select *
		,	rw = row_number() over ( partition by [dbo].[RemoveAccents](descricao) order by id_grupo_estoque desc)
		from Grupos_Estoque
	 )SubQuery
where rw = 1

update #teste
set descricao = 'MATERIA PRIMA'

where id_grupo_estoque = 21

select *
from #teste
order by descricao Desc

INSERT INTO THESYS_PRODUCAO..[Grupos_Estoque]
           ([codigo]
           ,[descricao]
           ,[item_venda]
           ,[item_producao]
           ,[item_compraprodutivo]
           ,[item_compranaoprodutivo]
           ,[id_tipo_produto]
           ,[codigo_no_dominio]
           ,[descricao_dominio]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device])
select
			[codigo]
           ,[descricao]
           ,[item_venda]
           ,[item_producao]
           ,[item_compraprodutivo]
           ,[item_compranaoprodutivo]
           ,[id_tipo_produto]
           ,[codigo_no_dominio]
           ,[descricao_dominio]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device]
from #teste
where id_grupo_estoque != 21