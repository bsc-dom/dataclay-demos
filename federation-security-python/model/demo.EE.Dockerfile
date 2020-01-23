FROM bscdataclay/dspython:2.1

COPY ./deploy ${DATACLAY_HOME}/deploy

# Execute
# Don't use CMD in order to keep compatibility with singularity container's generator
ENTRYPOINT ["dataclay-python-entry-point", "-m", "dataclay.executionenv.server"]
