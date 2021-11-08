#!/bin/sh
[ -n "$(docker images -q rogeriostos/conversao-peso:v1)" ] || echo docker pull rogeriostos/conversao-peso:v1

if [ ! "$(docker ps -q -f name=myappasp)" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=myappasp)" ]; then
        # cleanup
        docker rm -f myappasp
    fi
    # run your container
    docker container run -d --rm --name myappasp -p 80:80 rogeriostos/conversao-peso:v1
fi
[ -z "$(docker ps -q -f name=myappasp)" ] || echo "\nAcesse a aplicação em http://localhost/"
echo "\n"