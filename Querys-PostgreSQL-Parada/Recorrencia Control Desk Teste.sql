
DROP TABLE IF EXISTS TEMP_ANALITICO_RECORRENCIA; 
CREATE TEMPORARY TABLE TEMP_ANALITICO_RECORRENCIA AS

SELECT	 CONCAT('__export__.mmp_pre_dossie_',A.ID) 			AS EXTERNAL_ID
			,A.contato_id 													AS CONTATO_ID
			,CAST(A.create_date AS DATE)								AS CREATE_DATE
			,A.dt_envio_banco 											AS Recebido_Banco
			,A.cpf 															AS CPF
			,CASE 
					WHEN D.name 		    IS NULL 
					OR   D.name   =      'Sem Advogado' 
					OR   D.name  LIKE    'Defensoria%' 
					OR   D.name  LIKE    'DEFENSORIA%'
					OR   D.name  LIKE    'Defensor%'
					OR   D.name  LIKE    'DEFENSOR%'
					OR   D.name   =   	'N/H'
		   		OR   D.name   = 	   'N/A'
		   		OR   D.name  LIKE    'OAB%'
		   		OR   D.name  LIKE    'PARTE SEM ADVOGADO'
		   		OR   D.name  LIKE    'Juizado Sem Advogado'
		   		OR   D.name  LIKE    'Sem Patrocinio'
		   		OR   D.name  LIKE    'Parte Sem Advogado'
					THEN 'KAIKE' ELSE     D.name 
			 END																AS NOME_contato 
			,G.name  														AS	NOME_AUTOR
			,A.name 															AS DOSSIE
			,A.processo														AS N_PROCESSO
			,F.name 															AS PRODUTO
			,C.name 															AS CAMPANHA
			,A.faixa1 														AS VALOR_FAIXA_1
			,A.faixa2 														AS VALOR_FAIXA_2
			,X_MARCACAO_PLANEJAMENTO_1 								AS CARTEIRA_PLAN_1
			,X_MARCACAO_PLANEJAMENTO_2 								AS ESTRATÉGIA_PLAN_2
			,A.count_type 													AS RECORRENCIA
			,A.data_conclusao												AS DT_CONCLUSAO 
			,C.inativa														AS STATUS_CAMPANHA
			,A.state															AS STATUS
			,A.oab															AS OAB
			,MC.name															AS MOTIVO_CONCLUSAO
			,H.name  														AS FASE
			,A.flag_wo														AS FLAG
			,A.cluster_novo
						
FROM				mmp_pre_dossie A
JOIN	
					res_partner G
ON		   (A.autor_id	= G.id)

JOIN		   	res_partner D
ON			(A.contato_id = D.id)

JOIN		 		mmp_pre_campanha C
ON			(C.id =	A.campanha_id)

JOIN		   	mmp_pre_client_group F
ON			(A.group_id = F.id)

LEFT JOIN		mmp_pre_motivo_conclusao MC
ON			 (A.motivo_conclusao_id = MC.id)

JOIN		 		mmp_pre_dossie_fase H
ON			 (A.fase_id = H.ID)

WHERE		 A.state != '10c'
OR A.data_conclusao >= CURRENT_DATE - 60

/* APAGA OS NOME ZUADOS */	
DELETE FROM TEMP_ANALITICO_RECORRENCIA
WHERE (
		     NOME_CONTATO = 'KAIKE'
		  OR LENGTH(NOME_CONTATO) <= 2
		  OR CARTEIRA_PLAN_1 IN ('AGRESSOR','ATIVAS','PPM','TRAB','TESTE')
		  OR CAMPANHA  		IN ('PPM - Sucumbência','BMG - PROJETO ADV. AGRESSOR - 16.11')
		)
-- OK
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : CONTA QUANTAS VEZES O NOME CONTATO SE REPETE			    			*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS TEMP_KAIKE; 
CREATE TEMPORARY TABLE TEMP_KAIKE AS
SELECT *
,     ROW_NUMBER () OVER (PARTITION BY nome_contato ORDER BY EXTERNAL_ID) AS RECORRENCIA_CONTATO	
FROM TEMP_ANALITICO_RECORRENCIA

SELECT MAX(NOMES_DUPLICADOS) AS DUPLICADOS
,		 NOME_CONTATO
FROM TEMP_KAIKE
GROUP BY NOME_CONTATO
ORDER BY DUPLICADOS DESC
DROP TABLE IF EXISTS TEMP_TESTE; 
CREATE TEMPORARY TABLE TEMP_TESTE AS


SELECT 	
			NOME_CONTATO
,			COUNT(NOME_CONTATO) AS RECORRENCIA_CONTATO
FROM 
		TEMP_ANALITICO_RECORRENCIA
GROUP BY 1
ORDER BY 2 DESC

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : SEPARA O QUE É LISTA E INDIVIDUAL							    			*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS TEMP_RECORRENCIA_2; 
CREATE TEMPORARY TABLE TEMP_RECORRENCIA_2 AS

SELECT 
			EXTERNAL_ID
,			CASE WHEN MAX(RECORRENCIA_CONTATO) > 1 AND MIN(RECORRENCIA_CONTATO) != 1 THEN 'l' ELSE 'i' END AS REC_2
FROM 
		TEMP_KAIKE
GROUP BY 1
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  : FAZ A COMPARAÇÃO COM A COLUNA ORIGINAL VENDO O QUE FOI ALTERADO	*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DROP TABLE IF EXISTS TEMP_RECORRENCIA_3; 
CREATE TEMPORARY TABLE TEMP_RECORRENCIA_3 AS

SELECT 
			Y.*
,			X.recorrencia
,			X.STATUS
,			CASE WHEN Y.REC_2 = X.recorrencia THEN 'VERDADEIRO' ELSE 'FALSO' END AS VALIDACAO
FROM
				TEMP_RECORRENCIA_2 			Y		
		
LEFT JOIN	TEMP_ANALITICO_RECORRENCIA X 

ON 			(X.EXTERNAL_ID = Y.EXTERNAL_ID)
AND 			X.NOME_CONTATO = Y.NOME_CONTATO

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: DELETA VERDADEIRO, CONCLUÍDO E OQ ERA LISTA E PASSOU A SER INDIVIDUAL */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/		
DELETE FROM TEMP_RECORRENCIA_3
WHERE recorrencia = 'l' 
AND   REC_2 = 'i'
OR (
			VALIDACAO = 'VERDADEIRO'
		OR STATUS = '10c'
	 )

	SELECT * FROM TEMP_RECORRENCIA_3
	
			
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO: DELETA VERDADEIRO, CONCLUÍDO E OQ ERA LISTA E PASSOU A SER INDIVIDUAL */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/	
DROP TABLE IF EXISTS TEMP_TESTE; 
CREATE TEMPORARY TABLE TEMP_TESTE AS	
SELECT 
*
,		CASE WHEN REC_2 = 'l' THEN 'Lista' ELSE 'KAIKE OLHA AQUI' END AS STATUS_1
,     ROW_NUMBER () OVER (PARTITION BY nome_contato ORDER BY EXTERNAL_ID) AS nomes_duplicados
FROM TEMP_RECORRENCIA_3


DELETE FROM TEMP_TESTE
WHERE nomes_duplicados > 1

SELECT * FROM TEMP_TESTE

