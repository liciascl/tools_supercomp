#!/bin/bash

# Definir limites
MEMORY_LIMIT_MB=500   # Memória máxima permitida (em MB)
CPU_LIMIT_PERCENT=50  # CPU máxima permitida (em %)
TIME_LIMIT=90       # Tempo máximo permitido (em segundos)
USER_GROUP="alunos"  # Grupo de usuários a ser monitorado

# Monitorar processos dos usuários do grupo
for user in $(getent group "$USER_GROUP" | cut -d: -f4 | tr ',' ' '); do
    if [ -n "$user" ]; then
        for pid in $(pgrep -u "$user"); do
            # Verificar uso de memória
            mem_usage=$(pmap -x $pid | awk '/total/ {print $3}')  # Memória em KB
            mem_usage_mb=$((mem_usage / 1024)) # Converter para MB

            # Verificar uso de CPU
            cpu_usage=$(ps -p $pid -o %cpu --no-headers | awk '{print int($1)}')

            # Verificar tempo de execução
            process_time=$(ps -o etimes= -p $pid | tr -d ' ')

            # Condição para matar o processo
            if [[ "$mem_usage_mb" -gt "$MEMORY_LIMIT_MB" || "$cpu_usage" -gt "$CPU_LIMIT_PERCENT" || "$process_time" -gt "$TIME_LIMIT" ]]; then
                echo "[ALERTA] Matando processo $pid do usuário $user (Memória: ${mem_usage_mb}MB, CPU: ${cpu_usage}%, Tempo: ${process_time}s)"
                sudo kill -9 $pid
            fi
        done
    fi
done
