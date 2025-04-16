

bancos_contas

portadores


select distinct empresa
from BancosContasInativos

--alter table BancosContasInativos add id_empresa int

update BancosContasInativos
set id_empresa = 4

where empresa = 'MG'

empresas


select 
	fato.id_empresa
,	fato.id_banco
,	fato.cod_banco
,	dim.descricao
,	fato.nro_agencia
,	fato.nro_conta
,	fato.ativo
from Bancos_Contas fato
join bancos dim on dim.cod_banco = fato.cod_banco

begin tran
update Bancos_Contas
set ativo = 'N'

from Bancos_Contas fato
join thesys_homologacao..BancosContasInativos dim on  dim.cod_banco  = fato.cod_banco
							  and dim.Agência    = fato.nro_agencia
							  and dim.Conta	     = replace(fato.nro_conta,' ','')
where fato.id_empresa in (3,4.7,8,9,10)

commit


select distinct banco
from BancosContasInativos

alter table BancosContasInativos add cod_banco varchar(10)


UPDATE BancosContasInativos
SET Cod_Banco = CASE 
    WHEN Banco = 'ABC' THEN 246
    WHEN Banco = 'Alfa' THEN 25
    WHEN Banco = 'Banco Alfa' THEN 25
    WHEN Banco = 'Basa' THEN 83  -- Banco da Amazônia
    WHEN Banco = 'BBM' THEN 107
    WHEN Banco = 'Bradesco' THEN 237
    WHEN Banco = 'BS2' THEN 218
    WHEN Banco = 'C6' THEN 336
    WHEN Banco = 'Caixa' THEN 104  -- Caixa Econômica Federal
    WHEN Banco = 'Daycoval' THEN 707
    WHEN Banco = 'Industrial' THEN 604  -- Banco Industrial do Brasil
    WHEN Banco = 'Itau' THEN 341
    WHEN Banco = 'Santander' THEN 33
    WHEN Banco = 'Sofisa' THEN 637
    WHEN Banco = 'XP' THEN 102
    ELSE Banco  -- Mantém o valor atual se o banco não for encontrado
END;

begin tran
update Portadores
set ativo = 'N'

from Portadores fato
join Bancos_Contas dim on dim.id_banco_conta = fato.id_banco_conta
where dim.ativo = 'N'

commit

