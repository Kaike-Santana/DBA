 
 Use THESYS_DEV
 Go
	 		 
--Class_Fiscal		 

drop table if exists #teste
select *
into #teste
from (
    select *,
           rw = row_number() over (partition by cod_classfiscal, descricao_simplificada 
                                   order by case when descricao_completa <> '' then 0 else 1 end,
                                            descricao_simplificada desc)
    from class_fiscal
) subquery
where rw = 1


insert into THESYS_HOMOLOGACAO..Class_Fiscal
SELECT 
       [cod_classfiscal]
      ,[ipi]
      ,[id_mensagem]
      ,[descricao_simplificada]
      ,[ativo]
      ,[incl_data]
      ,[incl_user]
      ,[incl_device]
      ,[modi_data]
      ,[modi_user]
      ,[modi_device]
      ,[excl_data]
      ,[excl_user]
      ,[excl_device]
      ,[descricao_completa]
      ,[neces_lic_imp_comp]
      ,[carga_perigosa]
      ,[id_classe_cargaperigosa_tab_padrao]
      ,[classe_cargaperigosa]
      ,[id_subclasse_cargaperigosa_tab_padrao]
      ,[subclasse_cargaperigosa]
  FROM #teste
  Order By [descricao_simplificada] Desc
