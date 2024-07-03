
--USE [THESYS_DEV]
--GO

alter table [Paises] alter column descricao varchar(200)
alter table [Paises] alter column descricao_ingles varchar(200)

INSERT INTO [THESYS_PRODUCAO]..[Paises]
           ([cod_pais]
           ,[descricao]
           ,[dt_change]
           ,[cod_ibge]
           ,[descricao_ingles]
           ,[id_pais]
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
			[cod_pais]
           ,[descricao]
           ,[dt_change]
           ,[cod_ibge]
           ,[descricao_ingles]
           ,[id_pais]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device]
from [Paises] 