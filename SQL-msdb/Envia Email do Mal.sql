

begin;
 set nocount on;
declare @frase varchar(max) 
declare @data varchar(max)				   = (replace(convert(varchar(20),convert(date,getdate()) ,103),'/',''))
declare @ano  varchar(4)				   =  right(@data,4)
declare @mes  varchar(2)				   =  substring(@data,3,2)
declare @nomenclatura_disparo varchar(max) = 'Casos Defasados e Arquivos DataLake_'+@data+'.txt'
declare @para varchar(max)				   = 'controldesk@atmatec.com.br;npc@atmatec.com.br'
declare @copia varchar(max)				   = 'datascience@atmatec.com.br;victor.simoes@atmatec.com.br;kaio.seridonio@atmatec.com.br'
declare @nomenclatura_arq varchar(max)	   =  @ano + @mes + substring(@data,1,2) + '.txt'
declare @vDir1 varchar(1000)			   =  '\\polaris\NectarServices\Administrativo\Output\DataLake\'+@ano+'\'+@mes+'\Analitico\higienizacao_datalake_'+@nomenclatura_arq+''	
declare @vDir2 varchar(1000)			   =  '\\polaris\NectarServices\Administrativo\Output\DataLake\'+@ano+'\'+@mes+'\Assertiva\enriquecer_assertiva_'+@nomenclatura_arq+''	
declare @vDir3 varchar(1000)			   =  '\\polaris\NectarServices\Administrativo\Output\DataLake\'+@ano+'\'+@mes+'\Lemit\enriquecer_lemit_'+@nomenclatura_arq+''	
declare @vDir4 varchar(1000)			   =  '\\polaris\NectarServices\Administrativo\Output\DataLake\'+@ano+'\'+@mes+'\Desbloqueio\desbloqueio_datalake_'+@nomenclatura_arq+''
declare @assunto varchar(max)			   =  'Casos Defasados e Arquivos DataLake' 
declare @diretorio varchar(max)			   =   concat(@vDir1,';',@vDir2,';',@vDir3,';',@vDir4)
declare @File_Exists1 int
declare @File_Exists2 int
declare @File_Exists3 int
declare @File_Exists4 int
declare @html varchar(max)
 
 --> Valida Dir 1
execute 
	master.dbo.xp_fileexist 
	@vDir1,
    @File_Exists1 OUTPUT
set @File_Exists1 =  iif(@File_Exists1  = 1, 1, 0) 

 --> Valida Dir 2
execute 
	master.dbo.xp_fileexist 
	@vDir2,
    @File_Exists2 OUTPUT
set @File_Exists2 =  iif(@File_Exists2  = 1, 1, 0) 

 --> Valida Dir 3
execute 
	master.dbo.xp_fileexist 
	@vDir3,
    @File_Exists3 OUTPUT
set @File_Exists3 =  iif(@File_Exists3  = 1, 1, 0) 

 --> Valida Dir 4
execute 
	master.dbo.xp_fileexist 
	@vDir4,
    @File_Exists4 OUTPUT
set @File_Exists4 =  iif(@File_Exists4  = 1, 1, 0) 

--> if para validar o horário dinâmico
if( 
	datepart(hour,getdate()) between 0 and 12
  )
set @frase = 'NPC, bom dia! Tudo bem?'

if(
	datepart(hour,getdate()) between 13 and 18
  )
set @frase = 'NPC, boa tarde! Tudo bem?'

if(
	datepart(hour,getdate()) between 19 and 23
  )
set @frase = 'NPC, boa noite! Tudo bem?'


--> if para validar se existe algum arquivo com a data do dia
 
if  (
	 @File_Exists1
	) = 0
and (
	 @File_Exists2
	) = 0
and (
	 @File_Exists3
	) = 0
and (
	 @File_Exists4
	) = 0

