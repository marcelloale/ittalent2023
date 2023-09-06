#!/bin/bash

echo "Digite o nome do arquivo:"
read arquivo

palavras=$(wc -w < "$arquivo")

echo "Numero de palavras: $palavras"
