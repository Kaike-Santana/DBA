use Planning

 

/***********************************************************************************************************

 

Autor: Vitor Lunardi Sporkens de Moura
Alteração: Beatriz Santos de Oliveira Bernardo
Setor: NPC - Planejamento Estratégico

 

Função da Procedure:

 

O Objetivo dessa procedure é automatizar o processo de importação de Email. Nela fazemos um pré validação dos emails e dos domínios.

 

Data Criação: 28/04/2022
Data alteração: 07/06/2023

 

Status: Em uso.

 

***********************************************************************************************************/

 

IF OBJECT_ID('TEMPDB..#tmp_Preventivo')        IS NOT NULL drop table #tmp_Preventivo
IF OBJECT_ID('TEMPDB..#tmp_Devolu')            IS NOT NULL drop table #tmp_Devolu
IF OBJECT_ID('TEMPDB..#tmp_Entrantes')        IS NOT NULL drop table #tmp_Entrantes
IF OBJECT_ID('TEMPDB..#tmp_reneg_cbr')        IS NOT NULL drop table #tmp_reneg_cbr            
IF OBJECT_ID('TEMPDB..#tmp_reneg_ccr')        IS NOT NULL drop table #tmp_reneg_ccr            
IF OBJECT_ID('TEMPDB..#tmp_91a180_cbr')        IS NOT NULL drop table #tmp_91a180_cbr    
IF OBJECT_ID('TEMPDB..#tmp_91a180_ccr')        IS NOT NULL drop table #tmp_91a180_ccr    
IF OBJECT_ID('TEMPDB..#tmp_181a360_cbr')    IS NOT NULL drop table #tmp_181a360_cbr    
IF OBJECT_ID('TEMPDB..#tmp_181a360_ccr')    IS NOT NULL drop table #tmp_181a360_ccr    
IF OBJECT_ID('TEMPDB..#tmp_361a999_cbr')    IS NOT NULL drop table #tmp_361a999_cbr    
IF OBJECT_ID('TEMPDB..#tmp_361a999_ccr')    IS NOT NULL drop table #tmp_361a999_ccr    
IF OBJECT_ID('TEMPDB..#tmp_geral')            IS NOT NULL drop table #tmp_geral
IF OBJECT_ID('TEMPDB..##TBL_EMAIL_RNN')        IS NOT NULL drop table ##TBL_EMAIL_RNN

 

-------------------------------------------------------------------------------------------------------------

 

DROP TABLE IF EXISTS #TBL_ENVIO_EMAIL

 

SELECT DISTINCT  

 

CONTRATO    
,CPF_CNPJ    
,EMAIL    
,DT_ENVIO    
,Carteira
,ROW_NUMBER() OVER ( PARTITION BY CPF_CNPJ ORDER BY max(dt_envio) desc) RW

 

INTO #TBL_ENVIO_EMAIL

 

FROM planning..TBL_ENVIO_EMAIL_RENNER

 

GROUP BY

 

CONTRATO    
,CPF_CNPJ    
,EMAIL    
,DT_ENVIO    
,Carteira

