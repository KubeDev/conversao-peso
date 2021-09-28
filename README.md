# 🐳 Desafio 01 - Docker

## conversao-peso

## Adiconado multistage build com docker

``` sh
docker image build -t diogoferreira/app-conversao-peso:v1 .
```

``` sh
docker container run -d -p 8080:8080 --name app-conversao-peso diogoferreira/app-conversao-peso:v1
```

``` sh
docker container rm -f "CONTAINER ID"
```