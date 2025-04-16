
Use Thesys_Homologacao
Go

Alter Table Empresas Add Id_Transp_Pd  Int
Alter Table Empresas Add Id_TpFrete_Pd Int


-- FK para tabela Clifor
Alter Table dbo.Empresas
Add Constraint FK_Empresas_Clifor
Foreign Key (Id_Transp_Pd) 
References dbo.Clifor(Cod_Clifor);

-- FK para tabela Tipos_frete
Alter Table dbo.Empresas
Add Constraint FK_Empresas_TiposFrete
Foreign Key (Id_TpFrete_Pd) 
References dbo.Tipos_frete(Id_Tipo_Frete);


select *
from CliFor
where razao like '%proprio%'

Select *
From Tipos_Frete

update Empresas
set Id_TpFrete_Pd = 1

where ID_EMPRESA_GRUPO in (179,14144)