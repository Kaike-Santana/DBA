

-- CONSULTA CHECK DB EM TODOS OS BANCOS MENOS OS DE SISTEMA

EXECUTE master.sys.sp_MSforeachdb
'if ''?'' NOT IN (''Master'',''MSDB'',''Model'',''Tempdb'') DBCC checkdb(''?'')'