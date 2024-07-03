

select *
into teste
from clifor 

insert into clifor
select 
	[cod_cligrupo]
,	[razao]
,	[ativo]
,	[bairro]
,	[CODICIDADE]
,	[fantasia]
,	[id_pais]
,	[cod_atividade]
,	[endereco]
,	[end_complemento]
,	[cod_tipologradouro]
,	[end_numero]
,	[cep]
,	[cliente]
,	[fornec]
,	[pessoa]
,	[transportadora]
,	[vendedor]
,	[cnpj]
,	[cpf]
,	[rg]
,	[ie]
,	[insmunicipal]
,	[telefone1]
,	[telefone2]
,	[celular]
,	[fax]
,	[cxpostal]
,	[web]
,	[email]
,	[dt_abertura]
,	[porte]
,	[dt_nascto]
,	[suframa]
,	[contribuinte]
,	[retencao_iss]
,	[aliquota_iss]
,	[prospect]
,	[inscricao_produtorrural]
,	[emitir_cartacobranca]
,	[optante_sn]
,	[ie_nao_contribuinte]
,	[alccompras_permitealtfornec]
,	[end_latitude]
,	[end_longitude]
,	[situacao_credito]
,	[consentimento_lgpd]
,	[obs]
,	[CODIUF]
,	[CODIBANCO]
,	[RFBTipoMatrizFilial]
,	[RFBPorteEmpresa]
,	[RFBCNAEPrincipal]
,	[RFBCNAESecundarios]
,	[RFBSituacao]
,	[RBFDataSituacaoCadastral]
,	[RFBMotivoSituacaoCadastral]
,	[RFBSituacaoEspecial]
,	[RFBDataSituacaoEspecial]
,	[RFBNaturezaJuridica]
,	[RFBDataHoraConsulta]
,	[RFBEnteFederativoResponsavel]
,	[prestador_interno]
,	[armadores]
,	[recinto_alfandegado]
,	[cod_recinto_alf]
,	[despachantes]
,	[id_reprvend]
,	[id_transp_padrao]
,	[taxa_spread]
,	[id_usuario]
,	[id_condicao_pagamento]
,	[id_tabela_padrao_forma_pagamento]
,	[id_portador_cp]
,	[id_portador_cr]
,	[vlr_limite_credito]
,	[validade_limite_credito]
,	[validade_consulta_credito]
,	[dias_validade_consulta_credito]
,	[situacao_consulta_credito]
,	[data_analise]
,	[dias_bloq_cliente_atraso]
,	[restricao_venda]
,	[incl_data]
,	[incl_user]
,	[incl_device]
,	[modi_data]
,	[modi_user]
,	[modi_device]
,	[excl_data]
,	[excl_user]
,	[excl_device]
,	[id_tipo_frete]
,	[check_licencas_para_vendas]
,	[validade_licenca_pf]
,	[validade_vistoria_pc]
,	[validade_licenca_pc]
,	[industrializacao_por_encomenda]
from (
select *
,   rw = row_number() over ( partition by isnull(fato.cnpj,fato.cpf) order by fato.cod_clifor asc)
from teste fato
where not exists (
				   select *
				   from clifor dim
				   where isnull(dim.cnpj,dim.cpf) = isnull(fato.cnpj,fato.cpf)
				 )
) Sb
Where rw = 1


---> SEGUNDA PARTE TIRANDO DUPLICADO DOS CASOS DE CPF E CNPJ '00.000.000/0000-00'
DROP TABLE IF EXISTS #clifor_unique;
CREATE TABLE #clifor_unique (
    Min_Cod_Clifor_Old INT,
    Cod_Clifor_New INT
);

WITH RankedClifor AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY 
                CASE 
                    WHEN CNPJ = '00.000.000/0000-00' THEN razao
                    ELSE ISNULL(CNPJ, CPF) 
                END 
            ORDER BY cod_clifor ASC
        ) AS rw
    FROM clifor
    --WHERE RAZAO = 'TECNOTEX IMPORT EXPORT'
),
Duplicates AS (
    SELECT 
        cod_clifor AS Min_Cod_Clifor_Old,
        MIN(cod_clifor) OVER (PARTITION BY 
                                CASE 
                                    WHEN CNPJ = '00.000.000/0000-00' THEN razao
                                    ELSE ISNULL(CNPJ, CPF) 
                                END) AS Cod_Clifor_New
    FROM RankedClifor
)

