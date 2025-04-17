import pandas as pd
from datetime import datetime
from DatabaseConnecction import DatabaseConnection  # Importa a classe do outro módulo

# Função para ler a planilha Excel usando Pandas
def read_excel_with_pandas():
    file_path = 'Controle Vencimento Licencas_ atualizada 04-12-2024.xlsx'
    
    # Lê a planilha Excel usando Pandas
    df = pd.read_excel(file_path, sheet_name='Clientes')  
    
    # Remover espaços extras nos nomes das colunas
    df.columns = df.columns.str.strip()

    # Exibe os nomes das colunas para verificação
    print(df.columns)

    # Renomeia as colunas para facilitar o uso
    df = df.rename(columns={
        'Licença da polícia Federal': 'licenca_pf',
        'Dias restantes': 'dias_restantes_licenca',
        'Alvará da polícia civil': 'alvara_pc',
        'Certificado de vistoria da polícia civil': 'vistoria_pc'
    })
    
    return df

# Função para atualizar o banco de dados com base nos dados filtrados
def update_database_with_pandas(df):
    db = DatabaseConnection()
    conn = db.connect()

    if conn is None:
        return

    cursor = conn.cursor()

    # Obtem todos os CNPJs do banco de dados
    cursor.execute("Select Cnpj From Clifor")
    all_cnpjs_in_db = set(row[0] for row in cursor.fetchall())

    # Obtem os CNPJs presentes no Excel
    cnpjs_in_excel = set(df['CNPJ'])

    # Determina os CNPJs que não estão no Excel
    cnpjs_not_in_excel = all_cnpjs_in_db - cnpjs_in_excel

    # Atualiza os registros presentes no Excel
    for index, row in df.iterrows():
        cnpj = row['CNPJ']
        licenca_pf = row['licenca_pf'] if pd.notnull(row['licenca_pf']) else None
        vistoria_pc = row['vistoria_pc'] if pd.notnull(row['vistoria_pc']) else None
        licenca_pc = row['alvara_pc'] if pd.notnull(row['alvara_pc']) else None

        # Query de update diretamente no banco de dados para cada CNPJ presente no DataFrame
        update_query = """
        UPDATE clifor
        SET 
            check_licencas_para_vendas = 'S',
            validade_licenca_pf = IIF(TRY_CONVERT(DATE, ?) IS NOT NULL, ?, NULL),
            validade_vistoria_pc = IIF(TRY_CONVERT(DATE, ?) IS NOT NULL, ?, NULL),
            validade_licenca_pc = IIF(TRY_CONVERT(DATE, ?) IS NOT NULL, ?, NULL)
        WHERE cnpj = ?
        """

        # Executa a query de update
        cursor.execute(update_query, licenca_pf, licenca_pf, vistoria_pc, vistoria_pc, licenca_pc, licenca_pc, cnpj)

        # Imprime o CNPJ atualizado
        print(f"CNPJ atualizado: {cnpj}")

# Atualiza os registros que não estão no Excel em uma única operação
    if cnpjs_not_in_excel:
    # Cria uma string contendo os CNPJs que não estão no Excel, formatados para a consulta SQL
        cnpjs_not_in_excel_placeholder = ', '.join(f"'{cnpj}'" for cnpj in cnpjs_not_in_excel)

    # Executa uma única query para atualizar todos os CNPJs ausentes no Excel
        update_query_null = f"""
        Update Clifor
        Set 
            Check_Licencas_Para_Vendas = Null
        Where Cnpj In ({cnpjs_not_in_excel_placeholder})
        """
        cursor.execute(update_query_null)

    # Imprime uma mensagem informando que os CNPJs foram marcados como NULL
    print(f"{len(cnpjs_not_in_excel)} CNPJs ausentes no Excel foram atualizados para NULL.")


    # Commit para confirmar as atualizações
    conn.commit()

    # Mensagem final indicando o sucesso do processo
    print("ETL finalizado! Atualizações de licenças realizadas com sucesso.")

    # Fecha a conexão
    cursor.close()
    db.close()

# Função principal para execução do script
def main():
    # Lê a planilha usando Pandas
    df = read_excel_with_pandas()
    
    # Atualiza o banco de dados com os dados filtrados
    update_database_with_pandas(df)

if __name__ == "__main__":
    main()