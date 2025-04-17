# GeraGrafico.py
import pandas as pd
import streamlit as st
import matplotlib.pyplot as plt
import seaborn as sns
from database_connection import DatabaseConnection

# Instanciar a classe de conexão
db = DatabaseConnection()

# Conectar ao banco de dados
conn = db.connect()

# Verificar se a conexão foi bem-sucedida
if conn:
    # Executar a consulta SQL
    query = """
    WITH DistinctClientsPerUF AS (
        SELECT 
            DIM.UF,
            cod_clifor,
            ROW_NUMBER() OVER (PARTITION BY DIM.UF, FATO.cod_clifor ORDER BY FATO.cod_clifor) AS rn
        FROM 
            CLIFOR FATO
        LEFT JOIN 
            CIDADES DIM ON DIM.CODIIBGE = FATO.CODICIDADE
    ),
    ClientCounts AS (
        SELECT 
            UF,
            COUNT(DISTINCT cod_clifor) AS QTD_CLIENTES_UNIQ
        FROM 
            DistinctClientsPerUF
        WHERE rn = 1
        GROUP BY 
            UF
    )
    SELECT 
        FATO.cod_clifor,
        FATO.fantasia,
        DIM.UF,
        CC.QTD_CLIENTES_UNIQ
    FROM 
        CLIFOR FATO
    LEFT JOIN 
        CIDADES DIM ON DIM.CODIIBGE = FATO.CODICIDADE
    LEFT JOIN 
        ClientCounts CC ON DIM.UF = CC.UF;
    """

    df = pd.read_sql(query, conn)

    # Fechar a conexão
    db.close()

    # Agrupar os dados por UF e obter a contagem de clientes únicos
    uf_counts = df[['UF', 'QTD_CLIENTES_UNIQ']].drop_duplicates()

    # Configurar o Streamlit
    st.title('Quantidade de Clientes Únicos por UF')

    # Criar um gráfico de barras mais avançado com Seaborn
    plt.figure(figsize=(14, 8))
    sns.barplot(data=uf_counts, x='UF', y='QTD_CLIENTES_UNIQ', palette='viridis')
    plt.title('Quantidade de Clientes Únicos por UF', fontsize=20)
    plt.xlabel('UF', fontsize=15)
    plt.ylabel('Quantidade de Clientes Únicos', fontsize=15)
    plt.xticks(rotation=45)
    plt.grid(True, which='both', linestyle='--', linewidth=0.5)

    # Remover o contorno da parte superior e da direita do gráfico
    sns.despine()

    # Mostrar o gráfico no Streamlit
    st.pyplot(plt)
else:
    st.error("Falha ao conectar ao banco de dados.")
