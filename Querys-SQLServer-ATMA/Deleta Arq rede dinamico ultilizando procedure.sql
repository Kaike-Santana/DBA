


create table #teste (
	id int primary key identity(1,1)
,	dArquivo varchar(1000) not null
)

insert into #teste (dArquivo) values ('\\polaris\nectarservices\administrativo\output\datalake\2023\04\analitico\')
insert into #teste (dArquivo) values ('\\polaris\nectarservices\administrativo\output\datalake\2023\04\Lemit\')
insert into #teste (dArquivo) values ('\\polaris\nectarservices\administrativo\output\datalake\2023\04\Assertiva\')

declare @vContador int = 1
declare @vMaximo   int = (select max(id) from #teste)

while (@vContador <= @vMaximo)

begin

 declare @vSql varchar(1000)
 ,		@vDiretorio varchar(1000)	=	(select dArquivo from #teste where id = @vContador)
 
 set @vSql	=	'exec [dbo].[prc_ds_deleta_arquivo_rede] @ds_diretorio = ''' + @vDiretorio + ''' '
 set @vContador = @vContador +1 
 print 'o contador está em :' + convert(char(1), @vContador -1)
 
 exec(
 	  @vSql
 	 ) 

end