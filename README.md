# Tendrl Container
Tendrl Container allows user to create a tendrl setup with a minimal number of steps.

## Prerequisite
docker and docker-compose should be installed in the machine and the docker service should be running.
```sh
$ sudo yum install docker docker-compose
$ sudo service docker start
```
## Getting tendrl up and running
By default there will be 3 gluster containers and 1 tendrl container that will run. You can increase the number of gluster container by changing the `config.ini` file.
```sh
$ git clone https://github.com/cloudbehl/tendrl-container
$ cd tendrl-container
$ sudo sh tendrl-setup.sh
```
## remove the containers and data 
```sh
$ sh tendrl-clean.sh
```
## Listing the running containers and accessing the container
```sh
$ docker ps -q
$ docker exec -it {container-id/Name} /bin/bash
```
> example: docker exec -it tendrl_server /bin/bash

