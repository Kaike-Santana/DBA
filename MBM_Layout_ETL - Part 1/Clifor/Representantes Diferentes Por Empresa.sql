

--> Query Para Ver se Tem Representantes Diferentes Para o Mesmo CNPJ/CPF Por Empresa
Select 
   Empresa
,  Cod_Clifor_Mbm = Cod_Clifor
,  Razao
,  Fantasia
,  Cnpj
,  Cpf
,  Cod_Repres
,  Raz_Representante
,  Cnpj_Cpf_Repres
from #baseclifor as b1
where isnull(b1.cnpj, b1.cpf) in 
    (select isnull(b2.cnpj, b2.cpf)
     from #baseclifor as b2
     group by isnull(b2.cnpj, b2.cpf)
     having count(distinct b2.raz_representante) > 1)
And Isnull(Cnpj,Cpf) Not In ('00.000.000/0000-00', '000.000.000-00')
order by isnull(b1.cnpj, b1.cpf), b1.raz_representante