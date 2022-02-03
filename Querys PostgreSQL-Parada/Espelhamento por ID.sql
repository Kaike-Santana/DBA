/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																																							 */
/* PROGRAMADOR: KAIKE NATAN E THALES ALMEIDA                                                                          */
/* VERSAO     : 1.0      DATA: 25/10/2021                                                                             */
/* DESCRICAO  : PROCESSO DE ESPELHAMENTO DO NEGOCIAL PARA O PROCESSUAL ATRAVÉS DO ID									 		 */
/*																																							 */
/* ALTERACAO                                                                                                          */
/*        2. PROGRAMADOR: KAIKE NATAN E THALES ALMEIDA 															DATA: 26/10/2021	 */ 
/*           DESCRICAO  : FORMATAÇÃO DAS COLUNAS E TIPOS PARA FAZER O UPDATE NO PROCESSUAL									 */		   		
/* ALTERACAO                                                                                                          */
/*        3. PROGRAMADOR: KAIKE NATAN																	     			DATA: 27/10/2021	 */
/*           DESCRICAO  : RESPOSAVEL PELA VARIÁVEL DA DATA CURRRENT_DATE					   									 */   
/* ALTERACAO                                                                                                          */
/*        4. PROGRAMADOR: 																					     			DATA: __/__/____	 */
/*           DESCRICAO  : 					   																									 */                                                                                                                                        
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

CREATE OR REPLACE FUNCTION PRC_MIS_ESPELHAMENTO_ID ()								 
RETURNS TABLE(	
					ID VARCHAR (90) ,
					STATUS_ODOO	VARCHAR ,
					MOTIVO_CONCLUSAO VARCHAR ,
					FASE VARCHAR ,
					DATA_CONCLUSAO DATE, 
					VALOR_ACORDO	DOUBLE PRECISION
				 ) AS 
$BODY$

		SELECT	
			DOS.numero_acordo AS "ID PROCESSUAL"
			,CASE WHEN DOS.state = '10c' THEN 'Concluído'
				WHEN DOS.state = '01ac' THEN 'Aguardando Contato'
					WHEN DOS.state = '05cp' THEN 'Contraproposta'
						WHEN DOS.state = '03aa' THEN 'Aprovando Alçada'
							WHEN DOS.state = '06me' THEN 'Minuta Enviada'
								WHEN DOS.state = '04aan' THEN 'Aguardando Cliente'
									WHEN DOS.state = '02t' THEN 'Triagem'
										WHEN DOS.state = '08ap' THEN 'Aguardando Protocolo'
											WHEN DOS.state =  '07mr' THEN 'Minuta Recebida'
												WHEN DOS.state =  '09av' THEN 'Aguardando Validação'
			ELSE '"' 
				END AS "Status"
			,MC.name AS "Motivo de Conclusão"								 							 	
			,FAS.name "Fase"
			,DOS.data_conclusao AS "Data de Conclusão"
			,CAST(DOS.vl_acordo AS DOUBLE PRECISION) AS "Valor do Acordo"
		/*	,CLI.name AS "Grupo"
			,CA.name AS "Campanha" */
FROM		 mmp_pre_dossie DOS

LEFT
JOIN		 mmp_pre_dossie_fase FAS
ON			 DOS.fase_id			 
=			 FAS.id
LEFT
JOIN		 mmp_pre_campanha CA
ON			 DOS.campanha_id
=			 CA.id
LEFT
JOIN		 mmp_pre_motivo_conclusao MC
ON			 DOS.motivo_conclusao_id
=			 MC.id

LEFT
JOIN		 mmp_pre_client CLI
ON			 DOS.client_id
=			 CLI.id

WHERE DOS.numero_acordo LIKE '__export__.dossie%' 
AND (
		CAST (DOS.create_date AS DATE) 
												>= CURRENT_DATE 
		OR DOS.last_modified 
												>= CURRENT_DATE 
	 )
$BODY$ 
LANGUAGE SQL;

SELECT * FROM PRC_MIS_ESPELHAMENTO_ID();
