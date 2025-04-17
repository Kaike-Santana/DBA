import pandas as pd
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from datetime import datetime
from DataBaseConnection import DatabaseConnection  # Certifique-se de que este arquivo está no mesmo diretório

# Inicializa a conexão com o banco
db = DatabaseConnection()
conn = db.connect()

# Consulta SQL
sql = """
SELECT 
    [CNPJ], 
    [Razão_Social], 
    CASE 
        WHEN TRY_CONVERT(date, [Licença_da_polícia_Federal]) IS NOT NULL 
            AND MONTH(TRY_CONVERT(date, [Licença_da_polícia_Federal])) = MONTH(GETDATE()) 
            AND YEAR(TRY_CONVERT(date, [Licença_da_polícia_Federal])) = YEAR(GETDATE()) 
        THEN TRY_CONVERT(varchar, TRY_CONVERT(date, [Licença_da_polícia_Federal]), 103)
        ELSE '' 
    END AS [Licença_da_polícia_Federal],
    CASE 
        WHEN TRY_CONVERT(date, [Alvará_da_polícia_civil]) IS NOT NULL 
            AND MONTH(TRY_CONVERT(date, [Alvará_da_polícia_civil])) = MONTH(GETDATE()) 
            AND YEAR(TRY_CONVERT(date, [Alvará_da_polícia_civil])) = YEAR(GETDATE()) 
        THEN TRY_CONVERT(varchar, TRY_CONVERT(date, [Alvará_da_polícia_civil]), 103)
        ELSE '' 
    END AS [Alvará_da_polícia_civil],
    CASE 
        WHEN TRY_CONVERT(date, [Certificado_de_vistoria_da_polícia_civil]) IS NOT NULL 
            AND MONTH(TRY_CONVERT(date, [Certificado_de_vistoria_da_polícia_civil])) = MONTH(GETDATE()) 
            AND YEAR(TRY_CONVERT(date, [Certificado_de_vistoria_da_polícia_civil])) = YEAR(GETDATE()) 
        THEN TRY_CONVERT(varchar, TRY_CONVERT(date, [Certificado_de_vistoria_da_polícia_civil]), 103)
        ELSE '' 
    END AS [Certificado_de_vistoria_da_polícia_civil]
FROM TabelaValidadeLicenca
"""
df = pd.read_sql(sql, conn)
db.close()

# Tradução dos meses
meses = {
    'January': 'Janeiro', 'February': 'Fevereiro', 'March': 'Março',
    'April': 'Abril', 'May': 'Maio', 'June': 'Junho',
    'July': 'Julho', 'August': 'Agosto', 'September': 'Setembro',
    'October': 'Outubro', 'November': 'Novembro', 'December': 'Dezembro'
}

# Configuração do corpo do e-mail com HTML e CSS
current_month = datetime.now().strftime("%B")
translated_month = meses.get(current_month, current_month)  # Traduz o mês atual

body = """
<html>
    <head>
        <style>
            table {{
                width: 100%;
                border-collapse: collapse;
            }}
            th, td {{
                border: 1px solid #ddd;
                padding: 8px;
                text-align: left;
            }}
            th {{
                background-color: #4CAF50;
                color: white;
            }}
            tr:nth-child(even){{background-color: #f2f2f2}}
        </style>
    </head>
    <body>
        <table>
            <tr>
                <th colspan='5'>Licenças Vencendo em {month}</th>
            </tr>
            <tr>
                <th>CNPJ</th>
                <th>Razão Social</th>
                <th>Licença da Polícia Federal</th>
                <th>Alvará da Polícia Civil</th>
                <th>Certificado de Vistoria da Polícia Civil</th>
            </tr>
            {rows}
            <tr>
                <td colspan='5' style='text-align:right;'>
                    Informação extraída em: {date}
                </td>
            </tr>
        </table>
    </body>
</html>
""".format(
    month=translated_month,
    rows='\n'.join(
        f"<tr><td>{row['CNPJ']}</td><td>{row['Razão_Social']}</td><td>{row['Licença_da_polícia_Federal']}</td><td>{row['Alvará_da_polícia_civil']}</td><td>{row['Certificado_de_vistoria_da_polícia_civil']}</td></tr>"
        for index, row in df.iterrows()
    ),
    date=datetime.now().strftime("%d/%m/%Y")
)

# Configurações de e-mail e envio
message = MIMEMultipart()
message['From'] = "kaike1010@hotmail.com.br"
message['To'] = "kaike.santana@atrpservices.com.br, marcos.alves@atrpservices.com.br, thanner.almeida@atrpservices.com.br, daniela.perli@rubberon.com.br, administrativo@atrpservices.com.br"
message['Subject'] = f'Aviso das Empresas Que Com Licenças Vencendo'
message.attach(MIMEText(body, 'html'))

server = smtplib.SMTP("smtp.office365.com", 587)
server.starttls()
server.login("kaike1010@hotmail.com.br", "Deus@trino12")
text = message.as_string()
server.sendmail("kaike1010@hotmail.com.br", "kaike.santana@atrpservices.com.br", text)
server.quit()

print("E-mail enviado com sucesso!")