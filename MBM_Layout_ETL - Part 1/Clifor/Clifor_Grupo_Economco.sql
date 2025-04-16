Use Thesys_Homologacao
Go

--> Normaliza os Nomes Fantasia. Porém Depois Tem Rodar e Analisar.

/*
WITH Cte_Raiz_Cnpj AS (
    SELECT 
        Cod_Clifor,
        Razao,
        Ativo,
        Fantasia,
        Cnpj,
        Left(Dbo.Fn_Limpa_NoNum(Cnpj), 8) As Raiz
    FROM Clifor
    WHERE Pessoa = 'J'
      AND Coalesce(Cnpj, '') != ''
      AND Cnpj != '00.000.000/0000-00'
      AND Len(Dbo.Fn_Limpa_NoNum(Cnpj)) = 14
      AND Cnpj Not In ('00.000.000/0000-01', '00.000.000/0001-91', '99.999.999/9999-76', '99.999.999/9999-99','88.888.888/8888-88','88.888.888/0001-91') -- Sujeira
),


Cte_Update As (
Select *
, Frequencia = Row_Number () Over ( Partition By Raiz Order By Len(Fantasia) Asc)
From Cte_Raiz_Cnpj C
Where Exists (
			   Select 1
			   From cte_Raiz_Cnpj Sub
			   Where Sub.Raiz = C.Raiz
			   And sub.Fantasia <> C.Fantasia -- Nomes fantasia diferentes
			 )
)

Select * From Cte_Update
*/

--> Criacao da Tabela 
Drop Table If Exists Clifor_Grupo_Economico
Create Table Clifor_Grupo_Economico (
    Id_CliGr_Economico Int Identity(1,1) Primary Key,   --> Coluna ID com identidade
    Raiz_Cnpj Varchar(8) Not Null,						--> Raiz do CNPJ com 8 números
    NomeGrupo Varchar(100) Not Null						--> Nome do grupo
);




Alter Table Clifor Drop Column Raiz_Cnpj
Alter Table Clifor
Add Raiz_Cnpj Varchar(8);

Update Clifor
Set Raiz_Cnpj = Left(Dbo.Fn_Limpa_NoNum(Cnpj), 8)
Where Pessoa = 'J'
And Coalesce(Cnpj,'') != ''
And Left(Dbo.Fn_Limpa_NoNum(Cnpj), 8) Not In (00000000, 99999999) 


Insert Into Clifor_Grupo_Economico
Select 
	NomeGrupo = Raiz_Cnpj
,	Fantasia  = Max(Fantasia)
From Clifor
Where Raiz_Cnpj Is Not Null
Group By Raiz_Cnpj


Select Distinct 
	Fato.fantasia_empresa
,	fato.cod_clifor
,	fato.cliente_fornecedor
,	fato.cnpj
,	Raiz = Left(Dbo.Fn_Limpa_NoNum(Fato.Cnpj), 8)
,	fato.fantasia_cliente_forn
,	Dim.NomeGrupo
From Tb_Bi_Faturamento_Vendas_Estatico Fato 
Left Join Thesys_Homologacao.Dbo.Clifor_Grupo_Economico Dim On Dim.Raiz_Cnpj = Left(Dbo.Fn_Limpa_NoNum(Fato.Cnpj), 8)
Where Dim.NomeGrupo Is Not Null
Order By Left(Dbo.Fn_Limpa_NoNum(Fato.Cnpj), 8) Desc


--> 1 Check, Nao Pode Ter Nome Fantasia Igual Por Razao Diferente
Select 
	Raiz_Cnpj
,	NomeGrupo
,	Check1 As Duplicado
From (
	   Select *
	   ,	Check1 = Row_Number () Over ( Partition By Raiz_Cnpj Order By NomeGrupo Desc)
	   From Clifor_Grupo_Economico
	 ) SubQuery
Where SubQuery.Check1 > 1


--> 2 Check, Verifica se na Tabela Clifor, Tem Raiz de CNPJ > 1 e Que Nao Esta Presente na Tabela Clifor_Grupo_Economico
Create View Alerta_RaizCnpjNova As
With Cte_RaizCnpj As (
    Select
        Raiz_Cnpj  = Left(Dbo.Fn_Limpa_NoNum(Cnpj), 8) 
    ,   Quantidade = Count(*)
    From Clifor
    Where Pessoa = 'j'													  -- somente pessoas jurídicas
    And Coalesce(Cnpj, '') != ''										  -- excluindo cnpjs nulos ou vazios
    And Left(Dbo.Fn_Limpa_NoNum(Cnpj), 8) Not In ('00000000', '99999999') -- excluindo raízes inválidas
    Group By Left(Dbo.Fn_Limpa_NoNum(Cnpj), 8)
    Having Count(*) > 1													  -- somente raízes de cnpj com mais de uma ocorrência
)
Select *
From Cte_RaizCnpj As Cte
Where Not Exists (
				   Select *
				   From Clifor_Grupo_Economico As Cge
				   Where Cge.Raiz_Cnpj = Cte.Raiz_Cnpj
				 )

Select * 
From Alerta_RaizCnpjNova

--> Pega os Nome Definidos no Homolog e Joga no Prod, Homolog foi feito com os CLifor de Poli, Polirex, e MG
Update Fato
Set NomeGrupo = dim.NomeGrupo

From Clifor_Grupo_Economico Fato
Join THESYS_HOMOLOGACAO..Clifor_Grupo_Economico Dim On Dim.Raiz_Cnpj = fato.Raiz_Cnpj