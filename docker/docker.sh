#!/bin/bash
pname docker/docker

dockerclean(){
    docker rm -f $(docker ps -aq)
    docker rmi -f $(docker images -aq)
}