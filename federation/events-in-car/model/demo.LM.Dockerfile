ARG DATACLAY_TAG
FROM ubuntu:18.04
RUN apt-get -y update
RUN apt-get install -y sqlite3 libsqlite3-dev
COPY ./LM.sqlite /tmp/dataclay/dump.sql
RUN mkdir -p "/dataclay/storage"
RUN sqlite3 "/dataclay/storage/LM" ".read /tmp/dataclay/dump.sql"

FROM bscdataclay/logicmodule
COPY --from=0 /dataclay/storage/LM /dataclay/storage/LM

# The command can contain additional options for the Java Virtual Machine and
# must contain a class to be executed.
ENTRYPOINT ["dataclay-java-entry-point", "es.bsc.dataclay.logic.server.LogicModuleSrv"] 
# Don't use CMD in order to keep compatibility with singularity container's generator