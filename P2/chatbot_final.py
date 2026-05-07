import warnings
warnings.filterwarnings("ignore")

from langchain_community.document_loaders import TextLoader
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_community.embeddings import OllamaEmbeddings
from langchain_community.vectorstores import Chroma
from langchain_community.llms import Ollama
from langchain_core.prompts import PromptTemplate

# AQUI ESTÁ A CORREÇÃO: Usar o langchain_classic
from langchain_classic.chains import RetrievalQA

# ==========================================
# 1. PROMPT ENGINEERING
# ==========================================
prompt = PromptTemplate(
    input_variables=["context", "question"],
    template="""
És um enfermeiro de triagem do SNS24.
A tua função é analisar os sintomas do doente usando APENAS os protocolos oficiais fornecidos abaixo.
Não inventes diagnósticos fora destes documentos.

Protocolos (Base de Conhecimento RAG): 
{context} 

Sintomas do Doente: {question}

Raciocínio Interno:
1. Analisa os sintomas reportados.
2. Procura sinais de alarme no contexto para determinar se é EMERGÊNCIA, URGENTE, CONSULTA ou AUTO-CUIDADO.

Responde ESTRITAMENTE com a seguinte estrutura:

**Sintomas Identificados:** [Breve resumo]
**Nível de Urgência:** [EMERGÊNCIA, URGENTE, CONSULTA ou AUTO-CUIDADO]
**Encaminhamento:** [Ação que o doente deve tomar]
**Justificação Clínica:** [Explicação da decisão com base nos sintomas]
**Citação:** [Cita o nome ou secção do Protocolo SNS24 utilizado]
"""
)

# ==========================================
# 2. PIPELINE RAG (Indexação e Vetores)
# ==========================================
print("[1/3] A carregar a Base de Conhecimento SNS24...")
# ATENÇÃO: O ficheiro sns24_kb.txt TEM de estar na mesma pasta (P2)!
loader = TextLoader("sns24_kb.txt", encoding="utf-8")
documentos = loader.load()

splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=50)
chunks = splitter.split_documents(documentos)

print("[2/3] A preparar a Vector DB (ChromaDB)...")
embeddings = OllamaEmbeddings(model="nomic-embed-text")
vector_db = Chroma.from_documents(
    documents=chunks, 
    embedding=embeddings, 
    persist_directory="./chroma_sns24_final"
)

# ==========================================
# 3. INICIAR O MODELO (llama3.2)
# ==========================================
print("[3/3] A iniciar o Agente LLM...")
chatbot = RetrievalQA.from_chain_type(
    llm=Ollama(model="llama3.2", temperature=0.1),
    retriever=vector_db.as_retriever(search_kwargs={"k": 3}),
    chain_type_kwargs={"prompt": prompt}
)

# ==========================================
# 4. INTERFACE DO CHATBOT
# ==========================================
print("\n" + "="*60)
print(" 🏥 AGENTE SNS24 - TRIAGEM INTELIGENTE ".center(60))
print("="*60)
print("Olá! Sou o assistente virtual de triagem SNS24.")
print("Escreva 'sair' para terminar a sessão\n")

while True:
    sintomas = input("👤 Doente: ")
    
    if sintomas.lower() in ['sair', 'exit', 'quit']:
        print("\n🩺 Agente SNS24: As melhoras! Sessão terminada.")
        break
        
    print("⏳ A consultar protocolos Altitude...")
    
    resposta = chatbot.invoke(sintomas)
    
    print(f"\n🩺 Agente SNS24:\n{resposta['result']}\n")
    print("-" * 60)