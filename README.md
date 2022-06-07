# iris-kafka-docker
demonstrate InterSystems IRIS and Kafka integration

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation 

Clone/git pull the repo into any local directory

```
$ git clone https://github.com/isc-krakshith/iris-kafka-docker.git
```

Open the terminal in this directory and run:

```
$ docker-compose build
```
Among other things, iris.script which is called by the installer at this stage populates the Orders table with synthetic data.

3. Run the IRIS container with your project:

```
$ docker-compose up -d
```

## How to Use it
Open [InterSystems IRIS Management Portal](http://localhost:52773/csp/sys/UtilHome.csp) on your browser

default account _SYSTEM / SYS will need to be changed at first login

## What's inside the repository

### Dockerfile

Dockerfile which starts IRIS and imports Installer.cls and then runs the Installer.setup method, which creates KAFKA Namespace and imports ObjectScript code from /src and /testdata folders into it.

### .vscode/settings.json

Settings file to let you code in VSCode with [VSCode ObjectScript plugin](https://intersystems-community.github.io/vscode-objectscript/)

### .vscode/launch.json
Config file if you want to debug with VSCode ObjectScript

[Read about all the files in this artilce](https://community.intersystems.com/post/dockerfile-and-friends-or-how-run-and-collaborate-objectscript-projects-intersystems-iris)

### Apache Kafka v 2.13-3.0.1
Docker host volume bind makes this available within the container at /kafka/kafka_2.13-3.0.1

### Kafka.TraderProduction.cls
Contains the InterSystems IRIS Production settings, which brings up  EnsLib.Kafka.Service and EnsLib.Kafka.Operation and specifies the Kafka broker and topic parameters. It also contains the prameters used by the business process.

### Kafka.TraderProcess.cls
All the business logic is here

### Kafka.TestKafkaMessagingClient.cls
Creates a Kafka client using native API calls and runs tests on it to verify succesful functioning.
#### Start InterSystem IRIS terminal in running container to test it
```
docker-compose exec iris iris session iris

zn "KAFKA"

do ##class(Kafka.TestKafkaMessagingClient).KafkaClient()
```