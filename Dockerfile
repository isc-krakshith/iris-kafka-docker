ARG IMAGE=intersystems/iris-community:2022.1.0.191.0
ARG IMAGE=intersystemsdc/iris-community:latest
FROM $IMAGE

USER root

WORKDIR /opt/kafka
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/kafka
USER ${ISC_PACKAGE_MGRUSER}

COPY Installer.cls .
COPY src /usr/irissys/mgr/src
COPY iris.script /tmp/iris.script

#install Apache kafka 3.0.1
USER root
RUN mkdir /irisdata
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /irisdata
RUN mkdir /kafka
COPY kafka /kafka
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /kafka

#revert user
USER ${ISC_PACKAGE_MGRUSER}

# run iris and initial 
RUN iris start IRIS \
	&& iris session IRIS < /tmp/iris.script
