DECLARE @recipient_email NVARCHAR(100) = 'kaike.santana@atmatec.com.br'
DECLARE @subject NVARCHAR(100) = 'Assunto do e-mail'
DECLARE @html_body NVARCHAR(MAX) = N'
<html>
    <head>
        <style>
            /* estilo personalizado para o e-mail */
            h1 {
                color: red;
                font-family: Arial, sans-serif;
            }
            p {
                font-size: 16px;
                font-family: Arial, sans-serif;
                line-height: 1.5;
            }
        </style>
    </head>
    <body>
        <h1>Exemplo de e-mail em HTML com formatação de CSS</h1>
        <p>Olá, este é um exemplo de e-mail em HTML com formatação de CSS enviado através do SQL Server.</p>
    </body>
</html>
'

EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'DBA', -- Substitua pelo nome do seu perfil de e-mail
    @recipients = @recipient_email,
    @subject = @subject,
	@query_result_width = 90,
	@query_result_header = 0,
    @body = @html_body,
    @body_format = 'HTML',
	@attach_query_result_as_file = 0,
	@execute_query_database = 'master'
