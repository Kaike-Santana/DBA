	Alter Procedure PRC_DS_DAILY_SOLFACIL_PAG_PALEATIVO As

	Begin
	
	-- Declara váriaveis
	
	Declare		@Ini			Date		  = Convert(Date,Dateadd(D,-( Day(Dateadd(M,0,Getdate()-2))),Dateadd(M,0,Getdate()-1))) 
			,	@Fim			Varchar(40)   = Concat(Convert(Date,Getdate()-1), ' 23:59:59.599')	
			,	@sSql			VarChar(8000) = ''
			,	@Id				Int
			,	@FimLoop		Int
			,	@Arquivo		Varchar(200)
			,	@Dia			Int			  = Day(GetDate())
			,	@AnoMes			Varchar(7)
			,	@IniVir			Varchar(40)
			,	@Dt				DateTime = DateAdd(Day,-5,GetDate())
	
	Declare @MsDos				Table(Value Varchar(Max))



	-- Usa linguagem Shell para listar arquivos em um diretório

	Set @sSql = 'Dir \\NECTAR\NectarServices\Nectar\Solfácil\Backup\Carga\Pgto_Parcela_Acordo_-_SolFacil\'

	-- Trata a listagem pra trazer nome do arquivo ordenado por Id

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
	Where	Right(Value,4) = '.csv'


	-- Seta maximo Id , pois o maximo de Id é o ultimo arquivo atualizado

	Set @Id			= (Select Max(Id) From #AuxDos)
	Set @Arquivo	= (Select Arq From #AuxDos Where Id = @Id)


	-- Copia o arquivo em linguagem Shell 

	Set	@sSql = Concat('Copy '
						  ,'"\\NECTAR\NectarServices\Nectar\Solfácil\Backup\Carga\Pgto_Parcela_Acordo_-_SolFacil\'+@Arquivo+'" '
						  ,'"\\polaris\NectarServices\Administrativo\'+@Arquivo+'"')

	Exec master.dbo.xp_cmdshell @sSql

	-- Cria tabela com layout do arquivo para importação

	Drop Table If Exists  #AuxImport

	Create Table #AuxImport (	
								Id				Varchar(Max)
							,	Fundo			Varchar(Max)
							,	N_Parcela       Varchar(Max)
							,	Atraso          Varchar(Max)
							,	Vl_Pagamento    Varchar(Max)
							,	Dt_Pagamento    Varchar(Max)
							,	Carteira        Varchar(Max))

	-- Importa arquivo

	Set @sSql = 'Bulk Insert #AuxImport     
	From''\\polaris\NectarServices\Administrativo\'+@Arquivo+'''        
	With  (	
			FirstRow   = 2            
		,	CodePage   = ''ACP''            
		,	FieldTerminator = '';''
		  )'

	Exec (@sSql)

	-- Trata os dados os arquivo

	Drop Table If Exists  #AuxImportTratado
	Select  dbo.fn_StringtoBigInt(Id)						As Id
		,	dbo.fn_StringtoBigInt(N_Parcela)				As N_Parcela
		,	dbo.fn_StringtoBigInt(Atraso)					As Atraso
		,	Convert(Money,Vl_Pagamento)						As Vl_Pagamento
		,	Convert(Date,Dt_Pagamento,103)					As Dt_Pagamento

	Into #AuxImportTratado
	From #AuxImport

	-- Cria tabela no mesmo Layout da base que esta no Daily 

	Drop Table If Exists  TB_DS_DAILY_SOLFACIL_PAG_PALEATIVO
	Select Dt_Pagamento					As DATA
		,	Case	
				When Atraso Between -9999   
								And -1	 
				Then 'A Vencer'
				When Atraso Between	0	   
								And 15	 
				Then '0000 A 0015'
				When Atraso Between	16	   
								And 30	 
				Then '0016 A 0030'
				When Atraso Between	31	   
								And 45	 
				Then '0031 A 0045'
				When Atraso Between	46	   
								And 60	 
				Then '0046 A 0060'
				When Atraso Between	61	   
								And 90	 
				Then '0061 A 0090'
				When Atraso > 90						 
				Then '0091 A 9999' 
				Else 'Verificar'		
			End														As ATRASO
	,	0															As PG_VENC
	,	Count(1)													As QTD_PGTO
	,	Sum(Vl_Pagamento)											As VALOR_PAGO

	Into TB_DS_DAILY_SOLFACIL_PAG_PALEATIVO
	From  #AuxImportTratado
	Group By Dt_Pagamento
	,	Case	
				When Atraso Between -9999   
								And -1	 
				Then 'A Vencer'
				When Atraso Between	0	   
								And 15	 
				Then '0000 A 0015'
				When Atraso Between	16	   
								And 30	 
				Then '0016 A 0030'
				When Atraso Between	31	   
								And 45	 
				Then '0031 A 0045'
				When Atraso Between	46	   
								And 60	 
				Then '0046 A 0060'
				When Atraso Between	61	   
								And 90	 
				Then '0061 A 0090'
				When Atraso > 90						 
				Then '0091 A 9999' 
				Else 'Verificar'		
			End	

	
	-- Insere dados de acordos a vencer no mesmo layout do daily

	Insert TB_DS_DAILY_SOLFACIL_PAG_PALEATIVO
	Select	Convert(Date,Data_Venc)				As Data
		,	Atraso		
		,	Count(1)
		,	''									As Qtd_Pgto
		,   ''									As Valor_Pago


	From

	(
	Select 
		Convert(Date,Dtven_Pag)					As Data_Venc 
	,	Case	
					When Datediff(Day,Convert(Date,Dtatr_Con),Convert(Date,Dtcad_Aco)) Between -9999   And -1	 
					Then 'A Vencer'
					When Datediff(Day,Convert(Date,Dtatr_Con),Convert(Date,Dtcad_Aco)) Between	0	   And 15	 
					Then '0000 A 0015'
					When Datediff(Day,Convert(Date,Dtatr_Con),Convert(Date,Dtcad_Aco)) Between	16	   And 30	 
					Then '0016 A 0030'
					When Datediff(Day,Convert(Date,Dtatr_Con),Convert(Date,Dtcad_Aco)) Between	31	   And 45	 
					Then '0031 A 0045'
					When Datediff(Day,Convert(Date,Dtatr_Con),Convert(Date,Dtcad_Aco)) Between	46	   And 60	 
					Then '0046 A 0060'
					When Datediff(Day,Convert(Date,Dtatr_Con),Convert(Date,Dtcad_Aco)) Between	61	   And 90	 
					Then '0061 A 0090'
					When Datediff(Day,Convert(Date,Dtatr_Con),Convert(Date,Dtcad_Aco)) > 90						 
					Then '0091 A 9999' 
		Else 'Verificar' 
		End																As Atraso
	,	Count(Distinct Cgcpf_Dev)										As Pag_Venc
	,	Sum(Convert(Money,Vlpag_Pag))									As Valor_Pago

	From [10.251.1.36].Nectar.Dbo.Tb_Contrato   With(Nolock)   
	Join [10.251.1.36].Nectar.Dbo.Tb_Acordo     With(Nolock) 
	  On Idcon_Con 
	   = Idcon_Aco  
	Join [10.251.1.36].Nectar.Dbo.Tb_Pagamento  With(Nolock) 
	  On Idaco_Aco 
	   = Idaco_Pag  
	Join [10.251.1.36].Nectar.Dbo.Tb_Devedor    With(Nolock) 
	  On Iddev_Con 
	   = Iddev_Dev 

	Where Idemp_Con = 20 
	  And Dtven_Pag Between @Ini
						And @Fim
	  And Pagam_Pag = 1
	  And Staco_Aco = 0
	Group By Convert(Date,Dtven_Pag)  
	,	Case	
					When Datediff(Day,Convert(Date,Dtatr_Con),Convert(Date,Dtcad_Aco)) Between -9999   And -1	 
					Then 'A Vencer'
					When Datediff(Day,Convert(Date,Dtatr_Con),Convert(Date,Dtcad_Aco)) Between	0	   And 15	 
					Then '0000 A 0015'
					When Datediff(Day,Convert(Date,Dtatr_Con),Convert(Date,Dtcad_Aco)) Between	16	   And 30	 
					Then '0016 A 0030'
					When Datediff(Day,Convert(Date,Dtatr_Con),Convert(Date,Dtcad_Aco)) Between	31	   And 45	 
					Then '0031 A 0045'
					When Datediff(Day,Convert(Date,Dtatr_Con),Convert(Date,Dtcad_Aco)) Between	46	   And 60	 
					Then '0046 A 0060'
					When Datediff(Day,Convert(Date,Dtatr_Con),Convert(Date,Dtcad_Aco)) Between	61	   And 90	 
					Then '0061 A 0090'
					When Datediff(Day,Convert(Date,Dtatr_Con),Convert(Date,Dtcad_Aco)) > 90						 
					Then '0091 A 9999' 
		Else 'Verificar' 
		End																) X
	Group By Convert(Date,Data_Venc)
		,	Atraso

--***********************************************************************************************************************
--|									
--|														FECHAMENTO
--|
--***********************************************************************************************************************

	-- Repete o processo de listar arquivos do diretorio 

	Set @sSql = 'Dir \\NECTAR\NectarServices\Nectar\Solfácil\Backup\Carga\Pgto_Parcela_Acordo_-_SolFacil\'

	Delete From @MsDos
	Insert Into @MsDos
	Exec master.dbo.xp_cmdshell @sSql

	-- Trata pra listar nome dos arquivos novamente 

	Drop Table If Exists  #AuxDos2
	Select	Row_Number() Over (Order by (Select 0))		As Id
		,	Convert(DateTime,Left(Value,10),103)		As Data
		,	Left(Substring(Value,37,255)
		   ,CharIndex('.',Value,37)-37)					As Layout
		,	Substring(Value,37,255)						As Arq

	Into	#AuxDos2
	From	@MsDos
	Where	Right(Value,4) = '.csv'


	-- Cria Tabela de fechamento 

	Drop Table If Exists  #NmFechamento
	Create Table #NmFechamento (Id				Int Identity(1,1)
							,	NomeArquivo		Varchar(150))

	-- Insere na Tabela aquivos que contenha nome fechamento e criando Id pela ultima data de modificação do arquivo

	Insert Into #NmFechamento
	Select Arq

	From  #AuxDos2
	Where Arq Like '%Fechamento%'
	Order By Data 

	-- Seta maximo do Id que é o ultimo arquivo atuaizado

	Set @Id			= (Select Max(Id) From #NmFechamento)
	
	-- Seta nome do arquivo atual 

	Set @Arquivo	= (Select NomeArquivo From #NmFechamento Where Id = @Id )

	-- Copia aquivo atual para o outro diretório que permite importaão

	Set	@sSql = Concat('Copy '
						  ,'"\\NECTAR\NectarServices\Nectar\Solfácil\Backup\Carga\Pgto_Parcela_Acordo_-_SolFacil\'+@Arquivo+'" '
						  ,'"\\polaris\NectarServices\Administrativo\'+@Arquivo+'"')

	Exec master.dbo.xp_cmdshell @sSql

	-- Cria Tabela com layoout do arquivo para importação

	Drop Table If Exists  #AuxImport2

	Create Table #AuxImport2 (	
								Id				Varchar(Max)
							,	Fundo			Varchar(Max)
							,	N_Parcela       Varchar(Max)
							,	Atraso          Varchar(Max)
							,	Vl_Pagamento    Varchar(Max)
							,	Dt_Pagamento    Varchar(Max)
							,	Carteira        Varchar(Max))

	-- Importa arquivo 

	Set @sSql = 'Bulk Insert #AuxImport2     
	From''\\polaris\NectarServices\Administrativo\'+@Arquivo+'''        
	With  (	
			FirstRow   = 2            
		,	CodePage   = ''ACP''            
		,	FieldTerminator = '';''
		  )'

	Exec (@sSql)

	-- Trata os dados do arquivo 

	Drop Table If Exists  ##AuxImportTratado2
	Select  dbo.fn_StringtoBigInt(Id)						As Id
		,	dbo.fn_StringtoBigInt(N_Parcela)				As N_Parcela
		,	dbo.fn_StringtoBigInt(Atraso)					As Atraso
		,	Convert(Money,Vl_Pagamento)						As Vl_Pagamento
		,	Convert(Date,Dt_Pagamento,103)					As Dt_Pagamento

	Into ##AuxImportTratado2
	From #AuxImport2

	-- Seta Primeiro dia do mês considerando o minimo de data do arquivo 

	Set @Inivir = (Select Convert(Char(7),Min(Dt_Pagamento))+'-01' From ##AuxImportTratado2)

	-- Final do mês de hoje menos 5 dias

	Set @Fim	= Eomonth(DateAdd(Day,-5,GetDate()))

	-- Se for Dia 06 ( O criterio do dia 5 é por que o fechamento demora alguns dias para chegar)
	-- E Valida se o ano-mes da data do arquivo é o mesmo ano-mes do mes anterior
	
	IF Day(GetDate()) = 6 
	And Convert(Char(7), @Inivir) = Convert(Char(7), @Fim) 

	Begin 

	-- Se tiver dentro dos criterios cria tabela de pagamentos do mês anterior salvando histórico

	Set @AnoMes = Replace(Convert(Char(7), @Inivir),'-','_')


	Set @sSql = 'Select * Into   TB_DS_DAILY_SOLFACIL_PAG_PALEATIVO_'+@AnoMes+' 
								From   ##AuxImportTratado2
								Where Dt_Pagamento Between '''+@IniVir+''' And '''+@Fim+'''' 
	Exec(@sSql)

	Print 'Virada de Mês '

	End

	Else 

	Begin

	Print 'Vida que Segue'

	End


	-- Trata pra listar nome dos arquivos novamente 

	Drop Table If Exists  #AuxDos3
	Select	Row_Number() Over (Order by (Select 0))		As Id
		,	Convert(DateTime,Left(Value,10),103)		As Data
		,	Left(Substring(Value,37,255)
		   ,CharIndex('.',Value,37)-37)					As Layout
		,	Substring(Value,37,255)						As Arq

	Into	#AuxDos3
	From	@MsDos
	Where	Right(Value,4) = '.csv'
	  
   -- Deleta todos os arquivos csv do diretório     

	Set @Id = 1
	Set @FimLoop = (Select Max(Id) From #AuxDos3)


	While @Id <= @FimLoop

	Begin

	Set @Arquivo = (Select Arq From #AuxDos3 Where Id = @Id)
	Set @sSql = 'Del "\\polaris\NectarServices\Administrativo\'+@Arquivo+'"'
	Exec master.dbo.xp_cmdshell @sSql

	Set @Id = @Id + 1

	End

	-- Dropa todas as tabelas temporarias usadas No processo

	Drop Table If Exists  #AuxDos
	Drop Table If Exists  #AuxImport
	Drop Table If Exists  #AuxImportTratado
	Drop Table If Exists  #AuxDos2
	Drop Table If Exists  #NmFechamento
	Drop Table If Exists  #AuxImport2
	Drop Table If Exists  ##AuxImportTratado2
	Drop Table If Exists  #AuxDos3

End