
-- Programador: Kaike Natan
-- Data: 2023-06-30
-- Version: 1.0
-- Descriçâo: Responsável Por Levantar As Informaçôes Analiticas De Qualquer Projeto Da Assessoria.

CREATE OR ALTER FUNCTION dbo.Fnc_Busca_Contrato (
    @CONTR_CON VARCHAR (50), 
    @STDEV_CON CHAR(1)
)
RETURNS TABLE AS RETURN
(
    SELECT 
        IDEMP_CON,
        RAZAO_EMP,
        CGCPF_DEV,
        NOME_DEV,
        GENERO_DEV = CASE 
                        WHEN GENERO_DEV = '0' THEN 'Não Informado'
                        WHEN GENERO_DEV = '1' THEN 'Masculino' 
                        WHEN GENERO_DEV = '2' THEN 'Feminino' 
                        ELSE '' 
                     END,
        TPPES_DEV = CASE 
                        WHEN TPPES_DEV = '0' THEN 'Física'
                        WHEN TPPES_DEV = '1' THEN 'Jurídica'
                        ELSE ''
                    END,
        DTNAS_DEV,
        ESTCI_DEV = CASE 
                        WHEN ESTCI_DEV = '0' THEN 'Não Informado' 
                        WHEN ESTCI_DEV = '1' THEN 'Solteiro'
                        WHEN ESTCI_DEV = '2' THEN 'Casado'
                        WHEN ESTCI_DEV = '3' THEN 'Separado' 
                        WHEN ESTCI_DEV = '4' THEN 'Divorciado' 
                        WHEN ESTCI_DEV = '5' THEN 'Viúvo' 
                        ELSE '' 
                    END,
        IDCON_CON,
        CONTR_CON,
        NUCON_CON,
        CARGO_CON AS CARGO,
        RENDA = MERCA_CON,
        INFOR_CON AS FASE,
        DTINC_CON AS DT_ENTR_ASSESSORIA,
        DESCR_SEG AS SEGMENTACAO_CONTR,
        STDEV_CON,
        DESCR_SIT AS SITUACAO,
        DTDEV_CON,
        DTAGE_CON,
        DTATR_CON,
        NDIAS_CON AS DIAS_EM_ATRASO,
        DATEDIFF(DAY, DTATR_CON, CONVERT(DATE, GETDATE())) AS DIAS_DE_ENQUADRAMENTO,
        VLSAL_CON,
        VLMAC_CON,
        DTIMP_CON AS DT_IMP_NECTAR,
        ARQOR_CON AS CARGA_DO_CONTRATO,
        TITULOS_VENCIDOS,
        TITULOS_A_VENCER,
        NCONTRATOS,
        ULT_PGD_INDIRETO,
        VL_ULT_PGD_INDIRETO
    FROM  TB_CONTRATO WITH (NOLOCK)
    JOIN  TB_DEVEDOR WITH (NOLOCK) ON IDDEV_DEV = IDDEV_CON
    JOIN  TB_EMPRESA WITH (NOLOCK) ON IDEMP_CON = IDEMP_EMP
    JOIN  TB_SITUACAO WITH (NOLOCK) ON IDSIT_SIT = IDSIT_CON
    JOIN  TB_SEGMENTACAO WITH (NOLOCK) ON IDSEG_SEG = IDSEG_CON
    OUTER APPLY (
        SELECT COUNT(*) AS TITULOS_VENCIDOS 
        FROM TB_TRANSACAO WITH (NOLOCK) 
        WHERE IDCON_TRA = IDCON_CON
        AND CAST(DTFAT_TRA AS DATE) < CAST(GETDATE() AS DATE)
    ) VENCIDO
    OUTER APPLY (
        SELECT COUNT(*) AS TITULOS_A_VENCER 
        FROM TB_TRANSACAO WITH (NOLOCK) 
        WHERE IDCON_TRA = IDCON_CON
        AND CAST(DTFAT_TRA AS DATE) >= CAST(GETDATE() AS DATE)
    ) A_VENCER
    OUTER APPLY (
        SELECT COUNT(*) AS NCONTRATOS
        FROM TB_CONTRATO WITH (NOLOCK)
        WHERE CONTR_CON = @CONTR_CON
    ) N_CONTRATOS
    OUTER APPLY (
        SELECT TOP 1 DTPAG_PGD AS ULT_PGD_INDIRETO
        FROM TB_PAGDIRETO WITH (NOLOCK) 
        WHERE IDCON_CON = IDCON_PGD 
        ORDER BY DTPAG_PGD DESC
    ) PG_INDIRE
    OUTER APPLY (
        SELECT TOP 1 SUM(VLPAG_PGD) AS VL_ULT_PGD_INDIRETO
        FROM TB_PAGDIRETO WITH (NOLOCK) 
        WHERE IDCON_CON = IDCON_PGD 
        AND DTPAG_PGD = (
            SELECT MAX(DTPAG_PGD)
            FROM TB_PAGDIRETO WITH (NOLOCK) 
            WHERE IDCON_CON = IDCON_PGD 
            AND IDEMP_CON = 17
        )
    ) PG_INDIRETO
    WHERE CONTR_CON = @CONTR_CON
    AND STDEV_CON = @STDEV_CON
)


--> Exemplo De Chamada da Function

--SELECT *
--FROM dbo.Fnc_Busca_Contrato('28306276876', '0');