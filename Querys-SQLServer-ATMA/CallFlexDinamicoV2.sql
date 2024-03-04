
use dw_discador
go

--> Programador: Kaike Natan
--> Data: 2024-01-30
--> Descriçâo: Responsável Por Criar e Deletar Dinamicamente as Tabelas de Chamadas do CallFlex.
--> Version: 1.0

if  (
     day(
         getdate()
	    )
    )>= 7	--> Valida se já se passaram 7 dias do mes
and (
	 datepart(
			  dw,getdate()
			  )
	) = 7   --> Valida se é sababo
and (
	 datepart(hour,getdate())
	) > 14  --> Valida se é o periodo final da operacao

begin;

declare @dt_ini varchar (1000)  =  dateadd(month,-1,convert(date,getdate() - datepart(day,getdate())+1)) --> 1º dia de mês anterior
declare @dt_fim varchar (1000)  =  eomonth(@dt_ini)												    	 --> último dia do mês anterior
declare @ano    varchar (1000)  =  year(@dt_ini)
declare @mes	varchar (1000)  =  upper(
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
										  end
										)

declare @mes_ano varchar(1000)   =   '_' + @mes + '_' + @ano
declare @tsql	 varchar(1000)

--> Tabelas com Informaçoes do Mes Atual
declare @callflex_mes			varchar(1000) = upper('data_science.dbo.tb_ds_callflex_mes')
declare @callflex_mes_riachuelo varchar(1000) = upper('data_science.dbo.tb_ds_replica_atmsp6b1_mes')
declare @callflex_mes_renner	varchar(1000) = upper('data_science.dbo.tb_ds_callflex_mes_renner')
declare @callflex_mes_picpay	varchar(1000) = upper('data_science.dbo.tb_ds_callflex_mes_picpay')

--> Tabelas Que Vao Ser Criadas com Info do Mes Anterior
declare @vAtmsPbb1 varchar(1000) = upper('dw_discador.dbo.tb_ds_callflex_atmspbb1_mes')
declare @vAtmsP2b1 varchar(1000) = upper('dw_discador.dbo.tb_ds_callflex_atmsp2b1_mes')
declare @vAtmsP3b1 varchar(1000) = upper('dw_discador.dbo.tb_ds_callflex_atmsp3b1_mes')
declare @vAtmsP6b1 varchar(1000) = upper('dw_discador.dbo.tb_ds_callflex_atmsp6b1_mes')

------------------------------
-->: CallFlex Mes
------------------------------
if not exists (
			   select * 
			   from information_schema.tables 
			   where table_schema = 'dbo' 
			   and table_name = substring(@vAtmsPbb1 + @mes_ano,17,50)
			  )
set @tsql = '
select *
into ' + @vAtmsPbb1 +''+ @mes_ano +'
from ' + @callflex_mes + '
where data between '''+ @dt_ini + ''' and '''+ @dt_fim + '''
'
print(
	  @tsql
	 )

print convert(char(20),getdate(),20) + ' | ' + 'Criação da Tabela: ' + lower(@vAtmsPbb1) + '' + lower(@mes_ano) + ' OK! '

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
if not exists (
			   select * 
			   from information_schema.tables 
			   where table_schema = 'dbo' 
			   and table_name = substring(@vAtmsP6b1 + @mes_ano,17,50)
			  )
set @tsql = '
select *
into ' + @vAtmsP6b1 + ''+ @mes_ano +'
from ' + @callflex_mes_riachuelo + '
where data between '''+ @dt_ini + ''' and '''+ @dt_fim + '''
'
print(
	  @tsql
	 )

print convert(char(20),getdate(),20) + ' | ' + 'Criação da Tabela: ' + lower(@vAtmsP6b1) + '' + lower(@mes_ano) + ' OK! '

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
if not exists (
			   select * 
			   from information_schema.tables 
			   where table_schema = 'dbo' 
			   and table_name = substring(@vAtmsP2b1 + @mes_ano,17,50)
			  )
set @tsql = '
select *
into ' + @vAtmsP2b1 + ''+ @mes_ano +'
from ' + @callflex_mes_renner + '
where data between '''+ @dt_ini + ''' and '''+ @dt_fim + '''
'
print(
	  @tsql
	 )

print convert(char(20),getdate(),20) + ' | ' + 'Criação da Tabela: ' + lower(@vAtmsP2b1) + '' + lower(@mes_ano) + ' OK! '

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
if not exists (
			   select * 
			   from information_schema.tables 
			   where table_schema = 'dbo' 
			   and table_name = substring(@vAtmsP3b1 + @mes_ano,17,50)
			  )
set @tsql = '
select *
into ' + @vAtmsP3b1 + ''+ @mes_ano +'
from ' + @callflex_mes_picpay + '
where data between '''+ @dt_ini + ''' and '''+ @dt_fim + '''
'
print(
	  @tsql
	 )

print convert(char(20),getdate(),20) + ' | ' + 'Criação da Tabela: ' + lower(@vAtmsP3b1) + '' + lower(@mes_ano) + ' OK! '

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
,		@vFinal    int = 10

while (@vcontador <= @vFinal)
begin;
	set @vcontador += 1
	if (@vcontador = 10)
	print ('Opa Opa a beleza do Kaike é: ' + convert(char(2),@vFinal))
end;

end; 

else
	print ('Opa Opa só me execute quando for sábado e com a condiçâo que seja >= 7º dia do mês vigente e após as 14 horas!')