
USE THESYS_DEV
GO


INSERT INTO [THESYS_HOMOLOGACAO]..[Alertas_Usuarios]
           ([id_usuario]
           ,[id_alerta_setup]
           ,[desativado])
select 
 [id_usuario]
,[id_alerta_setup]
,[desativado]
from Alertas_Usuarios

update [Alertas_Usuarios]
set id_alerta_setup = case
						  when id_alerta_setup = 12 then 1
						  when id_alerta_setup = 13 then 2
						  when id_alerta_setup = 14 then 3
						  when id_alerta_setup = 15 then 4
						  when id_alerta_setup = 16 then 5
						  when id_alerta_setup = 17 then 6
						  when id_alerta_setup = 18 then 7
						  when id_alerta_setup = 19 then 8
						  when id_alerta_setup = 20 then 9
						  when id_alerta_setup = 21 then 10
					  end

ALTER TABLE [Alertas_Usuarios]
ADD CONSTRAINT FK_Alertas_Usuarios_Alertas_Setup
FOREIGN KEY (id_alerta_setup) 
REFERENCES [Alertas_Setup] (id_alerta_setup);VVVV