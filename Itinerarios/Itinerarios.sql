
INSERT INTO [dbo].[Itinerarios]
           ([descricao]
           ,[ativo]
           ,[pais_origem]
           ,[pais_destino]
           ,[cidade_destino]
           ,[cod_clifor]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device]
           ,[prazo_embarque]
           ,[prazo_desembarque]
           ,[prazo_transferencia]
           ,[dias_transito]
           ,[prazo_registro]
           ,[prazo_transporte]
           ,[prazo_descarregamento]
           ,[leadtime_total]
           ,[prazo_devolucao]
           ,[prazo_transito]
           ,[id_armador]
           ,[id_transportadora])
select 
			Itinerarios_2.[descricao]
           ,thesys_dev..Itinerarios_2.[ativo]
           ,[pais_origem]						=	Paises.id_pais
           ,[pais_destino]						=   p2.id_pais
           ,[cidade_destino] 					=   Cidades.codigo
           ,[cod_clifor]						=   terminais_alfandegados.id_clifor
           ,[incl_data]							=   getdate()
           ,[incl_user]							=	'ksantana'
           ,[incl_device]						=	null
           ,[modi_data]							=	null
           ,[modi_user]							=	null
           ,[modi_device]						=	null
           ,[excl_data]							=	null
           ,[excl_user]							=	null
           ,[excl_device]						=	null
           ,[prazo_embarque]					=	[Prazo_Dias_Para_Embarcar_Após_Po]
           ,[prazo_desembarque]					=	[Prazo_Dias_Para_Desembaraço_Averbação]
           ,[prazo_transferencia]				=	[Prazo_Dias_De_Transferência_Para_Porto_Seco]
           ,[dias_transito]						=	[Prazo_Dias_De_Transito_Porto_A_Porto]
           ,[prazo_registro]					=	[Prazo_Dias_Para_Registro_De_Di]
           ,[prazo_transporte]					=	[Prazo_Dias_Para_Transporte_Interno]
           ,[prazo_descarregamento]				=	[Prazo_Dias_Para_Descarregamento]
           ,[leadtime_total]					=	[Leatime_Total]
           ,[prazo_devolucao]					=	[Prazo_Dias_Devolução_De_Vazios]
           ,[prazo_transito]					=	[Prazo_Dias_De_Transito_Porto_A_Porto]
           ,[id_armador]						=	null
           ,[id_transportadora]					=	null
from thesys_dev..Itinerarios_2 --> Tabela que eu subi do excel que tem os dados antes de concatenar da TB Itinerarios
left join Paises					on Paises.descricao						 = Itinerarios_2.pais_origem
left join Paises as p2				on p2.descricao							 = Itinerarios_2.pais_destino
left join Cidades					on Cidades.DESCRICAO					 = Itinerarios_2.cidade_destino
Left Join terminais_alfandegados 	on terminais_alfandegados.descricao_arm  = thesys_dev..Itinerarios_2.Nome_Terminal_Alfandg2


terminais_alfandegados


update Itinerarios_2
set pais_origem = 'ESTADOS UNIDOS DA AMERICA'

where pais_origem = 'E.U.A'