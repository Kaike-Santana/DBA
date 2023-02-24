DECLARE @mydate DATETIME SELECT @mydate = GETDATE()-1

SELECT CONVERT(DATE,DATEADD(dd,-(DAY(@mydate)),@mydate)) Data,
'Último dia do mês anterior'  AS Tipo
UNION
SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@mydate)-1),@mydate),101) AS Date_Value,
'Primeiro dia do mês atual'
UNION
SELECT CONVERT(VARCHAR(25),@mydate,101) AS Date_Value, 'Hoje' AS Date_Type
UNION
SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,@mydate))),
DATEADD(mm,1,@mydate)),101),
'Último dia do mês atual'
UNION
SELECT CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,@mydate))-1),
DATEADD(mm,1,@mydate)),101),
'Primeiro dia do próximo mês'
GO