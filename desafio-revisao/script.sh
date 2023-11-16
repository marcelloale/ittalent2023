#!/bin/bash

# 3.1
if [ -z "$USER" ]; then
    echo "Variável USER não definida. Definindo..."
    USER=$(whoami)
fi
echo "Nome do usuário atual da máquina: $USER"

# 3.2
echo "Data e horário: $(date +'%Y-%m-%d %H:%M:%S')"

# 3.3
if ! which curl > /dev/null; then
    echo "curl não encontrado. Instalando..."
    sudo apt-get update
    sudo apt-get install -y curl
fi
echo "IP da máquina: $(curl -s ifconfig.me)"

# 3.4
if ! which traceroute > /dev/null; then
    echo "traceroute não encontrado. Instalando..."
    sudo apt-get update
    sudo apt-get install -y traceroute
fi
echo "Rastreamento da rota até o google.com:"
traceroute google.com



