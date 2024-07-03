
use THESYS_HOMOLOGACAO
go

drop table if exists #Base_Clifor_Contatos
select 
 'POLIRESINAS' AS EMPRESA
,	*
into #Base_Clifor_Contatos
from openquery([mbm_poliresinas],'
select 
	clifor_contatos.*
,	clifor.cgc_cpf
from clifor_contatos 
join clifor on clifor.cod_clifor = clifor_contatos.cod_clifor
where clifor_contatos.ativo = ''S''
')

INSERT INTO [dbo].[CliFor_Contatos]
           ([cod_clifor]
           ,[id_empresa_grupo]
           ,[empresa]
           ,[cod_antigo]
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
,	[id_empresa_grupo]		=   (select id_empresa_grupo from Empresas_Grupos where nome = 'POLI RESINAS') --> Mudar para a empresa que estiver fazendo
,	fato.[empresa]			
,	[cod_antigo]			=   fato.cod_clifor
,	fato.[nome]
,	fato.[area]
,	[telefone2]				=   fato.telefone
,	fato.[cargo]
,	[telefone1]			    =   fato.telefone1
,	fato.[email]
,	fato.[dt_nascto]
,	fato.[obs]
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
from #Base_Clifor_Contatos Fato
Left Join Clifor on Isnull(Clifor.cnpj,Clifor.cpf) = fato.cgc_cpf collate latin1_general_ci_ai 