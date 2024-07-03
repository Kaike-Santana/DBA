

INSERT INTO [THESYS_HOMOLOGACAO]..[Anexos_Tipos]
           ([descricao]
           ,[caminho_diretorio]
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
 [descricao]
,[caminho_diretorio]
,[incl_data]
,[incl_user]
,[incl_device]
,[modi_data]
,[modi_user]
,[modi_device]
,[excl_data]
,[excl_user]
,[excl_device]
from Anexos_Tipos