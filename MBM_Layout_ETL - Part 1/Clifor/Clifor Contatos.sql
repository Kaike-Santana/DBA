
use THESYS_HOMOLOGACAO
go

drop table if exists #Base_Clifor_Contatos
select 
 'Polirex' AS EMPRESA
,	*
into #Base_Clifor_Contatos
from openquery([mbm_polirex],'
select 
  clifor_contatos.cod_clifor, 
  clifor.razao as raz_clifor,
  clifor_contatos.nome, 
  clifor_contatos.area, 
  clifor_contatos.telefone1, 
  clifor_contatos.cargo, 
  clifor_contatos.celular, 
  clifor_contatos.telefone, 
  clifor_contatos.email, 
  clifor_contatos.dt_nascto, 
  clifor_contatos.email_pedcom, 
  clifor_contatos.email_pedven, 
  clifor_contatos.email_emisnf, 
  clifor_contatos.dt_change, 
  clifor_contatos.cpf, 
  clifor_contatos.email_boleto, 
  clifor_contatos.sequencia, 
  clifor_contatos.email_marketing, 
  clifor_contatos.email_chamado, 
  clifor_contatos.email_cte, 
  clifor_contatos.tipo_contato_contrato, 
  clifor_contatos.cod_controleterceiro, 
  clifor_contatos.ativo, 
  clifor_contatos.motivo_bloqueio, 
  clifor_contatos.email_senha, 
  clifor_contatos.dt_cadastro, 
  clifor_contatos.cod_usuariombm, 
  clifor_contatos.cripto, 
  clifor_contatos.usuario_app, 
  clifor_contatos.senha_app, 
  clifor_contatos.solicita_melhoria, 
  clifor_contatos.recebe_melhoriaviaemail, 
  clifor.cgc_cpf
from clifor_contatos 
join clifor on clifor.cod_clifor = clifor_contatos.cod_clifor
where clifor_contatos.ativo = ''S''
')


drop table if exists #final
select *
into #final
from (
		select *
		,	rw = row_number() over ( partition by nome, email order by cod_clifor desc)
		from #Base_Clifor_Contatos
	 )sb
where rw = 1
and cgc_cpf != '00.000.000/0000-00'
--and empresa = 'RUBBERON'
--AND cgc_cpf = '67.180.570/0001-81'
--order by nome, empresa desc


drop table if exists #final_Exterior
select *
into #final_Exterior
from (
		select *
		,	rw = row_number() over ( partition by nome, email order by cod_clifor desc)
		from #Base_Clifor_Contatos
	 )sb
where rw = 1
and cgc_cpf = '00.000.000/0000-00'
and email != 'noel@noel-automation.it'


INSERT INTO [dbo].[CliFor_Contatos]
           ([cod_clifor]
          -- ,[id_empresa_grupo]
          -- ,[empresa]
          -- ,[cod_antigo]
           ,[nome]
           ,[area]
           ,[telefone2]
           ,[cargo]
           ,[telefone1]
           ,[email]
           ,[dt_nascto]
           ,[obs]
           ,[email_pedcom]
           ,[email_pedven]
           ,[email_emisnf]
           ,[dt_change]
           ,[cpf]
           ,[email_boleto]
           ,[sequencia]
           ,[email_marketing]
           ,[email_chamado]
           ,[email_cte]
           ,[tipo_contato_contrato]
           ,[codigo_controleterceiro]
           ,[ativo]
           ,[motivo_bloqueio]
           ,[email_senha]
           ,[dt_cadastro]
           ,[cod_usuario_mbm]
           ,[cripto]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device])

select 
	[cod_clifor]			=	clifor.cod_clifor
