
--tempo 03:20

select distinct 
Data
,Nome_Fila
,left(hora,2) as intervalo
,sum(iif(statusatendimento='ANSWER' and tipo = 'entrante' and temponafila<30,1,0)) as Atendidas_SLA
,sum(iif(statusatendimento='ANSWER' and tipo = 'entrante',1,0)) as Atendidas
,sum(iif(statusatendimento='ABANDON'and tipo = 'entrante' and temponafila<5,1,0)) as ShortCall
,sum(iif(statusatendimento='ABANDON'and tipo = 'entrante',1,0)) as Abandono
,sum(iif(statusatendimento='ANSWER' and tipo = 'entrante',duracao,0)) as Total_Time_Call
,sum(iif(statusatendimento='ANSWER' and tipo = 'entrante',conversado,0)) as AHT
,sum(iif(tipo = 'entrante',temponafila,0))as Total_Time_Speedy_Answered
,sum(iif(statusatendimento='ABANDON' and tipo = 'entrante',duracao,0)) as Avarege_Abandon_Time
,count(distinct agente)-1 as HC
,sum(iif(statusatendimento='ANSWER' and tipo = 'sainte',1,0)) as Outbound
,sum(iif(statusatendimento='ANSWER' and tipo = 'sainte',conversado,0)) as OAHT

from tb_ds_callflex_mes with (nolock)
where Nome_Fila like '%Metal%' and Data between '2022-08-01' and '2022-08-31'

group by data, left(hora,2),Nome_Fila
order by intervalo asc