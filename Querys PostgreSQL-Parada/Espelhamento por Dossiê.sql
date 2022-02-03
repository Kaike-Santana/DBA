
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																																							 */
/* PROGRAMADOR: KAIKE NATAN E THALES ALMEIDA                                                                          */
/* VERSAO     : 1.0      DATA: 22/10/2021                                                                             */
/* DESCRICAO  : PROCESSO DE ESPELHAMENTO PARA O PROCESSUAL ATRAVÉS DO DOSSIE 					 		 							 */
/*			   																										   								 */
/* ALTERACAO                                                                                                          */
/*        2. PROGRAMADOR: KAIKE NATAN E THALES ALMEIDA 															DATA: 23/10/2021	 */ 
/*           DESCRICAO  : FORMATAÇÃO DAS COLUNAS E TIPOS PARA FAZER O UPDATE NO PROCESSUAL									 */				 																							 
/* ALTERACAO                                                                                                          */
/*        3. PROGRAMADOR: KAIKE NATAN E THALES ALMEIDA 															DATA: 24/10/2021	 */
/*           DESCRICAO  : CRIAÇÃO DA FUNÇÃO IFF PARA VALIDAÇÃO DA COLUNA Nº DO ACORDO PAM E BMG							 	 */          
/* ALTERACAO                                                                                                          */
/*        3. PROGRAMADOR: KAIKE NATAN E THALES ALMEIDA															DATA: 26/10/2021	 */
/*           DESCRICAO  : MODELAGEM FINAL DOS DADOS NO PADRÃO DE CADA REGRA DE NEGÓCIO DA CARTEIRA						 	 */ 
/* ALTERACAO                                                                                                          */
/*        3. PROGRAMADOR: 																									DATA: __/__/____	 */
/*           DESCRICAO  : 						 	 																								 */                                                                                                                                
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	SET	statement_timeout TO 600000;
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : ANALITICO PAN E BMG												    			*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS TEMP_PAM_BMG;
CREATE TEMPORARY TABLE TEMP_PAM_BMG AS
SELECT	
			DOS.name AS DOSSIE
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
			 END AS STATUS_ODOO
			,MC.name AS MOTIVO_CONCLUSAO									 							 	
			,FAS.name FASE
			,DOS.data_conclusao AS "Data de Conclusão"
			,cast(DOS.vl_acordo as double PRECISION) AS "Valor do Acordo"
			--,CLI.name AS "Grupo"
			--,CA.name AS "Campanha"
			
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

WHERE (
				DOS.numero_acordo NOT LIKE '%__export__.dossie%' 	
		 	OR DOS.numero_acordo IS NULL 
		)
AND CLI.name IN ('Banco BMG','BANCO PAN S/A')	  
AND DOS.data_conclusao >= '2021-12-01' 
AND MC.NAME = 'Acordo'
	 
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : SANATANDER								    										*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS TEMP_SANTANDER;
CREATE TEMPORARY TABLE TEMP_SANTANDER AS
SELECT	
			DOS.name AS DOSSIE
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
			 END AS STATUS_ODOO
			,MC.name AS MOTIVO_CONCLUSAO									 							 	
			,FAS.name FASE
			,DOS.data_conclusao AS "Data de Conclusão"
			,cast(DOS.vl_acordo as double PRECISION) AS "Valor do Acordo"
			--,CLI.name AS "Grupo"
			--,CA.name AS "Campanha"
			
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

WHERE 
			cli.name LIKE '%Santander%'
AND 		DOS.numero_acordo IS NULL			
AND 	   DOS.last_modified >= '2021-12-01'		

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : UNIFICAÇÃO DAS 2 TABELAS							  							*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS TEMP_FINAL;
CREATE TEMPORARY TABLE TEMP_FINAL 
											 (
												DOSSIE VARCHAR (45) NULL,
												STATUS_ODOO	VARCHAR NULL,
												MOTIVO_CONCLUSAO VARCHAR NULL,
												FASE VARCHAR NULL,
												DATA_CONCLUSAO DATE, 
												VALOR_ACORDO	DOUBLE PRECISION
												--GRUPO	VARCHAR NULL,
												--CAMPANHA	VARCHAR NULL
											 ) 

INSERT INTO TEMP_FINAL
SELECT *
FROM TEMP_PAM_BMG

UNION ALL

SELECT *
FROM TEMP_SANTANDER


/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : UNIFICAÇÃO DAS 2 TABELAS							  							*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

SELECT 
		*
FROM TEMP_FINAL






