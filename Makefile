all: default
default:
	cmake -H. -BBuild
	$(MAKE) -CBuild
Debug Release RelWithDebInfo MinSizeRel:
	cmake -H. -BBuild/$@ -DCMAKE_BUILD_TYPE=$@
	$(MAKE) -CBuild/$@