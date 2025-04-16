

DROP TABLE IF EXISTS #Temp_Bancos_Tratado
CREATE TABLE #Temp_Bancos_Tratado (
    Id_bancos_mov INT,
    historico_livre_tratado VARCHAR(1000),  -- Ajuste o tamanho conforme necessário
    valor DECIMAL(18, 2)
);


INSERT INTO #Temp_Bancos_Tratado (Id_bancos_mov, historico_livre_tratado, valor)
SELECT 
    Id_bancos_mov,
    -- Tratamento para capturar apenas o "RECEB NF - TÍTULO/PARCELA" sem o excesso de "-"
    'RECEB NF - ' + 
    SUBSTRING(
        REPLACE(LTRIM(REPLACE(historico_livre, '-', '')), ' ', ''),  -- Remove espaços e "-" extras
        CHARINDEX('RECEB NF -', historico_livre) + 10,
        CHARINDEX('/', REPLACE(LTRIM(REPLACE(historico_livre, '-', '')), ' ', ''), CHARINDEX('RECEB NF -', historico_livre)) 
        - CHARINDEX('RECEB NF -', historico_livre) - 7
    ) AS historico_livre_tratado,
	--historico_livre,
    valor
FROM Bancos_Movimentacoes
WHERE historico_livre LIKE 'RECEB NF -%';



DROP TABLE IF EXISTS #Temp_Recebimentos_Tratado;
CREATE TABLE #Temp_Recebimentos_Tratado (
    id_receb_Mov Int Not Null,
    Id_bancos_Mov INT,
    historico_pad_tratado VARCHAR(1000),  -- Ajuste o tamanho conforme necessário
    valor DECIMAL(18, 2)
);

INSERT INTO #Temp_Recebimentos_Tratado (id_receb_Mov, Id_bancos_Mov, historico_pad_tratado, valor)
SELECT 
    id_receb_mov,
    Id_bancos_Mov,
    -- Extração para garantir o formato "RECEB NF - TÍTULO/PARCELA" sem espaços extras
    'RECEB NF - ' + 
    SUBSTRING(
        REPLACE(LTRIM(REPLACE(historico_pad, '-', '')), ' ', ''),  -- Remove espaços e "-" extras
        CHARINDEX('RECEB NF -', historico_pad) + 10,
        CHARINDEX('/', REPLACE(LTRIM(REPLACE(historico_pad, '-', '')), ' ', ''), CHARINDEX('RECEB NF -', historico_pad)) 
        - CHARINDEX('RECEB NF -', historico_pad) - 7
    ) AS historico_livre_tratado,
	--historico_pad,
    valor
FROM Recebimentos_Contas_Mov
WHERE CONVERT(DATE, incl_data) >= '2024-10-02'
  AND id_bancos_mov IS NULL
  AND movimento IN ('LIQUIDAÇÃO - BAIXA TOTAL', '+BAIXA TOTAL( CONTABIL )', '-BAIXA PARCIAL( CONTABIL )')
  --AND PK IS NULL
  AND historico_pad LIKE 'RECEB NF -%';

Update Cr
Set Id_bancos_Mov = Bv.Id_bancos_mov

From #Temp_Recebimentos_Tratado Cr
Join #Temp_Bancos_Tratado		Bv On Bv.historico_livre_tratado = Cr.historico_pad_tratado

begin tran
update Fato
set id_bancos_mov = Dim.Id_bancos_Mov

from Recebimentos_Contas_Mov    Fato
Join #Temp_Recebimentos_Tratado Dim On Dim.id_receb_Mov = Fato.id_receb_mov
where convert(date, incl_data) >= '2024-10-02'
  and fato.id_bancos_mov is null
  and movimento in ('liquidação - baixa total', '+baixa total( contabil )', '-baixa parcial( contabil )')
  --and pk is null
  and historico_pad like 'receb nf -%';

commit







  update #Temp_Recebimentos_Tratado
  set historico_pad_tratado = 'RECEB NF - 34713/1'
  
  where historico_pad_tratado = 'RECEB NF - 13/1/'