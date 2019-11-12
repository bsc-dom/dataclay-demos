ARG DATACLAY_TAG
FROM ubuntu:18.04
RUN apt-get -y update
RUN apt-get install -y sqlite3 libsqlite3-dev
COPY ./LM.sqlite /tmp/dataclay/dump.sql
RUN sqlite3 "/tmp/dataclay/LM" ".read /tmp/dataclay/dump.sql"

FROM bscdataclay/logicmodule:2.0
COPY --from=0 /tmp/dataclay/LM /tmp/dataclay/LM

# The command can contain additional options for the Java Virtual Machine and
# must contain a class to be executed.
ENTRYPOINT ["/usr/src/dataclay/javaclay/mvn-entry-point.sh", "-Dexec.mainClass=es.bsc.dataclay.logic.server.LogicModuleSrv"] 
# Don't use CMD in order to keep compatibility with singularity container's generator