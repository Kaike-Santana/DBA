

DECLARE @OPERADORAS NVARCHAR(MAX) = 
									STUFF((
										 SELECT DISTINCT ',' + QUOTENAME(TERMINATOR) 
										 FROM TB_DS_CALLFLEX_MES 
										 WHERE TERMINATOR != '' 
										 AND DATA = '2022-05-28' 
										 FOR XML PATH('')
										 ),1,1,'')
DECLARE @TSQL NVARCHAR(MAX) = '
SELECT 
	DATA
,	'+@OPERADORAS+'
FROM TB_DS_CALLFLEX_MES 
PIVOT(
		COUNT  (
			    ORIGEM
		       )
			FOR TERMINATOR IN (
								'+@OPERADORAS+'
							  )
		) PVT 
WHERE DATA = ''2022-05-28'' '
EXEC (@TSQL)



SELECT 
	DATA
,	[RobRiacAtrCurVivoSip]
,	[TelecomMaisVoipGW3]
,   [vivosip3]
FROM TB_DS_CALLFLEX_MES 
PIVOT(
		COUNT (
			   ORIGEM
		      )
			FOR TERMINATOR IN (
								[RobRiacAtrCurVivoSip],[TelecomMaisVoipGW3],[vivosip3]
							  )
		) P 
WHERE DATA = '2022-05-28'