begin;
	set @diretorio = ''
	set @data       =  substring(@data,1,2) + '-' + substring(@data,3,2) + '-' + substring(@data,5,4)
	set @htmL = '  
	'+@frase+'<br/><br/>  
	
	Não houve casos de enriquecimento, bloqueio ou desbloqueio de telefones no dia: '+@data+'. <br/><br/>
	  
	Os Casos Defasados foram atualizados e se encontram na pasta: \\polaris\NectarServices\Administrativo\Output\Casos_Defasados\ favor realizar a marcação de acionamento! <br/><br/>	
	 
	<h2><span style="color:#A9A9A9"><strong><span style="font-size:10px"><span style="font-family:arial,helvetica,sans-serif"><em>Est&aacute; &eacute; uma mensagem autom&aacute;tica.</em></span></span></strong></span></h2>
	Atenciosamente,<br/>
	<img src="\\atlantida\Atma Solucoes\Administrativo\MIS\Kaike Natan\Assinatura.PNG" /><br/>'
end;

--> Validaçâo para verificar se houve apenas o arquivo de desbloqueio na CallFlex
if (
	@File_Exists1
) = 0

and (
	@File_Exists4
) = 1

begin; 
--> caso não tenha ele seta os arquivos em anexo dinamicamente 
	set @diretorio  =  @vDir4
	set @data       =  substring(@data,1,2) + '-' + substring(@data,3,2) + '-' + substring(@data,5,4)
	
	--> e também seta a frase dinamicamente de acordo com os arquivos que tiverem na rede
	set @htmL = '  
	'+@frase+'<br/><br/>  
	
	Segue em anexo apenas o arquivo de desbloqueio da BadList. <br/><br/> 
	
	Como não houve nenhum caso de bloqueio de novos telefones no dia '+@data+', também não haverá novos casos para enriquecimento. <br/><br/>
	  
	Os Casos Defasados foram atualizados e se encontram na pasta: \\polaris\NectarServices\Administrativo\Output\Casos_Defasados\ favor realizar a marcação de acionamento! <br/><br/>	
	 
	<h2><span style="color:#A9A9A9"><strong><span style="font-size:10px"><span style="font-family:arial,helvetica,sans-serif"><em>Est&aacute; &eacute; uma mensagem autom&aacute;tica.</em></span></span></strong></span></h2>
	Atenciosamente,<br/>
	<img src="\\atlantida\Atma Solucoes\Administrativo\MIS\Kaike Natan\Assinatura.PNG" /><br/>'
end;

if  (
	 @File_Exists1
	) = 1
and (
	 @File_Exists2
	) = 1
and (
	 @File_Exists3
	) = 1
and (
	 @File_Exists4
	) = 1

--> Se nâo entrar no If segue o fluxo normal
begin;
	set @diretorio = concat(@vDir1,';',@vDir2,';',@vDir3,';',@vDir4)
	set @htmL = '  
	'+@frase+'<br/><br/>  
	
	Segue em anexo os arquivos do DataLake: 1 para bloqueio, 1 desbloqueio na BadList e os outros 2 para enriquecimento: layout Lemit e Assertiva. <br/><br/>
	  
	Os Casos Defasados foram atualizados e se encontram na pasta: \\polaris\NectarServices\Administrativo\Output\Casos_Defasados\ favor realizar a marcação de acionamento! <br/><br/>	
	 
	<h2><span style="color:#A9A9A9"><strong><span style="font-size:10px"><span style="font-family:arial,helvetica,sans-serif"><em>Est&aacute; &eacute; uma mensagem autom&aacute;tica.</em></span></span></strong></span></h2>
	Atenciosamente,<br/>
	<img src="\\atlantida\Atma Solucoes\Administrativo\MIS\Kaike Natan\Assinatura.PNG" /><br/>' 
end;

begin try
	exec msdb.dbo.sp_send_dbmail  
	    @profile_name = 'dba',  
	    @recipients = @para ,
		@copy_recipients = @copia ,
		@importance = 'high',  
		@file_attachments = @diretorio,
	    @subject = @ASSUNTO,  
	    @body = @HTML,   
	    @body_format = 'html' 
end try

begin catch;
   	print 'erro número		: ' + convert(varchar, error_number());
 	print 'erro mensagem	: ' + error_message();
 	print 'erro severity	: ' + convert(varchar, error_severity());
 	print 'erro state		: ' + convert(varchar, error_state());
 	print 'erro line		: ' + convert(varchar, error_line());
 	print 'erro proc		: ' + error_procedure();
end catch;

end;