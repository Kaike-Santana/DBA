
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* PROGRAMADOR: KAIKE NATAN									                                    */
/* VERSAO     : DATA: 23/02/2022																*/
/* DESCRICAO  : SCRIP PARA IDENTIFICAR SENHAS FRAGEIS DO BANCO						  		    */
/*																								*/
/*	ALTERACAO                                                                                   */
/*        2. PROGRAMADOR:													 DATA: __/__/____	*/		
/*           DESCRICAO  :										 								*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	CRIA TEMPORÁRIA PARA RECEBER AS INFORMAÇÕES									    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
IF (OBJECT_ID('tempdb..#Senhas') IS NOT NULL) DROP TABLE #Senhas
CREATE TABLE #Senhas (
						Senha VARCHAR(100)
					 )
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	INSERI AS SENHAS MAIS COMUNS ULTILIZADAS									    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
INSERT INTO #Senhas
VALUES 
('teste'), ('TESTE'), ('password'), ('qwerty'),('football'),('baseball'),
('welcome'), ('abc123'),('1qaz2wsx'), ('dragon'), ('master'), ('monkey'), 
('letmein'),('login'), ('princess'), ('qwertyuiop'), ('solo'), ('passw0rd'), 
('starwars'), ('teste123'), ('TESTE123'), ('deuseamor'), ('jesuscristo'),('iloveyou'),
('MARCELO'), ('jc2512'), ('maria'), ('jose'), ('batman'),('123123'), ('123123123'),
('FaMiLia'),(''),(' '),('sexy'),('abel123'),('freedom'), ('whatever'),('qazwsx'),
('trustno1'), ('sucesso'),('1q2w3e4r'), ('1qaz2wsx'), ('1qazxsw2'), ('zaq12wsx'),('! qaz2wsx'),
('!qaz2wsx'), ('123mudar'), ('gabriel'), ('102030'), ('010203'), ('101010'), ('131313'),
('vitoria'), ('flamengo'), ('felipe'), ('brasil'), ('felicidade'), ('mariana'), ('101010'),
('123456'),('123456789	'),('Brasil	'),('12345'),('102030')	,('senha'),('12345678'),
('1234'),('10203'),('123123	'),('123'),('1234567'),('654321'),('1234567890'),('gabriel'),('abc123')	,
('q1w2e3r4t5y6'),('101010')	,('159753')	,('123321'),('senha123'),('mirantte'),('flamengo'),('felicidade'),
('qwerty'),('felipe'),('121212'),('111111'),('142536'),('familia'),('password'),('sucesso	'),
('vitoria'),('matheus'),('rafael'),('junior'),('112233'),('gustavo'),('mariana'),('1q2w3e4r'),('000000'),
('novo'),('131313'),('lucas123'),('estrela'),('daniel'),('musica'),('camila'),('eduardo'),('guilherme')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	INICIA O LOOP DE INSERÇÃO DAS SENHAS										    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DECLARE 
@Contador INT = 1, 
@Total INT = 10,
@Contador2 INT = 1,
@Total2 INT = 10
WHILE(@Contador < @Total)
BEGIN
WHILE(@Contador2 < @Total2)
BEGIN
INSERT INTO #Senhas
SELECT REPLICATE(CAST(@Contador AS VARCHAR(100)), @Contador2)
SET @Contador2 += 1
END
SET @Contador += 1
SET @Contador2 = 1
END
SET @Contador = 12
SET @Contador2 = 1
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	INSERI AS COMBINAÇÕES DE LETRAS REPETIDAS									    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
WHILE(@Contador <= 126)
BEGIN
WHILE(@Contador2 <= @Total2)
BEGIN
INSERT INTO #Senhas
SELECT REPLICATE(CHAR(@Contador), @Contador2)
SET @Contador2 += 1
END
SET @Contador += 1
SET @Contador2 = 1
END
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	IDENTIFICA AS SEQUENCIAS													    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
DECLARE @Atual VARCHAR(100) = ''
SET @Contador = 0
WHILE(@Contador <= @Total)
BEGIN
SET @Atual = @Atual + CAST((CASE WHEN @Contador = 10 THEN 0 ELSE @Contador END) AS VARCHAR(100))
INSERT INTO #Senhas
SELECT @Atual
SET @Contador = @Contador + 1
END
SET @Contador = 1
SET @Atual = ''
WHILE(@Contador <= @Total)
BEGIN
SET @Atual = @Atual + CAST((CASE WHEN @Contador = 10 THEN 0 ELSE @Contador END) AS VARCHAR(100))
INSERT INTO #Senhas
SELECT @Atual
SET @Contador = @Contador + 1
END
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	IDENTIFICA OS LOGINS DOS USUARIOS COM SENHAS FRAGEIS						    */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
INSERT INTO #Senhas
SELECT [name]
FROM sys.sql_logins
INSERT INTO #Senhas
SELECT LOWER([name])
FROM sys.sql_logins
INSERT INTO #Senhas
SELECT UPPER([name])
FROM sys.sql_logins
INSERT INTO #Senhas
SELECT DISTINCT REVERSE(Senha)
FROM #Senhas
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* DESCRICAO  :	SELECT FINAL USANDO CROSS JOIN PARA OBTER TODAS AS COMBINAÇÕES	POSSIVEIS		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
SELECT
	A.name
,	B.Senha
FROM sys.sql_logins		A
CROSS APPLY #Senhas		B
WHERE PWDCOMPARE(B.Senha, A.password_hash) = 1