DROP TABLE IF EXISTS #ETL_EMAIL
SELECT *
INTO #ETL_EMAIL
FROM OPENQUERY([WOLVERINE],'
SELECT CPF, EMAIL
FROM REPORTS.DBO.TB_EMAIL
WHERE PRIORIDADE = 1')
-------------------------------------------------------------------------------------------------------------
select

 

B.EMAIL
,case 
    when len(rtrim(ltrim(A.CPF_CNPJ))) = 11 
    then (left(rtrim(ltrim(A.NOME_DEVEDOR)),charindex(' ',rtrim(ltrim(A.NOME_DEVEDOR)))))
    else substring(rtrim(ltrim(A.NOME_DEVEDOR)),1,10)
end NOME
,a.CPF_CNPJ
,a.CONTRATO
,a.ID_CONTRATO

 

into #tmp_Preventivo

 

from Planning.DBO.tbl_rnn_cubo                     a with (nolock) 
join #ETL_EMAIL                                    b with (nolock) on b.cpf = a.cpf_cnpj 

 

where ELEGIBILIDADE = 1
and cast(DT_DEVOLUCAO as date) > cast(getdate() +2 as date) 
and case when preventivo_dia = 1 then 1 when dt_menor_vencimento_acordo between cast(getdate() as date) and cast(getdate() +5 as date) then 1 else 0 end = 1

 

-------------------------------------------------------------------------------------------------------------
select

 

B.EMAIL
,case 
    when len(rtrim(ltrim(A.CPF_CNPJ))) = 11 
    then (left(rtrim(ltrim(A.NOME_DEVEDOR)),charindex(' ',rtrim(ltrim(A.NOME_DEVEDOR)))))
    else substring(rtrim(ltrim(A.NOME_DEVEDOR)),1,10)
end NOME
,a.CPF_CNPJ
,a.CONTRATO
,a.ID_CONTRATO

 

into #tmp_Devolu

 

from Planning.DBO.TBL_RNN_CUBO                    a with (nolock) 
join #ETL_EMAIL                                   b with (nolock) on b.cpf = a.cpf_cnpj 

 

where ELEGIBILIDADE = 1
and cast(DT_DEVOLUCAO as date) between cast(getdate() as date) and cast(getdate() +2 as date)

 

-------------------------------------------------------------------------------------------------------------
select

 

B.EMAIL
,case 
    when len(rtrim(ltrim(A.CPF_CNPJ))) = 11 
    then (left(rtrim(ltrim(A.NOME_DEVEDOR)),charindex(' ',rtrim(ltrim(A.NOME_DEVEDOR)))))
    else substring(rtrim(ltrim(A.NOME_DEVEDOR)),1,10)
end NOME
,a.CPF_CNPJ
,a.CONTRATO
,a.ID_CONTRATO

 

into #tmp_Entrantes

 

from Planning.DBO.tbl_rnn_cubo                             a with (nolock) 
join #ETL_EMAIL		                                    b with (nolock) on b.cpf = a.cpf_cnpj 
left join planning..#TBL_ENVIO_EMAIL                    d with (nolock) on d.contrato = a.CONTRATO

 

where ELEGIBILIDADE = 1
and cast(DT_DEVOLUCAO as date) > cast(getdate() +5 as date) 
and datediff(DAY,DT_Entrada,cast(getdate() as date)) between 0 and 0
and case when preventivo_dia = 1 then 1 when dt_menor_vencimento_acordo between cast(getdate() as date) and cast(getdate() +5 as date) then 1 else 0 end = 0

 

-------------------------------------------------------------------------------------------------------------
select

 

B.EMAIL
,case 
    when len(rtrim(ltrim(A.CPF_CNPJ))) = 11 
    then (left(rtrim(ltrim(A.NOME_DEVEDOR)),charindex(' ',rtrim(ltrim(A.NOME_DEVEDOR)))))
    else substring(rtrim(ltrim(A.NOME_DEVEDOR)),1,10)
end NOME
,a.CPF_CNPJ
,a.CONTRATO
,a.ID_CONTRATO

 

into #tmp_reneg_cbr

 

from Planning.DBO.tbl_rnn_cubo                             a with (nolock) 
join #ETL_EMAIL                                   b with (nolock) on b.cpf = a.cpf_cnpj 
left join planning..#TBL_ENVIO_EMAIL                    d with (nolock) on d.contrato = a.CONTRATO

 

where FAIXA = '00.RENEG' 
AND ELEGIBILIDADE = 1
and cast(DT_DEVOLUCAO as date) > cast(getdate() +5 as date) 
and case when preventivo_dia = 1 then 1 when dt_menor_vencimento_acordo between cast(getdate() as date) and cast(getdate() +5 as date) then 1 else 0 end = 0
and datediff(DAY,DT_Entrada,cast(getdate() as date)) >2
and SALDO >=50
AND SUBPRODUTO IN ('CBR')
AND ISNULL(rw,1) = 1
AND ISNULL(DT_ENVIO,'1900-01-01') <= case when datepart (weekday, cast (getdate() as date)) = 2 then cast (getdate()-5 as date) else cast (getdate() -3  as date) end 
--and b.prioridade in (1)

 

-------------------------------------------------------------------------------------------------------------
select

 

B.EMAIL
,case 
    when len(rtrim(ltrim(A.CPF_CNPJ))) = 11 
    then (left(rtrim(ltrim(A.NOME_DEVEDOR)),charindex(' ',rtrim(ltrim(A.NOME_DEVEDOR)))))
    else substring(rtrim(ltrim(A.NOME_DEVEDOR)),1,10)
end NOME
,a.CPF_CNPJ
,a.CONTRATO
,a.ID_CONTRATO

 

into #tmp_reneg_ccr

 

from Planning.DBO.tbl_rnn_cubo                             a with (nolock) 
join #ETL_EMAIL                                    b with (nolock) on b.cpf = a.cpf_cnpj 
left join planning..#TBL_ENVIO_EMAIL                    d with (nolock) on d.contrato = a.CONTRATO

 

where FAIXA = '00.RENEG' 
AND ELEGIBILIDADE = 1
and cast(DT_DEVOLUCAO as date) > cast(getdate() +5 as date) 
and case when preventivo_dia = 1 then 1 when dt_menor_vencimento_acordo between cast(getdate() as date) and cast(getdate() +5 as date) then 1 else 0 end = 0
and datediff(DAY,DT_Entrada,cast(getdate() as date)) >2
and SALDO >=50
AND SUBPRODUTO not IN ('CBR')
AND ISNULL(rw,1) = 1
AND ISNULL(DT_ENVIO,'1900-01-01') <= case when datepart (weekday, cast (getdate() as date)) = 2 then cast (getdate()-5 as date) else cast (getdate() -3  as date) end 
--and b.prioridade in (1)

 

-------------------------------------------------------------------------------------------------------------

 

select

 

B.EMAIL
,case 
    when len(rtrim(ltrim(A.CPF_CNPJ))) = 11 
    then (left(rtrim(ltrim(A.NOME_DEVEDOR)),charindex(' ',rtrim(ltrim(A.NOME_DEVEDOR)))))
    else substring(rtrim(ltrim(A.NOME_DEVEDOR)),1,10)
end NOME
,a.CPF_CNPJ
,a.CONTRATO
,a.ID_CONTRATO

 

into #tmp_91a180_cbr

 

from Planning.DBO.tbl_rnn_cubo                             a with (nolock) 
join #ETL_EMAIL                                    b with (nolock) on b.cpf = a.cpf_cnpj 
left join planning..#TBL_ENVIO_EMAIL                    d with (nolock) on d.contrato = a.CONTRATO

 

where faixa not in('00.RENEG') 
and DIAS_CONGELADOS between 91 and 180
AND ELEGIBILIDADE = 1
and cast(DT_DEVOLUCAO as date) > cast(getdate() +5 as date) 
and case when preventivo_dia = 1 then 1 when dt_menor_vencimento_acordo between cast(getdate() as date) and cast(getdate() +5 as date) then 1 else 0 end = 0
and datediff(DAY,DT_Entrada,cast(getdate() as date)) >2
and SALDO >=50
AND SUBPRODUTO IN ('CBR')
AND ISNULL(rw,1) = 1
AND ISNULL(DT_ENVIO,'1900-01-01') <= case when datepart (weekday, cast (getdate() as date)) = 2 then cast (getdate()-5 as date) else cast (getdate() -3  as date) end 
--and b.prioridade in (1)

 

-------------------------------------------------------------------------------------------------------------
select

 

B.EMAIL
,case 
    when len(rtrim(ltrim(A.CPF_CNPJ))) = 11 
    then (left(rtrim(ltrim(A.NOME_DEVEDOR)),charindex(' ',rtrim(ltrim(A.NOME_DEVEDOR)))))
    else substring(rtrim(ltrim(A.NOME_DEVEDOR)),1,10)
end NOME
,a.CPF_CNPJ
,a.CONTRATO
,a.ID_CONTRATO

 

into #tmp_91a180_ccr

 

from Planning.DBO.tbl_rnn_cubo                             a with (nolock) 
join #ETL_EMAIL                                    b with (nolock) on b.cpf = a.cpf_cnpj 
left join planning..#TBL_ENVIO_EMAIL                    d with (nolock) on d.contrato = a.CONTRATO

 

where faixa not in('00.RENEG') 
and DIAS_CONGELADOS between 91 and 180
AND ELEGIBILIDADE = 1
and cast(DT_DEVOLUCAO as date) > cast(getdate() +5 as date) 
and case when preventivo_dia = 1 then 1 when dt_menor_vencimento_acordo between cast(getdate() as date) and cast(getdate() +5 as date) then 1 else 0 end = 0
and datediff(DAY,DT_Entrada,cast(getdate() as date)) >2
and SALDO >=50
AND SUBPRODUTO NOT IN ('CBR')
AND ISNULL(rw,1) = 1
AND ISNULL(DT_ENVIO,'1900-01-01') <= case when datepart (weekday, cast (getdate() as date)) = 2 then cast (getdate()-5 as date) else cast (getdate() -3  as date) end 
--and b.prioridade in (1)

 


-------------------------------------------------------------------------------------------------------------
select

 

B.EMAIL
,case 
    when len(rtrim(ltrim(A.CPF_CNPJ))) = 11 
    then (left(rtrim(ltrim(A.NOME_DEVEDOR)),charindex(' ',rtrim(ltrim(A.NOME_DEVEDOR)))))
    else substring(rtrim(ltrim(A.NOME_DEVEDOR)),1,10)
end NOME
,a.CPF_CNPJ
,a.CONTRATO
,a.ID_CONTRATO

 

into #tmp_181a360_cbr

 

from Planning.DBO.tbl_rnn_cubo                             a with (nolock) 
join #ETL_EMAIL                                   b with (nolock) on b.cpf = a.cpf_cnpj 
left join planning..#TBL_ENVIO_EMAIL                    d with (nolock) on d.contrato = a.CONTRATO

 

where faixa not in('00.RENEG') 
and DIAS_CONGELADOS between 181 and 360
AND ELEGIBILIDADE = 1
and cast(DT_DEVOLUCAO as date) > cast(getdate() +5 as date) 
and case when preventivo_dia = 1 then 1 when dt_menor_vencimento_acordo between cast(getdate() as date) and cast(getdate() +5 as date) then 1 else 0 end = 0
and datediff(DAY,DT_Entrada,cast(getdate() as date)) >2
and SALDO >=50
AND SUBPRODUTO IN ('CBR')
AND ISNULL(rw,1) = 1
AND ISNULL(DT_ENVIO,'1900-01-01') <= case when datepart (weekday, cast (getdate() as date)) = 2 then cast (getdate()-5 as date) else cast (getdate() -3  as date) end 
--and b.prioridade in (1)

 


-------------------------------------------------------------------------------------------------------------

 

select

 

B.EMAIL
,case 
    when len(rtrim(ltrim(A.CPF_CNPJ))) = 11 
    then (left(rtrim(ltrim(A.NOME_DEVEDOR)),charindex(' ',rtrim(ltrim(A.NOME_DEVEDOR)))))
    else substring(rtrim(ltrim(A.NOME_DEVEDOR)),1,10)
end NOME
,a.CPF_CNPJ
,a.CONTRATO
,a.ID_CONTRATO

 

into #tmp_181a360_ccr

 

from Planning.DBO.tbl_rnn_cubo                             a with (nolock) 
join #ETL_EMAIL                                   b with (nolock) on b.cpf = a.cpf_cnpj 
left join planning..#TBL_ENVIO_EMAIL                    d with (nolock) on d.contrato = a.CONTRATO

 

where faixa not in('00.RENEG') 
and DIAS_CONGELADOS between 181 and 360
AND ELEGIBILIDADE = 1
and cast(DT_DEVOLUCAO as date) > cast(getdate() +5 as date) 
and case when preventivo_dia = 1 then 1 when dt_menor_vencimento_acordo between cast(getdate() as date) and cast(getdate() +5 as date) then 1 else 0 end = 0
and datediff(DAY,DT_Entrada,cast(getdate() as date)) >2
and SALDO >=50
AND SUBPRODUTO NOT IN ('CBR')
AND ISNULL(rw,1) = 1
AND ISNULL(DT_ENVIO,'1900-01-01') <= case when datepart (weekday, cast (getdate() as date)) = 2 then cast (getdate()-5 as date) else cast (getdate() -3  as date) end 
--and b.prioridade in (1)

 


-------------------------------------------------------------------------------------------------------------

 

select

 

B.EMAIL
,case 
    when len(rtrim(ltrim(A.CPF_CNPJ))) = 11 
    then (left(rtrim(ltrim(A.NOME_DEVEDOR)),charindex(' ',rtrim(ltrim(A.NOME_DEVEDOR)))))
    else substring(rtrim(ltrim(A.NOME_DEVEDOR)),1,10)
end NOME
,a.CPF_CNPJ
,a.CONTRATO
,a.ID_CONTRATO

 

into #tmp_361a999_cbr

 

from Planning.DBO.tbl_rnn_cubo                             a with (nolock) 
join #ETL_EMAIL                                    b with (nolock) on b.cpf = a.cpf_cnpj 
left join planning..#TBL_ENVIO_EMAIL                    d with (nolock) on d.contrato = a.CONTRATO

 

where faixa not in('00.RENEG') 
and DIAS_CONGELADOS >= 361
AND ELEGIBILIDADE = 1
and cast(DT_DEVOLUCAO as date) > cast(getdate() +2 as date) 
and case when preventivo_dia = 1 then 1 when dt_menor_vencimento_acordo between cast(getdate() as date) and cast(getdate() +5 as date) then 1 else 0 end = 0
and datediff(DAY,DT_Entrada,cast(getdate() as date)) >2
and SALDO >=50
AND SUBPRODUTO IN ('CBR')
AND ISNULL(rw,1) = 1
--AND ISNULL(DT_ENVIO,'1900-01-01') <= case when datepart (weekday, cast (getdate() as date)) = 2 then cast (getdate()-5 as date) else cast (getdate() -3  as date) end 
--and b.prioridade in (1)

 

-------------------------------------------------------------------------------------------------------------

 

select

 

B.EMAIL
,case 
    when len(rtrim(ltrim(A.CPF_CNPJ))) = 11 
    then (left(rtrim(ltrim(A.NOME_DEVEDOR)),charindex(' ',rtrim(ltrim(A.NOME_DEVEDOR)))))
    else substring(rtrim(ltrim(A.NOME_DEVEDOR)),1,10)
end NOME
,a.CPF_CNPJ
,a.CONTRATO
,a.ID_CONTRATO

 

into #tmp_361a999_ccr

 

from Planning.DBO.tbl_rnn_cubo                             a with (nolock) 
join #ETL_EMAIL                                    b with (nolock) on b.cpf = a.cpf_cnpj 
left join planning..#TBL_ENVIO_EMAIL                    d with (nolock) on d.contrato = a.CONTRATO

 

where faixa not in('00.RENEG') 
and DIAS_CONGELADOS >= 361 
AND ELEGIBILIDADE = 1
and cast(DT_DEVOLUCAO as date) > cast(getdate() +5 as date) 
and case when preventivo_dia = 1 then 1 when dt_menor_vencimento_acordo between cast(getdate() as date) and cast(getdate() +5 as date) then 1 else 0 end = 0
and datediff(DAY,DT_Entrada,cast(getdate() as date)) >2
and SALDO >=50
AND SUBPRODUTO NOT IN ('CBR')
AND ISNULL(rw,1) = 1
AND ISNULL(DT_ENVIO,'1900-01-01') <= case when datepart (weekday, cast (getdate() as date)) = 2 then cast (getdate()-5 as date) else cast (getdate() -3  as date) end 
--and b.prioridade in (1)
--------------------------- Volume dia para disparar

 

select distinct                 *, FAIXA ='Preventivo'    into #tmp_geral                                        from #tmp_preventivo    union 
select distinct              *, FAIXA ='Devolucao'                                                        from #tmp_Devolu        union 
select distinct                 *, FAIXA ='Entrantes'                                                        from #tmp_Entrantes        union
select distinct                 *, FAIXA ='RENEG_CBR'                                                        from #tmp_reneg_cbr        union 
select distinct                 *, FAIXA ='RENEG_CCR'                                                        from #tmp_reneg_ccr        union 
select distinct                   *, FAIXA ='91-180_CBR'                                                        from #tmp_91a180_cbr    union 
select distinct                   *, FAIXA ='91-180_CCR'                                                        from #tmp_91a180_ccr    union 
select distinct                   *, FAIXA ='181-360_CBR'                                                    from #tmp_181a360_cbr    union 
select distinct                  *, FAIXA ='181-360_CCR'                                                    from #tmp_181a360_ccr    union 
select distinct                  *, FAIXA ='361-999_CBR'                                                    from #tmp_361a999_cbr    union     
select distinct                   *, FAIXA ='361-999_CCR'                                                    from #tmp_361a999_ccr            

 


/*Retorno o volume total que vai ser disparado (Serve para envio das Peças)*/                        

select distinct FAIXA, COUNT (1) from #tmp_geral group by FAIXA

 

--------------------------- Validação E-Mail

 

select distinct 2 as ID,*

 

into ##TBL_EMAIL_RNN

 

--,right (email,len(email)-charindex('@',email)+1)

 

from #tmp_geral

 

where email like '%@%' and email like '%.com%'

 

and email not like '% %' 
and email not like '%/%' 
and email not like '%"%' 
and email not like '%,%' 
and email not like '%!%' 
and email not like '%?%' 
and email not like '%<%' 
and email not like '%>%' 
and email not like '%&%' 
and email not like '%=%' 
and email not like '%-%' 
and email not like '%..%'

 

and right (email,len(email)-charindex('@',email)+1) not like '% %'  
and right (email,len(email)-charindex('@',email)+1) not like '%/%'  
and right (email,len(email)-charindex('@',email)+1) not like '%"%'  
and right (email,len(email)-charindex('@',email)+1) not like '%,%'  
and right (email,len(email)-charindex('@',email)+1) not like '%!%'  
and right (email,len(email)-charindex('@',email)+1) not like '%?%'  
and right (email,len(email)-charindex('@',email)+1) not like '%<%'  
and right (email,len(email)-charindex('@',email)+1) not like '%>%'  
and right (email,len(email)-charindex('@',email)+1) not like '%&%'  
and right (email,len(email)-charindex('@',email)+1) not like '%=%'  
and right (email,len(email)-charindex('@',email)+1) not like '%-%'  
and right (email,len(email)-charindex('@',email)+1) not like '%5..%'

 

and right (email,len(email)-charindex('@',email)+1) not like '%0%' 
and right (email,len(email)-charindex('@',email)+1) not like '%1%' 
and right (email,len(email)-charindex('@',email)+1) not like '%2%' 
and right (email,len(email)-charindex('@',email)+1) not like '%3%' 
and right (email,len(email)-charindex('@',email)+1) not like '%4%' 
and right (email,len(email)-charindex('@',email)+1) not like '%5%' 
and right (email,len(email)-charindex('@',email)+1) not like '%6%' 
and right (email,len(email)-charindex('@',email)+1) not like '%7%' 
and right (email,len(email)-charindex('@',email)+1) not like '%8%' 
and right (email,len(email)-charindex('@',email)+1) not like '%9%'

 

union

 

select distinct

 

1                as ID
,'EMAIL'        as EMAIL    
,'NOME'            as NOME    
,'CPF_CNPJ'        as CPF_CNPJ
,'CONTRATO'        as CONTRATO
,'IDCRM'        as ID_CONTRATO
,'FAIXA'            as FAIXA

 

 

/*Inclusão do titulo para marcação*/                        

 

IF OBJECT_ID('TEMPDB..##TBL_MARCACAOEmail_RENNER') IS NOT NULL DROP TABLE ##TBL_MARCACAOEmail_RENNER

 

select

 

DATA_MARC        = 'DATA_MARC'
,COMPLEMENTO    = 'COMPLEMENTO'
,CPF            = 'CPF'
,DTREF            = 'DTREF'
,EVENTO            = 'EVENTO'
,TELEFONE        = 'TELEFONE'
,ID                = 1                  

 

into ##TBL_MARCACAOEmail_RENNER

 

union

 

select distinct

 

concat(replace(cast(getdate() as date),'-',''),' ',left(cast(getdate() as time),2),':','00')    as DATA_MARC
,email                                                                                            as COMPLEMENTO
,cpf_cnpj                                                                                        as CPF
,''                                                                                                as DTREF
,'enviodeemail'                                                                                    as EVENTO
,''                                                                                                as Telefone
,2                                                                                                as ID

 

from ##TBL_EMAIL_RNN

 


/*Exporta o arquivo em CSV*/

 

select distinct FAIXA, count(1) as QTS from #tmp_geral group by FAIXA

 

SET LANGUAGE 'BRAZILIAN'

 

DECLARE @DATA                            VARCHAR(10) = (SELECT REPLACE(CONVERT(VARCHAR(10),GETDATE(),103),'/','')) 
DECLARE @HORA                            VARCHAR (3) = CONCAT (LEFT(CONVERT (TIME,GETDATE()),2),'H')
DECLARE @DATA2                            VARCHAR(4) = (SELECT REPLACE(LEFT (CONVERT(VARCHAR(10),GETDATE(),103),5),'/',''))  
DECLARE @MES                            VARCHAR(20) = CONCAT(FORMAT(GETDATE(),'MM'),' - ',UPPER(DATENAME(MONTH, GETDATE())))
DECLARE @ANO                            VARCHAR(8) = YEAR(GETDATE()) 
DECLARE @NOMENCLATURA_DISPARO_CBR        VARCHAR(MAX) = 'RENNER_EMAIL_CBR'+@DATA+'_'+@HORA+'.csv'
DECLARE @NOMENCLATURA_DISPARO_CCR        VARCHAR(MAX) = 'RENNER_EMAIL_CCR'+@DATA+'_'+@HORA+'.csv'
DECLARE @NOMENCLATURA_DISPARO_PREV        VARCHAR(MAX) = 'RENNER_EMAIL_PREVENTIVO_'+@DATA+'_'+@HORA+'.csv'
DECLARE @NOMENCLATURA_DISPARO_DEVO        VARCHAR(MAX) = 'RENNER_EMAIL_Devolucao_'+@DATA+'_'+@HORA+'.csv'
DECLARE @NOMENCLATURA_DISPARO_ENTR        VARCHAR(MAX) = 'RENNER_EMAIL_ENTRANTES_'+@DATA+'_'+@HORA+'.csv'
DECLARE @NOMENCLATURA_DISPARO_MARC        VARCHAR(MAX) = 'RENNER_MARCAR_'+@DATA+'_'+@HORA+'.csv'
DECLARE @BCP VARCHAR(MAX)

 

SET @BCP = 'master..xp_cmdshell ''bcp "SELECT EMAIL,NOME,cpf_cnpj,ID_CONTRATO FROM ##TBL_EMAIL_RNN where FAIXA in (''''Preventivo'''',''''FAIXA'''') order by ID asc " queryout "\\POLARIS\NectarServices\Administrativo\Temporario\Renner\Acao\Email"\'+@NOMENCLATURA_DISPARO_PREV+' -c -T -t ";" ''' EXEC (@BCP)
SET @BCP = 'master..xp_cmdshell ''bcp "SELECT EMAIL,NOME,cpf_cnpj,ID_CONTRATO FROM ##TBL_EMAIL_RNN where FAIXA in (''''Entrantes'''',''''FAIXA'''') order by ID asc " queryout "\\POLARIS\NectarServices\Administrativo\Temporario\Renner\Acao\Email"\'+@NOMENCLATURA_DISPARO_ENTR+' -c -T -t ";" ''' EXEC (@BCP)
SET @BCP = 'master..xp_cmdshell ''bcp "SELECT EMAIL,NOME,CPF_CNPJ,ID_CONTRATO FROM ##TBL_EMAIL_RNN where FAIXA in (''''Devolucao'''',''''FAIXA'''')    order by ID asc " queryout "\\POLARIS\NectarServices\Administrativo\Temporario\Renner\Acao\Email"\'            +@NOMENCLATURA_DISPARO_DEVO+' -c -T -t ";" ''' EXEC (@BCP)
SET @BCP = 'master..xp_cmdshell ''bcp "SELECT EMAIL,NOME,cpf_cnpj,ID_CONTRATO FROM ##TBL_EMAIL_RNN where FAIXA in (''''RENEG_CBR'''',''''91-180_CBR'''',''''181-360_CBR'''',''''361-999_CBR'''',''''FAIXA'''') order by ID asc " queryout "\\POLARIS\NectarServices\Administrativo\Temporario\Renner\Acao\Email"\'+@NOMENCLATURA_DISPARO_CBR+' -c -T -t ";" ''' EXEC (@BCP)
SET @BCP = 'master..xp_cmdshell ''bcp "SELECT EMAIL,NOME,cpf_cnpj,ID_CONTRATO FROM ##TBL_EMAIL_RNN where FAIXA in (''''RENEG_CCR'''',''''91-180_CCR'''',''''181-360_CCR'''',''''361-999_CCR'''',''''FAIXA'''') order by ID asc " queryout "\\POLARIS\NectarServices\Administrativo\Temporario\Renner\Acao\Email"\'+@NOMENCLATURA_DISPARO_CCR+' -c -T -t ";" ''' EXEC (@BCP)

 

SET @BCP = 'master..xp_cmdshell ''bcp "select DATA_MARC,COMPLEMENTO,CPF,DTREF,EVENTO,TELEFONE FROM ##TBL_MARCACAOEmail_RENNER order by ID asc " queryout "\\nectar\NectarServices\Nectar\Renner\Pesquisa"\'            +@NOMENCLATURA_DISPARO_MARC+' -c -T -t ";" ''' EXEC (@BCP)

 

--SELECT *
--FROM (SELECT DISTINCT 'DATA_MARC 'as DATA_MARC ,'COMPLEMENTO'as COMPLEMENTO,'CPF'as CPF,'DTREF'as DTREF,'EVENTO'as EVENTO,'TELEFONE'as TELEFONE
--UNION
--SELECT DISTINCT getdate () as DATA_MARC ,Email as COMPLEMENTO,cpf_cnpj as CPF,''as DTREF,'enviodeemail'as EVENTO,'' as TELEFONE FROM ##TBL_EMAIL_RNN) a

 


--select distinct FAIXA, count (1) as volume from ##TBL_EMAIL_RNN group by FAIXA    union 
--select distinct FAIXA, count (1) as volume from ##TBL_EMAIL_RNN group by FAIXA    union 
--select distinct FAIXA, count (1) as volume from ##TBL_EMAIL_RNN group by FAIXA    union 
--select distinct FAIXA, count (1) as volume from ##TBL_EMAIL_RNN group by FAIXA    union 
--select distinct FAIXA, count (1) as volume from ##TBL_EMAIL_RNN group by FAIXA    

 


--if (select max (dt_envio) from TBL_ENVIO_EMAIL ) <> cast (GETDATE() as date)
--begin  

 

insert into planning..TBL_ENVIO_EMAIL_RENNER

select distinct

 

GETDATE() as DT_ATUALIZACAO
,CONTRATO
,CPF_CNPJ    
,EMAIL    
,cast (getdate() as date) as DT_ENVIO
,'RENNER' as Carteira

--into planning..TBL_ENVIO_EMAIL_RENNER

 

from ##TBL_EMAIL_RNN

--end   

--DROP TABLE TBL_ENVIO_EMAIL_RENNER

 

--select distinct FAIXA, count (distinct cpf_cnpj) QTD 
--from Planning.DBO.tbl_rnn_cubo                             a with (nolock) 
--group by FAIXA