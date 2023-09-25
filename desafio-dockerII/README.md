# Desafio Docker II

## Como Compilar e executar a aplicação

A aplicação é escrita na linguagem de programação Go e teve como referência o [artigo](https://www.alura.com.br/artigos/criando-uma-simples-aplicacao-web-com-go) do [Daniel Artine](https://www.linkedin.com/in/danielartine/) no site da Alura.

Go é uma linguagem de programação moderna (desenvolvida no Google desde 2009) que prioriza a simplicidade, segurança e legibilidade, e é projetada para a construção de aplicações simultâneos em grande escala, especialmente serviços de rede.

O próprio Kubernetes é escrito em Go, assim como o Docker, o Terraform e muitos outros projetos populares de código aberto. Isso torna o Go uma boa opção para o desenvolvimento de aplicações nativos em nuvem.

## Como funciona a aplicação

Como você pode ver, o código é bastante simples, o mesmo implementa um servidor HTTP através da biblioteca padrão do Go. A função principal dele é chamada de `handler`.

```go
func handler(w http.ResponseWriter, r *http.Request) {
        fmt.Fprintln(w, "marcelloale@ITtalent2023 😁 ")
}
```

Como o nome sugere, ele lida com as solicitações HTTP. A solicitação é passada como um argumento para a função. E como um servidor HTTP precisa de uma maneira de enviar algo de volta para o cliente. O objeto permite que a função envie uma mensagem de volta para o usuário exibindo em seu navegador: neste caso uma simples string (Go suporta nativamente Unicode🚀):

```go
http.ResponseWriter "marcelloale@ITtalent2023 😁 "
```
O resto do código chama a função handler para manipular as solicitações HTTP e inicia o servidor HTTP ouvindo na porta 8080.

## Construindo nossa Imagem

Tudo começa com um Dockerfile.

O Docker cria imagens lendo as instruções de um Dockerfile. O `Dockerfile` tem as instruções para apartir de uma imagem inicial chamada imagem base, transformá-la de alguma forma e assim salvar o resultado como uma nova imagem.

Para nossa simples aplicação de Go usaremos um processo de compilação bastante padrão para contêineres em Go chamado multi-stage utilizando como referencia a [documentação](https://docs.docker.com/build/building/multi-stage/) do Docker.

Multi-stage builds são úteis para quem deseja otimizar Dockerfiles, mantendo-os fáceis de ler e manter.

Com  multi-stage builds, você usa várias instruções `FROM` em seu Dockerfile. Cada instrução `FROM` pode usar uma base diferente, e cada uma delas começa uma nova etapa da construção. Você pode copiar seletivamente artefatos de um estágio para outro, deixando para trás tudo o que você não quer na imagem final.

O Dockerfile a seguir possui duas etapas separadas: uma para construir um binário e outra em que copiamos o binário.

```Dockerfile
# syntax=docker/dockerfile:1
FROM golang:1.21-alpine as build
WORKDIR /src
COPY main.go go.* /src/
RUN go build -o /bin/app ./main.go

FROM scratch
COPY --from=build /bin/app /bin/app
CMD ["/bin/app"]
```
Você só precisa do Dockerfile único. Não há necessidade de um script de compilação separado. Basta executar docker build.

```bash
docker build -t app .
```

O resultado final é uma imagem de produção minúscula contendo apenas o binário. Nenhum das ferramentas de compilação necessárias para construir a aplicação está incluído na imagem resultante.

Como isso funciona? A segunda instrução inicia uma nova etapa de construção com a imagem como base. A linha copia apenas o artefato construído da etapa anterior para esta nova etapa. O SDK Go e quaisquer artefatos intermediários são deixados para trás e não são salvos na imagem final. FROM scratch e COPY --from=build.

Por padrão, as etapas de construção não têm nomes e você se refere a elas pelo número inteiro, começando com 0 para a primeira instrução. Você pode nomear as etapas de construção no Dockerfile usando `AS <NOME>`. Isso ajuda a identificar as etapas, mesmo se as instruções forem reorganizadas posteriormente, sem quebrar o processo. 

Link para imagem no [Docker Hub](https://hub.docker.com/repository/docker/marcelloale/appgo).

## Entendendo cada instrução do Dockerfile

1. `# syntax=docker/dockerfile:1`: Esta linha define o local da sintaxe Dockerfile que é usada para criar o Dockerfile. Neste caso, está usando a versão 1 da sintaxe do Dockerfile o uso de docker/dockerfile:1, sempre aponta para a versão mais recente da sintaxe. Para mais informações consulte a [documentação](https://docs.docker.com/build/dockerfile/frontend/).

2. `FROM golang:1.21-alpine as build`: Esta linha define a imagem base que será usada para a primeira etapa de construção nomeado como `build`. O Docker usará a imagem oficial do Golang (Go) com a tag `1.21-alpine` que além da versão 1.21 da linguagem tem como escolha o  Alpine Linux que é uma distribuição Linux minimalista e leve para compilar o código-fonte.

3. `WORKDIR /src`: Define o diretório de trabalho dentro do contêiner como `/src`. Isso significa que todos os comandos subsequentes serão executados a partir deste diretório.

4. `COPY main.go go.* /src/`: Copia os arquivos `main.go` e qualquer arquivo que comece com "go." do diretório de origem para o diretório `/src/` dentro do contêiner.

5. `RUN go build -o /bin/app ./main.go`: Este comando compila o código-fonte localizado em `main.go` dentro do diretório `/src/` do contêiner. O executável resultante é nomeado como `/bin/app`. Isso cria o binário do aplicativo dentro do contêiner.

6. `FROM scratch`: Aqui se inicia a segunda etapa da construção, usando uma imagem base mínima chamada "scratch". Essa imagem é essencialmente vazia, não contendo um sistema de arquivos Linux completo.

7. `COPY --from=build /bin/app /bin/app`: Copiamos o executável binário produzido na primeira etapa da construção chamada como "build" para o diretório `/bin/app` na imagem atual. Isso cria uma imagem mínima contendo apenas o binário do aplicativo.

8. `CMD ["/bin/app"]`: Define o comando que será executado quando um contêiner for iniciado a partir desta imagem. Neste caso, ele inicia o binário do aplicativo que foi copiado anteriormente para `/bin/app`.


## Instalando o Docker 

Primeiramente, para executar contêineres docker você precisa do Docker instalado em seu sistema. Caso ainda não o tenha, siga as instruções da [documentação](https://docs.docker.com/engine/install/) oficial do Docker para realizar a instalação.

## Executando nossa imagem do docker

Para executar a aplicação, você tem duas opções:

### Construir a imagem a partir dos arquivos deste repositório
Certifique-se de estar `desafio-dockerII`, onde estão localizados os arquivos Dockerfile e os outros arquivos necessários.

Execute o comando a seguir para construir a imagem Docker:

``` bash
docker image build -t myapp .
```

Após a conclusão da construção da imagem, você pode executar o contêiner com o comando:

``` bash
docker container run -d -p 80:8080 myapp
```
### Executar o contêiner diretamente apartir do Docker Hub

Você também pode executar o contêiner diretamente utilizando a imagem que está no Docker Hub, sem a necessidade de construir a imagem localmente. Utilize o seguinte comando:

```bash
docker container run -p 80:8080 marcelloale/appgo:0.0.1
```

Isso iniciará o contêiner com a aplicação em execução na porta 80 do seu sistema, e o terminal ficará ocupado enquanto o contêiner estiver em execução.
