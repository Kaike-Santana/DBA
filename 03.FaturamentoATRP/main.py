import streamlit as st
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go

# Configuração da página
st.set_page_config(page_title="Painel de Controle de Faturamento", layout="wide", page_icon="💰")

# Título e descrição
st.title("📊 Painel de Controle de Faturamento")
st.markdown("""
    Este painel interativo fornece uma visão consolidada e detalhada do faturamento de várias fontes entre maio e Março de 2025
    Use os filtros para explorar as diferentes fontes de receita e ajustar o intervalo de tempo conforme necessário.
""")
# Substitua a definição de dados no seu código por esta:
dados = {
    'Month': [
        'May 2024', 'June 2024', 'July 2024', 'August 2024', 'September 2024', 'October 2024',
        'May 2024', 'June 2024', 'July 2024', 'August 2024', 'September 2024',
        'May 2024', 'June 2024', 'July 2024', 'August 2024', 'September 2024',
        'May 2024', 'June 2024', 'July 2024', 'August 2024', 'September 2024',
        'May 2024', 'June 2024', 'July 2024', 'August 2024', 'September 2024',
        'September 2024', 'October 2024', 'November 2024', 'December 2024',
        'November 2024', 'December 2024',
        'January 2025', 'January 2025', 'January 2025',
        'February 2025', 'February 2025',
        'March 2025',
        'April 2025', 'April 2025'
    ],
    'Fonte': [
        'Salário ATRP', 'Salário ATRP', 'Salário ATRP', 'Salário ATRP', 'Salário ATRP', 'Salário ATRP',
        'Salário ATMA', 'Salário ATMA', 'Salário ATMA', 'Salário ATMA', 'Salário ATMA',
        'Rescisão ATMA', 'Rescisão ATMA', 'Rescisão ATMA', 'Rescisão ATMA', 'Rescisão ATMA',
        'Multa FGTS ATMA', 'Multa FGTS ATMA', 'Multa FGTS ATMA', 'Multa FGTS ATMA', 'Multa FGTS ATMA',
        'Restituição IRRF', 'Restituição IRRF', 'Restituição IRRF', 'Restituição IRRF', 'Restituição IRRF',
        'Seguro Desemprego', 'Seguro Desemprego', 'Seguro Desemprego', 'Seguro Desemprego',
        'Salário ATRP', 'Salário ATRP',
        'Salário ATRP', 'Seguro Desemprego', 'Consultoria',
        'Salário ATRP', 'Consultoria',
        'Salário ATRP',
        'Salário ATRP', 'Consultoria'
    ],
    'Valor (R$)': [
        8700, 9000, 9000, 11000, 11000, 11000,
        5500, 5500, 5500, 5500, 0,
        0, 0, 0, 15000, 0,
        0, 0, 0, 4500, 0,
        0, 0, 0, 1600, 0,
        2314, 2314, 2314, 2314,
        11000, 11000,
        11000, 2314, 5000,
        11000, 0,
        11000,
        11000, 1523
    ]
}


# Criando um DataFrame
df = pd.DataFrame(dados)

# Convertendo 'Month' para formato AAAA/MM e salvando na coluna Date
df['Date'] = pd.to_datetime(df['Month'], format='%B %Y').dt.strftime('%Y/%m')

# Ordenando pelo campo 'Date'
df = df.sort_values(by='Date')

# Layout com colunas para os filtros
col1, col2 = st.columns([1, 2])

# Criação das abas
aba = col1.selectbox("Selecione a visualização:", ["Consolidado", "ATMA", "ATRP", "Restituição IRRF", "Seguro Desemprego"])

# Lógica de filtro baseado na aba selecionada
if aba == "ATMA":
    filtro_subfonte = col1.multiselect("Selecione a Sub-Fonte de Faturamento:", 
                                       options=['Salário ATMA', 'Rescisão ATMA', 'Multa FGTS ATMA'])
    if filtro_subfonte:
        df_filtrado = df[df['Fonte'].isin(filtro_subfonte)]
    else:
        df_filtrado = df[df['Fonte'].str.contains('ATMA', na=False)]
elif aba == "ATRP":
    df_filtrado = df[df['Fonte'] == 'Salário ATRP']
elif aba == "Restituição IRRF":
    df_filtrado = df[df['Fonte'] == 'Restituição IRRF']
elif aba == "Seguro Desemprego":
    df_filtrado = df[df['Fonte'] == 'Seguro Desemprego']
else:  # Aba Consolidado
    df_filtrado = df.dropna(subset=['Fonte'])

# Filtro de meses
with col2:
    st.subheader("Filtrar por intervalo de meses")
    meses_disponiveis = df['Date'].unique()
    mes_inicio = st.selectbox("Mês de Início", sorted(meses_disponiveis), index=0, key="mes_inicio")
    mes_fim = st.selectbox("Mês de Fim", sorted(meses_disponiveis), index=len(meses_disponiveis)-1, key="mes_fim")

# Filtrar dados com base no intervalo de meses
df_filtrado = df_filtrado[(df_filtrado['Date'] >= mes_inicio) & (df_filtrado['Date'] <= mes_fim)]

# Gráfico de faturamento
st.subheader("📈 Faturamento ao Longo do Tempo")
fig = px.line(
    df_filtrado, 
    x='Date', 
    y='Valor (R$)', 
    color='Fonte', 
    markers=True, 
    line_shape='linear',
    labels={'Date': 'Mês', 'Valor (R$)': 'Faturamento (R$)'},
    template="plotly_white"
)

# Customizando o gráfico
fig.update_layout(
    title="Evolução do Faturamento de Maio de 2024 a Janeiro de 2025",
    xaxis_title="Mês",
    yaxis_title="Faturamento (R$)",
    hovermode="x unified",
    font=dict(family="Arial", size=14),
    title_font=dict(size=20)
)

# Adicionando controle deslizante de tempo
fig.update_xaxes(
    rangeslider_visible=True,
    rangeselector=dict(
        buttons=list([
            dict(count=1, label="1m", step="month", stepmode="backward"),
            dict(count=3, label="3m", step="month", stepmode="backward"),
            dict(step="all", label="Tudo")
        ])
    )
)

# Exibindo o gráfico
st.plotly_chart(fig, use_container_width=True)

# Faturamento total
faturamento_total = df_filtrado['Valor (R$)'].sum()
col2.metric("Faturamento Total", f"R$ {faturamento_total:,.2f}".replace(",", "X").replace(".", ",").replace("X", "."))

# Exibir o DataFrame filtrado com o formato AAAA/MM
st.subheader("📁 Dados Detalhados")
st.dataframe(
    df_filtrado
    .style
    .format({"Valor (R$)": "{:,.2f}"})  # Formata o valor para duas casas decimais
    .highlight_max(subset="Valor (R$)", color='lightgreen')
    .highlight_min(subset="Valor (R$)", color='pink')
)