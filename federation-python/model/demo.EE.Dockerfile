FROM bscdataclay/dspython:2.0

COPY ./deploy /usr/src/dataclay/pyclay/deploy

# Execute
# Don't use CMD in order to keep compatibility with singularity container's generator
ENTRYPOINT ["/usr/src/dataclay/pyclay/python-entry-point.sh", "-m", "dataclay.executionenv.server"]
