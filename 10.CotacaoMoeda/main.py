import requests
from database_connection import DatabaseConnection
from datetime import datetime

# Função para obter as taxas de câmbio
def get_exchange_rates():
    url = 'https://api.exchangerate-api.com/v4/latest/USD'  # Endpoint para obter taxas de câmbio baseadas no USD
    try:
        response = requests.get(url)
        data = response.json()
        return {
            'BRL': data['rates']['BRL'],
            'USD': data['rates']['USD'],
            'EUR': data['rates']['EUR']
        }
    except Exception as e:
        print(f"Erro ao obter taxas de câmbio: {e}")
        return None

# Função para inserir as taxas no banco de dados
def insert_exchange_rates_to_db(rates):
    db = DatabaseConnection()
    conn = db.connect()
    
    if conn is None:
        print("Conexão com o banco de dados falhou.")
        return

    cursor = conn.cursor()
    
    try:
        for currency, rate in rates.items():
            query = "INSERT INTO exchange_rates (currency, rate, date) VALUES (?, ?, ?)"
            cursor.execute(query, (currency, rate, datetime.now()))
        
        conn.commit()
        print("Taxas de câmbio inseridas com sucesso!")
    except Exception as e:
        print(f"Erro ao inserir dados no banco de dados: {e}")
        conn.rollback()
    finally:
        cursor.close()
        db.close()

# Executa o processo de obtenção e inserção das taxas de câmbio
rates = get_exchange_rates()
if rates:
    insert_exchange_rates_to_db(rates)


"""
CREATE TABLE exchange_rates (
    id INT IDENTITY PRIMARY KEY,
    currency VARCHAR(3),
    rate DECIMAL(18, 6),
    date DATETIME DEFAULT GETDATE()
);
"""