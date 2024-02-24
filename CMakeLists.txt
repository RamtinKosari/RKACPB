# - CMake Message Colors
if(NOT WIN32)
    string(ASCII 27 Esc)
    set(TAB           "   ")
    set(RESET         "${Esc}[m")
    set(GREEN         "${Esc}[38;2;0;255;0m")
    set(RED           "${Esc}[38;2;255;0;0m")
    set(SUCCESS       "${TAB}${GREEN}[SUCCESS]${RESET}")
    set(FAILED        "${TAB}${RED}[FAILED]${RESET}")
    set(BLUE          "${Esc}[38;2;106;140;150m")
    set(CYAN          "${Esc}[38;2;0;255;255m")
    set(LIGHT         "${Esc}[38;2;170;170;170m")
    set(TEXT          "${BLUE}")
    set(RKACPB           "${CYAN}[RKACPB]${TEXT}")
  endif()

# - Specify CMake Version
cmake_minimum_required(VERSION 3.10)

# - Project Name
message("${RKACPB} Initializing Project ...${RESET}")
project(run)
message("${RKACPB} Set Project Name to ${LIGHT}${PROJECT_NAME}${RESET}")

# - Set C++ Standard
set(CMAKE_CXX_STANDARD 11)

# - Find Requiered Packages
if (DEFINED _USE_PACKAGES)
    foreach(UserPackage ${_USE_PACKAGES})
        message("${RKACPB} Finding Package ${LIGHT}${UserPackage}${TEXT} ...${RESET}")
        find_package(${UserPackage} REQUIRED)
        message("${TAB}${SUCCESS} Package ${LIGHT}${UserPackage}${TEXT} has been Found${RESET}")
    endforeach()
else()
    message("${RKACPB} No Additional Package Given${RESET}")
endif()
