CREATE OR ALTER TRIGGER [dbo].[trg_UpdateCamposChaves_CTe]
ON [dbo].[Notas_Fiscais_CTE_XML]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Atualizações existentes para INSERT e UPDATE
    WITH XMLNAMESPACES ('http://www.portalfiscal.inf.br/cte' AS ns)
    UPDATE ct
    SET 
       --    id_nota_fiscal = 
        dhEmi = ct.ArquivoXML.value('(/ns:cteProc/ns:CTe/ns:infCte/ns:ide/ns:dhEmi)[1]', 'date'),
        Chave_CTe = SUBSTRING(ct.ArquivoXML.value('(/ns:cteProc/ns:CTe/ns:infCte/@Id)[1]', 'nvarchar(47)'), 4, 44),
        emit_nome = ct.ArquivoXML.value('(/ns:cteProc/ns:CTe/ns:infCte/ns:emit/ns:xNome)[1]', 'nvarchar(60)'),
        cMun_Origem = ct.ArquivoXML.value('(/ns:cteProc/ns:CTe/ns:infCte/ns:rem/ns:enderReme/ns:cMun)[1]', 'int'),
        cMun_Destino = ct.ArquivoXML.value('(/ns:cteProc/ns:CTe/ns:infCte/ns:dest/ns:enderDest/ns:cMun)[1]', 'int'),
        valor_frete = ct.ArquivoXML.value('(/ns:cteProc/ns:CTe/ns:infCte/ns:vPrest/ns:vRec)[1]', 'numeric(16,2)'),
        peso_bruto = ct.ArquivoXML.value('(/ns:cteProc/ns:CTe/ns:infCte/ns:infCTeNorm/ns:infCarga/ns:infQ[ns:tpMed="PESO BRUTO"]/ns:qCarga)[1]', 'decimal(15,4)'),
        cnpj_tomador = CASE
            WHEN ct.ArquivoXML.exist('(/ns:cteProc/ns:CTe/ns:infCte/ns:ide/ns:toma3)[1]') = 1 THEN
                CASE ct.ArquivoXML.value('(/ns:cteProc/ns:CTe/ns:infCte/ns:ide/ns:toma3/ns:toma)[1]', 'int')
                    WHEN 0 THEN ct.ArquivoXML.value('(/ns:cteProc/ns:CTe/ns:infCte/ns:rem/ns:CNPJ)[1]', 'nvarchar(14)')
                    WHEN 1 THEN ct.ArquivoXML.value('(/ns:cteProc/ns:CTe/ns:infCte/ns:exped/ns:CNPJ)[1]', 'nvarchar(14)')
                    WHEN 2 THEN ct.ArquivoXML.value('(/ns:cteProc/ns:CTe/ns:infCte/ns:receb/ns:CNPJ)[1]', 'nvarchar(14)')
                    WHEN 3 THEN ct.ArquivoXML.value('(/ns:cteProc/ns:CTe/ns:infCte/ns:dest/ns:CNPJ)[1]', 'nvarchar(14)')
                END
            WHEN ct.ArquivoXML.exist('(/ns:cteProc/ns:CTe/ns:infCte/ns:ide/ns:toma4)[1]') = 1 THEN
                ct.ArquivoXML.value('(/ns:cteProc/ns:CTe/ns:infCte/ns:ide/ns:toma4/ns:CNPJ)[1]', 'nvarchar(14)')
        END,
        Tomador_Nome = CASE
            WHEN ct.ArquivoXML.exist('(/ns:cteProc/ns:CTe/ns:infCte/ns:ide/ns:toma3)[1]') = 1 THEN
                CASE ct.ArquivoXML.value('(/ns:cteProc/ns:CTe/ns:infCte/ns:ide/ns:toma3/ns:toma)[1]', 'int')
                    WHEN 0 THEN ct.ArquivoXML.value('(/ns:cteProc/ns:CTe/ns:infCte/ns:rem/ns:xNome)[1]', 'nvarchar(60)')
                    WHEN 1 THEN ct.ArquivoXML.value('(/ns:cteProc/ns:CTe/ns:infCte/ns:exped/ns:xNome)[1]', 'nvarchar(60)')
                    WHEN 2 THEN ct.ArquivoXML.value('(/ns:cteProc/ns:CTe/ns:infCte/ns:receb/ns:xNome)[1]', 'nvarchar(60)')
                    WHEN 3 THEN ct.ArquivoXML.value('(/ns:cteProc/ns:CTe/ns:infCte/ns:dest/ns:xNome)[1]', 'nvarchar(60)')
                END
            WHEN ct.ArquivoXML.exist('(/ns:cteProc/ns:CTe/ns:infCte/ns:ide/ns:toma4)[1]') = 1 THEN
                ct.ArquivoXML.value('(/ns:cteProc/ns:CTe/ns:infCte/ns:ide/ns:toma4/ns:xNome)[1]', 'nvarchar(60)')
        END
    FROM inserted i
    JOIN [dbo].[Notas_Fiscais_CTE_XML] ct ON i.id_xml = ct.id_xml;

    -- Inserção das chaves das NF-e apenas para operações de INSERT
    IF NOT EXISTS (SELECT * FROM deleted)
    BEGIN
        WITH XMLNAMESPACES ('http://www.portalfiscal.inf.br/cte' AS ns)
        INSERT INTO [dbo].[Notas_Fiscais_CTe_Chaves] (id_xml_cte, id_nota_fiscal, chave_nfe)
        SELECT
            i.id_xml,
            nf.id_nota_Fiscal,
            x.chave.value('.', 'varchar(44)') AS chave_nfe
        FROM
            inserted i
        CROSS APPLY i.ArquivoXML.nodes('/ns:cteProc/ns:CTe/ns:infCte/ns:infCTeNorm/ns:infDoc/ns:infNFe/ns:chave') AS x (chave)
        LEFT JOIN notas_fiscais nf ON nf.nfe_chaveacesso = x.chave.value('.', 'varchar(44)');
    END
END