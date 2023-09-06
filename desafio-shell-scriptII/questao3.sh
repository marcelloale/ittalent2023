#!/bin/bash

echo "Qual o tamanho da senha?"
read tam_senha

senha=$(tr -d -c 'A-Za-z0-9' < /dev/urandom | head -c $tam_senha)

echo "Sua senha aleatória é: $senha"
