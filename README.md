# RKACPB
Ramtin Kosari Automatic C++ Project Builder

## Overview
Use This Automatic Project Builder to Build Your C++ Project
It Will Automatically Compiles All Related Codes Inside Your Project

## Build Automatic
to Build Automatically Your Project, Clone This Repository in Root Directory of Your Project
```shell
git clone https://github.com/RamtinKosari/RKACPB.git
cd RKACPB
./build.sh
```

if You Want to Build Specefic Files or Files with Specefic File Extensions, Do Like This :
* ./build.sh Builds All .cpp and .hpp Files Inside Your Project by Default
```shell
./build.sh --extensions *.cc *.c *.cxx *.hh *.h *.hxx *.py
# - This Command Will Build All Files with Provided Extensions
```

if You Need Additional Packages to Build Your Project, Do :
```shell
./build.sh --packages "OpenCV;X11"
# - This Command Will Link OpenCV and X11 Library to Build Target
```

## Update Your Code
to Build Updated Code Just Go to Build Directory and Do :
```shell
make
```
But if You have Added New Source File and You Want to Build Project Again Do [Build Automatic](#build-automatic)

### Dependencies
* Linux / Darwin (MacOS)
* CMake
* C++ Compiler
