
if  (
     day(
         getdate()
	    )
    )>= 7
and (
	 datepart(
			  dw,getdate()
			  )
	) = 1

begin;

declare @dt_ini varchar (max)  =  convert(date,getdate() - datepart(day,getdate())+1) --> 1º dia de mês atual
declare @dt_fim varchar (max)  =  eomonth(getdate())								  --> último dia do mês atual
declare @ano    varchar (max)  =  year(@dt_ini)
declare @mes	varchar (max)  =  upper(
								  case 
									  when month(@dt_ini) = 1  then 'jan'
									  when month(@dt_ini) = 2  then 'fev'
									  when month(@dt_ini) = 3  then 'mar'
									  when month(@dt_ini) = 4  then 'abr'
									  when month(@dt_ini) = 5  then 'mai'
									  when month(@dt_ini) = 6  then 'jun'
									  when month(@dt_ini) = 7  then 'jul'
									  when month(@dt_ini) = 8  then 'ago'
									  when month(@dt_ini) = 9  then 'set'
									  when month(@dt_ini) = 10 then 'out'
									  when month(@dt_ini) = 11 then 'nov'
									  when month(@dt_ini) = 12 then 'dez'
								  end)

declare @mes_ano varchar(max)   =   '_' + @mes + '_' + @ano
declare @tsql	 varchar(max)

declare @callflex_mes			varchar(max) = upper('data_science.dbo.tb_ds_callflex_mes')
declare @callflex_mes_riachuelo varchar(max) = upper('data_science.dbo.tb_ds_callflex_mes_riachuelo')
declare @callflex_mes_renner	varchar(max) = upper('data_science.dbo.tb_ds_callflex_mes_renner')
declare @callflex_mes_picpay	varchar(max) = upper('data_science.dbo.tb_ds_callflex_mes_picpay')

------------------------------
-->: CallFlex Mes
------------------------------
set @tsql = '
drop table if exists ' + @callflex_mes + '' + @mes_ano + '
select *
into ' + @callflex_mes + ''+ @mes_ano +'
from ' + @callflex_mes + '
where data between '''+ @dt_ini + ''' and '''+ @dt_fim + '''
'
print(
	  @tsql
	 )

print convert(char(20),getdate(),20) + ' | ' + 'Criação da Tabela: ' + lower(@callflex_mes) + '' + lower(@mes_ano) + ' OK! '

set @tsql = '
delete from ' + @callflex_mes + '
where data between '''+ @dt_ini + ''' and '''+ @dt_fim + '''
'
print(
	  @tsql
	 )

print convert(char(20),getdate(),20) + ' | ' + 'Delete na Tabela: ' + lower(@callflex_mes) + ' OK! '

------------------------------
-->: CallFlex Mes Riachuelo
------------------------------
set @tsql = '
drop table if exists ' + @callflex_mes_riachuelo + '' + @mes_ano + '
select *
into ' + @callflex_mes_riachuelo + ''+ @mes_ano +'
from ' + @callflex_mes_riachuelo + '
where data between '''+ @dt_ini + ''' and '''+ @dt_fim + '''
'
print(
	  @tsql
	 )

print convert(char(20),getdate(),20) + ' | ' + 'Criação da Tabela: ' + lower(@callflex_mes_riachuelo) + '' + lower(@mes_ano) + ' OK! '

set @tsql = '
delete from ' + @callflex_mes_riachuelo + '
where data between '''+ @dt_ini + ''' and '''+ @dt_fim + '''
'
print(
	  @tsql
	 )

print convert(char(20),getdate(),20) + ' | ' + 'Delete na Tabela: ' + lower(@callflex_mes_riachuelo) + ' OK! '

------------------------------
-->: CallFlex Mes Renner
------------------------------
set @tsql = '
drop table if exists ' + @callflex_mes_renner + '' + @mes_ano + '
select *
into ' + @callflex_mes_renner + ''+ @mes_ano +'
from ' + @callflex_mes_renner + '
where data between '''+ @dt_ini + ''' and '''+ @dt_fim + '''
'
print(
	  @tsql
	 )

print convert(char(20),getdate(),20) + ' | ' + 'Criação da Tabela: ' + lower(@callflex_mes_renner) + '' + lower(@mes_ano) + ' OK! '

set @tsql = '
delete from ' + @callflex_mes_renner + '
where data between '''+ @dt_ini + ''' and '''+ @dt_fim + '''
'
print(
	  @tsql
	 )

print convert(char(20),getdate(),20) + ' | ' + 'Delete na Tabela: ' + lower(@callflex_mes_renner) + ' OK! '

------------------------------
-->: CallFlex Mes PicPay
------------------------------
set @tsql = '
drop table if exists ' + @callflex_mes_picpay + '' + @mes_ano + '
select *
into ' + @callflex_mes_picpay + ''+ @mes_ano +'
from ' + @callflex_mes_picpay + '
where data between '''+ @dt_ini + ''' and '''+ @dt_fim + '''
'
print(
	  @tsql
	 )

print convert(char(20),getdate(),20) + ' | ' + 'Criação da Tabela: ' + lower(@callflex_mes_picpay) + '' + lower(@mes_ano) + ' OK! '

set @tsql = '
delete from ' + @callflex_mes_picpay + '
where data between '''+ @dt_ini + ''' and '''+ @dt_fim + '''
'
print(
	  @tsql
	 )

print convert(char(20),getdate(),20) + ' | ' + 'Delete na Tabela: ' + lower(@callflex_mes_picpay) + ' OK! '

--> Easter Eggs
declare @vcontador int = 0
declare @vFinal    int = 10

while (@vcontador <= @vFinal)
begin;
	set @vcontador += 1
	if (@vcontador = 10)
	print ('Opa Opa a beleza do Kaike é: ' + convert(char(2),@vFinal))
end;

end; 

else
	print ('Opa Opa só me execute quando for domingo e o dia seja >= 7º do mês vigente')