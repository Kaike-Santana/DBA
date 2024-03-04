

drop table if exists #base
select distinct
	Idcon_con
,	Contr_Con
,	DtAtr_Con			=  Convert(Date,DtAtr_Con)
,	CgCpf_Dev
,	DividaTotal			=  Vlsal_Con
,	SaldoTitulosAtraso	=  Sum(Vlfat_Tra)
--,	DtFatTitulo			=  Dtfat_Tra
--,	AtrasoTitulo		=  Datediff(Day,Dtfat_Tra,GetDate())
into #base
from (
		select * 
		from openquery([10.251.1.64],'
		 select 
		  idcon_con	 =	convert(varchar(10),idcon_con)
		, contr_con
		, dtatr_con	
		, cgcpf_dev
		, vlsal_con
		, vlfat_tra
		, dtfat_tra
		from nectar.dbo.tb_contrato	with( nolock ) 
		join nectar.dbo.tb_devedor	with( nolock ) on iddev_dev = iddev_con
		left join  (
						select distinct
						idcon_tra
					   ,iddoc_tra
					   ,vlfat_tra
					   ,dtfat_tra
						from	   nectar.dbo.tb_transacao with( nolock )
						inner join nectar.dbo.tb_contrato  with( nolock ) on idcon_tra = idcon_con and idemp_con = 16
						where agenc_tra != ''0''
		
						union all
		
						select distinct
						idcon_bai
					   ,iddoc_bai
					   ,vlfat_bai
					   ,dtfat_bai
						from	   nectar.dbo.tb_baixa	   with( nolock )
						inner join nectar.dbo.tb_contrato  with( nolock ) on idcon_bai = idcon_con and idemp_con = 16
						where agenc_bai != ''0''
					) t on t.idcon_tra = idcon_con
		left join nectar.dbo.tb_documento	with(nolock) on iddoc_doc = iddoc_tra  
		where idemp_con = 16
		')
	 )SubQuery
Where Datediff(Day,Dtfat_Tra,GetDate()) > 0 
Group By 
	Idcon_con
,	Contr_Con
,	Convert(Date,DtAtr_Con)
,	CgCpf_Dev
,	Vlsal_Con
--,	Dtfat_Tra
--,	Datediff(Day,Dtfat_Tra,GetDate())