
Use Thesys_Dev
Go

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* Programador: Kaike Natan																		*/
/* Versao     : Data: 07/06/2024																*/
/* Descricao  : Script De ETL Da Tabela Clifor do MBM Para o TheSys								*/
/*																								*/
/* Alteracao																					*/
/*        2. Programador:                                                  Data: __/__/____		*/        
/*           Descricao  :																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	Alter Procedure [dbo].[Prc_Etl_Clifor_MBM] As
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Base MBM Dos Clifors																*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
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
left join grupo_cliente on grupo_cliente.cod_grpcliente	= Clifor.cod_grpcliente')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Adiciona Coluna de Razao Representante Para Dar Update Coluna Id_Repre Venda		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
If Not Exists (
				Select 1 
				From Information_Schema.Columns 
				Where Table_Name = 'clifor' 
				And Column_Name  = 'raz_representante'
			  )
Begin
	Alter table Clifor
	Add Raz_Representante Varchar(Max);
End
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Popula Tabela Clifor Apenas Com o Diferencial										*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Insert Into Clifor
Select 
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
    Iif(cod_transp IS NULL, 'N', 'S') As transportadora,
    Iif(Cod_Repres IS NULL, 'N', 'S') As vendedor,
    Iif(Pessoa = 'J', cgc_cpf, NULL)  As cnpj,
    Iif(Pessoa = 'F', cgc_cpf, NULL)  As cpf,
    Iif(Pessoa = 'F', ie_rg, NULL)    As rg,
    Iif(Pessoa = 'J', ie_rg, NULL)    As ie,
    insmunicipal,
    telefone1,
    telefone2,
    celular,
    fax,
    cxpostal,
    web,
    email,
    Try_Convert(datetime, dt_cadastro) AS dt_abertura,
    NULL AS porte,
    Try_Convert(datetime, dt_nascto) AS dt_nascto,
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
	raz_representante =  null
From #BaseClifor Fato
Left Join Paises		 ON Paises.cod_ibge			 = Fato.cod_ibge_pais			Collate latin1_general_ci_ai 
Left Join Cidades		 ON Cidades.CodIibge		 = Fato.Cod_Ibge_Cidade			Collate latin1_general_ci_ai 
Left Join Grupo_Clientes ON Grupo_Clientes.descricao = Fato.descricao_grupo_cliente Collate latin1_general_ci_ai 
Where Not Exists (
				  Select *
				  From  clifor dim
				  Where dim.cod_antigo = fato.cod_clifor COLLATE latin1_general_ci_ai
				 )
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Adiciona Coluna de Razao do Representante Para Dar Update na Tabela Cidades		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Update CliFor
Set [id_reprvend] = CliFor.cod_clifor

From CliFor
Join #BaseClifor on #BaseClifor.raz_representante collate latin1_general_ci_ai  = CliFor.razao collate latin1_general_ci_ai 
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Atualiza a Coluna id_clifor_impmunicipal da Tabela de Cidades						*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Update Cidades
Set id_clifor_impmunicipal = clifor.cod_clifor

From Cidades
Join CliFor on CliFor.Codicidade = Cidades.Codigo