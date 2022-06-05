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

3. Run the IRIS container with your project:

```
$ docker-compose up -d
```

## How to Use it

...

## What's inside the repository

### Dockerfile

Dockerfile which starts IRIS and imports Installer.cls and then runs the Installer.setup method, which creates KAFKA Namespace and imports ObjectScript code from /src and /testdata folders into it.

### .vscode/settings.json

Settings file to let you code in VSCode with [VSCode ObjectScript plugin](https:)

### .vscode/launch.json
Config file if you want to debug with VSCode ObjectScript

[Read about all the files in this artilce](https://community.intersystems.com/post/dockerfile-and-friends-or-how-run-and-collaborate-objectscript-projects-intersystems-iris)
