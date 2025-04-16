
Use Thesys_Producao
Go

Create Table Estoque_Saldo_Competencia (
    Id_Estoque_Saldo	Int Identity(1,1) Primary Key Not Null,
	Id_Empresa          Int           Null,
    Id_Item				Int			  Null,
    Id_Estoque_Deposito Int			  Null,
    AnoMes				Varchar(8)	  Null,
    Saldo_Qtd_Inicial	Numeric(15,3) Null Default 0,
    Saldo_Qtd_Final		Numeric(15,3) Null Default 0,
    Saldo_Custo_Inicial Numeric(15,2) Null Default 0,
    Saldo_Custo_Final	Numeric(15,2) Null Default 0,
    Custo_Medio			Numeric(15,4) Null Default 0,
    Incl_Data			Datetime	  Null,
    Incl_User			Varchar(10)	  Null,
    Incl_Device			Varchar(30)	  Null,
    Modi_Data			Datetime	  Null,
    Modi_User			Varchar(10)	  Null,
    Modi_Device			Varchar(30)	  Null,
    Excl_Data			Datetime	  Null,
    Excl_User			Varchar(10)   Null,
    Excl_Device			Varchar(30)   Null
);

-- Criando a FK com a tabela Empresas
Alter Table Estoque_Saldo_Competencia
Add Constraint FK_Estoque_Saldo_Competencia_Empresas
Foreign Key (Id_Empresa) 
References Empresas (Id_Empresa);

-- Criando a FK com a tabela Itens
Alter Table Estoque_Saldo_Competencia
Add Constraint FK_Estoque_Saldo_Competencia_Itens
Foreign Key (Id_Item) 
References Itens (Id_Item);

-- Criando a FK com a tabela Estoque_Deposito
Alter Table Estoque_Saldo_Competencia
Add Constraint FK_Estoque_Saldo_Competencia_Estoque_Deposito
Foreign Key (Id_Estoque_Deposito) 
References Estoque_Deposito (Id_Estoque_Deposito);


