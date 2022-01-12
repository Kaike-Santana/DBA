
USE eData
GO

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*PROGRAMADOR: CONTROL DESK													  						    */
/*VERSAO     : 1.0      DATA: 05/09/2021                                                                */
/*DESCRICAO  : RESPONSAVEL POR ATUALIZAR O RELATORIO DE LOGADOS POR CAMPANHAS 			  			    */
/*																									    */
/*ALTERACAO                                                                                             */
/*        1. PROGRAMADOR: KAIKE NATAN												  DATA: 23/09/2021  */
/*           DESCRICAO  : MODELAGEM DOS DADOS										 			        */                                                                                                                                         
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	VARIÁVEIS														 */
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

	DECLARE @DT_REF  AS DATE
	SET @DT_REF = DATEADD(MINUTE, -1, GETDATE () ) 
	
	/*DECLARE @DT_KAIKE	AS DATE
	SET @DT_KAIKE	= GETDATE()*/
	
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	MODELAGEM														 */
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

SELECT 
		 CAMPAIGNDID
		,MAX(AGENTREADY) AS Logados
		,CampaignDescription
		,Moment
 FROM ChannelStatus	WITH(NOLOCK)
 WHERE MOMENT >= @DT_REF 
 --AND DATEPART(HOUR,MOMENT) <=7
 AND CampaignDid 
				IN (
						8100,8013,8002,7202,7200,7102,7101,7100,7001,6105,6043,6042,6041,
							6039,6037,6036,6032,6031,6030,6025,6024,6021,6011,6007,6005,5200,
								5104,5100,5000,4100,4033,4027,4021,4020,4004,3600,3500,3400,3100,
									2610,2501,2500,2100,2011,2003,2002,2000
					)

 GROUP BY Moment
		, CampaignDid
		, CampaignDescription

 ORDER BY 
		CampaignDid DESC
 

  
