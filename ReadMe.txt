This ports Python keras models saved as a .model file into C++ mex files.

Requirements

1. Cygwin (https://cygwin.com)
  - Add packages:
    - make
    - x86_64-w64-mingw32-g++
2. Python 3.6
3. Matlab

Build cpp-source and MEX models

1. Clone project
2. Copy keras model (.model) to models-subdirectory
3. Open Cygwin terminal and cd to project dir
4. Set up variables
  $ export MATLABHOME=/cygdrive/c/Program\ Files/MATLAB/R2018b
  $ export PYTHON=/cygdrive/c/Python36/python.exe
5. Run
  $ make all
6. in Matlab add "proj dir/mex" into Set Path
7. in  Matlab run
  >> test2(randn(1,2))

In Matlab

To predict multiple predictions, have each prediction as a parameter when calling the function
  >> a,b = test2(randn(1,2),randn(1,2))
The code checks that the input is the same size as expected input. If it is required to bypass this
let the last parameter be a true boolean value. This will bypass all dimensionality checking.
  >> test2(randn(1,3),true)


NOTE:
Using ELU as an activation layer is not supported, use it as a standalone layer itself.
in Python:
>> from keras.layers.advanced_activations import ELU
>> model.add(Dense())
>> model.add(ELU())
 instead of
 
>> model.add(Dense(), activation='elu')