drop table if exists #BaseMBM
SELECT *
into #BaseMBM
FROM OPENQUERY([MBM_POLIREX],'
select 
   ec.cod_empresa
,  null cod_deposito
,  ec.competencia
,  ec.cod_item
,  i.codigo
,  i.descricao
,  sum(esc.saldo_inicial) as saldo_inicial
,  sum(esc.saldo_final) as saldo_final
,  max(ec.custo_medio) as custo_medio
,  sum(ec.custo_medio * esc.saldo_inicial) as saldo_custo_inicial
,  sum(ec.custo_medio * esc.saldo_final  ) as saldo_custo_final
from estoq_competencia ec 
left join estoq_saldocompetencia esc 
         on  ec.cod_item    = esc.cod_item 
        and ec.competencia = esc.competencia 
        and ec.cod_empresa = esc.cod_empresa
left join item i on i.cod_item=ec.cod_item 
where ec.competencia like ''2025%''
and i.controla_estoque= ''S''
group by  ec.cod_empresa
,  ec.competencia
,  ec.cod_item
,  i.codigo
,  i.descricao
')


SELECT *
INTO #ITENS_IMAGRAF
FROM ITENS
WHERE id_unid_negocio = 9

Insert Into [Estoque_Saldo_Competencia]
SELECT Distinct
	id_empresa
,	id_item					
,	id_deposito
,	AnoMes = '2024/09'
,	[Saldo_Qtd_Inicial]		= 0
,	[Saldo_Qtd_Final]	 	= 0
,	[Saldo_Custo_Inicial]	= 0
,	[Saldo_Custo_Final]  	= 0
,	[Custo_Medio]		 	= 0
,	[Incl_Data]			 	= Null
,	[Incl_User]			 	= Null
,	[Incl_Device]		 	= Null
,	[Modi_Data]			 	= Null
,	[Modi_User]			 	= Null
,	[Modi_Device]		 	= Null
,	[Excl_Data]			 	= Null
,	[Excl_User]			 	= Null
,	[Excl_Device]		 	= Null
FROM Estoque_Movimentos Fato
WHERE entrada_saida = 'E'
AND EXISTS (
			 SELECT *
			 FROM #ITENS_IMAGRAF DIM
			 WHERE DIM.ID_ITEM = Fato.ID_ITEM
		   )


Truncate Table [dbo].[Estoque_Saldo_Competencia]
Insert   Into  [dbo].[Estoque_Saldo_Competencia]
           ([Id_Empresa]
           ,[Id_Item]
           ,[Id_Estoque_Deposito]
           ,[AnoMes]
           ,[Saldo_Qtd_Inicial]
           ,[Saldo_Qtd_Final]
           ,[Saldo_Custo_Inicial]
           ,[Saldo_Custo_Final]
           ,[Custo_Medio]
           ,[Incl_Data]
           ,[Incl_User]
           ,[Incl_Device]
           ,[Modi_Data]
           ,[Modi_User]
           ,[Modi_Device]
           ,[Excl_Data]
           ,[Excl_User]
           ,[Excl_Device])


Select 
	[Id_Empresa]		  = Empresas.[Id_Empresa]
,	[Id_Item]			  = Itens_Empresas.Id_Item
,	[Id_Estoque_Deposito] = Null
,	[AnoMes]			  = Left(Competencia,4) + '/' + Right(Competencia,2)
,	[Saldo_Qtd_Inicial]   = Coalesce(Sum(Saldo_Inicial)		 ,0)
,	[Saldo_Qtd_Final]	  = Coalesce(Sum(Saldo_Final)		 ,0)
,	[Saldo_Custo_Inicial] = Coalesce(Sum(Saldo_Custo_Inicial),0)
,	[Saldo_Custo_Final]   = Coalesce(Sum(Saldo_Custo_Final)	 ,0)
,	[Custo_Medio]		  = Coalesce(Avg(fato.Custo_Medio)   ,0)--> Se Atentar Aqui, Pq as Vezes, Traz 2 Itens e Com Sum, Duplica Custo Médio, criar uma lógica.
,	[Incl_Data]			  = GetDate()
,	[Incl_User]			  = 'ksantana'
,	[Incl_Device]		  = 'PC/10.1.0.123'
,	[Modi_Data]			  = Null
,	[Modi_User]			  = Null
,	[Modi_Device]		  = Null
,	[Excl_Data]			  = Null
,	[Excl_User]			  = Null
,	[Excl_Device]		  = Null
From #BaseMBM Fato
Join Empresas		  On  Empresas.Codigo_Antigo		     = Fato.Cod_Empresa    Collate latin1_general_ci_ai
Join Itens_Empresas	  On  Itens_Empresas.cod_reduzido_antigo = Fato.Cod_Item       Collate latin1_general_ci_ai
					  And Itens_Empresas.id_empresa_grupo    = 179
Join Itens			  On  Itens.id_item						 = Itens_Empresas.id_item and Itens_Empresas.id_empresa_grupo = 179
Left Join Estoque_Deposito On  Estoque_Deposito.Cod_Deposito      = Fato.Cod_Deposito   Collate latin1_general_ci_ai
					  And Estoque_Deposito.id_empresa        = Empresas.Id_Empresa

Where Itens.Controla_Estoque = 'S'
--and not exists (
--				   select *
--				   from Estoque_Saldo_Competencia dim
--				   where dim.Id_Item = Itens_Empresas.Id_Item
--				   and dim.AnoMes = Left(Competencia,4) + '/' + Right(Competencia,2) Collate latin1_general_ci_ai
--				   )
--and Itens_Empresas.id_item = 6241
--Where Exists (
--			  Select *
--			  From Itens Dim
--			  Where Dim.Codigo = Fato.Codigo Collate latin1_general_ci_ai
--			  And Dim.Controla_Estoque = 'S'
--			 )
--and fato.competencia between 202402 and 202409
--and Estoque_Deposito.cod_deposito Not In ('006','003')
Group By 
	Empresas.[Id_Empresa]
,	Itens_Empresas.Id_Item
--,	Estoque_Deposito.Id_Estoque_Deposito
,	Left(Competencia,4) + '/' + Right(Competencia,2)
Order By Left(Competencia,4) + '/' + Right(Competencia,2) Desc


--> Sempre Que Inserir Novos Dados, Dar Esse Update
Begin Transaction
	Update Estoque_Saldo_Competencia
	Set Custo_Medio = NullIF(Saldo_Custo_Final,0) / NullIf(Saldo_Qtd_Final,0)
	where Id_Item = 5057
	and Id_Empresa = 10
Commit Transaction