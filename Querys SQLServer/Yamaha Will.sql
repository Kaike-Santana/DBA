
USE BD_MIS
GO

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* PROGRAMADOR: KAIKE NATAN									                                    */
/* VERSAO     : 1.0      DATA: 21/09/2021                                                       */
/* DESCRICAO  : RESPONSAVEL POR PEGAR A FOTO DA YAMAHA COB							  		    */
/*																								*/
/*	ALTERACAO                                                                                   */
/*        1. PROGRAMADOR: 													 DATA: __/__/____	*/		
/*           DESCRICAO  : 																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	PEGA BASE DO SCC DA YAMAHA COB								     */
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

IF OBJECT_ID('TEMPDB.DBO.#BASE_YAMAHA_COB','U') IS NOT NULL
DROP TABLE #BASE_YAMAHA_COB 

SELECT *
INTO #BASE_YAMAHA_COB
FROM SCC_WEDOO WITH(NOLOCK)
WHERE ID_CEDENTE = 14

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	SEPARA A CARTEIRA DO DIA									     */
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

SELECT TOP 1

		"16-30"			=	(SELECT COUNT(1) FROM #BASE_YAMAHA_COB WHERE ATRASO BETWEEN 16  AND 30)
,		"31-60"			=	(SELECT COUNT(1) FROM #BASE_YAMAHA_COB WHERE ATRASO BETWEEN 31  AND 60)
,		"61-90"			=	(SELECT COUNT(1) FROM #BASE_YAMAHA_COB WHERE ATRASO BETWEEN 61  AND 90)
,		"91-120"		=	(SELECT COUNT(1) FROM #BASE_YAMAHA_COB WHERE ATRASO BETWEEN 91  AND 120)
,		"121-150"		=	(SELECT COUNT(1) FROM #BASE_YAMAHA_COB WHERE ATRASO BETWEEN 121 AND 150)
,		"151-180"		=	(SELECT COUNT(1) FROM #BASE_YAMAHA_COB WHERE ATRASO BETWEEN 151	AND 180)
,		"181-210"		=	(SELECT COUNT(1) FROM #BASE_YAMAHA_COB WHERE ATRASO BETWEEN 181 AND 210)
,		"211-240"		=	(SELECT COUNT(1) FROM #BASE_YAMAHA_COB WHERE ATRASO BETWEEN 211 AND 240)
,		"241-270"		=	(SELECT COUNT(1) FROM #BASE_YAMAHA_COB WHERE ATRASO BETWEEN 241 AND 270)
,		"271-300"		=	(SELECT COUNT(1) FROM #BASE_YAMAHA_COB WHERE ATRASO BETWEEN 271 AND 300)
,		"301-330"		=	(SELECT COUNT(1) FROM #BASE_YAMAHA_COB WHERE ATRASO BETWEEN 301 AND 330)
,		"331-360"		=	(SELECT COUNT(1) FROM #BASE_YAMAHA_COB WHERE ATRASO BETWEEN 331 AND 360)
,		">360"			=	(SELECT COUNT(1) FROM #BASE_YAMAHA_COB WHERE ATRASO  >360 )

FROM #BASE_YAMAHA_COB



