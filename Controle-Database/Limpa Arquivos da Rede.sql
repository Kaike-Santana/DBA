
--Programador: Kaike Natan
--Data: 2023-09-26
--Descriçâo: Responsável Por Limpar Da Rede Os Mailings Do AD Que Nâo Sâo Do Dia
--Version: 1.0

Declare @vTSQL  Varchar(8000)			 
Declare @vSSQL  Varchar(8000) = 'DIR \\polaris\NectarServices\Administrativo\Mailing_AD\Mailings\'
Declare @vARQ   Varchar(150)
Declare @vMSDOS Table (VALOR Varchar(8000))

/* Importa o diretório para a variável do tipo tabela */
Delete From @vMSDOS
Insert Into @vMSDOS
Exec Master.Dbo.Xp_CmdShell @vSSQL

/* ETL do comando DIR COMANDO SHELL */
Drop Table If Exists  #AuxDOS
Select	Row_Number() Over (Order By (Select 0))							AS Id
	,	Convert(Datetime,Left(Valor, 10), 103)							AS Data
	,	Left(Substring(Valor, 37, 255), Charindex('.', Valor, 37) - 37) AS Layout
	,	Substring(Valor, 37, 255)										AS Arq
Into	#AUXDOS
From	@vMSDOS
Where	Right(Valor, 4) = '.Txt'

/* Define o contador e o máximo de contagens */
Declare @vFirstCount Int = 1
Declare @vMaxCount   Int = (Select Max(Id) From #AuxDos)

While @vFirstCount <= @vMaxCount
Begin
    Set @vARQ = (
        Select ARQ
        From #AUXDOS
        Where ID = @vFirstCount
		AND Convert(Date, Data) != Convert(Date, GetDate())
    )

    -- Define o caminho completo do arquivo
    Declare @vCaminhoArquivo VARCHAR(1000) = '\\polaris\NectarServices\Administrativo\Mailing_AD\Mailings\' + @vARQ

    Begin
        -- Executa o comando DELETE para excluir o arquivo
        Set @vTSQL = 'DEL "' + @vCaminhoArquivo + '"'
        Exec Master.Dbo.Xp_CmdShell @vTSQL
    End

    -- Incrementa o contador
    Set @vFirstCount = @vFirstCount + 1
End