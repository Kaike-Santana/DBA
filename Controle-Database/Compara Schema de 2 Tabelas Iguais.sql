-- No SSMS ou similar, rode no contexto do seu servidor (pode ser master mesmo),
-- pois consultaremos ambos os bancos.

IF OBJECT_ID('tempdb..#dev_cols') IS NOT NULL DROP TABLE #dev_cols;
IF OBJECT_ID('tempdb..#hom_cols') IS NOT NULL DROP TABLE #hom_cols;

-- Coleta colunas do DEV
SELECT 
    c.name AS column_name,
    t.name AS data_type,
    c.max_length,
    c.precision,
    c.scale,
    c.is_nullable,
    DB_NAME() AS db_name,        -- apenas para referência
    'dbo'      AS schema_name,   -- ajuste se não for dbo
    'Notas_Fiscais_Itens' AS table_name
INTO #dev_cols
FROM thesys_dev.sys.columns c
JOIN thesys_dev.sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('thesys_dev.dbo.Notas_Fiscais_Itens')
-- ORDER BY c.column_id;  -- se quiser ver a ordem

-- Coleta colunas do HOMOLOG
SELECT 
    c.name AS column_name,
    t.name AS data_type,
    c.max_length,
    c.precision,
    c.scale,
    c.is_nullable,
    DB_NAME() AS db_name,        
    'dbo'      AS schema_name,   
    'Notas_Fiscais_Itens' AS table_name
INTO #hom_cols
FROM thesys_homologacao.sys.columns c
JOIN thesys_homologacao.sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('thesys_homologacao.dbo.Notas_Fiscais_Itens');

SELECT 
    'ALTER TABLE ' 
        + QUOTENAME(h.schema_name) + '.' 
        + QUOTENAME(h.table_name)
        + ' ALTER COLUMN '
        + QUOTENAME(h.column_name) + ' '
        + CASE 
            WHEN d.data_type IN ('numeric','decimal') 
                 AND d.data_type = h.data_type  -- ambos numeric/decimal
            THEN d.data_type + '(' 
                        + CAST(d.precision AS varchar(3)) + ',' 
                        + CAST(d.scale AS varchar(3)) + ')'
            
            -- Se quiser tratar outro tipo no dev (ex: varchar) vs numeric no hom,
            -- seria preciso mais lógica, ex:
            WHEN d.data_type IN ('numeric','decimal') 
                 AND h.data_type NOT IN ('numeric','decimal')
            THEN d.data_type + '(' 
                        + CAST(d.precision AS varchar(3)) + ',' 
                        + CAST(d.scale AS varchar(3)) + ')'
            -- etc...
            
            ELSE d.data_type  -- fallback (mas no seu caso pode focar em numeric)
          END
        + CASE WHEN d.is_nullable = 1 THEN ' NULL' ELSE ' NOT NULL' END
        + ';'  AS AlterScript
FROM #dev_cols d
JOIN #hom_cols h
    ON d.column_name = h.column_name
    -- Mesma tabela, se estiver comparando apenas 1 tabela, está ok
    AND d.table_name = h.table_name
    AND d.schema_name = h.schema_name
WHERE 
    -- precisamos garantir que H e D sejam numeric ou decimal quando formos alterar
    (
        d.data_type IN ('numeric','decimal')
        OR h.data_type IN ('numeric','decimal')
    )
    AND (
        d.data_type <> h.data_type
        OR d.precision <> h.precision
        OR d.scale     <> h.scale
        OR d.is_nullable <> h.is_nullable
    );




