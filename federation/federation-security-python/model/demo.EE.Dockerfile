FROM bscdataclay/dspython:develop

COPY ./deploy ${DATACLAY_HOME}/deploy

# Execute
# Don't use CMD in order to keep compatibility with singularity container's generator
ENTRYPOINT ["dataclay-python-entry-point", "-m", "dataclay.executionenv.server"]
