import tkinter as tk
from tkinter import ttk, messagebox
import psycopg2
import pandas as pd
import os
from datetime import datetime

# Configuração do banco
DB_CONFIG = {
    'dbname': 'NORTEBAG',
    'user': 'postgres',
    'password': 'abc@123',
    'host': '10.200.0.250',
    'port': '5432'
}

def caminho_downloads(nome_arquivo):
    pasta_downloads = os.path.join(os.path.expanduser("~"), "Downloads")
    return os.path.join(pasta_downloads, nome_arquivo)

def exportar_tabelas(tabelas, modulo, formato):
    data_str = datetime.now().strftime("%d%m%y")
    try:
        with psycopg2.connect(**DB_CONFIG) as conn:
            conn.set_client_encoding('LATIN1')
            for tabela in tabelas:
                df = pd.read_sql_query(f'SELECT * FROM "{tabela}"', conn)
                nome_arquivo = f"{tabela}_{data_str}_Nortebag.{formato}"
                caminho_final = caminho_downloads(nome_arquivo)

                if formato == "csv":
                    df.to_csv(caminho_final, index=False, sep=';', encoding='utf-8')
                elif formato == "txt":
                    with open(caminho_final, 'w', encoding='utf-8') as f:
                        f.write(df.to_string(index=False))

        messagebox.showinfo("Sucesso", f"Tabelas do módulo '{modulo}' exportadas com sucesso para Downloads!")
    except Exception as e:
        messagebox.showerror("Erro", str(e))

def consultar_top10(tabela):
    try:
        with psycopg2.connect(**DB_CONFIG) as conn:
            conn.set_client_encoding('LATIN1')
            df = pd.read_sql_query(f'SELECT * FROM "{tabela}" LIMIT 10', conn)
            exibir_resultado(df, tabela)
    except Exception as e:
        messagebox.showerror("Erro", str(e))

def exibir_resultado(df, titulo):
    resultado_janela = tk.Toplevel(root)
    resultado_janela.title(f"Top 10 - {titulo}")

    frame = tk.Frame(resultado_janela)
    frame.pack(fill='both', expand=True)

    canvas = tk.Canvas(frame)
    canvas.pack(side='left', fill='both', expand=True)

    scroll_y = tk.Scrollbar(frame, orient='vertical', command=canvas.yview)
    scroll_y.pack(side='right', fill='y')

    scroll_x = tk.Scrollbar(resultado_janela, orient='horizontal', command=canvas.xview)
    scroll_x.pack(side='bottom', fill='x')

    canvas.configure(yscrollcommand=scroll_y.set, xscrollcommand=scroll_x.set)
    canvas.bind('<Configure>', lambda e: canvas.configure(scrollregion=canvas.bbox('all')))

    subframe = tk.Frame(canvas)
    canvas.create_window((0, 0), window=subframe, anchor='nw')

    tree = ttk.Treeview(subframe)
    tree.pack(fill='both', expand=True)

    tree["columns"] = list(df.columns)
    tree["show"] = "headings"

    for col in df.columns:
        tree.heading(col, text=col)
        tree.column(col, width=150)

    for _, row in df.iterrows():
        tree.insert("", "end", values=list(row))

# Interface principal
root = tk.Tk()
root.title("Exportador - Módulos NORTEBAG")
root.geometry("480x650")

label = tk.Label(root, text="Selecione o módulo e a ação desejada", font=("Arial", 14))
label.pack(pady=10)

# ===== MÓDULO CONTAS A PAGAR =====
tk.Label(root, text="Módulo: Contas a Pagar (9 tabelas)", font=("Arial", 10, "bold")).pack(pady=5)
tk.Button(root, text="Visualizar Top 10 da tabela CPCADA", width=42, command=lambda: consultar_top10("cpcada")).pack(pady=2)
tk.Button(root, text="Exportar módulo (CSV)", width=42, command=lambda: exportar_tabelas(["cpcada", "cpmovi", "cpplanocontas", "cpplanocontascc", "tipodocto", "plano_contas", "portador", "usuario", "centro_custo"], "Contas a Pagar", "csv")).pack(pady=2)
tk.Button(root, text="Exportar módulo (TXT)", width=42, command=lambda: exportar_tabelas(["cpcada", "cpmovi", "cpplanocontas", "cpplanocontascc", "tipodocto", "plano_contas", "portador", "usuario", "centro_custo"], "Contas a Pagar", "txt")).pack(pady=2)

# ===== MÓDULO CONTAS A RECEBER =====
tk.Label(root, text="Módulo: Contas a Receber (4 tabelas)", font=("Arial", 10, "bold")).pack(pady=10)
tk.Button(root, text="Visualizar Top 10 da tabela CRCADA", width=42, command=lambda: consultar_top10("crcada")).pack(pady=2)
tk.Button(root, text="Exportar módulo (CSV)", width=42, command=lambda: exportar_tabelas(["crcada", "crmovi", "representante", "serie"], "Contas a Receber", "csv")).pack(pady=2)
tk.Button(root, text="Exportar módulo (TXT)", width=42, command=lambda: exportar_tabelas(["crcada", "crmovi", "representante", "serie"], "Contas a Receber", "txt")).pack(pady=2)

# ===== MÓDULO PEDIDO DE COMPRA =====
tk.Label(root, text="Módulo: Pedido de Compra (10 tabelas)", font=("Arial", 10, "bold")).pack(pady=10)
tk.Button(root, text="Visualizar Top 10 da tabela PEDIDO_COMPRA", width=42, command=lambda: consultar_top10("pedido_compra")).pack(pady=2)
tk.Button(root, text="Exportar módulo (CSV)", width=42, command=lambda: exportar_tabelas(["pedido_compra", "pedcompra_item", "pedcitem_planocontascc", "pedcitem_planocontas", "transportadora", "cond_pagamento", "prioridade", "tributacao", "unidade", "nat_operacao"], "Pedido de Compra", "csv")).pack(pady=2)
tk.Button(root, text="Exportar módulo (TXT)", width=42, command=lambda: exportar_tabelas(["pedido_compra", "pedcompra_item", "pedcitem_planocontascc", "pedcitem_planocontas", "transportadora", "cond_pagamento", "Prioridade", "tributacao", "unidade", "nat_operacao"], "Pedido de Compra", "txt")).pack(pady=2)

# ===== MÓDULO ESTOQUE =====
tk.Label(root, text="Módulo: Estoque (4 tabelas)", font=("Arial", 10, "bold")).pack(pady=10)
tk.Button(root, text="Visualizar Top 10 da tabela ESTOQ_MOVTO", width=42, command=lambda: consultar_top10("estoq_movto")).pack(pady=2)
tk.Button(root, text="Exportar módulo (CSV)", width=42, command=lambda: exportar_tabelas(["estoq_movto", "ordem_producao", "deposito", "localizacao"], "Estoque", "csv")).pack(pady=2)
tk.Button(root, text="Exportar módulo (TXT)", width=42, command=lambda: exportar_tabelas(["estoq_movto", "ordem_producao", "deposito", "localizacao"], "Estoque", "txt")).pack(pady=2)

root.mainloop()