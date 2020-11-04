from dataclay.api import init, finish

# Init dataClay session
init()

from SharedNS.classes import *

if __name__ == "__main__":
    import traceback
    try:
        KBob = DKB.get_by_alias("DKB")
        print(KBob)
        print("#################")
        finish()
    except:
        traceback.print_exc()
