# conversao-peso
# 🐳 Desafio 01 - Docker

## conversao-peso

## Adiconado multistage build com docker

``` sh
docker image build -t hernanisoares/conversaopeso:v1 .
```

libera o terminal
``` sh
docker container run -d -p 8080:80 --name conversaopeso hernanisoares/conversaopeso:v1
```

terminal preso, porem ao enccerrar a plicação, o container é deletado
``` sh
docker container run -rm -d -p 8080:80 --name conversaopeso hernanisoares/conversaopeso:v1
```