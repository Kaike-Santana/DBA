
use THESYS_HOMOLOGACAO
go

Drop Table If Exists #BaseItensFornec
Select 
	'POLIREX' AS EMPRESA
,	*
Into #BaseItensFornec
From OpenQuery([MBM_Polirex],'
select 
	item_fornec.*
,	clifor.cgc_cpf
from item_fornec 
join Clifor On Clifor.cod_clifor = item_fornec.cod_clifor
')



Insert Into Itens_Fornec
select *
from (
		Select 
			Cod_Clifor				 =  clifor.cod_clifor
		,	Id_Item					 =  itens_empresas.Id_Item
		,	Id_Unidade				 =  Null
		,	Cod_Unidade				 =  Fato.Unidade
		,	Cod_Item_Fornec			 =  Fato.Codigo_fornec
		,	[descricao_item_fornec]	 =  fato.desc_fornec
		,	[fator_conversao]		 =  fato.fator_conv
		,	[tempo_obtencao]		 =  fato.tempo_obtencao
		,	[operacao]				 =  Case 
											When fato.operador = 'M' Then '*'
											When fato.operador = 'D' Then '/'
											Else fato.operador
									    End
		,	[qtd_estoque_convertida] =  null 
		,	[qtd_estoque]			 =  null
		,	[incl_data]				 =  getdate()
		,	[incl_user]				 =  'ksantana'
		,	[incl_device]			 =  null
		,	[modi_data]				 =  null
		,	[modi_user]				 =  null
		,	[modi_device]			 =  null
		,	[excl_data]				 =  null
		,	[excl_user]				 =  null
		,	[excl_device]			 =  null
		,	id_unidade_padrao        = Null
		,	id_unidade_fornec		 = Null
		From #BaseItensFornec Fato
		Inner Join clifor		  On Dbo.Fn_Limpa_NoNum(Isnull(clifor.cnpj,clifor.cpf))	= Dbo.Fn_Limpa_NoNum(Fato.cgc_cpf) Collate latin1_general_ci_ai
		Inner Join itens_empresas On itens_empresas.cod_reduzido_antigo					= Fato.cod_item					   Collate latin1_general_ci_ai And itens_empresas.id_empresa_grupo = 179
		left  Join Unidades       On Unidades.Codigo									= Fato.Unidade					   Collate latin1_general_ci_as
) SubQuery
Where Not Exists (
				   Select *
				   From Itens_Fornec Dim
				   Where Dim.id_item	= SubQuery.Id_Item
				   And   Dim.cod_clifor = SubQuery.Cod_Clifor
				 )

--> Popular ela de novo quando arrumar a tabela de Itens