
/* 1. Criar tabela dCalendario */
set language 'Brazilian'
DROP TABLE IF EXISTS dCalendario;
CREATE TABLE dbo.dCalendario (
  [Data] DATETIME PRIMARY KEY,
  [Ano] AS DATEPART(YEAR,[Data]),
  [Mes] AS DATEPART(MONTH,[Data]),
  [Dia]  AS DATEPART(DAY,[Data]), 
  [DiaAno]  AS DATEPART(DAYOFYEAR,[Data]), 
  [Trimestre] AS DATEPART(QUARTER,[Data]),
  [SemanaAno]AS DATEPART(WK,[Data]),
  [MesNome] AS DATENAME(MONTH, [Data]),
  [DiaNome] AS DATENAME(WEEKDAY, [Data]),
  [AnoTrismestre_Nome] AS CONCAT(DATEPART(YEAR,[Data]),' - ',DATEPART(QUARTER,[Data]),'º Trismestre') 
);

declare @vContadorInicial int = 0
declare	@vDataInicio datetime = '2022-01-01'
declare	@vMaxContador int	  = datediff(day,@vDataInicio,'2030-12-31')

--PRINT (@vMaxContador)

while (@vcontadorinicial <= @vmaxcontador)
begin
	--set language 'Brazilian'
	insert into dCalendario (Data) values (@vDataInicio)
	set @vContadorInicial += 1
	set @vDataInicio += 1
	print ('o contador está em: ' + convert(char(20),@vContadorInicial))
	print ('a data está em: '     + convert(char(20),@vDataInicio))
end