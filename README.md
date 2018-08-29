# tendrl-container

## Getting tendrl up and running
```sh
$ sudo yum install docker docker-compose
$ service docker start
$ git clone https://github.com/cloudbehl/tendrl-container
$ sh tendrl-setup.sh
```
## Building the latest code locally
```sh
$ git clone https://github.com/cloudbehl/tendrl-container
$ docker build --rm -t ankushbehl/tendrl-centos .
$ docker build --rm -t ankushbehl/gluster-centos Centos/.
$ sh tendrl-setup.sh
```
## remove the data and containers
```sh
$ sh tendrl-clean.sh
```
