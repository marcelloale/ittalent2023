#!/bin/bash

# Função para realizar a operação de adição
addition() {
    resultado=$(echo "$1 + $2" | bc)
    echo "Resultado: $resultado"
}

# Função para realizar a operação de subtração
subtraction() {
    resultado=$(echo "$1 - $2" | bc)
    echo "Resultado: $resultado"
}

# Função para realizar a operação de multiplicação
multiplication() {
    resultado=$(echo "$1 * $2" | bc)
    echo "Resultado: $resultado"
}

# Função para realizar a operação de divisão
division() {
    resultado=$(echo "scale=2; $1 / $2" | bc)
    echo "Resultado: $resultado"
}

echo "Escolha uma operação:"
echo "1 = Adição"
echo "2 = Subtração"
echo "3 = Multiplicação"
echo "4 = Divisão"
read opcao

echo "Digite o primeiro numero:"
read num1
echo "Digite o segundo numero:"
read num2

case $opcao in
    1) addition $num1 $num2 ;;
    2) subtraction $num1 $num2 ;;
    3) multiplication $num1 $num2 ;;
    4) division $num1 $num2 ;;
    *) echo "Opção inválida" ;;
esac

