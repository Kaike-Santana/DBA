
Use Thesys_Homologacao
Go

select *
from Natureza_Operacao
where cod_natoperacao = '6101-001'


select *
from Natureza_Operacao
where id_NaturezaOperacao = 85


alter table Natureza_Operacao add Nat_Dev Varchar(20)
alter table Natureza_Operacao drop column Nat_Dev

Update Fato
Set Nat_Dev = LEFT(DIM.[Cód_Nat_Dev],8)
From Natureza_Operacao Fato
Join thesys_homologacao..txt_id_natureza_devolucao Dim On  Dim.Id_Empresa_Grupo = Fato.Id_Empresa_Grupo
								   And Dim.Cod_NatOperacao  = Fato.Cod_NatOperacao

select
	id_nat_dev = LEFT(DIM.[Cód_Nat_Dev],8)
, fato.*
from Natureza_Operacao fato
Join thesys_homologacao..txt_id_natureza_devolucao Dim On  Dim.Id_Empresa_Grupo = Fato.Id_Empresa_Grupo
													   And Dim.Cod_NatOperacao  = Fato.Cod_NatOperacao


UPDATE n1
SET n1.id_natureza_devolucao = n2.id_NaturezaOperacao
FROM Natureza_Operacao n1
JOIN Natureza_Operacao n2 ON n1.Nat_Dev = n2.cod_natoperacao
						  and n1.id_empresa_grupo = n2.id_empresa_grupo