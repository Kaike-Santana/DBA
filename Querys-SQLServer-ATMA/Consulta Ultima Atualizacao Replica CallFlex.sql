

-- Programador: Kaike Natan
-- Data: 18/07/2023
-- Descricao: Consultar A Ultima Atualizacao Na Nossa Réplica por Parte da CallFlex

drop table if exists #UltimaAtualizacao
create table #UltimaAtualizacao (
	Atualizacao varchar(100) not null
,	Referencia_Painel char(8) not null
)
go

insert into #UltimaAtualizacao
select *
from openquery([10.251.2.18],'
select max(calldate) as Ultima_Atualizacao,  ''Painel_1''
from replica_atmspbb1.chamadas

union all

select max(calldate) as Ultima_Atualizacao, ''Painel_2''
from replica_atmsp2b1.chamadas

union all

select max(calldate) as Ultima_Atualizacao, ''Painel_3''
from replica_atmsp3b1.chamadas

union all

select max(calldate) as Ultima_Atualizacao, ''Painel_4''
from replica_atmsp4b1.chamadas
')
go

select *
from #UltimaAtualizacao