INSERT INTO #clifor_unique (Min_Cod_Clifor_Old, Cod_Clifor_New)
SELECT Min_Cod_Clifor_Old, Cod_Clifor_New
FROM Duplicates;



DELETE FROM clifor
WHERE cod_clifor IN (
    SELECT Min_Cod_Clifor_Old
    FROM #clifor_unique
	WHERE Min_Cod_Clifor_Old != Cod_Clifor_New
);



-- Atualizar Pagamentos_Contas
UPDATE pc
SET pc.cod_clifor = m.Cod_Clifor_New
FROM Pagamentos_Contas pc
JOIN #clifor_unique m ON pc.cod_clifor = m.Min_Cod_Clifor_Old

-- Atualizar Recebimentos_Contas (campo cod_clifor)
UPDATE rc
SET rc.cod_clifor = m.Cod_Clifor_New
FROM Recebimentos_Contas rc
JOIN #clifor_unique m ON rc.cod_clifor = m.Min_Cod_Clifor_Old;

-- Atualizar Recebimentos_Contas (campo id_repres)
UPDATE rc
SET rc.id_repres = m.Cod_Clifor_New
FROM Recebimentos_Contas rc
JOIN #clifor_unique m ON rc.id_repres = m.Min_Cod_Clifor_Old;

-- Atualizar Notas_Fiscais (campo id_clifor)
UPDATE nf
SET nf.id_clifor = m.Cod_Clifor_New
FROM Notas_Fiscais nf
JOIN #clifor_unique m ON nf.id_clifor = m.Min_Cod_Clifor_Old;

-- Atualizar Notas_Fiscais (campo id_representante_vendedor)
UPDATE nf
SET nf.id_representante_vendedor = m.Cod_Clifor_New
FROM Notas_Fiscais nf
JOIN #clifor_unique m ON nf.id_representante_vendedor = m.Min_Cod_Clifor_Old;

-- Atualizar Notas_Fiscais (campo id_transp)
UPDATE nf
SET nf.id_transp = m.Cod_Clifor_New
FROM Notas_Fiscais nf
JOIN #clifor_unique m ON nf.id_transp = m.Min_Cod_Clifor_Old;

-- Atualizar Notas_Fiscais (campo id_transp_redespacho)
UPDATE nf
SET nf.id_transp_redespacho = m.Cod_Clifor_New
FROM Notas_Fiscais nf
JOIN #clifor_unique m ON nf.id_transp_redespacho = m.Min_Cod_Clifor_Old;

-- Atualizar Notas_Fiscais (campo id_cliforopertriang)
UPDATE nf
SET nf.id_cliforopertriang = m.Cod_Clifor_New
FROM Notas_Fiscais nf
JOIN #clifor_unique m ON nf.id_cliforopertriang = m.Min_Cod_Clifor_Old;

-- Atualizar Compras_Pedidos (campo id_fornecedor)
UPDATE cp
SET cp.id_fornecedor = m.Cod_Clifor_New
FROM Compras_Pedidos cp
JOIN #clifor_unique m ON cp.id_fornecedor = m.Min_Cod_Clifor_Old;

-- Atualizar Compras_Pedidos (campo id_transportadora)
UPDATE cp
SET cp.id_transportadora = m.Cod_Clifor_New
FROM Compras_Pedidos cp
JOIN #clifor_unique m ON cp.id_transportadora = m.Min_Cod_Clifor_Old;

-- Atualizar Vendas_Pedidos (campo id_cliente)
UPDATE vp
SET vp.id_cliente = m.Cod_Clifor_New
FROM Vendas_Pedidos vp
JOIN #clifor_unique m ON vp.id_cliente = m.Min_Cod_Clifor_Old;

-- Atualizar Vendas_Pedidos (campo id_transportadora)
UPDATE vp
SET vp.id_transportadora = m.Cod_Clifor_New
FROM Vendas_Pedidos vp
JOIN #clifor_unique m ON vp.id_transportadora = m.Min_Cod_Clifor_Old;

