
use THESYS_DEV
go


-- Thesys_ Dev
select *
from CliFor
where cod_clifor in (
 411120
,402519
,403879
,411984
,396036
,420140
,421583
)


select 
	cod_clifor
,	CODICIDADE
,	CODIUF
from CliFor
where razao in (
'BRASIL TERMINAL PORTUARIO S.A.'
,'SANTOS BRASIL PARTICIPACOES'
,'SUPER TERMINAIS COMERCIO E INDUSTRIA LTDA'
,'CHIBATAO NAVEGACAO E COMERCIO LTDA'
,'PORTONAVE S/A TERMINAIS PORTUARIOS DE NAVEGANTES'
,'EMBRAPORT EMPRESA BRASILEIRA DE TERMINAIS PORTUARI'
,'LOCALFRIO S A  ARMAZENS GERAIS FRIGORIFICOS'
)

INSERT INTO [dbo].[Terminais_Alfandegados]
           ([id_clifor]
           ,[cod_recinto_alf]
           ,[descricao_arm]
           ,[cod_urf_despacho]
           ,[id_cidade]
           ,[id_uf]
           ,[id_item]
           ,[id_pgto_condicao]
           ,[id_natoperacao]
           ,[aliq_iss_retido]
           ,[aliq_inss_retido]
           ,[aliq_pis_retido]
           ,[aliq_cofins_retido]
           ,[aliq_csll_retido]
           ,[aliq_ir_retido]
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
     VALUES
           (822						-- id_clifor
           ,NULL					-- cod_recinto_alf
           ,'Santos - Embraport'	-- descricao_arm
           ,NULL					-- cod_urf_despacho
           ,3548500					-- id_cidade
           ,35						-- id_uf
           ,NULL					-- id_item
           ,NULL					-- id_pgto_condicao
           ,NULL					-- id_natoperacao
           ,NULL					-- aliq_iss_retido
           ,NULL					-- aliq_inss_retido
           ,NULL					-- aliq_pis_retido
           ,NULL					-- aliq_cofins_retido
           ,NULL					-- aliq_csll_retido
           ,NULL					-- aliq_ir_retido
           ,'S'						-- ativo
           ,getdate()				-- incl_data
           ,'ksantana'				-- incl_user
           ,null					-- incl_device
           ,NULL					-- modi_data
           ,NULL					-- modi_user
           ,NULL					-- modi_device
           ,NULL					-- excl_data
           ,NULL					-- excl_user
           ,NULL);					-- excl_device
GO
