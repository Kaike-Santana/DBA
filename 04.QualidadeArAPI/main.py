import streamlit as st
import requests
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go

# Configuração da página do Streamlit
st.set_page_config(page_title="Monitoramento de Qualidade do Ar", layout="wide")

# Inserir o seu token da API do AQICN
API_TOKEN = "1bc9ee9f1409695bad1925962a7d1ed795272a0d"

# Função para buscar os dados da qualidade do ar
def get_air_quality_data(city: str, token: str):
    url = f"http://api.waqi.info/feed/{city}/?token={token}"
    try:
        response = requests.get(url)
        response.raise_for_status()  # Levanta um erro se a resposta HTTP for ruim
        data = response.json()
        if data["status"] == "ok":
            return data["data"]
        else:
            return None
    except requests.exceptions.RequestException as e:
        return None

# Função para interpretar os níveis de AQI
def interpret_aqi(aqi):
    if aqi <= 50:
        return "Boa", "Níveis de poluentes são considerados seguros.", "green"
    elif aqi <= 100:
        return "Moderada", "A qualidade do ar é aceitável; algumas pessoas sensíveis podem apresentar desconfortos respiratórios.", "yellow"
    elif aqi <= 150:
        return "Ruim para grupos sensíveis", "Pessoas com condições respiratórias e cardíacas podem sentir efeitos adversos.", "orange"
    elif aqi <= 200:
        return "Ruim", "Toda a população pode começar a sentir efeitos adversos à saúde.", "red"
    elif aqi <= 300:
        return "Muito ruim", "Sérios efeitos à saúde; emergências médicas podem ocorrer.", "purple"
    else:
        return "Perigosa", "Todo mundo pode sentir graves problemas de saúde.", "maroon"

# Título da aplicação
st.title("🌍 Monitoramento da Qualidade do Ar")

# Campo de entrada para o usuário escolher a cidade, sem valor padrão
city = st.text_input("Digite o nome da cidade (em inglês):")

# Validação: Se o usuário não digitou nada
if not city:
    st.info("Por favor, insira o nome de uma cidade para visualizar os dados.")
else:
    # Obter os dados da qualidade do ar
    data = get_air_quality_data(city, API_TOKEN)

    # Validação: Se a cidade não for encontrada ou o nome for inválido
    if data is None:
        st.error(f"Não foi possível encontrar dados para a cidade '{city}'. Verifique se o nome está correto e tente novamente.")
    else:
        # Extração dos principais dados
        aqi = data["aqi"]
        iaqi = data["iaqi"]

        # Interpretar o AQI
        aqi_status, health_message, color = interpret_aqi(aqi)

        # Exibir a qualidade geral do ar (AQI) com mensagem sobre saúde
        st.subheader(f"Índice de Qualidade do Ar (AQI) em {city.capitalize()}: {aqi} ({aqi_status})")
        st.markdown(f"**Mensagem sobre saúde:** {health_message}")
        st.markdown(f"### Níveis de AQI e seus efeitos:")
        st.markdown("""
        - **0-50 (Boa)**: Qualidade do ar considerada satisfatória; sem riscos à saúde.
        - **51-100 (Moderada)**: Qualidade aceitável; algumas pessoas sensíveis podem sentir desconfortos respiratórios.
        - **101-150 (Insalubre para Grupos Sensíveis)**: Grupos sensíveis podem ter efeitos adversos.
        - **151-200 (Insalubre)**: Toda a população pode sentir efeitos adversos.
        - **201-300 (Muito Insalubre)**: Efeitos graves à saúde para todos.
        - **300+ (Perigosa)**: Condições de emergência; riscos graves para a saúde de toda a população.
        """)

        # Coletar os poluentes e suas concentrações
        pollutants = []
        concentrations = []
        for pollutant, value in iaqi.items():
            pollutants.append(pollutant)
            concentrations.append(value['v'])

        # Criar DataFrame com os dados
        df = pd.DataFrame({
            "Poluente": pollutants,
            "Concentração (µg/m³)": concentrations
        })

        # Exibir os dados em um gráfico de barras com cores baseadas nos níveis de poluentes
        fig = px.bar(df, x="Poluente", y="Concentração (µg/m³)", title=f"Níveis de Poluentes em {city.capitalize()}",
                     labels={"Concentração (µg/m³)": "Concentração (µg/m³)", "Poluente": "Poluentes"}, 
                     template="plotly_white", color="Concentração (µg/m³)", 
                     color_continuous_scale=["green", "yellow", "orange", "red", "purple", "maroon"])

        # Customizações adicionais no gráfico
        fig.update_layout(
            title_font=dict(size=20),
            xaxis_title="Poluente",
            yaxis_title="Concentração (µg/m³)",
            font=dict(family="Arial", size=14),
            title_x=0.5
        )

        # Adicionar linha de referência para valores ideais (exemplo: PM2.5 ideal < 12 µg/m³)
        fig.add_hline(y=12, line_dash="dash", line_color="green", annotation_text="PM2.5 Ideal (<12 µg/m³)", annotation_position="top right")

        # Exibir o gráfico
        st.plotly_chart(fig, use_container_width=True)

        # Exibir a tabela de dados
        st.subheader("📊 Detalhes dos Poluentes")
        st.dataframe(df.style.background_gradient(cmap="RdYlGn", axis=0))

        # Exibir uma tabela explicativa sobre o que significa cada poluente
        st.markdown("### Explicações dos Poluentes:")
        st.write(pd.DataFrame({
            "Poluente": ["dew", "h", "p", "pm25", "t", "w"],
            "Descrição": [
                "Ponto de orvalho (dew point)", 
                "Umidade relativa do ar (%)", 
                "Pressão atmosférica (hPa)", 
                "Partículas finas (PM2.5) em µg/m³", 
                "Temperatura do ar (°C)", 
                "Velocidade do vento (m/s)"
            ]
        }))