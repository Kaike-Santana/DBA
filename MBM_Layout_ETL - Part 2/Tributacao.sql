
USE THESYS_HOMOLOGACAO
GO

DROP TABLE IF EXISTS #TRIBUTACAO
SELECT *
INTO #TRIBUTACAO
FROM OPENQUERY([MBM_POLIREX],'
SELECT *
FROM TRIBUTACAO')


SELECT *
INTO #BASE_UNIQUE
FROM (
SELECT *
,	RW = ROW_NUMBER () OVER ( PARTITION BY COD_TRIBUTACAO, DESCRICAO ORDER BY COD_TRIBUTACAO DESC)
FROM #TRIBUTACAO
) SB
WHERE RW = 1


Drop Table If Exists #Dexpara
Select *
Into #Dexpara
From Tabela_Padrao
where cod_tabelapadrao = 'tributacao_operacao'


INSERT INTO [dbo].[Tributacao]
           ([cod_tributacao]
           ,[descricao]
           ,[aliquota_icms]
           ,[perc_base_icms]
           ,[tipo_aliquota]
           ,[dentro_estado]
           ,[fora_estado]
           ,[cst]
           ,[id_tp_operacao]
           ,[id_tp_operacao2]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device])

SELECT 
	[cod_tributacao]		
,	fato.[descricao]			
,	[aliquota_icms]			
,	[perc_base_icms]	= perc_baseicms
,	[tipo_aliquota]		= Iif(Aliquota_Prod_Estado = 'E', 'Específica', 'Estado')
,	[dentro_estado]		
,	[fora_estado]			
,	[cst]				= sittributaria	
,	[id_tp_operacao]	= Dim.id_tabela_padrao	
,	[id_tp_operacao2]	= Dim_2.id_tabela_padrao	
,	[incl_data]			= GETDATE()
,	[incl_user]			= 'ksantana'
,	[incl_device]		= NULL
,	[modi_data]			= NULL
,	[modi_user]			= NULL
,	[modi_device]		= NULL
,	[excl_data]			= NULL
,	[excl_user]			= NULL
,	[excl_device]		= NULL
FROM #BASE_UNIQUE Fato
LEFT JOIN #Dexpara Dim   On Dim.codigo   = Fato.operacao1 collate latin1_general_ci_ai 
LEFT JOIN #Dexpara Dim_2 On Dim_2.codigo = Fato.operacao2 collate latin1_general_ci_ai 
where not exists (
				  select *
				  from Tributacao base
				  where base.cod_tributacao = fato.cod_tributacao collate latin1_general_ci_ai 
				 )

update fato
set id_tributacao	=	dim.id_tributacao
,	cod_tributacao	=	dim.cod_tributacao

from Natureza_Operacao fato
join Tributacao		   dim on dim.cod_tributacao = fato.cod_tributacao
where fato.id_empresa_grupo = 179


select *
from natureza_operacao 
where cod_natoperacao  = '1102-002'


--> CASO PRECISE AJUSTAR O COD_TRIBUTACAO DA PROPRIA TABELA NATURESA DE OPERACAO!!
/*
update natureza_operacao
set cod_tributacao = #BaseNatOperacao.cod_tributacao
from natureza_operacao 
join #BaseNatOperacao on #BaseNatOperacao.cod_natoperacao = natureza_operacao.cod_natoperacao collate latin1_general_ci_ai 
where natureza_operacao.id_empresa_grupo = 1584



--> Base MBM Natureza Da Operacao Da Poliresinas
drop table if exists #BaseNatOperacao
select 'POLIRESINAS' AS EMPRESA
,	*
into #BaseNatOperacao
from openquery([mbm_poliresinas],'
select nat_operacao.*
,	tipodocto.descricao as descricao_tipodocto
from nat_operacao
left join tipodocto on tipodocto.cod_tipodocto = nat_operacao.cod_tipodocto
')
*/