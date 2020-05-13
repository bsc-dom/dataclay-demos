from dataclay.api import init, finish

# Init dataClay session
init()

from DemoNS.classes import *

if __name__ == "__main__":
    KBob = DKB.get_by_alias("DKB")
    print(KBob)
    print("#################")
    finish()
