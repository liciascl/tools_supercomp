#!/bin/bash

# Nome do arquivo CSV contendo as informações dos alunos
alunos_csv="lista_de_grupos.csv"

# Criação de um diretório para armazenar as chaves geradas
mkdir -p chaves_alunos

# Loop através do arquivo CSV para criar usuários
while IFS=, read -r group_code user_name student_id first_name last_name; do
    # Ignorar a primeira linha do arquivo CSV (cabeçalho)
    if [[ "$user_name" != "User Name" && -n "$user_name" ]]; then

        # Criar diretório para o aluno
        mkdir -p "chaves_alunos/$user_name"

        # Geração das chaves SSH
        ssh-keygen -t rsa -b 2048 -f "chaves_alunos/$user_name/id_rsa" -q -N ""


        echo "Chaves SSH geradas para o usuario $user_name"

    fi
done < <(tail -n +2 "$alunos_csv")

echo "Todas as chaves foram geradas."
