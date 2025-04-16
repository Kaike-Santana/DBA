USE THESYS_DEV
GO

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* PROGRAMADOR: KAIKE NATAN																		*/
/* VERSAO     : DATA: 23/05/2024																*/
/* DESCRICAO  : SCRIPT PARA POPULAR A TABELA DE CLASS FISCAL DO THESYS							*/
/*																								*/
/* ALTERACAO																					*/
/*        2. PROGRAMADOR:                                                  DATA: __/__/____		*/        
/*           DESCRICAO  :																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: TABELA TEMPORÁRIA PARA ARMAZENAR OS DADOS DE CLASS FISCAL DOS 5 BANCOS DO MBM		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #BASE_CLASS_FISCAL_MBM
SELECT 
	'POLIMEROS' AS EMPRESA
,	*
INTO #BASE_CLASS_FISCAL_MBM
FROM OPENQUERY([MBM_MG_POLIMEROS],'
select 
	cod_classfiscal
,	descricao 
,	ativo 
from class_fiscal 
where cod_classfiscal != ''99999999''
and cod_classfiscal   != ''00000000''
and cod_classfiscal   != ''0''
')

UNION ALL

SELECT 
	'NORTEBAG' AS EMPRESA
,	*
FROM OPENQUERY([MBM_NORTEBAG],'
select 
	cod_classfiscal
,	descricao 
,	ativo 
from class_fiscal 
where cod_classfiscal != ''99999999''
and cod_classfiscal   != ''00000000''
and cod_classfiscal   != ''0''
')

UNION ALL

SELECT 
	'POLIRESINAS' AS EMPRESA
,	*
FROM OPENQUERY([MBM_POLIRESINAS],'
select 
	cod_classfiscal
,	descricao 
,	ativo 
from class_fiscal 
where cod_classfiscal != ''99999999''
and cod_classfiscal   != ''00000000''
and cod_classfiscal   != ''0''
')

UNION ALL

SELECT 
	'POLIREX' AS EMPRESA
,	*
FROM OPENQUERY([MBM_POLIREX],'
select 
	cod_classfiscal
,	descricao 
,	ativo 
from class_fiscal 
where cod_classfiscal != ''99999999''
and cod_classfiscal   != ''00000000''
and cod_classfiscal   != ''0''
')

UNION ALL

SELECT 
	'RUBBERON' AS EMPRESA
,	*
FROM OPENQUERY([MBM_RUBBERON],'
select 
	cod_classfiscal
,	descricao 
,	ativo 
from class_fiscal 
where cod_classfiscal != ''99999999''
and cod_classfiscal   != ''00000000''
and cod_classfiscal   != ''0''
')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: PARTICIONA AS CLASS FISCAIS PARA REMOVER OS DUPLICADOS							*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #UNIQ
SELECT *
INTO #UNIQ
FROM (
	   SELECT *
	   ,	RW = ROW_NUMBER() OVER ( PARTITION BY COD_CLASSFISCAL ORDER BY COD_CLASSFISCAL DESC)
	   FROM #BASE_CLASS_FISCAL_MBM
	 ) SubQuery
WHERE RW = 1
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: TB PADRAO PARA POPULAR id_classe_cargaperigosa_tab_padrao e classe_cargaperigosa	*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #TB_PAD_CARGA_PERIGOSA
SELECT *
INTO #TB_PAD_CARGA_PERIGOSA
FROM TABELA_PADRAO
WHERE COD_TABELAPADRAO = 'CARGA_PERIGOSA'
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: TBPAD FOR POPULAR id_subclasse_cargaperigosa_tab_padrao e subclasse_cargaperigosa */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS #TB_PAD_SUB_CLASS_CARGA_PERIGOSA
SELECT *
INTO #TB_PAD_SUB_CLASS_CARGA_PERIGOSA
FROM TABELA_PADRAO
WHERE COD_TABELAPADRAO = 'SUBCLASSE_CARGA_PERIGOSA'
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: PARTICIONA AS CLASS FISCAIS PARA REMOVER OS DUPLICADOS							*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
INSERT INTO CLASS_FISCAL
SELECT 
	[cod_classfiscal]						
,	[ipi]						
,	[id_mensagem]							
,	[descricao_simplificada]				
,	[ativo]									
,	[incl_data]								
,	[incl_user]								
,	[incl_device]							
,	[modi_data]								
,	[modi_user]								
,	[modi_device]							
,	[excl_data]								
,	[excl_user]								
,	[excl_device]							
,	[descricao_completa]					
,	[neces_lic_imp_comp]					
,	[carga_perigosa]						
,	[id_classe_cargaperigosa_tab_padrao]	
,	[classe_cargaperigosa]					
,	[id_subclasse_cargaperigosa_tab_padrao]	
,	[subclasse_cargaperigosa]				
,	venda									
FROM (
SELECT 
	[cod_classfiscal]							=	trim(fato.[cod_classfiscal])
,	[ipi]										=	Isnull(dim.alíquota, '0.000000')
,	[id_mensagem]								=   null
,	[descricao_simplificada]					=	fato.descricao
,	[ativo]										=	fato.ativo
,	[incl_data]									=	getdate()
,	[incl_user]									=	'ksantana'
,	[incl_device]								=	'PC/10.1.0.254'
,	[modi_data]									=	 null
,	[modi_user]									=	 null
,	[modi_device]								=	 null
,	[excl_data]									=	 null
,	[excl_user]									=	 null
,	[excl_device]								=	 null
,	[descricao_completa]						=	 Isnull(dim.descrição, 	fato.descricao)
,	[neces_lic_imp_comp]						=    'N' 
,	[carga_perigosa]							=    'N' 
,	[id_classe_cargaperigosa_tab_padrao]		=	 null --> TB_DExPARA_CARGA_PERIGOSA 
,	[classe_cargaperigosa]						=	 null --> TB_DExPARA_CARGA_PERIGOSA
,	[id_subclasse_cargaperigosa_tab_padrao]		=	 null --> TB_DExPARA_CARGA_PERIGOSA
,	[subclasse_cargaperigosa]					=	 null --> TB_DExPARA_CARGA_PERIGOSA
,	venda										=	 'N'
,	RN											=    ROW_NUMBER() OVER ( PARTITION BY trim(fato.[cod_classfiscal]) ORDER BY trim(fato.[cod_classfiscal]) DESC)
FROM #UNIQ FATO
LEFT JOIN TABELA_DEXPARA_NCM DIM ON DIM.NCM = FATO.COD_CLASSFISCAL COLLATE SQL_Latin1_General_CP1_CI_AI --> TABELA DE DExPARA PARA OS CÓDIGOS NCM(COD_CLASSFISCAL)
WHERE NOT EXISTS (
				   SELECT *
				   FROM CLASS_FISCAL DIM
				   WHERE DIM.cod_classfiscal =  trim(FATO.cod_classfiscal) COLLATE SQL_Latin1_General_CP1_CI_AI
				 )
)SUBQUERY
WHERE RN = 1



--update TABELA_DEXPARA_NCM
--set alíquota = '0.000000'
--where alíquota = 'NT'
--or alíquota Is Null
--
--
--update TABELA_DEXPARA_NCM
--set alíquota = FORMAT(TRY_CONVERT(NUMERIC(15,6), REPLACE(alíquota, ',', '.')), '0.000000')
--
--drop table TABELA_DEXPARA_NCM