


select distinct 
	cgcpf_dev
,	nome_dev
,	idcon_con
,	contr_con
,	linha_pro
,	dtcad_pro
,	vlcor_pro
,	idpes_pro
,	nome_pes
from tb_propost		 with( nolock )
join tb_contrato	 with( nolock ) on idcon_pro = idcon_con
join tb_devedor		 with( nolock ) on iddev_dev = iddev_con
left join tb_pessoal with( nolock ) on idpes_pro = idpes_pes
where cgcpf_dev = '00005656281'
and convert(date,dtcad_pro) = convert(date,getdate())
and idemp_con = 17