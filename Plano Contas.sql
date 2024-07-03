USE [THESYS_DEV]
GO

INSERT INTO [THESYS_HOMOLOGACAO]..[Plano_Contas]
           ([id_plano]
           ,[cod_planocontas]
           ,[descricao]
           ,[descricao_contabil]
           ,[lancamento]
           ,[reduzido]
           ,[tipo]
           ,[nivel]
           ,[ativo]
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
			[id_plano]
           ,[cod_planocontas]
           ,[descricao]
           ,[descricao_contabil]
           ,[lancamento]
           ,[reduzido]
           ,[tipo]
           ,[nivel]
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
from [Plano_Contas]


select *
into #plano
from (
select *
, rw = row_number() over( partition by cod_planocontas, tipo order by cod_planocontas desc)
from plano_contas
) sb
where rw = 1