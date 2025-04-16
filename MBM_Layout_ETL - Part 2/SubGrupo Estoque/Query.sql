insert into Subgrupos_Estoque
(	[id_grupo_estoque]
   ,[codigo]
   ,[descricao]
   ,[ativo]
   ,[dt_bloqueio]		
   ,[motivo_bloqueio]	
   ,[seq_exibicao]
   ,[auxiliar_string1]	
   ,[incl_data]			
   ,[incl_user]			
   ,[incl_device]		
   ,[modi_data]			
   ,[modi_user]			
   ,[modi_device]		
   ,[excl_data]			
   ,[excl_user]			
   ,[excl_device]	
)
select 
			[id_grupo_estoque]
           ,[codigo]
           ,[descricao]
           ,[ativo]
           ,[dt_bloqueio]		= null
           ,[motivo_bloqueio]	= null
           ,[seq_exibicao]
           ,[auxiliar_string1]	= null
           ,[incl_data]			= getdate()
           ,[incl_user]			= 'ksantana'
           ,[incl_device]		= null
           ,[modi_data]			= null
           ,[modi_user]			= null
           ,[modi_device]		= null
           ,[excl_data]			= null
           ,[excl_user]			= null
           ,[excl_device]		= null
from (
select *
,	rw = row_number() over ( partition by descricao, id_grupo_estoque order by id_grupo_estoque desc)
from Tabela_subgrupo_estoque
) ss
where rw = 1
and descricao not in ('SERVIÇOS','SERVIÇO')
order by  [descricao] desc