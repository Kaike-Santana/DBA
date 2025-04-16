

begin transaction

update Fato 
set check_licencas_para_vendas = 'S'
,	validade_licenca_pf		   =  iif(try_convert(date, Dim.[licen�a_da_pol�cia_federal])			    is not null, dim.[licen�a_da_pol�cia_federal], null)
,	validade_vistoria_pc	   =  iif(try_convert(date, Dim.[Certificado_de_vistoria_da_pol�cia_civil]) is not null, dim.[Certificado_de_vistoria_da_pol�cia_civil], null)
,	validade_licenca_pc		   =  iif(try_convert(date, Dim.[Alvar�_da_pol�cia_civil])				    is not null, dim.[Alvar�_da_pol�cia_civil], null)
from clifor Fato
Join TabelaValidadeLicenca Dim On (Dim.cnpj = fato.cnpj)

commit transaction

update TabelaValidadeLicenca
set cnpj = '04.973.218/0001-83'

where [Raz�o_Social] = 'GREENTEX QUIMICA LTDA'
and    cnpj is null 
