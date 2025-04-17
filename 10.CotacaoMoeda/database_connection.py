# database_connection.py
import pyodbc

class DatabaseConnection:
    def __init__(self):
        self.server = '10.200.0.4'
        self.database = 'thesys_dev'
        self.username = 'sa'
        self.password = '$MASTER@2023#'
        self.connection_string = f'DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={self.server};DATABASE={self.database};UID={self.username};PWD={self.password}'
        self.conn = None

    def connect(self):
        try:
            self.conn = pyodbc.connect(self.connection_string)
            print("Conexão bem-sucedida!")
            return self.conn
        except Exception as e:
            print(f"Erro ao conectar ao banco de dados: {e}")
            return None

    def close(self):
        if self.conn:
            self.conn.close()
            print("Conexão fechada.")