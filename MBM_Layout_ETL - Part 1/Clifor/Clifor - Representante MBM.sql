
USE [THESYS_DEV]
GO

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* Programador: Kaike Natan																		*/
/* Versao     : Data: 07/06/2024																*/
/* Descricao  : Script De ETL Da Tabela Clifor do MBM Para o TheSys								*/
/*																								*/
/* Alteracao																					*/
/*        2. Programador: Kaike Natan                                      Data: 26/06/2024		*/        
/*           Descricao  : Inclusão da Mascara de Formataçâo das Colunas de Cpf/Cnpj				*/
/* Alteracao																					*/
/*        3. Programador: Kaike Natan                                      Data: 28/06/2024		*/        
/*           Descricao  : Inclusão de Todas as Empresas do MBM									*/
/* Alteracao																					*/
/*        4. Programador: Kaike Natan                                      Data: 01/07/2024		*/        
/*           Descricao  : Inclusão do Insert, por Razâo Para os Clientes do Exterior			*/
/* Alteracao																					*/
/*        5. Programador:                                                  Data: __/__/____		*/        
/*           Descricao  :																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	---ALTER Procedure [dbo].[Prc_Etl_Clifor_MBM] As
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Base MBM Dos Clifors																*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #BaseClifor
Select 
	'Poliresinas' As Empresa
,	*
,	Cnpj = Iif(Pessoa = 'J', Cgc_Cpf, Null) 
,	Cpf	 = Iif(Pessoa = 'F', Cgc_Cpf, Null) 
Into #BaseClifor
From OpenQuery([MBM_Poliresinas],'
Select Clifor.*
,	bairro.descricao		as descricao_bairro
,	cidade.cod_ibge			as cod_ibge_cidade
,	pais.cod_ibge			as cod_ibge_pais
from Representante as clifor 
left join bairro		on bairro.cod_bairro			= Clifor.cod_bairro
left join cidade		on cidade.cod_cidade			= Clifor.cod_cidade
left join pais			on pais.cod_pais				= Clifor.cod_pais
')

Union All

Select 
	'RUBBERON' AS Empresa
,	*
,	Cnpj = Iif(Pessoa = 'J', Cgc_Cpf, Null) 
,	Cpf	 = Iif(Pessoa = 'F', Cgc_Cpf, Null) 
From OpenQuery([MBM_Poliresinas],'
Select Clifor.*
,	bairro.descricao		as descricao_bairro
,	cidade.cod_ibge			as cod_ibge_cidade
,	pais.cod_ibge			as cod_ibge_pais
from Representante as clifor 
left join bairro		on bairro.cod_bairro			= Clifor.cod_bairro
left join cidade		on cidade.cod_cidade			= Clifor.cod_cidade
left join pais			on pais.cod_pais				= Clifor.cod_pais
')

Union All

Select 
	'POLIREX' AS EMPRESA
,	*
,	Cnpj = Iif(Pessoa = 'J', Cgc_Cpf, Null) 
,	Cpf	 = Iif(Pessoa = 'F', Cgc_Cpf, Null) 
From OpenQuery([MBM_Poliresinas],'
Select Clifor.*
,	bairro.descricao		as descricao_bairro
,	cidade.cod_ibge			as cod_ibge_cidade
,	pais.cod_ibge			as cod_ibge_pais
from Representante as clifor 
left join bairro		on bairro.cod_bairro			= Clifor.cod_bairro
left join cidade		on cidade.cod_cidade			= Clifor.cod_cidade
left join pais			on pais.cod_pais				= Clifor.cod_pais
')

Union All

Select 
	'NORTEBAG' AS EMPRESA
,	*
,	Cnpj = Iif(Pessoa = 'J', Cgc_Cpf, Null) 
,	Cpf	 = Iif(Pessoa = 'F', Cgc_Cpf, Null) 
From OpenQuery([MBM_Poliresinas],'
Select Clifor.*
,	bairro.descricao		as descricao_bairro
,	cidade.cod_ibge			as cod_ibge_cidade
,	pais.cod_ibge			as cod_ibge_pais
from Representante as clifor 
left join bairro		on bairro.cod_bairro			= Clifor.cod_bairro
left join cidade		on cidade.cod_cidade			= Clifor.cod_cidade
left join pais			on pais.cod_pais				= Clifor.cod_pais
')

Union All

Select 
	'MG_POLIMERIS' AS EMPRESA
,	*
,	Cnpj = Iif(Pessoa = 'J', Cgc_Cpf, Null) 
,	Cpf	 = Iif(Pessoa = 'F', Cgc_Cpf, Null) 
From OpenQuery([MBM_Poliresinas],'
Select Clifor.*
,	bairro.descricao		as descricao_bairro
,	cidade.cod_ibge			as cod_ibge_cidade
,	pais.cod_ibge			as cod_ibge_pais
from Representante as clifor 
left join bairro		on bairro.cod_bairro			= Clifor.cod_bairro
left join cidade		on cidade.cod_cidade			= Clifor.cod_cidade
left join pais			on pais.cod_pais				= Clifor.cod_pais
')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Aplica Mascara de Formataçâo Nas Colunas de CNPJ e CPF Apenas Onde Esta Errado	*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/	
Update #BaseClifor
Set Cnpj = Case 
               When Pessoa = 'F' And Cnpj Is Not Null Then Null 
               Else Cnpj 
           End,
    Cpf =  Case 
               When Pessoa = 'J' And Cpf  Is Not Null Then Null 
               Else Cpf 
           End
Where 
    (Pessoa = 'F' And Cnpj Is Not Null) 
    Or 
    (Pessoa = 'J' And Cpf  Is Not Null)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Aplica Mascara de Formataçâo Nas Colunas de CNPJ e CPF Apenas Onde Esta Errado	*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/	
Update #BaseClifor
Set Cnpj = Case 
               When Cnpj Is Not Null And Cnpj != Dbo.FormatarCnpj(Cnpj) 
               Then Dbo.FormatarCnpj(Cnpj) 
               Else Cnpj 
           End,
    Cpf =  Case 
               When Cpf Is Not Null And Cpf   != Dbo.FormatarCpf(Cpf) 
               Then Dbo.FormatarCpf(Cpf) 
               Else Cpf 
           End
Where 
    (Cnpj Is Not Null And Cnpj != Dbo.FormatarCnpj(Cnpj))
    Or
    (Cpf  Is Not Null And Cpf  != Dbo.FormatarCpf(Cpf));
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Popula Tabela Clifor Apenas Com o Diferencial	Por CNPJ/CPF						*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Insert Into Clifor 
Select 
    cod_cligrupo,
    razao,
    ativo,
    bairro,
    CODICIDADE,
    Fantasia,
    id_pais,
    cod_atividade,
    endereco,
    end_complemento,
    cod_tipologradouro,
    end_numero,
    cep,
    cliente ,
    fornec  ,
    pessoa,
    transportadora  ,
    vendedor			,
    cnpj,
    cpf,
    rg ,
    ie,
    insmunicipal,
    telefone1,
    telefone2,
    celular = null,
    fax,
    cxpostal,
    web,
    email,
    dt_abertura ,
    porte ,
    dt_nascto,
    suframa						,
    contribuinte				,
    retencao_iss				,
    aliquota_iss				,
    prospect					,
    inscricao_produtorrural		,
    emitir_cartacobranca		,
    optante_sn					,
    ie_nao_contribuinte			,
    alccompras_permitealtfornec ,
    end_latitude				,
    end_longitude				,
    situacao_credito			,
    consentimento_lgpd			,
    obs,
    CODIUF ,
    CODIBANCO,
    RFBTipoMatrizFilial,
    RFBPorteEmpresa,
    RFBCNAEPrincipal,
    RFBCNAESecundarios,
    RFBSituacao,
    RBFDataSituacaoCadastral,
    RFBMotivoSituacaoCadastral,
    RFBSituacaoEspecial,
    RFBDataSituacaoEspecial,
    RFBNaturezaJuridica,
    RFBDataHoraConsulta,
    RFBEnteFederativoResponsavel,
    prestador_interno,
    armadores,
    recinto_alfandegado,
    cod_recinto_alf,
    despachantes,
    id_reprvend,
    id_transp_padrao,
    taxa_spread,
    id_usuario,
    id_condicao_pagamento,
    id_tabela_padrao_forma_pagamento,	
    id_portador_cp,
    id_portador_cr,
    vlr_limite_credito,							   
    validade_limite_credito,  
    validade_consulta_credito,
    situacao_consulta_credito,
    dias_bloq_cliente_atraso,
    restricao_venda,
    incl_data,
    incl_user,
    incl_device,
    modi_data,
    modi_user,
    modi_device,
    excl_data,
    excl_user,
    excl_device,
    id_tipo_frete,
    dias_validade_consulta_credito,
    check_licencas_para_vendas,
    validade_licenca_pf,
    validade_vistoria_pc,
    validade_licenca_pc,
    industrializacao_por_encomenda,
	data_analise
From (
Select 
    cod_cligrupo = null,
    razao,
    ativo,
    descricao_bairro AS bairro,
    Cidades.codigo AS CODICIDADE,
    Fantasia,
    Paises.id_pais AS id_pais,
    cod_atividade = 7, --> Atividades = 7, transportadora
    endereco,
    end_complemento = null,
    cod_tipologradouro = null,
    end_numero = null,
    fato.cep AS cep,
    cliente = 'N',
    fornec = 'N',
    pessoa,
    transportadora = 'S',
    vendedor = 'N'	,
    cnpj,
    cpf,
    rg = Null,
    ie = Null,
    insmunicipal,
    telefone1,
    telefone2,
    celular = null,
    fax,
    cxpostal,
    web,
    email,
    Try_Convert(datetime, dt_cadastro) AS dt_abertura,
    NULL AS porte,
    Try_Convert(datetime, dt_cadastro) AS dt_nascto,
    suframa = null,
    contribuinte = null,
    retencao_iss = null,
    aliquota_iss = null,
    prospect = null,
    inscricao_produtorrural = null,
    emitir_cartacobranca = null,
    optante_sn = null,
    ie_nao_contribuinte = null,
    alccompras_permitealtfornec = null,
    end_latitude = null,
    end_longitude = null ,
    situacao_credito = null ,
    consentimento_lgpd = null,
    --cod_clifor AS cod_antigo,
    --Empresa AS cod_empresa,
    obs,
    Cidades.CODIUF AS CODIUF,
    Null As CODIBANCO,
    Null As RFBTipoMatrizFilial,
    Null As RFBPorteEmpresa,
    Null As RFBCNAEPrincipal,
    Null As RFBCNAESecundarios,
    Null As RFBSituacao,
    Null As RBFDataSituacaoCadastral,
    Null As RFBMotivoSituacaoCadastral,
    Null As RFBSituacaoEspecial,
    Null As RFBDataSituacaoEspecial,
    Null As RFBNaturezaJuridica,
    Null As RFBDataHoraConsulta,
    Null As RFBEnteFederativoResponsavel,
    Null As prestador_interno,
    Null As armadores,
    Null As recinto_alfandegado,
    Null As cod_recinto_alf,
    Null As despachantes,
    Null As id_reprvend,
    Null As id_transp_padrao,
    Null As taxa_spread,
    Null As id_usuario,
    Null As id_condicao_pagamento,
    Null As id_tabela_padrao_forma_pagamento,	
    Null As id_portador_cp,
    Null As id_portador_cr,
    convert(numeric(16,2),null) AS vlr_limite_credito,							   
    convert(date,null) AS validade_limite_credito,  
    convert(date,null) AS validade_consulta_credito,
    convert(int,null) AS dias_validade_consulta_credito,
    NULL AS situacao_consulta_credito,
	NULL AS data_analise,
    NULL AS dias_bloq_cliente_atraso,
    NULL AS restricao_venda,
    GETDATE() AS incl_data,
    'ksantana' AS incl_user,
    NULL As incl_device,
    NULL As modi_data,
    NULL As modi_user,
    NULL As modi_device,
    NULL As excl_data,
    NULL As excl_user,
    NULL As excl_device,
    NULL As id_tipo_frete,
    NULL As check_licencas_para_vendas,
    convert(date,null) AS validade_licenca_pf,
    convert(date,null) AS validade_vistoria_pc,
    convert(date,null) AS validade_licenca_pc,
    NULL AS industrializacao_por_encomenda,
	raz_representante =  null, 
	rw  = row_number() over ( partition by Dbo.Fn_Limpa_NoNum(Isnull(Fato.Cnpj,Fato.Cpf)) Order by Dt_Atualizacao Desc)
From #BaseClifor Fato
Left Join Paises		 ON Paises.cod_ibge			 = Fato.cod_ibge_pais			Collate latin1_general_ci_ai 
Left Join Cidades		 ON Cidades.CodIibge		 = Fato.Cod_Ibge_Cidade			Collate latin1_general_ci_ai 
--Left Join Grupo_Clientes ON Grupo_Clientes.descricao = Fato.descricao_grupo_cliente Collate latin1_general_ci_ai 
Where Not Exists (
				  Select *
				  From  Clifor Dim
				  Where Dbo.Fn_Limpa_NoNum(Isnull(Dim.Cnpj,Dim.Cpf)) = Dbo.Fn_Limpa_NoNum(Isnull(Fato.Cnpj,Fato.Cpf)) Collate latin1_general_ci_ai
				 )
) SubQuery
Where Rw = 1
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Popula Tabela Clifor Apenas Com o Diferencial	Por Razâo Social					*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Insert Into Clifor 
Select 
    cod_cligrupo,
    razao,
    ativo,
    bairro,
    CODICIDADE,
    Fantasia,
    id_pais,
    cod_atividade,
    endereco,
    end_complemento,
    cod_tipologradouro,
    end_numero,
    cep,
    cliente ,
    fornec  ,
    pessoa,
    transportadora  ,
    vendedor			,
    cnpj,
    cpf,
    rg ,
    ie,
    insmunicipal,
    telefone1,
    telefone2,
    celular = null,
    fax,
    cxpostal,
    web,
    email,
    dt_abertura ,
    porte ,
    dt_nascto,
    suframa						,
    contribuinte				,
    retencao_iss				,
    aliquota_iss				,
    prospect					,
    inscricao_produtorrural		,
    emitir_cartacobranca		,
    optante_sn					,
    ie_nao_contribuinte			,
    alccompras_permitealtfornec ,
    end_latitude				,
    end_longitude				,
    situacao_credito			,
    consentimento_lgpd			,
    obs,
    CODIUF ,
    CODIBANCO,
    RFBTipoMatrizFilial,
    RFBPorteEmpresa,
    RFBCNAEPrincipal,
    RFBCNAESecundarios,
    RFBSituacao,
    RBFDataSituacaoCadastral,
    RFBMotivoSituacaoCadastral,
    RFBSituacaoEspecial,
    RFBDataSituacaoEspecial,
    RFBNaturezaJuridica,
    RFBDataHoraConsulta,
    RFBEnteFederativoResponsavel,
    prestador_interno,
    armadores,
    recinto_alfandegado,
    cod_recinto_alf,
    despachantes,
    id_reprvend,
    id_transp_padrao,
    taxa_spread,
    id_usuario,
    id_condicao_pagamento,
    id_tabela_padrao_forma_pagamento,	
    id_portador_cp,
    id_portador_cr,
    vlr_limite_credito,							   
    validade_limite_credito,  
    validade_consulta_credito,
    situacao_consulta_credito,
    dias_bloq_cliente_atraso,
    restricao_venda,
    incl_data,
    incl_user,
    incl_device,
    modi_data,
    modi_user,
    modi_device,
    excl_data,
    excl_user,
    excl_device,
    id_tipo_frete,
    dias_validade_consulta_credito,
    check_licencas_para_vendas,
    validade_licenca_pf,
    validade_vistoria_pc,
    validade_licenca_pc,
    industrializacao_por_encomenda,
	data_analise
From (
Select 
    cod_cligrupo = null,
    razao,
    ativo,
    descricao_bairro AS bairro,
    Cidades.codigo AS CODICIDADE,
    Fantasia,
    Paises.id_pais AS id_pais,
    cod_atividade = 7, --> Atividades = 7, transportadora
    endereco,
    end_complemento = null,
    cod_tipologradouro = null,
    end_numero = null,
    fato.cep AS cep,
    cliente = 'N',
    fornec = 'N',
    pessoa,
    transportadora = 'S',
    vendedor = 'N'	,
    cnpj,
    cpf,
    rg = Null,
    ie = null,
    insmunicipal,
    telefone1,
    telefone2,
    celular = null,
    fax,
    cxpostal,
    web,
    email,
    Try_Convert(datetime, dt_cadastro) AS dt_abertura,
    NULL AS porte,
    Try_Convert(datetime, dt_cadastro) AS dt_nascto,
    suframa = null,
    contribuinte = null,
    retencao_iss = null,
    aliquota_iss = null,
    prospect = null,
    inscricao_produtorrural = null,
    emitir_cartacobranca = null,
    optante_sn = null,
    ie_nao_contribuinte = null,
    alccompras_permitealtfornec = null,
    end_latitude = null,
    end_longitude = null ,
    situacao_credito = null ,
    consentimento_lgpd = null,
    --cod_clifor AS cod_antigo,
    --Empresa AS cod_empresa,
    obs,
    Cidades.CODIUF AS CODIUF,
    Null As CODIBANCO,
    Null As RFBTipoMatrizFilial,
    Null As RFBPorteEmpresa,
    Null As RFBCNAEPrincipal,
    Null As RFBCNAESecundarios,
    Null As RFBSituacao,
    Null As RBFDataSituacaoCadastral,
    Null As RFBMotivoSituacaoCadastral,
    Null As RFBSituacaoEspecial,
    Null As RFBDataSituacaoEspecial,
    Null As RFBNaturezaJuridica,
    Null As RFBDataHoraConsulta,
    Null As RFBEnteFederativoResponsavel,
    Null As prestador_interno,
    Null As armadores,
    Null As recinto_alfandegado,
    Null As cod_recinto_alf,
    Null As despachantes,
    Null As id_reprvend,
    Null As id_transp_padrao,
    Null As taxa_spread,
    Null As id_usuario,
    Null As id_condicao_pagamento,
    Null As id_tabela_padrao_forma_pagamento,	
    Null As id_portador_cp,
    Null As id_portador_cr,
    convert(numeric(16,2),null) AS vlr_limite_credito,							   
    convert(date,null) AS validade_limite_credito,  
    convert(date,null) AS validade_consulta_credito,
    convert(int,null) AS dias_validade_consulta_credito,
    NULL AS situacao_consulta_credito,
	NULL AS data_analise,
    NULL AS dias_bloq_cliente_atraso,
    NULL AS restricao_venda,
    GETDATE() AS incl_data,
    'ksantana' AS incl_user,
    NULL As incl_device,
    NULL As modi_data,
    NULL As modi_user,
    NULL As modi_device,
    NULL As excl_data,
    NULL As excl_user,
    NULL As excl_device,
    NULL As id_tipo_frete,
    NULL As check_licencas_para_vendas,
    convert(date,null) AS validade_licenca_pf,
    convert(date,null) AS validade_vistoria_pc,
    convert(date,null) AS validade_licenca_pc,
    NULL AS industrializacao_por_encomenda,
	raz_representante =  null, 
	rw  = row_number() over ( partition by Dbo.Fn_Limpa_NoNum(Isnull(Fato.Cnpj,Fato.Cpf)) Order by Dt_Atualizacao Desc)
From #BaseClifor Fato
Left Join Paises		 ON Paises.cod_ibge			 = Fato.cod_ibge_pais			Collate latin1_general_ci_ai 
Left Join Cidades		 ON Cidades.CodIibge		 = Fato.Cod_Ibge_Cidade			Collate latin1_general_ci_ai 
--Left Join Grupo_Clientes ON Grupo_Clientes.descricao = Fato.descricao_grupo_cliente Collate latin1_general_ci_ai 
Where Not Exists (
				  Select *
				  From  Clifor Dim
				  Where Dim.razao = Fato.razao Collate latin1_general_ci_ai
				 )
And Isnull(Fato.Cnpj,Fato.Cpf) In ('00.000.000/0000-00','000.000.000-00')
) SubQuert
Where Rw = 1
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Adiciona Coluna de Razao do Representante Para Dar Update na Tabela Cidades		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Update CliFor
Set [id_reprvend] = CliFor.cod_clifor

From CliFor
Join #BaseClifor on #BaseClifor.razao collate latin1_general_ci_ai  = CliFor.razao collate latin1_general_ci_ai 
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Atualiza os Clientes Que Sâo Estrangeiros Com Seus Respectivos Codigos			*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Update Clifor Set CodiUf = 54Where Cnpj = '00.000.000/0000-00'Update Clifor Set CodiCidade = 5300117Where Cnpj = '00.000.000/0000-00'/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Segunda Validação na Tabela Fisica, Garantinfo que Siga o Layout					*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/Update Clifor
Set Cnpj = Case 
               When Cnpj Is Not Null And Cnpj != Dbo.FormatarCnpj(Cnpj) 
               Then Dbo.FormatarCnpj(Cnpj) 
               Else Cnpj 
           End,
    Cpf =  Case 
               When Cpf Is Not Null And Cpf   != Dbo.FormatarCpf(Cpf) 
               Then Dbo.FormatarCpf(Cpf) 
               Else Cpf 
           End
Where 
    (Cnpj Is Not Null And Cnpj != Dbo.FormatarCnpj(Cnpj))
    Or
    (Cpf  Is Not Null And Cpf  != Dbo.FormatarCpf(Cpf));
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Segunda Validação na Tabela Fisica, Garantinfo que Siga o Layout					*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
update fato
set transportadora = 'N'
,	vendedor       = 'S'

from clifor fato 
join #BaseClifor dim on  Dbo.Fn_Limpa_NoNum(Isnull(dim.Cnpj,dim.Cpf)) = Dbo.Fn_Limpa_NoNum(Isnull(Fato.Cnpj,Fato.Cpf))  Collate latin1_general_ci_ai 
					 and Isnull(fato.Cnpj,fato.Cpf) Not In ('00.000.000/0000-00','000.000.000-00')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Segunda Validação na Tabela Fisica, Garantinfo que Siga o Layout					*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
--> Não rodar, só foi 1 vez, para deixar ajustado, apenas que é os Vendedores.
--update fato
--set vendedor = 'N'
--from clifor fato
--left join #baseclifor dim 
--  on dbo.fn_limpa_nonum(isnull(dim.cnpj,dim.cpf)) = dbo.fn_limpa_nonum(isnull(fato.cnpj,fato.cpf))  collate latin1_general_ci_ai 
-- and isnull(fato.cnpj,fato.cpf) != '00.000.000/0000-00'
--where dim.cnpj is null;

SELECT *
FROM CLIFOR
WHERE razao = 'REPRESENTANTE'

update clifor
set vendedor = 'S'
where razao = 'representante'

update clifor
set transportadora = 'N'
where razao = 'representante'