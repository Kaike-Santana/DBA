
use THESYS_HOMOLOGACAO
go

--> tabelas que a Clifor Depende!! Atualizar elas Primeiro

-- Atividades > bancos > ok

--pagamentos_condicoes > tabela_padrao ok


-- Base Clifor Poli
Drop Table If Exists #BaseClifor
Select 
	'POLIRESINAS' AS EMPRESA
,	*
Into #BaseClifor
From OpenQuery([MBM_Poliresinas],'
select 
	Clifor.*
,	bairro.descricao		as descricao_bairro
,	cidade.cod_ibge			as cod_ibge_cidade
,	pais.cod_ibge			as cod_ibge_pais
,	representante.razao		as raz_representante  
,	grupo_cliente.descricao as descricao_grupo_cliente
from Clifor 
left join bairro		on bairro.cod_bairro			= Clifor.cod_bairro
left join cidade		on cidade.cod_cidade			= Clifor.cod_cidade
left join pais			on pais.cod_pais				= Clifor.cod_pais
left join representante on representante.cod_repres		= Clifor.cod_repres
left join grupo_cliente on grupo_cliente.cod_grpcliente	= Clifor.cod_grpcliente
--Where Clifor.ativo = ''S'' --Deixar descomentado pois a tabela de contas a pagar depende de todos os clifors
')


--> Tab Clifor do de para exemplo de Layout.
thesys_dev..clifor

alter table clifor add raz_representante varchar(max)

INSERT INTO clifor
SELECT 
    Grupo_Clientes.id_grupo_cliente AS cod_cligrupo,
    razao,
    ativo,
    descricao_bairro AS bairro,
    Cidades.codigo AS CODICIDADE,
    Fantasia,
    Paises.id_pais AS id_pais,
    cod_atividade,
    endereco,
    end_complemento,
    cod_tipologradouro,
    end_numero,
    fato.cep AS cep,
    cliente,
    fornec,
    pessoa,
    IIF(cod_transp IS NULL, 'N', 'S') AS transportadora,
    IIF(Cod_Repres IS NULL, 'N', 'S') AS vendedor,
    IIF(Pessoa = 'J', cgc_cpf, NULL) AS cnpj,
    IIF(Pessoa = 'F', cgc_cpf, NULL) AS cpf,
    IIF(Pessoa = 'F', ie_rg, NULL) AS rg,
    IIF(Pessoa = 'J', ie_rg, NULL) AS ie,
    insmunicipal,
    telefone1,
    telefone2,
    celular,
    fax,
    cxpostal,
    web,
    email,
    TRY_CONVERT(datetime, dt_cadastro) AS dt_abertura,
    NULL AS porte,
    TRY_CONVERT(datetime, dt_nascto) AS dt_nascto,
    suframa,
    contribuinte,
    subst_tributaria_iss AS retencao_iss,
    aliquota_iss,
    prospect,
    inscricao_produtorrural,
    emitir_cartacobranca,
    optante_sn,
    ie_nao_contribuinte,
    alccompras_permitealtfornec,
    end_latitude,
    end_longitude,
    situacao_credito,
    consentimento_lgpd,
    cod_clifor AS cod_antigo,
    Empresa AS cod_empresa,
    obs,
    Cidades.CODIUF AS CODIUF,
    NULL AS CODIBANCO,
    NULL AS RFBTipoMatrizFilial,
    NULL AS RFBPorteEmpresa,
    NULL AS RFBCNAEPrincipal,
    NULL AS RFBCNAESecundarios,
    NULL AS RFBSituacao,
    NULL AS RBFDataSituacaoCadastral,
    NULL AS RFBMotivoSituacaoCadastral,
    NULL AS RFBSituacaoEspecial,
    NULL AS RFBDataSituacaoEspecial,
    NULL AS RFBNaturezaJuridica,
    NULL AS RFBDataHoraConsulta,
    NULL AS RFBEnteFederativoResponsavel,
    NULL AS prestador_interno,
    NULL AS armadores,
    NULL AS recinto_alfandegado,
    NULL AS cod_recinto_alf,
    NULL AS despachantes,
    NULL AS id_reprvend,
    NULL AS id_transp_padrao,
    NULL AS taxa_spread,
    NULL AS id_usuario,
    NULL AS id_condicao_pagamento,
    NULL AS id_tabela_padrao_forma_pagamento,	
    NULL AS id_portador_cp,
    NULL AS id_portador_cr,
    convert(numeric(16,2),null) AS vlr_limite_credito,							   
    convert(date,null) AS validade_limite_credito,  
    convert(date,null) AS validade_consulta_credito,
    convert(int,null) AS dias_validade_consulta_credito,
    NULL AS situacao_consulta_credito,
    NULL AS dias_bloq_cliente_atraso,
    NULL AS restricao_venda,
    GETDATE() AS incl_data,
    'ksantana' AS incl_user,
    NULL AS incl_device,
    NULL AS modi_data,
    NULL AS modi_user,
    NULL AS modi_device,
    NULL AS excl_data,
    NULL AS excl_user,
    NULL AS excl_device,
    NULL AS id_tipo_frete,
    NULL AS check_licencas_para_vendas,
    convert(date,null) AS validade_licenca_pf,
    convert(date,null) AS validade_vistoria_pc,
    convert(date,null) AS validade_licenca_pc,
    NULL AS industrializacao_por_encomenda,
	raz_representante =  null
FROM #BaseClifor Fato
LEFT JOIN Paises		 ON Paises.cod_ibge			 = Fato.cod_ibge_pais			COLLATE latin1_general_ci_ai 
LEFT JOIN Cidades		 ON Cidades.CodIibge		 = Fato.Cod_Ibge_Cidade			COLLATE latin1_general_ci_ai 
LEFT JOIN Grupo_Clientes ON Grupo_Clientes.descricao = Fato.descricao_grupo_cliente COLLATE latin1_general_ci_ai 
WHERE NOT EXISTS (
    SELECT *
    FROM clifor dim
    WHERE dim.cod_antigo = fato.cod_clifor COLLATE latin1_general_ci_ai
);

--> Tabela Cidades tem uma coluna que referencia a tabela clifor


--update CliFor
--set [id_reprvend] = CliFor.cod_clifor
--
--from CliFor
--join #BaseClifor on #BaseClifor.raz_representante collate latin1_general_ci_ai  = CliFor.razao collate latin1_general_ci_ai 
--
--alter table clifor drop column raz_representante
--
--
--update Cidades
--set id_clifor_impmunicipal = clifor.cod_clifor
--
--from Cidades
--join CliFor on CliFor.CODICIDADE = Cidades.CODIGO
--
--UPDATE clifor
--SET cod_antigo = RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR, cod_antigo), 7)
--where cod_empresa != 'CLOROETIL'

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Itens Forncec																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/* Dependencias da Tabela Itens_Fornec */