--,	[id_empresa_grupo]		=   (select id_empresa_grupo from Empresas_Grupos where nome = 'POLI RESINAS') --> Mudar para a empresa que estiver fazendo
--,	fato.[empresa]			
--,	[cod_antigo]			=   fato.cod_clifor
,	Nome					=   trim(fato.[nome])
,	fato.[area]
,	[telefone2]				=   fato.telefone
,	fato.[cargo]
,	[telefone1]			    =   fato.telefone1
,	fato.[email]
,	fato.[dt_nascto]
,	[obs]					=    Null
,	fato.[email_pedcom]
,	fato.[email_pedven]
,	fato.[email_emisnf]
,	fato.[dt_change]
,	fato.[cpf]
,	fato.[email_boleto]
,	fato.[sequencia]
,	fato.[email_marketing]
,	fato.[email_chamado]
,	fato.[email_cte]
,	fato.[tipo_contato_contrato]
,	[codigo_controleterceiro] = fato.cod_controleterceiro
,	fato.[ativo]
,	fato.[motivo_bloqueio]
,	fato.[email_senha]
,	fato.[dt_cadastro]
,	[cod_usuario_mbm]		  = fato.cod_usuariombm
,	fato.[cripto]
,	[incl_data]		= getdate()
,	[incl_user]		= 'ksantana'
,	[incl_device]	= null
,	[modi_data]		= null
,	[modi_user]		= null
,	[modi_device]	= null
,	[excl_data]		= null
,	[excl_user]		= null
,	[excl_device]	= null
from #final Fato --> 11.929
Inner Join Clifor on Dbo.Fn_Limpa_NoNum(Isnull(Clifor.cnpj,Clifor.cpf)) = Dbo.Fn_Limpa_NoNum(fato.cgc_cpf) collate latin1_general_ci_ai 
				  and clifor.cnpj Not In ('00.000.000/0000-00','000.000.000-00')
Where Not Exists (
				   Select *
				   From CliFor_Contatos Dim
				   Where Dim.cod_clifor = Clifor.cod_clifor
				   And Dim.Nome         = Fato.Nome collate latin1_general_ci_ai 
				 )

Union All

select 
	[cod_clifor]			=	clifor.cod_clifor
,	Nome					=   trim(fato.[nome])
,	fato.[area]
,	[telefone2]				=   fato.telefone
,	fato.[cargo]
,	[telefone1]			    =   fato.telefone1
,	fato.[email]
,	fato.[dt_nascto]
,	[obs]					=    Null
,	fato.[email_pedcom]
,	fato.[email_pedven]
,	fato.[email_emisnf]
,	fato.[dt_change]
,	fato.[cpf]
,	fato.[email_boleto]
,	fato.[sequencia]
,	fato.[email_marketing]
,	fato.[email_chamado]
,	fato.[email_cte]
,	fato.[tipo_contato_contrato]
,	[codigo_controleterceiro] = fato.cod_controleterceiro
,	fato.[ativo]
,	fato.[motivo_bloqueio]
,	fato.[email_senha]
,	fato.[dt_cadastro]
,	[cod_usuario_mbm]		  = fato.cod_usuariombm
,	fato.[cripto]
,	[incl_data]		= getdate()
,	[incl_user]		= 'ksantana'
,	[incl_device]	= null
,	[modi_data]		= null
,	[modi_user]		= null
,	[modi_device]	= null
,	[excl_data]		= null
,	[excl_user]		= null
,	[excl_device]	= null
from #final_Exterior Fato --> 54
Inner Join Clifor on  Clifor.razao = Fato.raz_clifor collate latin1_general_ci_ai 
				  and Clifor.cnpj In ('00.000.000/0000-00','000.000.000-00')
Where Not Exists (
				   Select *
				   From CliFor_Contatos Dim
				   Where Dim.cod_clifor = Clifor.cod_clifor
				   And Dim.Nome         = Fato.Nome collate latin1_general_ci_ai 
				 )



with cte_duplicados as (
	select *
	,	rw = row_number () over ( partition by cod_clifor, nome order by incl_data asc)
	from CliFor_Contatos
)


delete from CliFor_Contatos
where id_clifor_contatos in (
select id_clifor_contatos
from cte_duplicados
where rw > 1
--and not exists (
--				select *
--				from Vendas_Pedidos
--				where id_clifor_contato = cte_duplicados.id_clifor_contatos
--			   )
)



With Cte_CliPedVenda As (
	Select distinct id_clifor_contato
	From Vendas_Pedidos
)


select *
from CliFor_Contatos Fato
where (    email like '%Polirex%'
		or email like '%Rubberon%'
		or email like '%Nortebag%'
		or email like '%Poliresinas%'
		or email like '%Mgpolime%'
	  )
And Exists (
			Select *
			From Cte_CliPedVenda Dim
			Where Dim.id_clifor_contato = Fato.id_clifor_contatos
		   )


Update CliFor_Contatos
set email = Null
Where id_clifor_contatos In ( --> Passar Aqui Lista Dos Select Acima
 849
,905
,907
,910
,913
,917
,922
,923
,931
,981
,1509
,7855
)