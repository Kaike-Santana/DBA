
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* PROGRAMADOR: KAIKE NATAN                                                                                           */
/* VERSAO     : 1.0      																									DATA: 26/01/2022   */
/* DESCRICAO  : FILTRA OS CASOS DE COLCHÃO COM PARCELAS EM ATRASO 				 											 		 */			
/* ALTERACAO                                                                                                          */
/*        2. PROGRAMADOR: INCLUSÃO DOS CASOS DE PREVENTIVO														DATA: 27/01/2022	 */
/*           DESCRICAO  : 								 																							 */       
/* ALTERACAO                                                                                                          */
/*        3. PROGRAMADOR: 																									DATA: __/__/____	 */
/*           DESCRICAO  : 								 																							 */                                                                                                                                    
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : PEGA A BASE ANALITICA											    			*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS TEMP_TABELA_PAGAMENTO;
CREATE TEMPORARY TABLE TEMP_TABELA_PAGAMENTO AS

SELECT  '__export__.mmp_pre_dossie_' || DOS.id AS ID
			,DOS.name AS Dossie
			,AUT.name AS Autor
			,SUBSTRING(AUT.name, 0, STRPOS(AUT.name, ' ')) AS primeiro_nome
			,DOS.contato_id
			,PAR.sequence Parcelas
			,PAR.data_vencimento
			,PAR.data_pagamento
			,CASE WHEN 	PAR.data_vencimento < CURRENT_DATE 
					AND 	PAR.data_pagamento IS NULL 
					THEN 'Acordo Atrasado' 
					ELSE 'Acordo em Dia' 
			 END AS situ_acordo
			,DOS.vl_acordo AS "Valor Acordo"
			,CLI.name
			,DOS.state AS status_odoo
			,CA.name AS campanha
			,MC.name AS motivo_conclusao
			
FROM 				 mmp_pre_dossie DOS
LEFT JOIN		 res_partner ADV 				  ON DOS.contato_id  		  = ADV.id
LEFT JOIN		 res_partner AUT 				  ON DOS.autor_id	 			  = AUT.id
LEFT JOIN		 mmp_pre_campanha CA 		  ON DOS.campanha_id 		  = CA.id
LEFT JOIN		 mmp_pre_motivo_conclusao MC ON DOS.motivo_conclusao_id = MC.id
LEFT JOIN		 mmp_pre_parcelas PAR 		  ON DOS.id 					  = PAR.dossie_id
LEFT JOIN		 mmp_pre_client_group CLI    ON DOS.group_id				  = CLI.id

WHERE CLI.name IN ('Gyramais','Minerva S.A.')
AND  	MC.name ILIKE 'Acordo Parcelado'
AND 	PAR.sequence > 1
ORDER 
		BY PAR.data_vencimento DESC 
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO : SEPARA O PRIMEIRO NOME PARA O SMS E FLAG DOS DUPLICADOS		 		*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS TEMP_PAGAMENTO_ATRASO;
CREATE TEMPORARY TABLE TEMP_PAGAMENTO_ATRASO AS

SELECT 
		*
,		ROW_NUMBER () OVER (PARTITION BY DOSSIE   ORDER BY ID) AS DOSSIE_DUPLICADOS
,		CASE WHEN LENGTH(primeiro_nome) < 2 THEN autor ELSE primeiro_nome END AS nome_sms

FROM TEMP_TABELA_PAGAMENTO
WHERE situ_acordo != 'Acordo em Dia'
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	REMOVE OS DOSSIES DUPLICADOS 												*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

DELETE FROM TEMP_PAGAMENTO_ATRASO
WHERE  DOSSIE_DUPLICADOS > 1

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : CRUZA COM A BASE DE TELEFONE E FAZ FLAG DOS DUPLICADOS			  	*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS TEMP_INCLUSAO_TELEFONE;
CREATE TEMPORARY TABLE TEMP_INCLUSAO_TELEFONE AS
		
SELECT 
	DOS.*
,	RTRIM(LTRIM(CASE WHEN CHAR_LENGTH (regexp_replace(b.name, '\d', '', 'g')) < CHAR_LENGTH (b.name) THEN regexp_replace(b.name, '[^0-9]', '', 'g') ELSE NULL END)) 
																		    		 AS TELEFONE
,	E.name 																 		 AS STATUS_TELEFONE
,	ROW_NUMBER () OVER (PARTITION BY DOS.DOSSIE ORDER BY DOS.ID) AS DOSSIE_DUPLICADO

FROM TEMP_PAGAMENTO_ATRASO DOS
LEFT JOIN res_partner D			   ON (DOS.contato_id = D.id)
LEFT JOIN mmp_pre_phone_number B ON (D.id 			 = B.partner_id)
LEFT JOIN mmp_pre_phone_status E ON	(E.id				 =	B.status_id)
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	REMOVE OS DOSSIES DUPLICADOS 												*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

DELETE FROM TEMP_INCLUSAO_TELEFONE
WHERE DOSSIE_DUPLICADO > 1
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : REMOVE OS CAMPOS DE VALIDAÇÃO												*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

ALTER TABLE TEMP_INCLUSAO_TELEFONE
 DROP COLUMN DOSSIE_DUPLICADOS
,DROP COLUMN DOSSIE_DUPLICADO
,DROP COLUMN primeiro_nome
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : ÚLTIMA VALIDAÇÃO DO DOSSIE SEM TELEFONE									*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS TEMP_ARRUMA_TELEFONE;
CREATE TEMPORARY TABLE TEMP_ARRUMA_TELEFONE AS

SELECT 
			*		
,			CASE WHEN telefone IS NULL AND dossie = '000000044558' THEN '51981944997' ELSE telefone END AS Telefones
FROM TEMP_INCLUSAO_TELEFONE
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : DROPA COLUNA DE VALIDAÇÃO														*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

ALTER TABLE TEMP_ARRUMA_TELEFONE
DROP COLUMN telefone
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : LAYOUT DA FRASE DE SMS DO GYRA+ E MINERVA								*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
SELECT 
		TELEFONES
,		NOME_SMS || ',' || 'Nao perca oportunidade de regularizar seu debito! Entre em contato atraves do link bit.ly/MMP-Contatos' AS SMS
FROM TEMP_ARRUMA_TELEFONE
--WHERE NAME = 'Minerva S.A.'
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : LAYOUT DA FRASE DE WHATS APP DO GYRA+ E MINERVA						*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

SELECT  '55' || TELEFONES || ',' || AUTOR AS WHATS
FROM TEMP_ARRUMA_TELEFONE
WHERE NAME = 'Minerva S.A.'
