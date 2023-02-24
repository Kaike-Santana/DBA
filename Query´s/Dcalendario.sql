

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* PROGRAMADOR: KAIKE NATAN									                                    */
/* VERSAO     : DATA: 16/09/2022																*/
/* DESCRICAO  : SCRIPT SAPEKA QUE ALIMENTA D CALENDARIO											*/
/*																								*/
/*	ALTERACAO                                                                                   */
/*        2. PROGRAMADOR: 													 DATA: __/__/____	*/		
/*           DESCRICAO  :  			 															*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: TABELA FERIADO																    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS FERIADO
CREATE TABLE DBO.FERIADO (
     DATA DATE NOT NULL,
     ABRANGENCIA CHAR(1) NOT NULL 
       CHECK (ABRANGENCIA IN ('M', 'E', 'N')), 
     ORIGEM CHAR(1) NOT NULL 
       CHECK (ORIGEM IN ('R','C')), -- RELIGIOSO OU CIVIL
     TIPO CHAR(1) NOT NULL 
       CHECK (TIPO IN ('F', 'M')), -- FIXO OU MÓVEL
     DESCRICAO VARCHAR(80) NOT NULL,
     CONSTRAINT PK_FERIADO PRIMARY KEY (DATA, ABRANGENCIA)
);
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: INSERE FERIADOS NACIONAIS 													    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
INSERT INTO DBO.FERIADO (DATA, ABRANGENCIA, ORIGEM, TIPO, DESCRICAO) 
VALUES 
     -- NACIONAIS
     ('2020/01/01', 'N', 'C', 'F', 'CONFRATERNIZAÇÃO UNIVERSAL'),
     ('2020/04/21', 'N', 'C', 'F', 'TIRADENTES'),
     ('2020/05/01', 'N', 'C', 'F', 'DIA DO TRABALHO'),
     ('2020/07/09', 'N', 'C', 'F', 'INDEPENDÊNCIA DO BRASIL'),
     ('2020/10/12', 'N', 'R', 'F', 'N. S. APARECIDA'),
     ('2020/11/02', 'N', 'C', 'F', 'FINADOS'),
     ('2020/11/15', 'N', 'C', 'F', 'PROCLAMAÇÃO DA REPÚBLICA'),
     ('2020/12/25', 'N', 'R', 'F', 'NATAL')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: REPETE FERIADOS FIXOS POR 29 ANOS 											    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
WITH GETNUMS (N) AS (
SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL))
  FROM (VALUES (0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) AS A(N)
       CROSS JOIN (VALUES (0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) AS B(N)
       CROSS JOIN (VALUES (0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) AS C(N)
)
INSERT INTO DBO.FERIADO 
            (DATA, ABRANGENCIA, ORIGEM, TIPO, DESCRICAO)
  SELECT DATEADD (YEAR, +N.N, F.DATA), 
         F.ABRANGENCIA, F.ORIGEM, F.TIPO, F.DESCRICAO
  FROM DBO.FERIADO AS F
       CROSS JOIN GETNUMS AS N
  WHERE N.N <= 29
        AND F.TIPO = 'F';

-- ACRESCENTA FERIADOS MÓVEIS QUE DEPENDEM DA PÁSCOA
DECLARE @A   INTEGER, 
		@B   INTEGER, 
		@C   INTEGER, 
		@D   INTEGER, 
        @E   INTEGER, 
		@F   INTEGER, 
		@G   INTEGER,
		@H   INTEGER, 
        @I   INTEGER, 
		@K   INTEGER, 
		@L   INTEGER,
		@M   INTEGER,
        @ANO INTEGER, 
		@MES INTEGER, 
		@DIA INTEGER
SET @ANO= 2020;

WHILE (@ANO < 2050)
  BEGIN 
  SET @A = @ANO % 19;
  SET @B = @ANO / 100;
  SET @C = @ANO % 100;
  SET @D = @B / 4;
  SET @E = @B % 4;
  SET @F = (@B + 8) / 25;
  SET @G = (@B - @F + 1) / 3;
  SET @H = (19 * @A + @B - @D - @G + 15) % 30;
  SET @I = @C / 4;
  SET @K = @C % 4;
  SET @L = (32 + 2 * @E + 2 * @I - @H - @K) % 7;
  SET @M = (@A + 11 * @H + 22 * @L) / 451;

  SET @MES = (@H + @L - 7 * @M + 114) / 31;
  SET @DIA = 1+ (@H + @L - 7 * @M + 114) % 31;

  -- FERIADOS MÓVEIS (NACIONAIS, ESTADUAIS E MUNICIPAIS)
  INSERT INTO DBO.FERIADO 
              (DATA, ABRANGENCIA, ORIGEM, TIPO, DESCRICAO)
    VALUES
       -- NACIONAIS
       (DATEADD (DAY, -2, DATEFROMPARTS (@ANO, @MES, @DIA)),
        'N', 'R', 'M', 'PAIXÃO DE CRISTO'),
       -- MUNICIPAIS, DE BELO HORIZONTE
       (DATEADD (DAY, -2, DATEFROMPARTS (@ANO, @MES, @DIA)),
        'M', 'R', 'M', 'SEXTA-FEIRA SANTA'),
       (DATEADD (DAY, +60, DATEFROMPARTS (@ANO, @MES, @DIA)),
        'M', 'R', 'M', 'CORPUS CHRISTI');

  -- PRÓXIMO ANO
  SET @ANO+= 1;
END;
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: CRIA TABELA CALENDARIO														    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS CALENDARIO
CREATE TABLE DBO.CALENDARIO (
     DATA DATE NOT NULL,
     DIA AS CAST (DATEPART (DAY, DATA)   AS TINYINT) PERSISTED,
     MES AS CAST (DATEPART (MONTH, DATA) AS TINYINT) PERSISTED,
     ANO AS CAST (DATEPART (YEAR, DATA)  AS SMALLINT) PERSISTED,
     DIA_SEMANA VARCHAR(20) NOT NULL,
     SEMANA_ANO TINYINT NOT NULL,
     DIA_UTIL BIT NOT NULL DEFAULT 1,
     FERIADO BIT NOT NULL DEFAULT 0,
     CONSTRAINT PK_CALENDARIO PRIMARY KEY (DATA)
);

DECLARE @DATAINICIAL DATE, @DATAFINAL DATE;
SET @DATAINICIAL = CONVERT (DATE, '1/1/2020', 103);
SET @DATAFINAL   = CONVERT (DATE, '31/12/2049', 103);

--
DECLARE @DIAS INTEGER;
SET @DIAS= DATEDIFF (DAY, @DATAINICIAL, @DATAFINAL) +1;

SET DATEFIRST 7; -- SEMANA COMEÇA NO DOMINGO
SET LANGUAGE BRAZILIAN; -- DATENAME RETORNAR EM PORTUGUÊS
SET NOCOUNT ON;

WITH GETNUMS (N) AS (
SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL))
  FROM (VALUES (0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) AS A(N)
       CROSS JOIN (VALUES (0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) AS B(N)
       CROSS JOIN (VALUES (0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) AS C(N)
       CROSS JOIN (VALUES (0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) AS D(N)
       CROSS JOIN (VALUES (0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) AS E(N)
),
PERIODO AS (
SELECT DATEADD (DAY, (T.N -1), @DATAINICIAL) AS DIA
  FROM GETNUMS AS T
  WHERE T.N <= @DIAS
)
INSERT INTO DBO.CALENDARIO (DATA, DIA_SEMANA, SEMANA_ANO, DIA_UTIL, FERIADO)
SELECT P.DIA, 
	   DATENAME (WEEKDAY, P.DIA),
	   DATEPART (WEEK, P.DIA),
	   CASE 
			WHEN DATEPART (WEEKDAY, P.DIA) IN (1, 7) 
			OR EXISTS (SELECT * FROM DBO.FERIADO AS F WHERE F.DATA = P.DIA AND F.ORIGEM IN ('C','R'))
            THEN 0 ELSE 1 
		END,
       CASE
			WHEN EXISTS (SELECT * FROM DBO.FERIADO AS F WHERE F.DATA = P.DIA AND F.ORIGEM IN ('C','R'))
            THEN 1 ELSE 0 
	   END
FROM PERIODO AS P;