-- Atualizar Vendas_Pedidos (campo id_representante)
UPDATE vp
SET vp.id_representante = m.Cod_Clifor_New
FROM Vendas_Pedidos vp
JOIN #clifor_unique m ON vp.id_representante = m.Min_Cod_Clifor_Old;

-- Atualizar Vendas_Pedidos (campo id_redespacho)
UPDATE vp
SET vp.id_redespacho = m.Cod_Clifor_New
FROM Vendas_Pedidos vp
JOIN #clifor_unique m ON vp.id_redespacho = m.Min_Cod_Clifor_Old;

-- Atualizar Compras_Importacoes (campo id_armador)
UPDATE ci
SET ci.id_armador = m.Cod_Clifor_New
FROM Compras_Importacoes ci
JOIN #clifor_unique m ON ci.id_armador = m.Min_Cod_Clifor_Old;

-- Atualizar Compras_Importacoes (campo id_recinto_alfandegado)
UPDATE ci
SET ci.id_recinto_alfandegado = m.Cod_Clifor_New
FROM Compras_Importacoes ci
JOIN #clifor_unique m ON ci.id_recinto_alfandegado = m.Min_Cod_Clifor_Old;

-- Atualizar Compras_Importacoes (campo id_despachante)
UPDATE ci
SET ci.id_despachante = m.Cod_Clifor_New
FROM Compras_Importacoes ci
JOIN #clifor_unique m ON ci.id_despachante = m.Min_Cod_Clifor_Old;

-- Atualizar Compras_Importacoes_Conteineres (campo id_transportadora)
UPDATE cic
SET cic.id_transportadora = m.Cod_Clifor_New
FROM Compras_Importacoes_Conteineres cic
JOIN #clifor_unique m ON cic.id_transportadora = m.Min_Cod_Clifor_Old;

-- Atualizar Compras_Importacoes_Despesas_LogStatus (campo cod_clifor)
UPDATE cidls
SET cidls.cod_clifor = m.Cod_Clifor_New
FROM Compras_Importacoes_Despesas_LogStatus cidls
JOIN #clifor_unique m ON cidls.cod_clifor = m.Min_Cod_Clifor_Old;

-- Atualizar Compras_Importacoes_Despesas_Previsoes (campo cod_clifor)
UPDATE cidp
SET cidp.cod_clifor = m.Cod_Clifor_New
FROM Compras_Importacoes_Despesas_Previsoes cidp
JOIN #clifor_unique m ON cidp.cod_clifor = m.Min_Cod_Clifor_Old;

-- Atualizar Itinerarios (campo id_armador)
UPDATE it
SET it.id_armador = m.Cod_Clifor_New
FROM Itinerarios it
JOIN #clifor_unique m ON it.id_armador = m.Min_Cod_Clifor_Old;

-- Atualizar Itinerarios (campo id_transportadora)
UPDATE it
SET it.id_transportadora = m.Cod_Clifor_New
FROM Itinerarios it
JOIN #clifor_unique m ON it.id_transportadora = m.Min_Cod_Clifor_Old;

-- Atualizar Itinerarios (campo cod_clifor)
UPDATE it
SET it.cod_clifor = m.Cod_Clifor_New
FROM Itinerarios it
JOIN #clifor_unique m ON it.cod_clifor = m.Min_Cod_Clifor_Old;

-- Atualizar Itinerario_Despesas (campo id_clifor)
UPDATE id
SET id.id_clifor = m.Cod_Clifor_New
FROM Itinerario_Despesas id
JOIN #clifor_unique m ON id.id_clifor = m.Min_Cod_Clifor_Old;

-- Atualizar Tarifario_Outros (campo id_clifor)
UPDATE tos
SET tos.id_clifor = m.Cod_Clifor_New
FROM Tarifario_Outros tos
JOIN #clifor_unique m ON tos.id_clifor = m.Min_Cod_Clifor_Old;

-- Atualizar Clifor_SERASA (campo cod_clifor)
UPDATE cs
SET cs.cod_clifor = m.Cod_Clifor_New
FROM Clifor_SERASA cs
JOIN #clifor_unique m ON cs.cod_clifor = m.Min_Cod_Clifor_Old;

