USE [THESYS_DEV]
GO

INSERT INTO [THESYS_HOMOLOGACAO]..[Frete_Cidades_Distancia]
           ([uf_origem]
           ,[cidade_origem]
           ,[uf_destino]
           ,[cidade_destino]
           ,[distancia_metros]
           ,[tempo_segundos]
           ,[data_criacao])
select 
 [uf_origem]
,[cidade_origem]
,[uf_destino]
,[cidade_destino]
,[distancia_metros]
,[tempo_segundos]
,[data_criacao]
from [Frete_Cidades_Distancia]