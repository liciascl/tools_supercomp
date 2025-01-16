#!/bin/bash

# Nome do arquivo CSV contendo as informações dos alunos
alunos_csv="alunos.csv"

# Diretório onde as chaves públicas dos alunos estão armazenadas
chaves_dir="chaves_alunos"

# Arquivo para registrar os nomes de usuários criados
usuarios_criados="usuarios_criados.txt"

# Limpar o conteúdo do arquivo de usuários criados
> "$usuarios_criados"


# Endereço do NFS ou diretório remoto (ajuste conforme necessário)
nfs_server="10.10.10.10"

# Loop através do arquivo CSV para criar usuários
while IFS=, read -r aluno; do
    # Ignorar a primeira linha do arquivo CSV (cabeçalho)
    if [ "$aluno" != "Alunos" ]; then
        # Extrair o primeiro nome
        primeiro_nome=$(echo "$aluno" | awk '{print $1}')
        
        # Extrair as primeiras letras dos sobrenomes
        sobrenomes=$(echo "$aluno" | awk '{$1=""; print $0}')
        abreviacao_sobrenomes=$(echo "$sobrenomes" | awk '{for(i=1;i<=NF;i++) printf "%s", substr($i,1,1)}')

        # Criar o nome de usuário
        usuario=$(echo "${primeiro_nome}${abreviacao_sobrenomes}" | tr '[:upper:]' '[:lower:]' | tr -d '[:punct:]')

        # Criar o usuário com diretório home e sem senha
        useradd -m -s /bin/bash "$usuario"

        # Configurar para que o usuário não possa fazer login com senha
        passwd -l "$usuario"


        # Criar o diretório .ssh no home do usuário
        mkdir -p /home/"$usuario"/.ssh

        # Copiar a chave pública para o diretório .ssh do usuário
        cp "$chaves_dir"/"$usuario"/id_rsa.pub /home/"$usuario"/.ssh/authorized_keys

        # Ajustar as permissões corretas
        chown -R "$usuario":"$usuario" /home/"$usuario"/.ssh
        chmod 700 /home/"$usuario"/.ssh
        chmod 600 /home/"$usuario"/.ssh/authorized_keys

        # Criar o diretório scratch dentro do diretório home do usuário
        sudo mkdir -p /home/"$usuario"/scratch
        chown "$usuario":"$usuario" /home/"$usuario"/scratch
        chmod 700 /home/"$usuario"/scratch

        # Adicionar entrada no fstab para montar o diretório scratch via NFS
        echo "$nfs_server:/home/$usuario/scratch /home/$usuario/scratch nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0" | sudo tee -a $CHROOT/etc/fstab

        # Remover permissões sudo do usuário
       gpasswd -d $usuario sudo

        echo "Usuário criado e configurado com a pasta scratch: $usuario"
	fi   
done < $alunos_csv

echo "Todos os usuários foram criados e configurados para autenticação via chave pública e a pasta scratch foi montada."
