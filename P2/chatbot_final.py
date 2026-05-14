import warnings
warnings.filterwarnings("ignore")

from langchain_community.document_loaders import TextLoader
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_community.embeddings import OllamaEmbeddings
from langchain_community.vectorstores import Chroma
from langchain_community.llms import Ollama
from langchain_core.prompts import PromptTemplate
from langchain_classic.chains import RetrievalQA

# Importações para a interface visual
from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from rich.live import Live
from rich.text import Text
from rich.prompt import Prompt

console = Console()

# ==========================================
# 1. PROMPT ENGINEERING
# ==========================================
prompt = PromptTemplate(
    input_variables=["context", "question"],
    template="""
És um enfermeiro de triagem do SNS24.
Analisa os sintomas do doente usando APENAS os protocolos oficiais.

Protocolos: {context} 
Sintomas: {question}

Responde ESTRITAMENTE com esta estrutura:
Sintomas Identificados: [Resumo]
Nível de Urgência: [EMERGÊNCIA, URGENTE, CONSULTA ou AUTO-CUIDADO]
Encaminhamento: [Ação]
Justificação Clínica: [Explicação]
Citação: [Nome do Protocolo]
"""
)

# ==========================================
# 2. PIPELINE RAG
# ==========================================
with console.status("[bold cyan]A carregar Base de Conhecimento SNS24...", spinner="dots"):
    loader = TextLoader("sns24_kb.txt", encoding="utf-8")
    documentos = loader.load()
    splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=50)
    chunks = splitter.split_documents(documentos)
    
    embeddings = OllamaEmbeddings(model="nomic-embed-text")
    vector_db = Chroma.from_documents(
        documents=chunks, 
        embedding=embeddings, 
        persist_directory="./chroma_sns24_final"
    )

    chatbot = RetrievalQA.from_chain_type(
        llm=Ollama(model="llama3.2", temperature=0.1),
        retriever=vector_db.as_retriever(search_kwargs={"k": 3}),
        chain_type_kwargs={"prompt": prompt}
    )

# ==========================================
# 3. INTERFACE VISUAL (RICH)
# ==========================================

def mostrar_cabecalho():
    grid = Table.grid(expand=True)
    grid.add_column(justify="center", ratio=1)
    grid.add_row("[bold white on blue]\n  SISTEMA INTELIGENTE DE TRIAGEM SNS24  \n[/bold white on blue]")
    grid.add_row("[dim]Projeto P2 - LEGSI (Universidade do Minho)[/dim]\n")
    console.print(Panel(grid, border_style="blue"))

def formatar_resposta(texto_raw):
    # Parsing básico da resposta para a tabela
    linhas = texto_raw.split('\n')
    dados = {}
    for linha in linhas:
        if ":" in linha:
            chave, valor = linha.split(":", 1)
            dados[chave.strip()] = valor.strip()
    
    # Definir cor baseada na urgência [cite: 41, 42, 43]
    urgencia = dados.get("Nível de Urgência", "").upper()
    cor = "green"
    if "EMERGÊNCIA" in urgencia: cor = "bold red"
    elif "URGENTE" in urgencia: cor = "bold yellow"
    elif "CONSULTA" in urgencia: cor = "cyan"

    table = Table(title="Relatório de Triagem", show_header=False, border_style=cor)
    table.add_row("[bold]Sintomas[/]", dados.get("Sintomas Identificados", "---"))
    table.add_row("[bold]Urgência[/]", f"[{cor}]{urgencia}[/]")
    table.add_row("[bold]Ação[/]", dados.get("Encaminhamento", "---"))
    table.add_row("[bold]Justificação[/]", dados.get("Justificação Clínica", "---"))
    table.add_row("[bold]Protocolo[/]", f"[dim]{dados.get('Citação', '---')}[/]")
    
    return table

# Loop Principal
mostrar_cabecalho()

while True:
    pergunta = Prompt.ask("\n[bold blue]Descreva os sintomas[/]")
    
    if pergunta.lower() in ['sair', 'exit', 'quit']:
        console.print("\n[bold green]As melhoras! Sessão terminada.[/]\n")
        break
        
    with console.status("[bold yellow]A aplicar protocolos Altitude...[/]", spinner="dots"):
        resposta = chatbot.invoke(pergunta)
        resultado_tabela = formatar_resposta(resposta['result'])
    
    console.print("\n", resultado_tabela)
    console.print("[dim]─" * 60 + "[/]\n")