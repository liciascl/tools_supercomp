#!/bin/bash

# Nome do arquivo que contém a lista de usuários a serem excluídos
usuarios_criados="usuarios_criados.txt"

# Verificar se o arquivo existe
if [ ! -f "$usuarios_criados" ]; then
    echo "Arquivo $usuarios_criados não encontrado!"
    exit 1
fi

# Loop através do arquivo de usuários criados para excluir usuários
while IFS= read -r usuario; do
    if [ -n "$usuario" ]; then
        # Remover o usuário e seu diretório home
        sudo userdel -r "$usuario"
        
        # Remover a entrada do fstab relacionada ao usuário
        sudo sed -i "\|$nfs_server:/home/$usuario/scratch|d" /etc/fstab

        echo "Usuário removido: $usuario"
    fi
done < "$usuarios_criados"

echo "Todos os usuários listados em $usuarios_criados foram removidos."
