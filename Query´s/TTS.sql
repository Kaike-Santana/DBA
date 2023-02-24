




SELECT A.* 
into #TESTE
FROM OPENQUERY([10.251.2.18],
'Select 
         a.uniqueid
        ,date_format(a.calldate,"%Y-%m-%d") as Data
        ,time_format(a.calldate,"%H:%i:%s") as Hora
        ,a.origem
        ,a.destino
        ,a.tipo
        ,a.idcrm
        ,a.statusnegocio
        ,b.name as Nome_Fila
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
		,a.did_clid
    from replica_atmspbt1.chamadas a
    inner join replica_atmspbt1.tts_queues b on a.fila = b.queue
    where convert(a.calldate, date) = subdate(curdate(),2) ') A