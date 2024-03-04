
	-- Declara Variaveis

	Declare @MsDos				Table(Value Varchar(Max))
	Declare @sSql				Varchar(8000)
		,	@Ini				Int = 1
		,	@Fim				Int
		,	@Arquivo			Varchar(150)


	-- Usa linguagem Shell para listar arquivos em um diretório

	Set @sSql = 'Dir \\polaris\NectarServices\Administrativo\'

	-- Trata a listagem pra trazer nome do arquivo ordenado por Id e somente do tipo xlsb

	Delete From @MsDos
	Insert Into @MsDos
	Exec master.dbo.xp_cmdshell @sSql

	Drop Table If Exists  #AuxDos
	Select	Row_Number() Over (Order by (Select 0))		As Id
		,	Convert(DateTime,Left(Value,10),103)		As Data
		,	Left(Substring(Value,37,255)
		   ,CharIndex('.',Value,37)-37)					As Layout
		,	Substring(Value,37,255)						As Arq

	Into	#AuxDos
	From	@MsDos
	Where	Right(Value,4) = 'xlsb'

	-- Seta o Fim como o maximo do Id da listagem dos arquvos 
	Set @Fim = (Select Max(Id) From #AuxDos)

	-- Faça enquanto o @Fim for maior ou igual ao @Ini

	While @Fim >= @Ini 

	Begin 

	-- Pega o nome do arquivo conforme Id

	Set @Arquivo = (Select Arq From #AuxDos Where Id = @Ini)

	-- Importa Sheet do arquivo

	Drop Table If Exists  ##AuxImport1
	Set @sSql = 
	'Select  * Into ##AuxImport1
	From OpenRowSet(''Microsoft.ACE.OLEDB.12.0'',
	''Excel 12.0 Xml;HDR=YES;Database=\\polaris\NectarServices\Administrativo\'+@Arquivo+''',''SELECT * FROM [VC2 VIVO$]'')'
	Exec (@sSql)

	-- Insere na Tabela 

	Insert Into [TB_RESUMIDO_VC]
	Select *
		,	@Arquivo				As Nome_Arquivo
		,	'VC2 VIVO'				As Nome_Sheet
	From   ##AuxImport1

	-- Importa Sheet do arquivo

	Drop Table If Exists  ##AuxImport2
	Set @sSql = 
	'Select  * Into ##AuxImport2
	From OpenRowSet(''Microsoft.ACE.OLEDB.12.0'',
	''Excel 12.0 Xml;HDR=YES;Database=\\polaris\NectarServices\Administrativo\'+@Arquivo+''',''SELECT * FROM [VC3 VIVO$]'')'
	Exec (@sSql)

	-- Insere na Tabela 

	Insert Into [TB_RESUMIDO_VC]
	Select *
		,	@Arquivo				As Nome_Arquivo
		,	'VC3 VIVO'				As Nome_Sheet
	From   ##AuxImport2

	-- Importa Sheet do arquivo

	Drop Table If Exists  ##AuxImport3
	Set @sSql = 
	'Select  * Into ##AuxImport3
	From OpenRowSet(''Microsoft.ACE.OLEDB.12.0'',
	''Excel 12.0 Xml;HDR=YES;Database=\\polaris\NectarServices\Administrativo\'+@Arquivo+''',''SELECT * FROM [VC2 - Fixo para Móvel$]'')'
	Exec (@sSql)

	-- Insere na Tabela 

	Insert Into [TB_RESUMIDO_VC]
	Select *
		,	@Arquivo							As Nome_Arquivo
		,	'VC2 - Fixo para Móvel'				As Nome_Sheet
	From   ##AuxImport3

	-- Importa Sheet do arquivo

	Drop Table If Exists  ##AuxImport4
	Set @sSql = 
	'Select  * Into ##AuxImport4
	From OpenRowSet(''Microsoft.ACE.OLEDB.12.0'',
	''Excel 12.0 Xml;HDR=YES;Database=\\polaris\NectarServices\Administrativo\'+@Arquivo+''',''SELECT * FROM [VC3 - Fixo para Móvel$]'')'
	Exec (@sSql)

	-- Insere na Tabela 

	Insert Into [TB_RESUMIDO_VC]
	Select *
		,	@Arquivo							As Nome_Arquivo
		,	'VC3 - Fixo para Móvel'				As Nome_Sheet
	From   ##AuxImport4

	-- Importa Sheet do arquivo

	Drop Table If Exists  ##AuxImport5
	Set @sSql = 
	'Select  * Into ##AuxImport5
	From OpenRowSet(''Microsoft.ACE.OLEDB.12.0'',
	''Excel 12.0 Xml;HDR=YES;Database=\\polaris\NectarServices\Administrativo\'+@Arquivo+''',''SELECT * FROM [Outros$]'')'
	Exec (@sSql)

	-- Insere na Tabela 

	Insert Into [TB_RESUMIDO_VC]
	Select *
		,	@Arquivo				As Nome_Arquivo
		,	'Outros'				As Nome_Sheet
	From   ##AuxImport5



	Print 'Fim da Importação do Arquivo '+@Arquivo 

	Set @Ini = @Ini + 1

	End

	-- Dropa tabelas temporárias utilizadas no processo

	Drop Table If Exists  ##AuxImport1
	Drop Table If Exists  ##AuxImport2
	Drop Table If Exists  ##AuxImport3
	Drop Table If Exists  ##AuxImport4
	Drop Table If Exists  ##AuxImport5
	Drop Table If Exists  #AuxDos



	-- Forma para fazer Importação Manual ( Arquivo por Arquivo, Sheet por Sheet )



	--Drop Table If Exists  ##AuxImport5
	--Select  * 
	--Into ##AuxImport5 
	--From OpenRowSet('Microsoft.ACE.OLEDB.12.0',  
	--'Excel 12.0 Xml;HDR=YES;Database=\\polaris\NectarServices\Administrativo\Resumido por VC.xlsb','SELECT * FROM [Outros$]')



	--Insert Into [TB_RESUMIDO_VC]
	--Select *
	--	,	'Resumido por VC.xlsb'				As Nome_Arquivo
	--	,	'Outros'							As Nome_Sheet
	--From   ##AuxImport5


