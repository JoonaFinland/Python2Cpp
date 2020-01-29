MATLABHOME ?= /cygdrive/c/Program\ Files/MATLAB/R2018b
PYTHON ?= /cygdrive/c/Users/jwx696851/AppData/Local/Continuum/anaconda3/envs/Python3.6/python.exe
MAKEFLAGS += -rR
CC = /cygdrive/c/cygwin64/bin/x86_64-w64-mingw32-g++
FLAGS = -c -DMATLAB_DEFAULT_RELEASE=R2017b  -DUSE_MEX_CMD   -m64 -DMATLAB_MEX_FILE  -I"include"  -I"$(MATLABHOME)/extern/include" -I"$(MATLABHOME)/simulink/include" -fexceptions -fno-omit-frame-pointer -std=c++11 -O2 -fwrapv -DNDEBUG
.SECONDARY:

MODELS=$(notdir $(wildcard models/*.model))
MEXFILES = $(addprefix mex/, $(patsubst %.model, %.mexw64, $(MODELS)))

all: $(MEXFILES) clean

source/%.cpp: models/%.model
	$(PYTHON) scripts/keraport.py $^ $* $*

source/%.obj: source/%.cpp
	$(CC) $(FLAGS) $^ -o $@

include/keras_model.obj: 
	$(CC) $(FLAGS) "include/keras_model.cpp" -o $@

cpp_mexapi_version.obj: 
	$(CC) $(FLAGS) "$(MATLABHOME)/extern/version/cpp_mexapi_version.cpp" -o $@

mex/%.mexw64: source/%.obj include/keras_model.obj cpp_mexapi_version.obj
	$(CC) -m64 -Wl,--no-undefined -shared -static -s -Wl,"$(MATLABHOME)/extern/lib/win64/mingw64/exportsmexfileversion.def" $^ -L"$(MATLABHOME)\extern\lib\win64\mingw64" -llibmx -llibmex -llibmat -lm -llibmwlapack -llibmwblas -llibMatlabDataArray -llibMatlabEngine -o $@
	
clean:
	rm -rf *.obj example* source/*.obj include/*.obj

fullclean:
	rm -rf mex/*.mexw64 *.obj example* source/*.obj include/*.obj source/*.cpp tmp/*.temp