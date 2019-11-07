FROM mf2c/dataclay-logicmodule:2.24 as dataclay

FROM compss/compss:2.5

COPY --from=dataclay /usr/src/dataclay/dataclay.jar /opt/COMPSs/storage/dataclay.jar
COPY --from=dataclay /usr/src/dataclay/lib /opt/COMPSs/storage/lib

COPY stubs /app/stubs
COPY bin /app/bin

COPY cfgfiles /dataclay-cfgfiles

ENTRYPOINT runcompss --storage_conf=/dataclay-cfgfiles/session.properties --classpath=/app/stubs:/app/bin Wordcount
CMD ""
