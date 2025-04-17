import requests
from pyspark.sql import SparkSession
import json

# Inicializa uma sessão Spark
spark = SparkSession.builder \
    .appName("API to DataFrame") \
    .getOrCreate()

# Etapa 1: Fazer a requisição HTTP para uma API pública (neste caso, a JSON Placeholder)
url = "https://jsonplaceholder.typicode.com/posts"
response = requests.get(url)

# Verificar se a resposta foi bem sucedida (código 200)
if response.status_code == 200:
    # Converte a resposta JSON para um objeto Python (lista de dicionários)
    data = response.json()

    # Etapa 2: Criar um DataFrame PySpark a partir dos dados
    # O Spark aceita listas de dicionários para criar DataFrames
    df = spark.createDataFrame(data)

    # Exibe o DataFrame para verificar os dados
    df.show(truncate=False)

    # Etapa 3: Registrar o DataFrame como uma tabela temporária para consultas SQL
    df.createOrReplaceTempView("posts")

    # Agora você pode fazer consultas SQL no DataFrame usando Spark SQL
    # Exemplo de consulta SQL
    result_df = spark.sql("SELECT userId, id, title FROM posts WHERE userId = 1")

    # Exibir o resultado da consulta
    result_df.show(truncate=False)

else:
    print(f"Erro ao fazer requisição: {response.status_code}")

# Finalizar a sessão Spark
spark.stop()