
USE THESYS_DEV

--insert into THESYS_PRODUCAO..Empresas
select 
		    [ID_EMPRESA_GRUPO]
           ,[DESCRICAO]
           ,[CODIUF]
           ,[CODICIDADE]
           ,[CIDADE]
           ,[BAIRRO]
           ,[ENDERECO]
           ,[TIPOENDERECO]
           ,[NOME]
           ,[RAZSOC]
           ,[CNPJ]
           ,[INSCR_EST]
           ,[CEP]
           ,[NUMERO]
           ,[TELEFONE_FIXO]
           ,[TELEFONE_CELULAR]
           ,[EMAIL]
           ,[SITE]
           ,[COMPLEMENTO]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device]
           ,[CODIGO_ANTIGO]
           ,[CODIIBGE]
           ,[nfe_certificado_nome_arquivo]
           ,[nfe_certificado_senha]
           ,[nfe_certificado_numero_serie]
           ,[nfe_email_host]
           ,[nfe_email_port]
           ,[nfe_email_user]
           ,[nfe_email_password]
           ,[nfe_email_subject]
           ,[nfe_email_ssl]
           ,[nfe_email_tls]
           ,[nfe_email_use_thread]
           ,[nfe_email_from_name]
           ,[nfe_tipo_ambiente]
           ,[nfe_certificado_url]
           ,[nfe_email_cc]
           ,[nfe_email_texto_corpo]
           ,[nfe_certificado_binario]
           ,[id_portador_cp]
           ,[id_portador_cr]
from empresas
where DESCRICAO not in (
'TheSys Company',
'COMPANY TEST 1',
'COMPANY TEST 2',
'COMPANY TEST 3'
)



--portadores
--
--empresas_grupos