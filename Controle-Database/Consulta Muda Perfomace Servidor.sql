DECLARE @Fl_Xp_CmdShell_Ativado BIT = (SELECT (CASE WHEN CAST([value] AS VARCHAR(MAX)) = '1' THEN 1 ELSE 0 END) FROM sys.configurations WHERE [name] = 'xp_cmdshell')
 
IF (@Fl_Xp_CmdShell_Ativado = 0)
BEGIN
 
    EXECUTE sp_configure 'show advanced options', 1;
    RECONFIGURE WITH OVERRIDE;
    
    EXEC sp_configure 'xp_cmdshell', 1;
    RECONFIGURE WITH OVERRIDE;
    
END
 
 
-- 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c (High Performance = Alta Performance)
-- 381b4222-f694-41f0-9685-ff5bb260df2e (Balanced = Balanceado)
-- a1841308-3541-4fab-bc81-f71556f20b4a (Power saver = Economia de Energia)
 
EXEC sys.xp_cmdshell 'powercfg.exe /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c' -- High Performance
 
 
IF (@Fl_Xp_CmdShell_Ativado = 0)
BEGIN
 
    EXEC sp_configure 'xp_cmdshell', 0;
    RECONFIGURE WITH OVERRIDE;
 
    EXECUTE sp_configure 'show advanced options', 0;
    RECONFIGURE WITH OVERRIDE;
 
END