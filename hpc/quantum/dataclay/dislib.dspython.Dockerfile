FROM bscdataclay/dspython

RUN python3 -m pip install scipy==1.3.1 matplotlib scikit-learn
# Execute
ENTRYPOINT ["dataclay-python-entry-point", "-m", "dataclay.executionenv.server"]
