from dataclay.api import init, finish

# Init dataClay session
init()

from DemoNS.classes import *

if __name__ == "__main__":
    try:
        KBob = DKB.get_by_alias("DKB")
    except Exception:
        print("DKB NOT FOUND. Creating")
        KBob = DKB()
        KBob.make_persistent(alias="DKB")
    print("DKB created!")
    finish()
