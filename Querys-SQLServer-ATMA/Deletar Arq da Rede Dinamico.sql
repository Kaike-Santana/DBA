


--> Programador: kaike natan

--> data: 28/04/2023

--> Versão 1.2

--exec dbo.aaa_teste 
--@ds_diretorio = '\\polaris\nectarservices\administrativo\output\datalake\2023\04\analitico\'

create procedure PRC_DS_DELETA_ARQUIVO_REDE (
	@ds_diretorio varchar(1000)
	)
as

begin
  set nocount on
	declare @query varchar(8000) = 'dir/ -c /4 /n "' + @ds_diretorio + '"'

    declare @retorno table (
        linha int identity(1, 1),
        resultado varchar(max)
    )

	insert into @retorno
	exec master.dbo.xp_cmdshell 
	@command_string = @query

	--select * from @retorno

    declare @tabela_final table (
        linha int identity(1, 1),
        dt_criacao datetime,
        fl_tipo bit,
        qt_tamanho int,
        ds_arquivo varchar(1000)
    )

	insert into @tabela_final(dt_criacao, fl_tipo, qt_tamanho, ds_arquivo)
	select 
    convert(datetime, left(resultado, 17), 103) as dt_criacao,
    1 as fl_tipo, 
    ltrim(substring(ltrim(resultado), 18, 19)) as qt_tamanho,
    @query + substring(resultado, charindex(ltrim(substring(ltrim(resultado), 18, 19)), resultado, 18) + len(ltrim(substring(ltrim(resultado), 18, 19))) + 1, len(resultado)) as ds_arquivo
	from @retorno
	where resultado is not null
	and linha >= 6
	and linha < (select max(linha) from @retorno) - 2
	and resultado not like '%<dir>%'
	order by ds_arquivo

	--select * from @tabela_final

	declare @vcontador int = 1
	declare @vmaximo   int = (select max (linha) from @tabela_final)

	print @vmaximo

	while (@vcontador <= @vmaximo)

	begin;
		declare @vtsql    varchar(1000)
		declare @vcaminho varchar(1000) = (select ds_arquivo from @tabela_final where qt_tamanho <= 1000 and linha = @vcontador )
		set @vcaminho	=	replace(@vcaminho,'dir/ -c /4 /n ','')

		set @vcontador += 1

		print @vcaminho
		print 'o loop está em: ' + convert(char(1),@vcontador - 1)

		set @vtsql	=	'exec xp_cmdshell' + ' ' + '' + '''' + 'del' + ' ' + @vcaminho + ''''
	
		exec(
			 @vtsql
			)
	end;

end