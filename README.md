# Docker + ASP.Net


Claro, porque não? Neste exemplo vamos conteirizar uma aplicação ASP.Net. 
Para testar esta aplicação dentro de um contêiner, vocẽ precisa ter o <a href="https://docs.docker.com/get-docker/" target="_blank">Docker</a> instalado em sua máquina. 
Caso não deseje saber sobre o arquivo de conteinerização **Dockerfile**, vá direto para a sessão <a href="#testando-a-aplicacao">Testando a aplicação</a>.

## Dockerfile

A grosso modo, entenda o Dockerfile como uma receita que será utilizada para gerar o contêiner.

Como as linguagens suportadas pela plataforma “_.net_” são compiladas, vamos usar uma imagem intermediária para compilar e finalizar nossa imagem com apenas o necessário para executar a aplicação.

Então, vamos à imagem de compilação. Vamos indicar a imagem que utilizaremos para compilar nossa aplicação. Para isto utilizaremos o comando ``` FROM ``` e o nome da imagem, vamos atribuir o alias build a esta imagem.
```docker
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
```
Vamos definir o diretório de trabalho. O comando abaixo, cria a pasta "_src_", caso ela não exista e nos move para dentro da pasta.
```docker
WORKDIR /src
```
Copie os arquivos da aplicação para o nosso diretório de trabalho.

```docker
COPY *.sln .
COPY ConversaoPeso.Web/*.csproj ./ConversaoPeso.Web/
```
Restaurando as dependências e as ferramentas do projeto.

```docker
RUN dotnet restore
```
Agora vamos copiar os scripts da aplicação para a pasta _“/src/ConversaoPeso.Web”_, alterar o diretório de trabalho para o diretório da aplicação e compilar todo o projeto.

```docker
COPY ConversaoPeso.Web/. ./ConversaoPeso.Web/
WORKDIR /src/ConversaoPeso.Web
RUN dotnet publish -c release -o /app --no-restore
```
Note que o resultado da compilação será salvo na pasta “_/app_”

Ok, a primeira fase foi concluída. Agora vamos a imagem de produção. Vamos utilizar a imagem “**aspnet:5.0**” que é mais leve e é o suficiente para executar nossa aplicação.
```docker
FROM mcr.microsoft.com/dotnet/aspnet:5.0 as production
```
Definir o diretório de trabalho e copiar a aplicação compilada na imagem “_build_” para a imagem “_production_”.
```docker
WORKDIR /app
COPY --from=build /app ./
```
Para finalizar, vamos incluir o start imutável.

```docker
ENTRYPOINT ["dotnet", "ConversaoPeso.Web.dll"]
```
O arquivo final será este:
```docker
# image build
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY *.sln .
COPY ConversaoPeso.Web/*.csproj ./ConversaoPeso.Web/
RUN dotnet restore
 
COPY ConversaoPeso.Web/. ./ConversaoPeso.Web/
WORKDIR /src/ConversaoPeso.Web
RUN dotnet publish -c release -o /app --no-restore
 
# image production
FROM mcr.microsoft.com/dotnet/aspnet:5.0 as production
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "ConversaoPeso.Web.dll"]
```
Ótimo, com a “receita” pronta, vamos criar nossa imagem. 
```
docker build -t conversao-peso:v1 .
```
Para visualizar a imagem criada, utilize o comando abaixo
```
docker image ls
```
```
REPOSITORY                        TAG       IMAGE ID       CREATED       SIZE
conversao-peso                    v1        d6ba851cae82   3 days ago    210MB
<none>                            <none>    22e4b12a9e52   3 days ago    647MB
mcr.microsoft.com/dotnet/sdk      5.0       3d9edf094595   3 weeks ago   631MB
mcr.microsoft.com/dotnet/aspnet   5.0       8102e4dcab1c   3 weeks ago   205MB
```
Note o tamanho das imagens, a imagem que utilizamos para compilar, a _skd:5.0_ tem 631Mb mas nossa aplicação tem apenas 210Mb, isto porque a imagem que utilizamos para executar a aplicação foi a _aspnet:5.0_ que possui 1/3 do tamanho da imagem de compilação.
Durante o processo uma imagem sem nome foi criada, a imagem ```<none>```, esta imagem é a imagem de compilação. Esta imagem já cumpriu o seu papel e já não é mais necessária, para eliminá-la use o comando abaixo.
```
docker image prune
```
## Criando o contêiner
Já criamos nossa imagem, então estamos prontos para executarmos o contêiner, para isto, utilize o comando abaixo:
```
docker container run -d --rm --name app-aspnet -p 80:80 conversao-peso:v1
```
Podemos verificar se o contêiner está em sendo executado com o comando
```
docker container ls -a
```
<a name="testando-a-aplicacao">&nbsp;</a>
## Testando a aplicação

Se você seguiu as instruções acima, a aplicação pode ser acessada no em <a href="http://localhost" target="_blank">http://localhost</a>. Caso contrário, baixe o arquivo <a href="https://github.com/rogeriostos/conversao-peso/blob/main/start.sh" target="_blank">start.sh</a> e de permissão de execução em sua máquina com o comando 
```
sudo chmod +x start.sh 
```
E execute com o comando 
```
./start.sh
```
Isto irá baixar a imagem da aplicação para sua máquina e executar o contêiner. Agora é só testar a aplicação em <a href="http://localhost" target="_blank">http://localhost</a>