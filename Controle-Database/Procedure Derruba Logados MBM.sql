
Use Thesys_Dev
Go

Execute Sp_ExecuteSQL N'
--Programador: Kaike Natan
--Data: 26/07/2024
--Descricao: Procedure Plpg SQL, Para Derrubar Usuarios Inativos Ha 1 Hora ou Mais

--CREATE OR REPLACE FUNCTION delete_old_logins()
--RETURNS void AS $$
--BEGIN
--    DELETE FROM public.login
--    WHERE EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - (dt_transacao::timestamp + hr_transacao::interval))) / 3600 >= 1;
--END;
--$$ LANGUAGE plpgsql;

    SELECT *
    FROM OPENQUERY([MBM_POLIRESINAS], ''SELECT delete_old_logins()'')
';