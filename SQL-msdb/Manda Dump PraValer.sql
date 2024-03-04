
if(
   datepart(dw,getdate())
  ) not in (7,1)

begin;

declare @frase varchar(max) 
declare @data varchar(max)				   = (replace(convert(varchar(20),convert(date,getdate()-1) ,103),'/',''))
declare @nomenclatura_disparo varchar(max) = 'dump_pra_valer_'+@data+'.txt'
declare @para varchar(max)				   = 'joao.filho@pravaler.com.br;igor.neves@pravaler.com.br'
declare @copia varchar(max)				   = 'datascience@atmatec.com.br;emilly.lima@atmatec.com.br;kaio.seridonio@atmatec.com.br'
declare @tsql varchar(max)

--> variáveis pra quando for 2 arq
declare @nomenclatura_disparo_2 varchar(max)
declare @diretorio2 varchar(max)
declare @data_2 varchar(max)

if (
	datepart(dw,getdate())
   ) = 2

begin;
  set @data				      = (replace(convert(varchar(20),convert(date,getdate()-2) ,103),'/',''))
  set @nomenclatura_disparo   = 'dump_pra_valer_'+@data+'.txt'
  						    
  set @data_2				  = (replace(convert(varchar(20),convert(date,getdate()-3) ,103),'/',''))
  set @nomenclatura_disparo_2 = 'dump_pra_valer_'+@data_2+'.txt'
end;

if(
	datepart(hour,getdate()) between 0 and 12
  )
set @frase = 'Jean, bom dia! Tudo bem?'

if(
	datepart(hour,getdate()) between 13 and 18
  )
set @frase = 'Jean, boa tarde! Tudo bem?'

if(
	datepart(hour,getdate()) between 19 and 23
  )
set @frase = 'Jean, boa noite! Tudo bem?'

declare  
    @html varchar(max)
,   @assunto varchar(max)   =  ('Arquivo Retorno PraValer - (DUMP)')  
,	@diretorio varchar(max) = '\\polaris\NectarServices\Administrativo\Temporario\PraValer\Dump\'+@nomenclatura_disparo+''

if (
	datepart(dw,getdate())
   ) = 2
   
begin;
  set @diretorio = '\\polaris\NectarServices\Administrativo\Temporario\PraValer\Dump\'+@nomenclatura_disparo+';\\polaris\NectarServices\Administrativo\Temporario\PraValer\Dump\'+@nomenclatura_disparo_2+''
end;

set @htmL = '  
'+@frase+'<br/><br/>  
  
Segue arquivo(s) Dump(s) atualizado(s).<br/><br/>	
 
<h2><span style="color:#A9A9A9"><strong><span style="font-size:10px"><span style="font-family:arial,helvetica,sans-serif"><em>Est&aacute; &eacute; uma mensagem autom&aacute;tica.</em></span></span></strong></span></h2>
Atenciosamente,<br/>
<img src="\\atlantida\Atma Solucoes\Administrativo\MIS\Kaike Natan\Assinatura.PNG" /><br/>'  
begin try
	exec msdb.dbo.sp_send_dbmail  
	    @profile_name = 'DBA',  
	    @recipients = @para ,
		@copy_recipients = @copia ,
		@importance = 'HIGH',  
		@file_attachments = @diretorio,
	    @subject = @ASSUNTO,  
	    @body = @HTML,   
	    @body_format = 'HTML' 
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

else 
	print ('Eu só vou executar de segunda a sexta ''--'' ');