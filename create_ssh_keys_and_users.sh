#!/bin/bash

# Nome do arquivo CSV contendo as informações dos alunos
alunos_csv="alunos.csv"

# Criação de um diretório para armazenar as chaves geradas
mkdir -p chaves_alunos

# Arquivo para registrar os nomes de usuários criados
usuarios_criados="usuarios_criados.txt"

# Limpar o conteúdo do arquivo de usuários criados
> "$usuarios_criados"

# Loop através do arquivo CSV para criar usuários
while IFS=, read -r aluno; do
    # Ignorar a primeira linha do arquivo CSV (cabeçalho)
    if [[ "$aluno" != "Alunos" && -n "$aluno" ]]; then
        # Extrair o primeiro nome
        primeiro_nome=$(echo "$aluno" | awk '{print $1}')
        
        # Extrair as primeiras letras dos sobrenomes
        sobrenomes=$(echo "$aluno" | awk '{$1=""; print $0}')
        abreviacao_sobrenomes=$(echo "$sobrenomes" | awk '{for(i=1;i<=NF;i++) printf "%s", substr($i,1,1)}')

        # Criar o nome de usuário
        usuario=$(echo "${primeiro_nome}${abreviacao_sobrenomes}" | tr '[:upper:]' '[:lower:]' | tr -d '[:punct:]')

        echo "Criando usuário: $usuario"

        # Criar o usuário com diretório home e sem senha
        useradd -m -s /bin/bash "$usuario"

        # Configurar para que o usuário não possa fazer login com senha
        passwd -l "$usuario"

        # Remover permissões sudo do usuário, se existirem
        deluser "$usuario" sudo 2>/dev/null || gpasswd -d "$usuario" sudo 2>/dev/null

        # Registrar o nome de usuário criado
        echo "$usuario" >> "$usuarios_criados"

        # Criação de um diretório para o aluno
        mkdir -p "chaves_alunos/$usuario"

        # Geração das chaves SSH
        ssh-keygen -t rsa -b 2048 -f "chaves_alunos/$usuario/id_rsa" -q -N ""

        # Criar o diretório .ssh no home do usuário
        mkdir -p /home/"$usuario"/.ssh

        # Copiar a chave pública para o diretório .ssh do usuário
        cp "chaves_alunos/$usuario/id_rsa.pub" /home/"$usuario"/.ssh/authorized_keys

        # Ajustar as permissões corretas
        chown -R "$usuario":"$usuario" /home/"$usuario"/.ssh
        chmod 700 /home/"$usuario"/.ssh
        chmod 600 /home/"$usuario"/.ssh/authorized_keys

        echo "Usuário criado e removido do grupo sudo: $usuario"
        echo "Chaves SSH geradas e copiadas para o diretório .ssh do usuário: $usuario"
    fi
done < "$alunos_csv"

echo "Todos os usuários foram criados e removidos do grupo sudo."
echo "A lista de usuários criados está em $usuarios_criados."
echo "Todas as chaves foram geradas e copiadas para as pastas .ssh dos respectivos usuários."
