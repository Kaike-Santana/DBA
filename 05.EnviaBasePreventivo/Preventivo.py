from DatabaseConnection import DatabaseConnection
from EmailConfig import EmailConfig
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from datetime import datetime
import os

def execute_procedure():
    db = DatabaseConnection()
    conn = db.connect()
    if conn:
        cursor = conn.cursor()
        cursor.execute("EXEC Prc_EnviaBasePreventivo_10_Dias")
        columns = [column[0] for column in cursor.description]
        results = cursor.fetchall()
        #print("Colunas retornadas pela procedure:", columns)  # Verificação das colunas
        db.close()
        return columns, results
    return None, None

def generate_txt_file(columns, results):
    current_date = datetime.now().strftime("%d_%m_%Y")
    filename = f"Preventivo_10Dias_{current_date}.txt"
    
def generate_txt_file(columns, results):
    current_date = datetime.now().strftime("%d_%m_%Y")
    filename = f"Preventivo_10Dias_{current_date}.txt"
    
    # Definir a ordem desejada das colunas
    desired_order = [
        'cod_empresa', 'razao_empresa', 'fantasia_empresa', 'cod_serie', 'nro_titulo', 'parcela',
        'cod_tipodocto', 'historico', 'dt_emissao', 'valor', 'saldo', 'cod_portador', 'situacao',
        'cod_ocorrencianw', 'dessituacao', 'nro_nobanco', 'enviado_banco', 'cod_cliforbaixa',
        'dt_recebimento', 'nro_nfiscal', 'cliente', 'fornec', 'cod_clifor', 'razao', 'fantasia',
        'cgc_cpf', 'cod_grpcliente', 'descr_grpcliente', 'cod_grpfornec', 'descr_grpfornec',
        'valor_taxa', 'dt_limitedescto', 'calculardescto', 'tipodescto', 'calcularjuros',
        'tipojuros', 'calcularmulta', 'tipomulta', 'valordescto', 'percentualdescto', 'valorjuros',
        'percentualjuros', 'valormulta', 'percentualmulta', 'cod_repres', 'razao_rep',
        'nro_diascredito', 'tipo_titulo', 'antecipacao', 'protestado', 'negociacao', 'status',
        'descr_tipodocto', 'cod_natrecdesp', 'descricao_natrecdesp', 'tipo_natrecdesp',
        'cod_situacaotitulo', 'desc_situacaotitulo', 'anotacoes', 'dt_baixa', 'dt_bompara',
        'valor_rec', 'juros_rec', 'descto_rec', 'cod_tipologradouro', 'endereco', 'end_numero',
        'end_complemento', 'bairro', 'cidade', 'cep', 'telefone1', 'telefone2', 'email',
        'portadores_mov', 'Parcela_De', 'Dia_Atual', 'Dias', 'dt_vencto'
    ]
    
    # Criar um mapeamento de índices
    column_indices = {col: i for i, col in enumerate(columns)}
    
    with open(filename, 'w', encoding='utf-8') as file:
        # Escrever o cabeçalho
        file.write('\t'.join(desired_order) + '\n')
        
        # Escrever os dados na ordem correta
        for row in results:
            ordered_row = []
            for col in desired_order:
                if col in column_indices:
                    value = str(row[column_indices[col]]) if row[column_indices[col]] is not None else ''
                    # Substituir quebras de linha e tabulações, mas preservar as vírgulas
                    value = value.replace('\n', ' ').replace('\r', ' ').replace('\t', ' ')
                    # Envolver o valor entre aspas se contiver uma vírgula
                    if ',' in value:
                        value = f'"{value}"'
                    ordered_row.append(value)
                else:
                    ordered_row.append('')  # Coluna não encontrada nos resultados
            file.write('\t'.join(ordered_row) + '\n')
    
    return filename


def send_email(filename):
    email_config = EmailConfig()
    
    msg = MIMEMultipart()
    msg['From'] = email_config.email_usuario
    msg['To'] = ', '.join(email_config.email_destinatarios)
    msg['Subject'] = f'Base Preventivo 10 Dias (Rubberon) - {datetime.now().strftime("%d/%m/%Y")}'
    
    body = "Segue em anexo os casos Preventivo que irão vencer em 10 dias."
    msg.attach(MIMEText(body, 'plain'))
    
    with open(filename, 'rb') as file:
        part = MIMEText(file.read().decode('utf-8'))
        part.add_header('Content-Disposition', 'attachment', filename=filename)
        msg.attach(part)
    
    try:
        with smtplib.SMTP(email_config.smtp_server, email_config.smtp_port) as server:
            server.starttls()
            server.login(email_config.email_usuario, email_config.email_senha)
            server.send_message(msg)
        print("E-mail enviado com sucesso!")
    except Exception as e:
        print(f"Erro ao enviar e-mail: {str(e)}")

def main():
    columns, results = execute_procedure()
    if results:
        filename = generate_txt_file(columns, results)
        send_email(filename)
        print(f"Procedure executada e resultado enviado por e-mail com sucesso! Arquivo gerado: {filename}")
        # Opcional: remover o arquivo após o envio
        # os.remove(filename)
    else:
        print("Falha ao executar a procedure.")

if __name__ == "__main__":
    main()