-- Atualizar clifor_natoper (campo cod_clifor)
UPDATE cn
SET cn.cod_clifor = m.Cod_Clifor_New
FROM clifor_natoper cn
JOIN #clifor_unique m ON cn.cod_clifor = m.Min_Cod_Clifor_Old;

-- Atualizar CliFor_Bancos (campo id_clifor)
UPDATE cb
SET cb.id_clifor = m.Cod_Clifor_New
FROM CliFor_Bancos cb
JOIN #clifor_unique m ON cb.id_clifor = m.Min_Cod_Clifor_Old;

-- Atualizar CliFor_ChavePix (campo id_clifor)
UPDATE cpx
SET cpx.id_clifor = m.Cod_Clifor_New
FROM CliFor_ChavePix cpx
JOIN #clifor_unique m ON cpx.id_clifor = m.Min_Cod_Clifor_Old;

-- Atualizar CliFor_Contatos (campo cod_clifor)
UPDATE cc
SET cc.cod_clifor = m.Cod_Clifor_New
FROM CliFor_Contatos cc
JOIN #clifor_unique m ON cc.cod_clifor = m.Min_Cod_Clifor_Old;

-- Atualizar Frete_Tabelas (campo id_clifor)
UPDATE ft
SET ft.id_clifor = m.Cod_Clifor_New
FROM Frete_Tabelas ft
JOIN #clifor_unique m ON ft.id_clifor = m.Min_Cod_Clifor_Old;

-- Atualizar Itens_Fornec (campo cod_clifor)
UPDATE ifn
SET ifn.cod_clifor = m.Cod_Clifor_New
FROM Itens_Fornec ifn
JOIN #clifor_unique m ON ifn.cod_clifor = m.Min_Cod_Clifor_Old;

-- Atualizar Estoque_Movimentos (campo id_clifor)
UPDATE em
SET em.id_clifor = m.Cod_Clifor_New
FROM Estoque_Movimentos em
JOIN #clifor_unique m ON em.id_clifor = m.Min_Cod_Clifor_Old;

-- Atualizar Parametros_Imp_Financeiros (campo clifor_impfederal)
UPDATE pif
SET pif.clifor_impfederal = m.Cod_Clifor_New
FROM Parametros_Imp_Financeiros pif
JOIN #clifor_unique m ON pif.clifor_impfederal = m.Min_Cod_Clifor_Old;

-- Atualizar Tarifario_Transportadores (campo id_clifor)
UPDATE tt
SET tt.id_clifor = m.Cod_Clifor_New
FROM Tarifario_Transportadores tt
JOIN #clifor_unique m ON tt.id_clifor = m.Min_Cod_Clifor_Old;

-- Atualizar Terminais_Alfandegados (campo id_clifor)
UPDATE ta
SET ta.id_clifor = m.Cod_Clifor_New
FROM Terminais_Alfandegados ta
JOIN #clifor_unique m ON ta.id_clifor = m.Min_Cod_Clifor_Old;

-- Atualizar Estoque_carga_ret_ind (campo cod_clifor)
UPDATE ecri
SET ecri.cod_clifor = m.Cod_Clifor_New
FROM Estoque_carga_ret_ind ecri
JOIN #clifor_unique m ON ecri.cod_clifor = m.Min_Cod_Clifor_Old;

-- Atualizar Vendas_Historico_An_Cred (campo ID_CLIENTE)
UPDATE vhac
SET vhac.ID_CLIENTE = m.Cod_Clifor_New
FROM Vendas_Historico_An_Cred vhac
JOIN #clifor_unique m ON vhac.ID_CLIENTE = m.Min_Cod_Clifor_Old;


-- Atualizar Vendas_Historico_An_Cred (campo ID_CLIENTE)
UPDATE Compras_Cotacoes
SET id_fornecedor = m.Cod_Clifor_New
FROM Compras_Cotacoes
JOIN #clifor_unique m ON Compras_Cotacoes.id_fornecedor = m.Min_Cod_Clifor_Old;


update [CliFor_Contatos]set cod_clifor = 423673where cod_clifor in (423859)select distinct cod_cliforfrom [Pagamentos_Contas] fatowhere not exists (					select *					from clifor dim					where dim.cod_clifor = fato.cod_clifor				 )