-- Itens_Fornec > clifor > Atividades > bancos > pagamentos_condicoes > tabela_padrao ok

-- itens > familia_pcp > unidades ok

Drop Table If Exists #BaseItensFornec
Select 
	'POLIRESINAS' AS EMPRESA
,	*
Into #BaseItensFornec
From OpenQuery([MBM_Poliresinas],'
select 
	item_fornec.*
,	clifor.cgc_cpf
from item_fornec 
join Clifor On Clifor.cod_clifor = item_fornec.cod_clifor
Where Clifor.ativo = ''S''
')



Insert Into Itens_Fornec
Select 
	Cod_Clifor				 =  clifor.cod_clifor
,	Id_Item					 =  itens_empresas.Id_Item
,	Id_Unidade				 =  Unidades.id_unidade
,	Cod_Unidade				 =  Unidades.codigo
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
From #BaseItensFornec Fato
Inner Join clifor		  On Dbo.Fn_Limpa_NoNum(Isnull(clifor.cnpj,clifor.cpf))	= Dbo.Fn_Limpa_NoNum(Fato.cgc_cpf) Collate latin1_general_ci_ai
Inner Join itens_empresas On itens_empresas.cod_reduzido_antigo					= Fato.cod_item					   Collate latin1_general_ci_ai And itens_empresas.id_empresa_grupo = 1584
Left  Join Unidades       On Unidades.Codigo									= Fato.Unidade					   Collate latin1_general_ci_ai
order by id_item desc

--> Popular ela de novo quando arrumar a tabela de Itens


