# RKACPB
<p>
    <a href="https://github.com/ramtinkosari/RKACPB"><img src="https://img.shields.io/badge/status-Under%20Develop-cyan?&labelColor=344250&color=4C778F"/></a>
    <a href="https://github.com/ramtinkosari/RKACPB"><img src="https://img.shields.io/badge/C%2B%2B-11-darkcyan?logo=c%2B%2B&labelColor=344250&color=4C778F"/></a>
    <a href="https://github.com/ramtinkosari/RKACPB"><img src="https://img.shields.io/badge/CMake-3.10.x-darkcyan?logo=cmake&labelColor=344250&color=4C778F"/></a>
</p>

Ramtin Kosari's Automatic C++ Project Builder

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

## Supported Packages
RKACPB's ```--packages``` Option Currently Supports these Packages :
- [x] OpenCV [(Open Source Computer Vision Library)](https://opencv.org/)
- [x] GLEW [(OpenGL Extension Wrangler Library)](https://glew.sourceforge.net/)
- [x] glfw3 [(Graphics Library Framework)](https://www.glfw.org/)
- [x] OpenGL [(Open Graphics Library)](https://www.opengl.org/)
- [x] GLUT [(OpenGL Utility Toolkit)](https://www.opengl.org/resources/libraries/glut/)
- [x] GLU [(OpenGL Utility Library)](https://www.ibm.com/docs/en/aix/7.1?topic=manual-opengl-utility-glu-library)
- [x] X11 [(X Window System)](https://www.x.org/)

⚠️ Use them in the Way as Above


## Build Updated Code
to Build Updated Code Just Go to Build Directory and Do :
```shell
make
```
But if You have Added New Source File and You Want to Build Project Again Do [Build Automatic](#build-automatic)

## Features
### 1. Include Directories Automatically
RKACPB Automatically Defines Include Directories for each Configured Directory via [Build Script](https://github.com/RamtinKosari/RKACPB/blob/main/build.sh). So You Can Use Source Files in Your Code without Using Their Relative Paths like :
```c++
//-- Instead of Using This :
# include "../../Utils/Terminal/Colors/Colors.hpp"

//-- Use This :
# include "Colors.hpp"
```

### 2. Define Headers Macro Combined with ```RKACPB``` (for Support) Automatically
RKACPB Automatically Defines Macros for each Header File in Your Project, You Can Use These Macros in Your Code before Including any Headers in Order to Check That Header File is Configured to Compile. Sample Usage for Header File Named ```foo.hpp``` in Your C++ Code:
```c++
//-- Use This When You Want to be Sure if Necessary Headers are Configured to be Compiled, This is One of RKACPB's Supports
//-- Check if Project is Configured by RKACPB
# ifdef RKACPB
    //-- Check if foo.hpp is Configured to be Compiled
    # ifndef HAS_RKACPB_MODULE_FOO
        //-- Handle if Not Defiend
        # error This Code Needs Foo Header File
    # endif // HAS_RKACPB_MODULE_FOO
# endif // RKACPB
```
⚠️ RKACPB Defines Macros in Style of ```HAS_RKACPB_MODULE_[Header File Name without .hpp .cpp and ...]```

⚠️ if You Want this Feature Works Well, You Must be Sure that Your Header File You Are Writing This, Must be Included Somehow into Where ```main()``` Method is (Executable).

### Dependencies
* Linux / Darwin (MacOS)
* CMake
* C++ Compiler

### Repo Info
<p>
    <a href="https://github.com/ramtinkosari/RKACPB"><img src="https://img.shields.io/github/created-at/ramtinkosari/RKACPB?logo=github&labelColor=344250&color=447F76"/></a>
    <a href="https://github.com/ramtinkosari/RKACPB/commits/main"><img src="https://img.shields.io/github/last-commit/ramtinkosari/RKACPB?logo=github&labelColor=344250&color=447F76" alt="Latest commit"/></a>
    <a href="https://github.com/ramtinkosari/RKACPB"><img src="https://img.shields.io/github/issues/ramtinkosari/RKACPB?labelColor=344250&color=447F76""/></a>
    <a href="https://github.com/ramtinkosari/RKACPB"><img src="https://img.shields.io/github/discussions/ramtinkosari/RKACPB?labelColor=344250&color=447F76"/></a>
    <a href="https://github.com/ramtinkosari/RKACPB"><img src="https://img.shields.io/github/repo-size/ramtinkosari/RKACPB?labelColor=344250&color=447F76"/></a>
    <a href="https://github.com/ramtinkosari/RKACPB"><img src="https://img.shields.io/github/forks/ramtinkosari/RKACPB?style=flat&labelColor=344250&color=447F76"/></a>
    <a href="https://github.com/ramtinkosari/RKACPB"><img src="https://img.shields.io/github/stars/ramtinkosari/RKACPB?style=flat-square&labelColor=344250&color=447F76"/></a>
</p>

### Contact
<p>
    <a href="https://t.me/ramtinkosari"><img src="https://img.shields.io/badge/Telegram-ramtinkosari-2CA5E0?&labelColor=344250&color=2CA5E0&logo=telegram"/></a>
    <a href="mailto:ramtinkosari@gmail.com"><img src="https://img.shields.io/badge/Gmail-Send%20Email-D14836?&labelColor=344250&color=D14836&logo=gmail"/></a>
    <a href="https://www.instagram.com/ramtin.qb"><img src="https://img.shields.io/badge/Instagram-Follow%20Me-E4405F?&labelColor=344250&color=E4405F&logo=instagram"/></a>
</p>
