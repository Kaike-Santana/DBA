
USE [THESYS_DEV]
GO

INSERT INTO [THESYS_HOMOLOGACAO]..[Aliquotas_II]
           ([id_classfiscal]
           ,[id_pais_origem]
           ,[aliq_importacao]
           ,[vigencia_inicial]
           ,[vigencia_final]
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
--	[id_classfiscal]
	id_classfiscal_homolog  = dim_2.id_clasfisc
--,	dim_2.descricao_simplificada
,	Aliquotas_II.[id_pais_origem]
,	Aliquotas_II.[aliq_importacao]
,	Aliquotas_II.[vigencia_inicial]
,	Aliquotas_II.[vigencia_final]
,	Aliquotas_II.[incl_data]
,	Aliquotas_II.[incl_user]
,	Aliquotas_II.[incl_device]
,	Aliquotas_II.[modi_data]
,	Aliquotas_II.[modi_user]
,	Aliquotas_II.[modi_device]
,	Aliquotas_II.[excl_data]
,	Aliquotas_II.[excl_user]
,	Aliquotas_II.[excl_device]
from Aliquotas_II
left join class_fiscal on class_fiscal.id_clasfisc = Aliquotas_II.id_classfiscal
left join thesys_homologacao..class_fiscal as dim_2 on dim_2.descricao_simplificada = class_fiscal.descricao_simplificada


ALTER TABLE [Aliquotas_II]
ADD CONSTRAINT FK_Aliquotas_II_class_fiscal
FOREIGN KEY (id_classfiscal) 
REFERENCES [class_fiscal] (id_clasfisc);