

SELECT A.*
FROM
OPENQUERY(
[10.251.2.18],
'Select
a.uniqueid
,date_format(a.calldate,"%Y-%m-%d") as Data
,time_format(a.calldate,"%H:%i:%s") as Hora
,a.origem
,a.destino
,a.tipo
,a.idcrm
,a.statusnegocio
,b.nome as Nome_Fila
,a.agente
,a.calldate
,a.duracao
,a.conversado
,a.statusatendimento
,a.ddd
,a.classe_order
,a.status
,a.billsec
,a.bilhetado
,a.aftercall_tempo
,a.temponafila
,a.fila
,a.valor
,a.desligadopor
,a.doc
,a.mailing
,a.abandonado
,a.redirecionado
,a.isdncause
,a.terminator
from replica_atmspbb1.chamadas a
inner join replica_atmspbb1.queues b on a.fila = b.fila
where a.calldate between ''2022-04-01 00:00:00'' and ''2022-04-12 23:59:59'' ')A