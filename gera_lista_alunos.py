import pandas as pd

# Lista fornecida de alunos
alunos_lista = [
    "ALEXANDRE RODRIGUES SANTAROSSA", "ANA LAIZ NOVAIS DE FARIAS", "BRUNA LIMA MEINBERG",
    "CAROLINE CHAIM DE LIMA CARNEIRO", "DIOGO PEREIRA LOBO", "DOUGLAS PABLO GABRIEL MENDONÇA DE MELLO HERMIDA",
    "FERNANDA DE OLIVEIRA PEREIRA", "GIOVANA CASSONI ANDRADE", "GUSTAVO MENDES DA SILVA",
    "ISABELLA DOS SANTOS DE AMORIM", "KEVIN NAGAYUKI SHINOHARA", "LUANA WILNER ABRAMOFF",
    "NICOLAS ENZO YASSUDA", "PEDRO FRACASSI", "PEDRO GOMES DE SÁ DRUMOND", "PEDRO HENRIQUE RIZO COLPAS",
    "TALES IVALQUE TAVEIRA DE FREITAS","ALBERTO MANSUR", "ARIEL TAMEZGUI LEVENTHAL", "ARTHUR MOREIRA", 
    "BRUNO MARQUES LI VOLSI FALCAO", "CAIO ORTEGA BÔA", "GUSTAVO ELIZIARIO STEVENSON DE OLIVEIRA", 
    "JERÔNIMO DE ABREU AFRANGE", "JOÃO PEDRO RODRIGUES SANTOS", "LUCA MIZRAHI", "MATHEUS RAFFAELLE NERY CASTELLUCCI", 
    "MATHEUS RIBEIRO BARROS", "PEDRO BALBO PORTELLA", "PEDRO CLIQUET DO AMARAL", "PEDRO TOLEDO PIZA CIVITA", 
    "RODRIGO PAOLIELLO DE MEDEIROS"
]

# Remover entradas vazias
alunos_lista = [aluno for aluno in alunos_lista if aluno]

# Criar um DataFrame com a lista de alunos
df_alunos_lista = pd.DataFrame(alunos_lista, columns=["Alunos"])

# Salvando em um arquivo CSV
df_alunos_lista.to_csv('alunos.csv', index=False)
