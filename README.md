# conversao-peso
# 🐳 Desafio 01 - Docker

## conversao-peso

## Adiconado multistage build com docker

``` sh
docker image build -t hernanisoares/conversaopeso:v1 .
docker image tag hernanisoares/conversaopeso:v1 hernanisoares/conversaopeso:latest
```

- libera o terminal
``` sh
docker container run -d -p 8080:80 --name conversaopeso hernanisoares/conversaopeso:v1
```

- terminal preso, porem ao enccerrar a plicação, o container é deletado
``` sh
docker container run -rm -d -p 8080:80 --name conversaopeso hernanisoares/conversaopeso:v1
```

- logue no registry docker hub

``` sh
docker login
```

- envie para o registry sua imagem

``` sh
docker push hernanisoares/conversaopeso:v1
docker push hernanisoares/conversaopeso:latest
```